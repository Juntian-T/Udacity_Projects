//
//  MemeTableViewController.swift
//  Meme
//
//  Created by Juntian Tao on 7/24/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath) as! MemeTableViewCell
        let selectedMeme = memes[indexPath.row]
        cell.memedImage.image = selectedMeme.memedImage
        cell.topLabel.text = selectedMeme.topText
        cell.bottomLabel.text = selectedMeme.bottomText
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedMeme = memes[indexPath.row]
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("detailVC") as! MemeDetailViewController
        detailVC.meme = selectedMeme
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
