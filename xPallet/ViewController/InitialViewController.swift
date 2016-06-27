//
//  InitialViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/23/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "AgreeToTerms")
        NSUserDefaults.standardUserDefaults().removeObjectForKey(pickUpLongitude)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(pickUpLatitude)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func tapLoginButton(sender: AnyObject) {
        let token = NSUserDefaults.standardUserDefaults().objectForKey(pUserToken)
        if token == nil {
            self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController, animated: true)
        } else {
            self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("mainViewController") as! MainViewController, animated: true)
        }
    }
    @IBAction func tapRegisterButton(sender: AnyObject) {
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("registerViewController") as! RegisterViewController, animated: true)
    }
}
