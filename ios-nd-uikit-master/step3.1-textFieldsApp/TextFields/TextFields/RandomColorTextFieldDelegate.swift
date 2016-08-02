//
//  RandomColorTextFieldDelegate.swift
//  TextFields
//
//  Created by Juntian Tao on 7/18/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit

class RandomColorTestFieldDelegate: NSObject, UITextFieldDelegate {
    
    let colors = [UIColor.redColor(), UIColor.orangeColor(),
                  UIColor.yellowColor(), UIColor.greenColor(),
                  UIColor.blueColor(), UIColor.purpleColor(),
                  UIColor.brownColor()];
    
    func randomColor() -> UIColor {
        let index = Int(arc4random()) % colors.count
        return colors[index]
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.textColor = self.randomColor()
        return true
    }
}
