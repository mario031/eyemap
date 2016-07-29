//
//  MapNavigationController.swift
//  EyeMap
//
//  Created by mario on 2016/07/28.
//  Copyright © 2016年 mario. All rights reserved.
//

import UIKit

class MapNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: MyMenuTableViewController(), menuPosition:.Left)
        //sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 180.0 // optional, default is 160
        sideMenu?.bouncingEnabled = false
//        sideMenu?.allowPanGesture = false
        sideMenu?.animationDuration = 0.2
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
