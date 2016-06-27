//
//  AddCardViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 12/10/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit
import Alamofire
import Braintree
import MBProgressHUD

class AddCardViewController: UIViewController, CustomTextFieldDelegate {

    
    @IBOutlet weak var txtCardNumber: CustomTextField!
    @IBOutlet weak var txtExpiresDate: CustomTextField!
    @IBOutlet weak var txtZipCode: CustomTextField!
    @IBOutlet weak var txtCVV: CustomTextField!
    
    var brainClient: BTAPIClient!
    let bClientToken = NSUserDefaults.standardUserDefaults().objectForKey(pBraintreeClientToken) as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtCardNumber.mDelegate = self
        txtExpiresDate.mDelegate = self
        txtCVV.mDelegate = self
        txtZipCode.mDelegate = self
        
        txtCardNumber.setTextFieldType(.CardNumber)
        txtExpiresDate.setTextFieldType(.Date)
        txtZipCode.setTextFieldType(.ZipCode)
        txtCVV.setTextFieldType(.CVV)
        
        let tapViewGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tapViewGesture)
        
        initView()
        // Do any additional setup after loading the view.
        
        brainClient = BTAPIClient(authorization: bClientToken)
    }

    @IBAction func tapSaveButton(sender: AnyObject) {
        if checkValidation() {
            self.saveCard()
        }
    }
    
    @IBAction func tapBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func initView(){
        txtCardNumber.attributedPlaceholder = NSAttributedString(string: "Card Number", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtExpiresDate.attributedPlaceholder = NSAttributedString(string: "MM/YY", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtCVV.attributedPlaceholder = NSAttributedString(string: "CVV", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        txtZipCode.attributedPlaceholder = NSAttributedString(string: "ZIP", attributes: [NSForegroundColorAttributeName: placeholderTextColor])
    }
    
    func dismissKeyboard(sender: AnyObject){
        self.txtCardNumber.resignFirstResponder()
        self.txtCVV.resignFirstResponder()
        self.txtZipCode.resignFirstResponder()
        self.txtExpiresDate.resignFirstResponder()
    }
    
    func checkValidation() -> Bool{
        if !txtCardNumber.checkValid() {
            return false
        } else if !txtCVV.checkValid() {
            return false
        } else if !txtExpiresDate.checkValid(){
            return false
        } else if !txtZipCode.checkValid() {
            return false
        }
        return true
    }
    
    func saveCard() {
        var cardClient: BTCardClient!
        cardClient = BTCardClient(APIClient: brainClient)
        let cardNumber = txtCardNumber.text?.stringByReplacingOccurrencesOfString("-", withString: "")
        let expireDate = txtExpiresDate.text! as String
        
        if cardClient != nil{
            let card = BTCard(number: cardNumber!, expirationMonth: String(expireDate.characters.prefix(2)), expirationYear: "20" + String(expireDate.characters.suffix(2)), cvv: txtCVV.text)
            card.postalCode = txtZipCode.text
            cardClient.tokenizeCard(card, completion: { (cardNounce: BTCardNonce?, error: NSError?) -> Void in
                if error == nil {
                    print("Successfully got nonce: \((cardNounce?.nonce)! as String)")
                } else {
                    print(error)
                }
            })
        } else {
            print("Unable to create cardClient. Check that tokenization key or client token is valid.")
        }
    }
    
    // MARK: CustomTextField Delegate
    func customTextFieldShouldReturn(sender: AnyObject) {
        let textField = sender as! CustomTextField
        switch textField {
        case txtCardNumber:
            txtExpiresDate.becomeFirstResponder()
            break
        case txtExpiresDate:
            txtCVV.becomeFirstResponder()
            break
        case txtCVV:
            txtZipCode.becomeFirstResponder()
            break
        case txtZipCode:
            txtZipCode.resignFirstResponder()
            break
        default:
            break
        }
    }
    
    func customTextFieldDidEndEditing(sender: AnyObject) {
        let textField = sender as! CustomTextField
        if textField == txtZipCode {
            txtZipCode.resignFirstResponder()
        }
    }
}
