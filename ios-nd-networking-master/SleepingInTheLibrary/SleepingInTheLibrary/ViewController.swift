//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var grabImageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func grabNewImage(sender: AnyObject) {
        setUIEnabled(false)
        getImageFromFlickr()
    }
    
    // MARK: Configure UI
    
    private func setUIEnabled(enabled: Bool) {
        photoTitleLabel.enabled = enabled
        grabImageButton.enabled = enabled
        
        if enabled {
            grabImageButton.alpha = 1.0
        } else {
            grabImageButton.alpha = 0.5
        }
    }
    
    // MARK: Make Network Request
    
    private func getImageFromFlickr() {
        let parameters = [Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.GalleryPhotosMethod,
                          Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                          Constants.FlickrParameterKeys.GalleryID: Constants.FlickrParameterValues.GalleryID,
                          Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
                          Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                          Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        let urlString = Constants.Flickr.APIBaseURL + escapeParameters(parameters)
        let requestURL = NSURL(string: urlString)
        let request = NSURLRequest(URL: requestURL!)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            guard error == nil else {
                print("Can't make request")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print("Can't parse into JSON object")
                return
            }
            
            guard let photosDict = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String: AnyObject],
                photoArray = photosDict[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                    print("can't find photos")
                    return
            }
            
            let randomIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoDict = photoArray[randomIndex]
            
            guard let imageURL = photoDict[Constants.FlickrResponseKeys.MediumURL] as? String,
                photoTitle = photoDict[Constants.FlickrResponseKeys.Title] as? String,
                imageData = NSData(contentsOfURL: NSURL(string: imageURL)!) else {
                    print("can't find photo")
                    return
            }
            
            performUIUpdatesOnMain {
                self.photoImageView.image = UIImage(data: imageData)
                self.photoTitleLabel.text = photoTitle
                self.setUIEnabled(true)
            }
        }
        
        task.resume()
    }
    
    private func escapeParameters(parameters: [String: AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                let stringValue = "\(value)"
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            
            return "?\(keyValuePairs.joinWithSeparator("&"))"
        }
    }
}