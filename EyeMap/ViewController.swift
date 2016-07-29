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
    var powerLebel:String = "0"
    var logStatus = false
    
    var location:Dictionary<String,String> = [:]
    var eyeData:[Dictionary<String,AnyObject>] = [[:],[:],[:],[:],[:]]
    var eyeUp:[String] = []
    var eyeDown:[String] = []
    var eyeRight:[String] = []
    var eyeLeft:[String] = []
    var dataTime:[String] = []
    var sendUp:String = "0"
    var sendDown:String = "0"
    var sendLeft:String = "0"
    var sendRight:String = "0"
    var kakudo:Float = 0.0
    
    var item = [[String]]()
    var myData:String = ""
    
    var timer:NSTimer!
    var index:Int = 0
    var direction:String = "0.0"
    
    @IBOutlet weak var memeConnectStatus: UILabel!
    @IBOutlet weak var connectButton: MKButton!
    @IBOutlet weak var logButton: MKButton!
    @IBOutlet weak var memeStatus: UILabel!
    @IBOutlet weak var logLabel: UILabel!
    
    let userDefaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name:String = userDefaults.valueForKey("userName") as! String!
        self.navigationItem.title = name
        self.navigationItem.hidesBackButton = true
        
        let now:NSDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date:String = dateFormatter.stringFromDate(now)
        userDefaults.setValue(date, forKey: "date")
        
        MEMELib.sharedInstance().delegate = self
        
        //位置情報が許可されていなかったら設定画面に遷移するかを選ぶ
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.Restricted || status == CLAuthorizationStatus.Denied {
            let alertController = UIAlertController(title: "Not allow location service", message: "Allow the service?", preferredStyle: .Alert)
            let otherAction = UIAlertAction(title: "OK", style: .Default) {
                action in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)
                UIApplication.sharedApplication().openURL(url!)
            }
            let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel) {
                action in
            }
            
            alertController.addAction(otherAction)
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        
        ///アプリ起動時に位置情報が許可してなかったら許可するかを選ばせる
        if status == CLAuthorizationStatus.NotDetermined {
            myLocationManager.requestWhenInUseAuthorization()
        }
        
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        myLocationManager.pausesLocationUpdatesAutomatically = false
        myLocationManager.activityType = CLActivityType.Fitness
        myLocationManager.distanceFilter = kCLDistanceFilterNone
        myLocationManager.allowsBackgroundLocationUpdates = true
        myLocationManager.headingOrientation = .Portrait
        
        //data logモード判定
        if self.logStatus{
            self.logButton.setTitle("Log Stop", forState: .Normal)
        }else{
            self.logButton.setTitle("Log Start", forState: .Normal)
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        let connect = MEMELib.sharedInstance().isConnected
        if connect {
            memeConnectStatus.text = "Connected"
        }else{
            memeConnectStatus.text = "Not Connected"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        }
    }
    
    //Memeのデータ取得関数
    func memeRealTimeModeDataReceived(data: MEMERealTimeData!) {
        RealtimeData.sharedInstance.memeRealTimeModeDataReceived(data)
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let string = formatter.stringFromDate(now)
        self.dataTime.append(string)
        self.eyeUp.append(RealtimeData.sharedInstance.dict[3]["value"]!)
        self.eyeDown.append(RealtimeData.sharedInstance.dict[4]["value"]!)
        self.eyeLeft.append(RealtimeData.sharedInstance.dict[5]["value"]!)
        self.eyeRight.append(RealtimeData.sharedInstance.dict[6]["value"]!)
      
        if self.logStatus == true{
            self.memeStatus.text = ""
            myData = "\(self.userDefaults.valueForKey("userName") as! String),\(self.location["lat"]!),\(self.location["lon"]!),\(data.eyeMoveUp),\(data.eyeMoveDown),\(data.eyeMoveLeft),\(data.eyeMoveRight),\(data.roll),\(data.pitch),\(data.yaw),\(self.kakudo),\(string)\n"
            // ドキュメントパス
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            //ディレクトリ名
            let folderName = "/eyedata/"
            // ファイル名
            let fileName = "eyedata.csv"
            //　ファイルのパス
            let filePath = documentsPath+folderName+fileName
            
            let output = NSOutputStream(toFileAtPath: filePath, append: true)
            output?.open()
            let cstring = self.myData.cStringUsingEncoding(NSUTF8StringEncoding)
            let bytes = UnsafePointer<UInt8>(cstring!)
            let size = self.myData.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            output?.write(bytes, maxLength: size)
            output?.close()
        }
        
        self.powerLebel = "Power:" + RealtimeData.sharedInstance.dict[2]["value"]!
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.powerLebel, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
    }
    
    func memePeripheralDisconnected(peripheral: CBPeripheral!) {
        print("disconnected")
    }
    
    //Meme接続設定ボタンの挙動
    @IBAction func pushConnectButton(sender: AnyObject) {
        let findView: MemeFindViewController = self.storyboard?.instantiateViewControllerWithIdentifier("findView") as! MemeFindViewController
        let connect = MEMELib.sharedInstance().isConnected
        if connect {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton:false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("YES", action: {
                    MEMELib.sharedInstance().disconnectPeripheral()
                    MEMELib.sharedInstance().stopDataReport()
                    self.myLocationManager.stopUpdatingLocation()
                    self.myLocationManager.stopUpdatingHeading()
                    self.memeConnectStatus.text = "Not Connected"
                    self.logButton.setTitle("Log Start", forState: .Normal)
                    self.logStatus = false
                    self.logLabel.text = ""
            })
            alertView.addButton("NO", action:{})
            alertView.showWarning("Stop Connecting?", subTitle: "")
        }else {
            self.navigationController?.pushViewController(findView, animated: true)
        }
    }
    
    //LogButtonを押した時の挙動
    @IBAction func button(sender: UIButton) {
        let connect = MEMELib.sharedInstance().isConnected
        if connect {
            if self.logStatus{
                print("Log Stop!")
                self.logButton.setTitle("Log Start", forState: .Normal)
                self.logStatus = false
                self.logLabel.text = ""
                myLocationManager.stopUpdatingLocation()
                myLocationManager.stopUpdatingHeading()
                self.timer.invalidate()
            }else{
                self.logButton.setTitle("Log Stop", forState: .Normal)
                self.logLabel.text = "now logging"
                myLocationManager.startUpdatingLocation()
                myLocationManager.startUpdatingHeading()
            }
        }else{
            let appearance = SCLAlertView.SCLAppearance(
            showCloseButton:false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("YES", action: {
                let findView: MemeFindViewController = self.storyboard?.instantiateViewControllerWithIdentifier("findView") as! MemeFindViewController
                self.navigationController?.pushViewController(findView, animated: true)
            })
            alertView.addButton("NO", action:{})
            alertView.showWarning("Not Connected", subTitle: "Connect to MEME?")
        }
    }
    
    //定期的にサーバに送信
    func logEye(timer:NSTimer){
        //ドキュメントパス
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        //ディレクトリ名
        let folderName = "/eyedata/"
        // ファイル名
        let fileName = "eyedata.csv"
        //　ファイルのパス
        let filePath = documentsPath+folderName+fileName
    
        let URL = NSURL(string: "https://life-cloud.ht.sfc.keio.ac.jp/~mario/eyemap/insert_data.php")
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "POST"
        let csvData = try! NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding) as String
        csvData.enumerateLines { (line, stop) -> () in
            self.item += [line.componentsSeparatedByString(",")]
        }
        
        request.addValue("application/json; charaset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(self.item, options: NSJSONWritingOptions.PrettyPrinted)
        var response: NSURLResponse?
        let data: NSData! = try! NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        let myData:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        print(myData)
        self.item = [[String]]()
        
        let manager = NSFileManager()
        try! manager.removeItemAtPath(filePath)
    }
    
    //位置情報取得成功時によばれる関数
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            self.location.updateValue(NSString(format: "%.10f", location.coordinate.latitude) as String, forKey: "lat")
            self.location.updateValue(NSString(format: "%.10f", location.coordinate.longitude) as String, forKey: "lon")
            //print("緯度：\(location.coordinate.latitude)")
            //print("経度：\(location.coordinate.longitude)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if self.direction == "0.0" || self.direction == "0.00"{
            self.direction = NSString(format: "%0.2f", newHeading.trueHeading) as String
            print("方向:\(self.direction)")
        }else{
            if self.logStatus == false{
                print("Log Start!")
                self.timer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: #selector(ViewController.logEye(_:)), userInfo: nil, repeats: true)
                self.kakudo = NSString(string: RealtimeData.sharedInstance.dict[11]["value"]!).floatValue - NSString(string: self.direction).floatValue
                self.logStatus = true
            }
            
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

