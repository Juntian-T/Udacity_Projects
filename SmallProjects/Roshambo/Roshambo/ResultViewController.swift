//
//  resultViewController.swift
//  Roshambo
//
//  Created by Juntian Tao on 7/17/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit

enum Shape: String {
    case Rock = "Rock"
    case Paper = "Paper"
    case Scissor = "Scissor"
    
    static func getRandomShape() -> Shape {
        let shapes = ["Rock", "Paper", "Scissor"]
        let index = Int(arc4random() % 3)
        return Shape(rawValue: shapes[index])!
    }
}

class ResultViewController: UIViewController {

    
    var userShape: Shape?
    var computerShape: Shape = Shape.getRandomShape()
    
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!

    
    func result() {
        switch (userShape!, computerShape) {
        case (.Rock, .Scissor), (.Paper, .Rock), (.Scissor, .Paper):
            resultLabel.text = "You won!"
            resultImage.image = UIImage(named: "\(userShape!.rawValue)-\(computerShape.rawValue)")
            print("\(userShape!.rawValue)-\(computerShape.rawValue)")
        case (.Paper, .Scissor), (.Scissor, .Rock), (.Rock, .Paper):
            resultLabel.text = "You lost :("
            resultImage.image = UIImage(named: "\(computerShape.rawValue)-\(userShape!.rawValue)")
            print("\(userShape!.rawValue)-\(computerShape.rawValue)")
        default:
            resultLabel.text = "It is a tie!"
            resultImage.image = UIImage(named: "itsATie")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        result()
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
