//
//  ViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageURL = NSURL(string: Constants.CatURL)
        let task = NSURLSession.sharedSession().dataTaskWithURL(imageURL!) { (data, response, error) in
            if error == nil {
                performUIUpdatesOnMain {
                    self.imageView.image = UIImage(data: data!)
                }
                print("success")
            } else {
                print("No data")
            }
        }
        
        task.resume()
        // TODO: Add all the networking code here!
    }
}
