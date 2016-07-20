//
//  ViewController.swift
//  Roshambo
//
//  Created by Juntian Tao on 7/17/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    
    @IBAction func rock(sender: UIButton) {
        let resultViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ResultViewController") as! ResultViewController
        resultViewController.userShape = getUserShape(sender)
        self.presentViewController(resultViewController, animated: true, completion: nil)
    }
    
    @IBAction func paper(sender: UIButton) {
        self.performSegueWithIdentifier("play", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "play" {
            let resultViewController = segue.destinationViewController as! ResultViewController
            resultViewController.userShape = getUserShape(sender as! UIButton)
        }
    
    }
    
    func getUserShape(sender: UIButton) -> Shape {
        let shape = sender.titleForState(.Normal)!
        return Shape(rawValue: shape)!
    }
    
}

