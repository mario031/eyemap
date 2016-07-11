//
//  MimamoriTabBarController.swift
//  Mimamori
//
//  Created by Yuki Furukawa on 2015/09/04.
//  Copyright (c) 2015年 Life-Cloud. All rights reserved.
//

import UIKit

class EyeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewControllers:[UIViewController] = self.viewControllers!
        
        let font: UIFont! = UIFont.systemFontOfSize(12)
        
        viewControllers[0].tabBarItem.setTitleTextAttributes([NSFontAttributeName: font],forState:UIControlState.Normal)
        viewControllers[1].tabBarItem.setTitleTextAttributes([NSFontAttributeName: font],forState:UIControlState.Normal)
        self.selectedIndex = 0
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
