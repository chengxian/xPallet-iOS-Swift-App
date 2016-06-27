//
//  ProfileViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 12/14/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, CustomTextFieldDelegate {

    
    @IBOutlet weak var txtUserName: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPhoneNumber: CustomTextField!
    @IBOutlet weak var accountTypeSwitch: CustomSwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtUserName.mDelegate = self
        txtEmail.mDelegate = self
        txtPhoneNumber.mDelegate = self
        
        txtPhoneNumber.setTextFieldType(.PhoneNumber)
        txtEmail.setTextFieldType(.Email)
        // Do any additional setup after loading the view.
        
        let tapViewGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tapViewGesture)
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func changeAccountType(sender: AnyObject) {
        
    }
    
    @IBAction func tapUpdateProfile(sender: AnyObject) {
        
    }
    
    @IBAction func tapLogOut(sender: AnyObject) {
        logOut()
    }
    
    func initView(){
        txtUserName.attributedPlaceholder = NSAttributedString(string: "User name", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtPhoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        
        accountTypeSwitch.leftTitle = "Personal"
        accountTypeSwitch.rightTitle = "Business"
        accountTypeSwitch.backgroundColor = UIColor(red: 77/255.0, green: 90/255.0, blue: 107/255.0, alpha: 1)
        accountTypeSwitch.selectedBackgroundColor = UIColor(red: 94/255.0, green: 160/255.0, blue: 239/255.0, alpha: 1)
        accountTypeSwitch.selectedTitleColor = UIColor.whiteColor()
        accountTypeSwitch.titleColor = UIColor(white: 1, alpha: 0.5)
        accountTypeSwitch.titleFont = UIFont.systemFontOfSize(15)
        
    }
    
    func dismissKeyboard(sender: AnyObject){
        self.txtEmail.resignFirstResponder()
        self.txtUserName.resignFirstResponder()
        self.txtPhoneNumber.resignFirstResponder()
    }
    
    func logOut (){
        // Logout functions
        NSUserDefaults.standardUserDefaults().removeObjectForKey(pUserToken)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(pBraintreeClientToken)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    // MARK: CustomTextField Delegate
    
    func customTextFieldDidEndEditing(sender: AnyObject) {
        
    }
    
    func customTextFieldShouldReturn(sender: AnyObject) {
        let textField = sender as! CustomTextField
        switch textField {
        case self.txtUserName:
            txtEmail.becomeFirstResponder()
            break
        case self.txtEmail:
            txtPhoneNumber.becomeFirstResponder()
            break
        case self.txtPhoneNumber:
            txtPhoneNumber.resignFirstResponder()
            break
        default:
            break
        }
    }
}
