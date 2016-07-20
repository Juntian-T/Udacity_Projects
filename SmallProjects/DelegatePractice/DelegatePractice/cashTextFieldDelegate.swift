//
//  cashTextFieldDelegate.swift
//  DelegatePractice
//
//  Created by Juntian Tao on 7/18/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import Foundation
import UIKit

class cashTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        var newText = oldText.stringByReplacingCharactersInRange(range, withString: string)
        var newTextString = String(newText)
        
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        var digitText = ""
        for c in newTextString.unicodeScalars {
            if digits.longCharacterIsMember(c.value) {
                digitText.append(c)
            }
        }
        print("Current String:" + digitText)
        
        if let numOfPennies = Int(digitText) {
            print("Current pennies: " + String(numOfPennies))
            let dollars = String(numOfPennies / 100)
            let cents = numOfPennies % 100
            let centsString = cents < 10 ? "0" + String(cents): String(cents)
            newText = "$\(dollars).\(centsString)"
            print("Dollars: " + dollars)
            print("Cents: " + centsString)
        } else {
            newText = "$0.00"
        }
        print("Formatted: " + newText)
        textField.text = newText
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = "$0.00"
    }
    
}
