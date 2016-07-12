//
//  ViewController.swift
//  EyeMap
//
//  Created by mario on 2016/07/04.
//  Copyright © 2016年 mario. All rights reserved.
//

import UIKit
import CoreLocation
import MaterialKit
import SCLAlertView

class ViewController: UIViewController, CLLocationManagerDelegate, MEMELibDelegate {

    var myLocationManager: CLLocationManager!
    var statusCheck: StatusCheck = StatusCheck()
    
    @IBOutlet weak var memeStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = NSUserDefaults()
        let name:String = userDefaults.valueForKey("userName") as! String!
        self.navigationItem.title = name
        self.navigationItem.hidesBackButton = true
        
        MEMELib.sharedInstance().delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.Restricted || status == CLAuthorizationStatus.Denied {
            return
        }
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        
        if status == CLAuthorizationStatus.NotDetermined {
            myLocationManager.requestWhenInUseAuthorization()
        }
        
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        myLocationManager.distanceFilter = kCLDistanceFilterNone
//        print(MEMELib.sharedInstance().isCalibrated.rawValue)
        let connect = MEMELib.sharedInstance().isConnected
        if connect {
            memeStatus.text = "Connected"
            let calib = MEMELib.sharedInstance().isCalibrated
            switch calib.rawValue{
            case 0:
                UIAlertView(title: "キャリブレーションが完了していません", message: "", delegate: nil, cancelButtonTitle: "OK").show()
            case 1:
                UIAlertView(title: "体軸のキャリブレーションのみ完了しています", message: "", delegate: nil, cancelButtonTitle: "OK").show()
            case 2:
                UIAlertView(title: "眼電位のキャリブレーションのみ完了しています", message: "", delegate: nil, cancelButtonTitle: "OK").show()
            case 3:
                print("キャリブレーションは完了しています")
            default:
                break
            }
        }else{
            memeStatus.text = "Not Connected"
        }
    }
    
    func memeRealTimeModeDataReceived(data: MEMERealTimeData!) {
        
        RealtimeData.sharedInstance.memeRealTimeModeDataReceived(data)
    }
    
    func memePeripheralDisconnected(peripheral: CBPeripheral!) {
        print("disconnected")
    }
    
    @IBAction func button(sender: UIButton) {
        let connect = MEMELib.sharedInstance().isConnected
        if connect {
            myLocationManager.requestLocation()
            print(RealtimeData.sharedInstance.dict[11]["value"])
        }else{
            let appearance = SCLAlertView.SCLAppearance(
            showCloseButton:false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("YES", action: {
                let FindView: MemeFindViewController = self.storyboard?.instantiateViewControllerWithIdentifier("findView") as! MemeFindViewController
                self.navigationController?.pushViewController(FindView, animated: true)
            })
            alertView.addButton("NO", action:{})
            alertView.showWarning("Not Connected", subTitle: "Connect to MEME?")
        }
    }
    
    //位置情報取得成功時によばれる関数
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            print("緯度：\(location.coordinate.latitude)")
            print("経度：\(location.coordinate.longitude)")
        }
    }
    
    //位置情報取得失敗時によばれる関数
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error")
    }
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

