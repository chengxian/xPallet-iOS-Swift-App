//
//  CustomizeMoveViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 12/10/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit

class CustomizeMoveViewController: UIViewController {

    
    @IBOutlet weak var imgSmallMove: UIImageView!
    @IBOutlet weak var imgBigMove: UIImageView!
    @IBOutlet weak var imgBigTruck: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tapCustomizeButton(sender: AnyObject) {
        
    }
    
    @IBAction func tapBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
