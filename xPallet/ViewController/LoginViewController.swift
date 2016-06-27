//
//  LoginViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/23/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class LoginViewController: UIViewController,  APIHelperControllerDelegate, CustomTextFieldDelegate {

    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var btnLoginNext: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnFacebookConnect: UIButton!
    
    var apiController: APIHelperController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.mDelegate = self
        passwordTextField.mDelegate = self
        emailTextField.setTextFieldType(.Email)
        passwordTextField.setTextFieldType(.Password)
        
        apiController = APIHelperController()
        apiController.apiHelperDelegate = self
        
        initView()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func initView(){
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
    }
    @IBAction func tabFacebookConnect(sender: AnyObject) {
        
    }
    
    @IBAction func gotoInitialScreen(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func tapLoginNext(sender: AnyObject) {
        self.checkValidation()
    }
    
    @IBAction func tapForgotPassword(sender: AnyObject) {
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("forgetPasswordVIew") as! ForgetPasswordViewController, animated: true)
    }
    
    func checkValidation(){
        if emailTextField.text != "" && passwordTextField.text != "" {
            _ = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.attemptLogin()
        } else {
            ShowAlerts.showErrorAlerts("", errorMessage: "Enter Email and Password")
        }
    }
    
    func attemptLogin(){
        apiController.requestPostAPIs(kUserLogIn, parameter: [pUserEmail: emailTextField.text!, pUserPassword: passwordTextField.text!])
    }
    
    // MARK: CustomTextField Delegate
    func customTextFieldDidEndEditing(sender: AnyObject) {
        
    }
    
    func customTextFieldShouldReturn(sender: AnyObject) {
        let textField = sender as! CustomTextField
        switch textField {
        case self.emailTextField:
            passwordTextField.becomeFirstResponder()
            break
        case self.passwordTextField:
            passwordTextField.resignFirstResponder()
            break
        default:
            break
        }
    }
    
    // MARK: APIHelperDelegate
    func onSuccess(api: String, response: Response<AnyObject, NSError>) {
//        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        if api == kUserLogIn {
            let error = response.result.value?.valueForKey("error")
            if error != nil {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                ShowAlerts.showErrorAlerts("Login Failed", errorMessage: error as! String)
            } else {
                print(response.result.value)
                if response.result.value?.valueForKey("success") as! Bool == true{
                    let token = response.result.value?.valueForKey("token") as! String
                    NSUserDefaults.standardUserDefaults().setObject(token, forKey: pUserToken)
                    // Get Braintree client token
                    apiController.requestGetAPIs(kGetBrainTreeToken, parameter: [pUserToken: token])
                }
            }
        } else if api == kGetBrainTreeToken {
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            let error = response.result.value?.valueForKey("error")
            if response.result.value?.valueForKey("success") as! Bool == true {
                let bToken = response.result.value?.valueForKey(pBraintreeClientToken) as! String
                NSUserDefaults.standardUserDefaults().setObject(bToken, forKey: pBraintreeClientToken)
                self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("mainViewController") as! MainViewController, animated: true)
                print(bToken)
            } else {
                print(error)
            }
        }
    }
    
    func onFailed(api: String) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
}
