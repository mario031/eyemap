//
//  CalendarViewController.swift
//  EyeMap
//
//  Created by mario on 2016/07/28.
//  Copyright © 2016年 mario. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ENSideMenuDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let userDefaults = NSUserDefaults()
    var num:String!
    var checkMarks = [false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name:String = "Settings"
        self.num = "1"
        userDefaults.setValue("", forKey: "value")
        userDefaults.setValue("", forKey: "num")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.title = name
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Bar"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CalendarViewController.menu(_:)))
        
        self.sideMenuController()?.sideMenu?.delegate = self
    }
    
    // sectionの数を返す
    func numberOfSectionsInTableView( tableView: UITableView ) -> Int {
        
        return 1
    }
    
    // 各sectionのitem数を返す
    func tableView( tableView: UITableView, numberOfRowsInSection section: Int ) -> Int  {
        
        return 3
    }
    
    // sectionのタイトル
    func tableView( tableView: UITableView, titleForHeaderInSection section: Int ) -> String? {
        
        if section < 1 {
            return "データ表示設定"
        }
        return nil
    }
    
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath ) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell( style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell" )
        
        switch indexPath.row {
        case 0:
            cell.accessoryType = .Checkmark
            cell.textLabel?.textColor = UIColor.blueColor()
            cell.detailTextLabel?.textColor = UIColor.blueColor()
            cell.textLabel!.text = "全てのデータを表示"
        case 1:
            cell.textLabel!.text = " \(self.num) 秒ごとの平均を表示"
        case 2:
            cell.textLabel!.text = " \(self.num) 個ごとの平均を表示"
            cell.detailTextLabel!.text = "データは20Hzで取得しています"
        default:
            break
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath ) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .None {
                cell.accessoryType = .Checkmark
                cell.textLabel?.textColor = UIColor.blueColor()
                cell.detailTextLabel?.textColor = UIColor.blueColor()
                
                checkMarks = checkMarks.enumerate().flatMap { (elem: (Int, Bool)) -> Bool in
                    if indexPath.row != elem.0 {
                        let otherCellIndexPath = NSIndexPath(forRow: elem.0, inSection: 0)
                        if let otherCell = tableView.cellForRowAtIndexPath(otherCellIndexPath) {
                            otherCell.accessoryType = .None
                            otherCell.textLabel?.textColor = UIColor.blackColor()
                            otherCell.detailTextLabel?.textColor = UIColor.blackColor()
                        }
                    }
                    return indexPath.row == elem.0
                }
            }
            switch indexPath.row {
            case 0:
                userDefaults.setValue("", forKey: "value")
                print("all data")
            case 1:
                let alert:UIAlertController = UIAlertController(title:"何秒ごとのデータを取得したいですか",
                                                                message: "",
                                                                preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
                                                                style: UIAlertActionStyle.Default,
                                                                handler:{
                                                                    (action:UIAlertAction!) -> Void in
                                                                    let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                                                                    if textFields != nil {
                                                                        for textField:UITextField in textFields! {
                                                                            if(textField.text != ""){
                                                                                self.userDefaults.setValue("time", forKey: "value")
                                                                                self.userDefaults.setValue(textField.text, forKey: "num")
                                                                                self.num = textField.text
                                                                                cell.textLabel!.text = " \(self.num) 秒ごとの平均を表示"
                                                                            }
                                                                        }
                                                                    }
                                                                    print("time avg data")
                })
                alert.addAction(defaultAction)
                
                //textfiledの追加
                alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
                    text.keyboardType = .NumberPad
                })
                presentViewController(alert, animated: true, completion: nil)
            case 2:
                let alert:UIAlertController = UIAlertController(title:"何個ごとのデータを取得したいですか",
                                                                message: "",
                                                                preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
                                                                style: UIAlertActionStyle.Default,
                                                                handler:{
                                                                    (action:UIAlertAction!) -> Void in
                                                                    let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                                                                    if textFields != nil {
                                                                        for textField:UITextField in textFields! {
                                                                            if(textField.text != ""){
                                                                                self.userDefaults.setValue("num", forKey: "value")
                                                                                self.userDefaults.setValue(textField.text, forKey: "num")
                                                                                self.num = textField.text
                                                                                cell.textLabel!.text = " \(self.num) 個ごとの平均を表示"
                                                                            }
                                                                        }
                                                                    }
                                                                    print("num avg data")
                })
                alert.addAction(defaultAction)
                
                //textfiledの追加
                alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
                    text.keyboardType = .NumberPad
                })
                presentViewController(alert, animated: true, completion: nil)
            default:
                break
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func menu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
