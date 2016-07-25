//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Juntian Tao on 7/24/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memedImage: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memedImage.image = meme.memedImage
        tabBarController?.tabBar.hidden = true
    }

}
