//
//  ViewController.swift
//  EyeMap
//
//  Created by mario on 2016/07/04.
//  Copyright © 2016年 mario. All rights reserved.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    
    var date:String = ""
    var diffDate:NSDate!
   
    var myLocationManager: CLLocationManager!
    var dateFormatter = NSDateFormatter()
    
    let userDefaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.diffDate = NSDate()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.stringFromDate(self.diffDate)
        self.navigationItem.title = userDefaults.valueForKey("userName") as! String + " " + self.date

        webview.delegate = self
        //webviewに表示
        let url = NSURL(string : "https://life-cloud.ht.sfc.keio.ac.jp/~mario/eyemap/index.php?name=\(userDefaults.valueForKey("userName") as! String!)&date=\(self.date)")
        let urlRequest = NSURLRequest(URL: url!)
        self.webview.loadRequest(urlRequest)
    }
    
    //今日に戻る
    @IBAction func reload(sender: AnyObject) {
        self.diffDate = NSDate()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.stringFromDate(self.diffDate)
        self.navigationItem.title = userDefaults.valueForKey("userName") as! String + " " + self.date
        self.webview.reload()
    }
    
    //日付を戻る
    @IBAction func back(sender: AnyObject) {
        self.diffDate = NSDate(timeInterval: -24*60*60, sinceDate: self.diffDate)
        self.date = dateFormatter.stringFromDate(self.diffDate)
        let url = NSURL(string : "https://life-cloud.ht.sfc.keio.ac.jp/~mario/eyemap/index.php?name=\(userDefaults.valueForKey("userName") as! String!)&date=\(self.date)")
        let urlRequest = NSURLRequest(URL: url!)
        self.webview.loadRequest(urlRequest)
        self.navigationItem.title = userDefaults.valueForKey("userName") as! String + " " + self.date
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

