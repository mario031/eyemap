//
//  ViewController.swift
//  EyeMap
//
//  Created by mario on 2016/07/04.
//  Copyright © 2016年 mario. All rights reserved.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController,UIWebViewDelegate, ENSideMenuDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    
    var date:String = ""
    var diffDate:NSDate!
    var myLocationManager: CLLocationManager!
    var dateFormatter = NSDateFormatter()
    
    let userDefaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.date = userDefaults.valueForKey("date") as! String
        self.navigationItem.title = "Map:" + self.date
        
        self.sideMenuController()?.sideMenu?.delegate = self
        
        webview.delegate = self
        //webviewに表示
        let url = NSURL(string : "https://life-cloud.ht.sfc.keio.ac.jp/~mario/eyemap/index.php?name=\(userDefaults.valueForKey("userName") as! String!)&date=\(self.date)&value=\(userDefaults.valueForKey("value") as! String)&num=\(userDefaults.valueForKey("num") as! String)")
        let urlRequest = NSURLRequest(URL: url!)
        self.webview.loadRequest(urlRequest)
    }
    
    //今日に戻る
    @IBAction func reload(sender: AnyObject) {
        let url = NSURL(string : "https://life-cloud.ht.sfc.keio.ac.jp/~mario/eyemap/index.php?name=\(userDefaults.valueForKey("userName") as! String!)&date=\(self.date)&value=\(userDefaults.valueForKey("value") as! String)&num=\(userDefaults.valueForKey("num") as! String)")
        let urlRequest = NSURLRequest(URL: url!)
        self.webview.loadRequest(urlRequest)

        self.navigationItem.title = userDefaults.valueForKey("userName") as! String + " " + self.date
    }
    
    //Menu
    @IBAction func menu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showWithStatus("Now Loading")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

