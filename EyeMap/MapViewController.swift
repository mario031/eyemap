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
   
    var myLocationManager: CLLocationManager!
    var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = NSUserDefaults()
        let name:String = userDefaults.valueForKey("userName") as! String!
        self.navigationItem.title = name
        self.myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        myActivityIndicator.color = UIColor.blackColor()
        myActivityIndicator.hidesWhenStopped = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: myActivityIndicator)

        webview.delegate = self
        //webviewに表示
        let url = NSURL(string : "https://life-cloud.ht.sfc.keio.ac.jp/~mario/eyemap/index.php")
        let urlRequest = NSURLRequest(URL: url!)
        //        self.webview.scalesPageToFit = true
        self.webview.loadRequest(urlRequest)
    }
    
    @IBAction func reload(sender: AnyObject) {
        self.webview.reload()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        myActivityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        myActivityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

