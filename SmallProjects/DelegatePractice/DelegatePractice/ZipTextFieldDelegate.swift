//
//  ZipTextFieldDelegate.swift
//  DelegatePractice
//
//  Created by Juntian Tao on 7/18/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import Foundation
import UIKit

class ZipTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        
        return newText.length <= 5
    }
}
