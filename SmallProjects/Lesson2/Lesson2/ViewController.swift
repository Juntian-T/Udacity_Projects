//
//  ViewController.swift
//  Lesson2
//
//  Created by Juntian Tao on 7/16/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func activityButtonPressed(sender: AnyObject) {
        let img = UIImage()
        let activityVC = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    @IBAction func buttonPressed(sender: AnyObject) {
        let nextController = UIImagePickerController()
        self.presentViewController(nextController, animated: true, completion: nil)
    }

    @IBAction func alertButtonPressed(sender: AnyObject) {
        let alertVC = UIAlertController(title: "Alert Title", message: "This is an alerrrt", preferredStyle: .ActionSheet)
        let okAction = UIAlertAction(title: "Okay", style: .Default, handler: { action in self.dismissViewControllerAnimated(true, completion: nil)})
        alertVC.addAction(okAction)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
}

