//
//  MimamoriTabBarController.swift
//  Mimamori
//
//  Created by Yuki Furukawa on 2015/09/04.
//  Copyright (c) 2015年 Life-Cloud. All rights reserved.
//

import UIKit

class EyeNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = NSUserDefaults()
        let name:String = userDefaults.valueForKey("userName") as! String!
        self.navigationItem.title = name
        self.navigationItem.hidesBackButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
