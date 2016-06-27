//
//  CustomTextField.swift
//  xPallet
//
//  Created by ChengXian Lim on 12/11/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import Foundation
import UIKit

enum TextFieldType: Int {
    case Normal, Email, Date, PhoneNumber, CardNumber, Password, CVV, ZipCode
}

protocol CustomTextFieldDelegate {
    func customTextFieldDidEndEditing(sender: AnyObject)
    func customTextFieldShouldReturn(sender: AnyObject)
}

class CustomTextField: UITextField, UITextFieldDelegate {
    
    var mDelegate: CustomTextFieldDelegate!
    var enableEmpty: Bool = true
    var type: TextFieldType = .Normal
    var borderWidth: CGFloat = 1.0
    var borderColor: UIColor = UIColor.clearColor()
    var textLength = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    func initialize() {
        self.delegate = self
        self.layer.borderColor = borderColor.CGColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidBeginEditing:", name: UITextFieldTextDidBeginEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidEndEditing:", name: UITextFieldTextDidEndEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: self)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidBeginEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidEndEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: self)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 4, 2)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 4, 2)
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        layer.borderWidth = borderWidth
    }
    
    func setTextFieldEnableEmpty(enable: Bool) {
        self.enableEmpty = enable
    }
    
    func setTextFieldBorderColor(borderColor:UIColor) {
        self.borderColor = borderColor
        self.layer.borderColor = borderColor.CGColor
    }
    
    func setTextFieldBorderWidth(borderWidth: CGFloat) {
        self.borderWidth = borderWidth
        self.layer.borderWidth = borderWidth
    }
    
    func setTextFieldType(textFieldType: TextFieldType) {
        type = textFieldType
        if type == .Email {
            
        } else if type == .Date {
            
        } else if type == .CardNumber {
            
        } else if type == .PhoneNumber {
        
        } else if type == .Password {
        
        }
    }
    
    func setValid(valid:Bool) {
        if valid == true {
            self.layer.borderColor = borderColor.CGColor
        }
        else {
            self.layer.borderColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0).CGColor
        }
    }
    
    func checkValid() -> Bool {
        if enableEmpty == true && self.text!.isEmpty == false {
            let currentText = self.text! as NSString
            
            if type == .Email {
                let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"                
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
                if emailTest.evaluateWithObject(self.text) == false {
//                    self.setValid(false)
                    return false
                }
                
            } else if type == .CardNumber && currentText.length > 19 {
//                self.setValid(false)
                return false
            } else if type == .Date && currentText.length > 5 {
//                self.setValid(false)
                return false
            } else if type == .PhoneNumber && currentText.length != 12 {
//                self.setValid(false)
                return false
            } else if type == .Password && currentText.length < 8{
//                self.setValid(false)
                return false
            } else if type == .CVV && currentText.length > 4 {
                return false
            } else if type == .ZipCode && currentText.length > 5 {
                return false
            }
//            self.setValid(true)
            return true
        }
//        self.setValid(false)
        return false
    }
    
    func textFieldDidBeginEditing(sender: UITextField) {
        self.layer.borderColor = borderColor.CGColor
    }
    
    func textFieldDidChange(sender: UITextField){
        if type == .PhoneNumber {
            var text = self.text! as NSString
            var delete = false
            if textLength >= text.length {
                delete = true
            } else {
                delete = false
            }
            
            var newText = self.text
            if text.length == 3 || text.length == 7 {
                if !delete {
                    newText = newText! + "-"
                }
            } else if textLength == 3 {
                if !delete {
                    newText = newText!.insertString("-", index: 3)
                }
            } else if textLength == 7 {
                if !delete {
                    newText = newText!.insertString("-", index: 7)
                }
            }
            self.text = newText
            text = newText! as NSString
            textLength = text.length
        } else if type == .CardNumber {
            var text = self.text! as NSString
            var delete = false
            if textLength >= text.length {
                delete = true
            } else {
                delete = false
            }
            
            var newText = self.text
            if text.length == 4 || text.length == 9 || text.length == 14 {
                if !delete {
                    newText = newText! + "-"
                }
            } else if textLength == 4 {
                if !delete {
                    newText = newText!.insertString("-", index: 4)
                }
            } else if textLength == 9 {
                if !delete {
                    newText = newText!.insertString("-", index: 9)
                }
            } else if textLength == 14 {
                if !delete {
                    newText = newText!.insertString("-", index: 14)
                }
            }
            self.text = newText
            text = newText! as NSString
            textLength = text.length
        } else if type == .Date {
            var text = self.text! as NSString
            var delete = false
            if textLength >= text.length {
                delete = true
            } else {
                delete = false
            }
            var newText = self.text
            if text.length == 2 {
                if !delete {
                    newText = newText! + "/"
                }
            } else if textLength == 2 {
                if !delete {
                    newText = newText!.insertString("/", index: 2)
                }
            }
            
            self.text = newText
            text = newText! as NSString
            textLength = text.length
        } else if type == .ZipCode {
            let text  = self.text! as NSString
            if text.length == 5 {
                self.mDelegate.customTextFieldDidEndEditing(self)
            }
        }
    }
    
    func textFieldDidEndEditing(sender: UITextField) {
        self.checkValid()
        if mDelegate != nil
        {
            mDelegate.customTextFieldDidEndEditing(self)
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.checkValid()
        if mDelegate != nil {
            mDelegate.customTextFieldShouldReturn(self)
            return true
        }
        return true
    }
}
