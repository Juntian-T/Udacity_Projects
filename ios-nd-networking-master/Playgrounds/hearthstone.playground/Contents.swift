//
//  hearthstone.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForHearthstoneJSON = NSBundle.mainBundle().pathForResource("hearthstone", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawHearthstoneJSON = NSData(contentsOfFile: pathForHearthstoneJSON!)

/* Error object */
var parsingHearthstoneError: NSError? = nil

/* Parse the data into usable form */
var parsedHearthstoneJSON = try! NSJSONSerialization.JSONObjectWithData(rawHearthstoneJSON!, options: .AllowFragments) as! NSDictionary

func parseJSONAsDictionary(dictionary: NSDictionary) {
    let minions = parsedHearthstoneJSON["Basic"] as! [[String: AnyObject]]
    
    var num = 0
    for (_, e) in minions.enumerate() {
        if let type = e["type"] as? String, cost = e["cost"] as? Int{
            if type == "Minion" && cost == 5 {
                num+=1
            }
        }
    }
    print(num)
    
    var num2 = 0
    for ele in minions {
        if let type = ele["type"] as? String, durability = ele["durability"] as? Int{
            if type == "Weapon" && durability == 2 {
                num2+=1
            }
            
            if type == "Minion" {
                num+=1
            }
        }
    }
    print(num2)
    
}

parseJSONAsDictionary(parsedHearthstoneJSON)
