//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by Juntian Tao on 7/24/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "collectionViewCell"

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 2.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        
        let widthDimension = (self.view.frame.width - (2 * space)) / space
        let heightDimension = (self.view.frame.height - (2 * space)) / space
        flowLayout.itemSize = CGSizeMake(widthDimension, heightDimension)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        collectionView!.reloadData()
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.memedImage?.image = memes[indexPath.row].memedImage
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedMeme = memes[indexPath.row]
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("detailVC") as! MemeDetailViewController
        detailVC.meme = selectedMeme
        navigationController?.pushViewController(detailVC, animated: true)
    }


}
