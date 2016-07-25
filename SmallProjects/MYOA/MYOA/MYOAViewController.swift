//
//  MYOAViewController.swift
//  MYOA
//
//  Created by Juntian Tao on 7/21/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit

class MYOAViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start Over", style: .Plain, target: self, action: #selector(MYOAViewController.startover))
        
    }

    func startover() {
        if let navController = navigationController{
            navController.popToRootViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("VC being deinitilized")
    }


}

