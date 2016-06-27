//
//  SMSVerificationViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/23/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class SMSVerificationViewController: UIViewController, CustomTextFieldDelegate, APIHelperControllerDelegate {

    @IBOutlet weak var txtVerificationCode: CustomTextField!
    @IBOutlet weak var btnResend: UIButton!
    
    var apiHelperController: APIHelperController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtVerificationCode.becomeFirstResponder()
        txtVerificationCode.mDelegate = self
        
        apiHelperController = APIHelperController()
        apiHelperController.apiHelperDelegate = self
        
        let tapViewGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tapViewGesture)
        initView()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func tapResendButton(sender: AnyObject) {
        _ = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        attemptResendCode()
    }
    
    func initView(){
        txtVerificationCode.attributedPlaceholder = NSAttributedString(string: "Code", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
    }
    
    @IBAction func tapNextButton(sender: AnyObject) {
        //This part will be changed later
        if txtVerificationCode.text != "" {
            _ = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.attemptVerify()
        } else {
            ShowAlerts.showErrorAlerts("", errorMessage: "Enter Verification Code")
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
            self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dismissKeyboard(sender: AnyObject){
        self.txtVerificationCode.resignFirstResponder()
    }
    
    func attemptVerify(){
        let code = txtVerificationCode.text
        apiHelperController.requestPutAPIs(kSMSVerify, parameter: [pMobileFriendlyToken: code!])
    }
    
    func attemptResendCode(){
        let phoneNumber = NSUserDefaults.standardUserDefaults().objectForKey(mPhoneNumber) as! String
        apiHelperController.requestPostAPIs(kSMSVerifyResend, parameter: [mPhoneNumber: phoneNumber])
    }
    
    // MARK: CustomTextField Delegate
    func customTextFieldShouldReturn(sender: AnyObject) {
        let textField = sender as! CustomTextField
        textField.resignFirstResponder()
    }
    
    func customTextFieldDidEndEditing(sender: AnyObject) {
        
    }
    
    // MARK: APIHelperDelegate
    func onSuccess(api: String, response: Response<AnyObject, NSError>) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        switch api {
        case kSMSVerify:
            if response.result.value?.valueForKey("errors") != nil {
                let error = response.result.value?.valueForKey("errors") as! [AnyObject]
                ShowAlerts.showErrorAlerts("", errorMessage: error[0] as! String)
            } else {
                print(response.result.value)
                if response.result.value?.valueForKey("success") as! Bool == true {
                    self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("mainViewController") as! MainViewController, animated: true)
                }
            }
            break
        case kSMSVerifyResend:
            print(response.result.value)
            break
        default:
            return
        }
    }
    
    func onFailed(api: String) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        ShowAlerts.showErrorAlerts("", errorMessage: "Unknown network error")
    }
    
}
