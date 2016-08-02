//
//  VillainDetailViewController.swift
//  BondVillains
//
//  Created by Juntian Tao on 7/21/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class VillainDetailViewController: UIViewController {
    
    @IBOutlet weak var villainImage: UIImageView!
    @IBOutlet weak var villainLabel: UILabel!
    
    var villain: Villain!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        villainImage.image = UIImage(named: villain.imageName)
        villainLabel.text = villain.name
    }

}
