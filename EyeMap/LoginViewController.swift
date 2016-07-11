//
//  ViewController.swift
//  EyeMap
//
//  Created by mario on 2016/07/04.
//  Copyright © 2016年 mario. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let userDefaults = NSUserDefaults()
                userDefaults.setValue(unwrappedSession.userName, forKey: "userName")
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                    (action:UIAlertAction) -> Void in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController")
                    self.presentViewController(viewController, animated: true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)

    }
}
