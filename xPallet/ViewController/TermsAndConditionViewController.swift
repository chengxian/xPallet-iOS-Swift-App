//
//  TermsAndConditionViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/23/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit

class TermsAndConditionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goBackToRegister(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func agreeTerms(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "AgreeToTerms")
        self.navigationController?.popViewControllerAnimated(true)
    }

}


