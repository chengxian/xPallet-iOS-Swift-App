//
//  RegisterViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/23/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class RegisterViewController: UIViewController,  APIHelperControllerDelegate, CustomTextFieldDelegate {
    
    @IBOutlet weak var txtFirstName: CustomTextField!
    @IBOutlet weak var txtLastName: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPhoneNumber: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var btnAgreeTerms: UIButton!
    @IBOutlet weak var usageSwitch: CustomSwitch!
    
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    
    var phoneNumberLength = 0
    var apiHelperController: APIHelperController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFirstName.mDelegate = self
        txtLastName.mDelegate = self
        txtEmail.mDelegate = self
        txtPhoneNumber.mDelegate = self
        txtPassword.mDelegate = self
        
        txtPhoneNumber.setTextFieldType(.PhoneNumber)
        txtEmail.setTextFieldType(.Email)
        txtPassword.setTextFieldType(.Password)
        
        apiHelperController = APIHelperController()
        apiHelperController.apiHelperDelegate = self
        
        let tapViewGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tapViewGesture)
        initView()
    }
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().objectForKey("AgreeToTerms") as! Bool == true {
            btnAgreeTerms.selected = true
        }
    }
    
    func initView(){
        txtFirstName.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtLastName.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtPhoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
                
        usageSwitch.leftTitle = "Personal"
        usageSwitch.rightTitle = "Business"
        usageSwitch.backgroundColor = UIColor(red: 77/255.0, green: 90/255.0, blue: 107/255.0, alpha: 1)
        usageSwitch.selectedBackgroundColor = UIColor(red: 94/255.0, green: 160/255.0, blue: 239/255.0, alpha: 1)
        usageSwitch.selectedTitleColor = UIColor.whiteColor()
        usageSwitch.titleColor = UIColor(white: 1, alpha: 0.5)
        usageSwitch.titleFont = UIFont.systemFontOfSize(15)
        
    }
    
    @IBAction func tapLoginWithFacebook(sender: AnyObject) {
        
    }
    
    @IBAction func tapAgreeTerms(sender: AnyObject) {
        btnAgreeTerms.selected = !btnAgreeTerms.selected
    }
    
    @IBAction func gotoTermsAndConditions(sender: AnyObject) {
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("terms_view_controller") as! TermsAndConditionViewController, animated: true)
    }
    
    @IBAction func tapNextButton(sender: AnyObject) {
        checkValidation()
    }
    
    @IBAction func tapBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func switchUsage(sender: AnyObject) {
        
    }
    
    func dismissKeyboard(sender: AnyObject){
        self.txtEmail.resignFirstResponder()
        self.txtFirstName.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtPhoneNumber.resignFirstResponder()
    }
    
    func checkValidation(){
        // This part will be updated later
        if txtPassword.text != "" && txtFirstName.text != "" && txtLastName.text != "" && txtEmail.text != "" && txtPhoneNumber.text != "" {
            let pass = txtPassword.text! as NSString
            if pass.length >= 8 {
                if txtEmail.text?.containsString("@") == true {
                    if self.btnAgreeTerms.selected {
                        attemptRegister()
                    } else {
                        ShowAlerts.showErrorAlerts("", errorMessage: "Please agree to terms and conditions.")
                    }
                } else {
                    ShowAlerts.showErrorAlerts("", errorMessage: "Email type incorrect.")
                }
            } else {
                ShowAlerts.showErrorAlerts("", errorMessage: "Password should be longer than 8 letters.")
            }
        } else {
            ShowAlerts.showErrorAlerts("", errorMessage: "Please fill all fields.")
        }
    }
    
    func attemptRegister(){
        _ = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let phoneNumber = txtPhoneNumber.text?.stringByReplacingOccurrencesOfString("-", withString: "")
        apiHelperController.requestPostAPIs(kUserSignUp, parameter: [pUserEmail: txtEmail.text!,
                                                                    pUserPassword: txtPassword.text!,
                                                                    pUserPasswordConfirm: txtPassword.text!,
                                                                    pUserFirstName: txtFirstName.text!,
                                                                    pUserLastName: txtLastName.text!,
                                                                    pUserPhoneNumber: "1" + phoneNumber!,
                                                                    pUserRole: "user"])
    }
    
    // MARK: CustomTextField Delegate
    func customTextFieldDidEndEditing(sender: AnyObject) {
        
    }
    
    func customTextFieldShouldReturn(sender: AnyObject) {
        let textField = sender as! CustomTextField
        switch textField {
        case self.txtFirstName:
            txtLastName.becomeFirstResponder()
            break
        case self.txtLastName:
            txtEmail.becomeFirstResponder()
            break
        case self.txtEmail:
            txtPhoneNumber.becomeFirstResponder()
            break
        case self.txtPhoneNumber:
            txtPassword.becomeFirstResponder()
            break
        case self.txtPassword:
            txtPassword.resignFirstResponder()
            break
        default:
            break
        }
    }
    
    // MARK: APIHelperControllerDelegate
    func onSuccess(api: String, response: Response<AnyObject, NSError>) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        let error = response.result.value?.valueForKey("errors")
        if error != nil {
            let emailUsed = error?.valueForKey("email") as! [AnyObject]
            if emailUsed[0] as! String == eEmailAreadyTaken {
                print(emailUsed[0] as! String)
                let alert = UIAlertController(title: "Account already exists", message: "Please login", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                    self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController, animated: true)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }            
        } else {
            print(response.result.value)
            let phoneNumber = response.result.value?.valueForKey(mPhoneNumber)
            NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: mPhoneNumber)
            self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("sms_verification_view_controller") as! SMSVerificationViewController, animated: true)
        }
    }
    
    func onFailed(api: String) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
}
