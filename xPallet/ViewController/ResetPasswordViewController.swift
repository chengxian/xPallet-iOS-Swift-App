//
//  ResetPasswordViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 12/10/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ResetPasswordViewController: UIViewController, CustomTextFieldDelegate, APIHelperControllerDelegate {

    
    @IBOutlet weak var txtSMSCode: CustomTextField!
    @IBOutlet weak var txtNewPassword: CustomTextField!
    @IBOutlet weak var txtConfirmPassword: CustomTextField!
    
    var apiHelperController: APIHelperController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        apiHelperController = APIHelperController()
        apiHelperController.apiHelperDelegate = self
        
        txtSMSCode.mDelegate = self
        txtNewPassword.mDelegate = self
        txtConfirmPassword.mDelegate = self
        
        txtNewPassword.setTextFieldType(.Password)
        txtConfirmPassword.setTextFieldType(.Password)
        
        let tapViewGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tapViewGesture)
        initView()
    }
    
    @IBAction func tapBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func tapUpdatePassword(sender: AnyObject) {
        checkValidation()
    }
    
    func dismissKeyboard(sender: AnyObject){        
        self.txtSMSCode.resignFirstResponder()
        self.txtNewPassword.resignFirstResponder()
        self.txtConfirmPassword.resignFirstResponder()
    }
    
    func initView(){
        txtSMSCode.attributedPlaceholder = NSAttributedString(string: "Code", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtNewPassword.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
    }
    
    func checkValidation (){
        if txtNewPassword.text != "" && txtConfirmPassword.text != "" && txtSMSCode.text != "" {
            let pass = txtNewPassword.text! as NSString
            if pass.length >= 8 {
                if txtNewPassword.text == txtConfirmPassword.text {
                    _ = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    attemptUpdatePassword()
                } else {
                    ShowAlerts.showErrorAlerts("", errorMessage: "Confirm password must be same with new password")
                }
            } else {
                ShowAlerts.showErrorAlerts("", errorMessage: "Password should be longer than 8 letters.")
            }
        } else {
            ShowAlerts.showErrorAlerts("", errorMessage: "Please fill all fields.")
        }
    }
    
    func attemptUpdatePassword() {
        apiHelperController.requestPutAPIs(kChangePassword, parameter: [pNewPassword: txtNewPassword.text!,
            pPasswordConfirm: txtConfirmPassword.text!,
            pMobileFriendlyToken: txtSMSCode.text!])
    }
    
    // MARK: APIHelperController Delegate
    func onSuccess(api: String, response: Response<AnyObject, NSError>) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        print(response.result.value)
        let error = response.result.value?.valueForKey("error")
        if error != nil {
            ShowAlerts.showErrorAlerts("", errorMessage: "SMS Code Incorrect. Please try again")
        } else {
            if response.result.value?.valueForKey("success") as! Bool == true {
                self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("mainViewController") as! MainViewController, animated: true)
            }
        }
    }
    
    func onFailed(api: String) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    // MARK: CustomTextField Delegate
    func customTextFieldShouldReturn(sender: AnyObject) {
        let textField = sender as! CustomTextField
        switch textField {
        case txtSMSCode:
            txtNewPassword.becomeFirstResponder()
            break
        case txtNewPassword:
            txtConfirmPassword.becomeFirstResponder()
            break
        case txtConfirmPassword:
            txtConfirmPassword.resignFirstResponder()
            break
        default:
            break
        }
    }
    
    func customTextFieldDidEndEditing(sender: AnyObject) {
        
    }
}
