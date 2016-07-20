//
//  ViewController.swift
//  DelegatePractice
//
//  Created by Juntian Tao on 7/18/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var cashField: UITextField!
    @IBOutlet weak var lockField: UITextField!
    @IBOutlet weak var editable: UISwitch!
    
    let zipDelegate = ZipTextFieldDelegate()
    let cashDelegate = cashTextFieldDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zipCodeField.delegate = zipDelegate
        cashField.delegate = cashDelegate
        lockField.delegate = self
        
        editable.setOn(false, animated: true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return self.editable.on
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func toggle(sender: AnyObject) {
        if !editable.on {
            lockField.resignFirstResponder()
        }
    }

}

