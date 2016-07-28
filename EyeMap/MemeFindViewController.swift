//
//  MemeFindViewController.swift
//  EyeMap
//
//  Created by mario on 2016/07/07.
//  Copyright © 2016年 mario. All rights reserved.
//
import UIKit

final class MemeFindViewController: UITableViewController, MEMELibDelegate {
    
    var peripherals:NSMutableArray!
    var viewController:ViewController!
    var statusCheck: StatusCheck = StatusCheck()
    var timer:NSTimer = NSTimer()
    
    var connectedMemeId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MEMELib.sharedInstance().delegate = self
        self.peripherals = []
        self.title = "Search MEME"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scan", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MemeFindViewController.scanButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MemeFindViewController.cancelButtonPressed))
    }
    
    func scanButtonPressed(){
        self.peripherals = []
        let status:MEMEStatus = MEMELib.sharedInstance().startScanningPeripherals()
        SVProgressHUD.showWithStatus("Now Searching")
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "memeFoundError:", userInfo: nil, repeats: false)
        self.statusCheck.checkMEMEStatus(status)
    }
    
    func cancelButtonPressed(){
        SVProgressHUD.dismiss()
        timer.invalidate()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func memeFoundError(timer:NSTimer){
        MEMELib.sharedInstance().stopScanningPeripherals()
        SVProgressHUD.showErrorWithStatus("Not Found")
    }
    
    func memePeripheralFound(peripheral: CBPeripheral!, withDeviceAddress address: String!) {
        
        timer.invalidate()
        var alreadyFound = false
        for p in self.peripherals {
            if p.identifier == peripheral.identifier {
                alreadyFound = true
                break
            }
        }
        
        if !alreadyFound {
            print("New Peripheral found \(peripheral.identifier.UUIDString) \(address)")
            self.peripherals.addObject(peripheral)
            self.tableView.reloadData()
        }
        SVProgressHUD.dismiss()
    }
    
    func memePeripheralConnected(peripheral: CBPeripheral!) {
        
        print("MEME Device Connected")
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.tableView.userInteractionEnabled = false
        let data = MEMELib.sharedInstance().startDataReport()
        dispatch_async(dispatch_get_main_queue(), {
            if (data == MEME_OK) { // 呼び出し結果の確認
                MEMELib.sharedInstance().stopScanningPeripherals()
                self.performSegueWithIdentifier("backMainFromFind", sender: self)
            } else {
                SVProgressHUD.dismiss()
            }
        })
    }
    
    func memePeripheralDisconnected(peripheral: CBPeripheral!) {
        
        print("MEME Device Disconnected")
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.tableView.userInteractionEnabled = true
    }
    
    func memeRealTimeModeDataReceived(data: MEMERealTimeData!) {
        print("data received")
    }
    
    func memeAppAuthorized(status: MEMEStatus) {
        self.statusCheck.checkMEMEStatus(status)
    }
    
    
    func memeCommandResponse(response: MEMEResponse) {
        
        print("Command Response - eventCode: \(response.eventCode) - commandResult: \(response.commandResult)")
        
        switch (response.eventCode) {
        case 0x02:
            print("Data Report Started");
            break;
        case 0x04:
            print("Data Report Stopped");
            break;
        default:
            break;
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peripherals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceCellIdentifier", forIndexPath: indexPath)
        let peripheral:CBPeripheral = self.peripherals.objectAtIndex(indexPath.row) as! CBPeripheral
        cell.textLabel?.text = peripheral.identifier.UUIDString
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let peripheral:CBPeripheral = self.peripherals.objectAtIndex(indexPath.row) as! CBPeripheral
        let status:MEMEStatus = MEMELib.sharedInstance().connectPeripheral(peripheral)
        SVProgressHUD.showWithStatus("Now Connecting")
        self.statusCheck.checkMEMEStatus(status)
        if (status == MEME_OK) { // 呼び出し結果の確認
            print("select MEME")
        } else {
            SVProgressHUD.dismiss()
        }
        print("Start connecting to MEME Device...")
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


