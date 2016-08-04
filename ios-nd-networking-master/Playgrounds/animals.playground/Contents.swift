//
//  animals.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

/* Path for JSON files bundled with the Playground */
var pathForAnimalsJSON = NSBundle.mainBundle().pathForResource("animals", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAnimalsJSON = NSData(contentsOfFile: pathForAnimalsJSON!)

/* Error object */
var parsingAnimalsError: NSError? = nil

/* Parse the data into usable form */
var parsedAnimalsJSON = try! NSJSONSerialization.JSONObjectWithData(rawAnimalsJSON!, options: .AllowFragments) as! NSDictionary

func parseJSONAsDictionary(dictionary: NSDictionary) {
    let photos = parsedAnimalsJSON["photos"] as! NSDictionary
    let photoArray = photos["photo"] as! [[String: AnyObject]]
    let count = photoArray.count
    print(count)
    
    for (index, photo) in photoArray.enumerate() {
        print("\(index): \(photo)")
    }
    
    let urlString = photoArray[2]["url_m"] as! String
    let imgurl = NSURL(string: urlString)
    let imgData = NSData(contentsOfURL: imgurl!)
    let img = UIImage(data: imgData!)
}

parseJSONAsDictionary(parsedAnimalsJSON)
