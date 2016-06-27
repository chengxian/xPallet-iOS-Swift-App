//
//  ShowAlerts.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/24/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit

class ShowAlerts {
    
    class func showErrorAlerts(title: String, errorMessage: String){
        let errorAlert = UIAlertView()
        errorAlert.title = title
        errorAlert.message = errorMessage
        errorAlert.delegate = nil
        errorAlert.addButtonWithTitle("OK")
        errorAlert.show()
    }
}
