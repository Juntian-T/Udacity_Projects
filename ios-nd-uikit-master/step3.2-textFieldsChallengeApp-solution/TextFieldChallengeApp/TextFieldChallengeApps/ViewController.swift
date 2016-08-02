//
//  ViewController.swift
//  TextFieldChallengeApps
//
//  Created by Jason on 11/12/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var editingSwitch: UISwitch!
    
    let zipCodeDelegate = ZipCodeTextFieldDelegate()
    let cashDelegate = CashTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField1.delegate = self.zipCodeDelegate
        self.textField2.delegate = self.cashDelegate
        self.textField3.delegate = self
        
        self.editingSwitch.setOn(false, animated: false)
    }
    
    // Text Field Delegate

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return self.editingSwitch.on
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    @IBAction func toggleTheTextEditor(sender: AnyObject) {
        
        if !(sender as! UISwitch).on {
            self.textField3.resignFirstResponder()
        }
    }

}

