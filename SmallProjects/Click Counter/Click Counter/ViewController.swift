//
//  ViewController.swift
//  Click Counter
//
//  Created by Juntian Tao on 7/15/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var count: Int = 0
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var label = UILabel()
        label.frame = CGRectMake(150, 150, 50, 50)
        label.text = "0"
        self.view.addSubview(label)
        
        self.label = label
        
        var incButton = UIButton()
        incButton.frame = CGRectMake(150, 200, 100, 50)
        incButton.setTitle("Increase", forState: .Normal)
        incButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.view.addSubview(incButton)
        
        incButton.addTarget(self, action: #selector(ViewController.increment), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        var decButton = UIButton()
        decButton.frame = CGRectMake(150, 230, 100, 50)
        decButton.setTitle("decrease", forState: .Normal)
        decButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.view.addSubview(decButton)
        
        decButton.addTarget(self, action: #selector(ViewController.decrement), forControlEvents: UIControlEvents.TouchUpInside)
    }

    func increment() {
        count += 1
        self.label.text = "\(count)"
        self.view.backgroundColor = randomColor()
    }
    
    func decrement() {
        count -= 1
        self.label.text = "\(count)"
        self.view.backgroundColor = randomColor()
    }
    
    
    func randomColor() -> UIColor {
        let r = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let g = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let b = CGFloat(arc4random()) / CGFloat(UInt32.max)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

