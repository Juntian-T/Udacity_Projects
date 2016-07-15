//
//  ViewController.swift
//  ColorMaker
//
//  Created by Juntian Tao on 7/15/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func slided(sender: AnyObject) {
        let red = redSlider.value
        let green = greenSlider.value
        let blue = blueSlider.value
        
        
        let cgRed: CGFloat = CGFloat(red)
        let cgGreen: CGFloat = CGFloat(green)
        let cgBlue: CGFloat = CGFloat(blue)
        
        colorView.backgroundColor = UIColor(red: cgRed, green: cgGreen, blue: cgBlue, alpha: 1)
    }

    
}

