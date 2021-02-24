//
//  UITextField+Additions.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 10/01/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    // MARK: Public Methods
    
    func isValid() -> Bool {
        
        if (text?.isEmpty == true) {
            Utility.showSnackBar(msg: App.Validations.requiredStr, icon: nil)
            return false
        }
        
        if (self.keyboardType == .emailAddress) {
            return isEmail(self.text)
        }
        
        return true
    }
}

extension UITextField{
 
    // MARK: Public Methods
    
    func isValid() -> Bool {
        
        if (text?.isEmpty == true) {
            Utility.showSnackBar(msg: App.Validations.requiredStr, icon: nil)
            return false
        }
        
        if (self.keyboardType == .emailAddress) {
            return isEmail(self.text)
        }
        
        return true
    }
    
    func compare(field: UITextField)-> Bool {
        if self.text == field.text {
            return true
        }
        Utility.showSnackBar(msg: App.Validations.compareStr, icon: nil)
        return false
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension UITextView {
    
    func getExpandedHeight(_ maxExpand: CGFloat, _ isScrollable: Bool = true)-> CGFloat {
        
        let fixedWidth = self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: maxExpand))
        
        var maxHeight : CGFloat = 0
        if newSize.height > maxExpand {
            maxHeight = maxExpand
            self.isScrollEnabled = isScrollable
        } else {
            maxHeight = newSize.height
            self.isScrollEnabled = false
        }
        self.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: maxHeight)
        
        return maxHeight
    }
    
}
