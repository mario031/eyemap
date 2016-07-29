//
//  CalendarViewController.swift
//  EyeMap
//
//  Created by mario on 2016/07/28.
//  Copyright © 2016年 mario. All rights reserved.
//

import UIKit

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ENSideMenuDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectDateLabel: UILabel!
    
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    var day:String!
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today: NSDate!
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    
    let userDefaults = NSUserDefaults()
    var date:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name:String = "Calendar"
        
        date = []
        
        self.navigationItem.title = name
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Bar"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CalendarViewController.menu(_:)))
        self.sideMenuController()?.sideMenu?.delegate = self
        
        let data:NSString = "name=\(self.userDefaults.valueForKey("userName") as! String)"
        let myData:NSData = data.dataUsingEncoding(NSUTF8StringEncoding)!
        //URLの指定
        let url: NSURL! = NSURL(string: "https://life-cloud.ht.sfc.keio.ac.jp/~mario/eyemap/get_db_date.php")
        let request = NSMutableURLRequest(URL: url)
        //POSTを指定
        request.HTTPMethod = "POST"
        //Dataをセット
        request.HTTPBody = myData
        let result = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        let json = JSON(data:result!)
        for(var i = 0;i < json.count;i++){
            date.append(json[i].stringValue)
        }
        
        headerTitle.text = changeHeaderTitle(selectedDate)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        if section == 0 {
            return 7
        } else {
            return dateManager.daysAcquisition() //ここは月によって異なる(後ほど説明します)
        }
    }
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalendarCell
        //テキストカラー
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()
        } else {
            cell.textLabel.textColor = UIColor.blackColor()
        }
        //テキスト配置
        if indexPath.section == 0 {
            cell.textLabel.text = weekArray[indexPath.row]
        } else {
            cell.textLabel.text = dateManager.conversionDateFormat(indexPath)
            //月によって1日の場所は異なる(後ほど説明します)
        }
        
        //Cellの背景色変更
        let backgroundView = UIView(frame: cell.bounds)
        cell.backgroundColor = UIColor.whiteColor()
        cell.backgroundView = backgroundView
        
        let selectedBGView = UIView(frame: cell.bounds)
        selectedBGView.backgroundColor = UIColor.lightGrayColor()
        cell.selectedBackgroundView = selectedBGView
        
        if indexPath.section == 1{
            if indexPath.row >= dateManager.firstDate() && dateManager.lastDateOfMonth() >= indexPath.row{
                 cell.userInteractionEnabled = true
                for(var i = 0;i < date.count; i++){
                    self.day = dateManager.conversionDateFormat(indexPath)
                    let ngo = self.headerTitle.text! + "-" + day
                    if(ngo == date[i]){
                        let backgroundView = UIView(frame: cell.bounds)
                        cell.backgroundColor = UIColor.lightBlue()
                        cell.backgroundView = backgroundView
                    }
                }
            }else{
                cell.userInteractionEnabled = false
                cell.textLabel.text = ""
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalendarCell
        //ここに処理を記述
        if indexPath.section == 1{
            self.day = dateManager.conversionDateFormat(indexPath)
            userDefaults.setValue(self.headerTitle.text! + "-" + day, forKey: "date")
            self.selectDateLabel.text = self.headerTitle.text! + "-" + day
        }
    }
    
    //headerの月を変更
    func changeHeaderTitle(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let selectMonth = formatter.stringFromDate(date)
        return selectMonth
    }

    
    @IBAction func pushNextButton(sender: UIButton) {
        selectedDate = dateManager.nextMonth(selectedDate)
        collectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
    }
    
    @IBAction func pushPrevButton(sender: UIButton) {
        selectedDate = dateManager.prevMonth(selectedDate)
        collectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func menu(sender: AnyObject) {
        toggleSideMenuView()
    }

}
