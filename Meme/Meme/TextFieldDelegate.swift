//
//  TextFieldDelegate.swift
//  Meme
//
//  Created by Juntian Tao on 7/19/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}