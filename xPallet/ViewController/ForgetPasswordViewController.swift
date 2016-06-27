//
//  ForgetPasswordViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 12/10/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ForgetPasswordViewController: UIViewController, CustomTextFieldDelegate, APIHelperControllerDelegate {

    
    @IBOutlet weak var txtPhoneNumber: CustomTextField!
    var phoneNumberLength = 0
    
    var apiHelperController: APIHelperController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtPhoneNumber.mDelegate = self
        txtPhoneNumber.setTextFieldType(.PhoneNumber)
        
        txtPhoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        let tapViewGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tapViewGesture)
        
        apiHelperController = APIHelperController()
        apiHelperController.apiHelperDelegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapSubmit(sender: AnyObject) {
        checkValidation()
    }
    
    @IBAction func tapBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dismissKeyboard(sender: AnyObject){        
        self.txtPhoneNumber.resignFirstResponder()
    }
    
    func checkValidation(){
        // This part will be updated later
        if txtPhoneNumber.text != "" {
            attemptRequestPassword()
        } else {
            ShowAlerts.showErrorAlerts("", errorMessage: "Please enter your phone number.")
        }
    }
    
    func attemptRequestPassword(){
        _ = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let phoneNumber = txtPhoneNumber.text?.stringByReplacingOccurrencesOfString("-", withString: "")
//        NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: mPhoneNumber)
        apiHelperController.requestPostAPIs(kForgetPassword, parameter: [mPhoneNumber: "1" + phoneNumber!])
    }
    
    // MARK: CustomTextField Delegate
    func customTextFieldShouldReturn(sender: AnyObject) {
        let textField = sender as! CustomTextField
        textField.resignFirstResponder()
    }
    
    func customTextFieldDidEndEditing(sender: AnyObject) {
        
    }
    
    // MARK: APIHelperControllerDelegate
    
    func onSuccess(api: String, response: Response<AnyObject, NSError>) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        print(response.result.value)
        
        let error = response.result.value?.valueForKey("error")
        if error != nil {
            ShowAlerts.showErrorAlerts("", errorMessage: error as! String)
        } else {
            if response.result.value?.valueForKey("success") as! Bool == true {
                self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("resetPasswordView") as! ResetPasswordViewController, animated: true)
            }
        }
    }
    
    func onFailed(api: String) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
}
