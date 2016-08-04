//
//  ViewController.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {
    
    // MARK: Properties
    
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var phraseSearchButton: UIButton!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latLonSearchButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phraseTextField.delegate = self
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        // FIX: As of Swift 2.2, using strings for selectors has been deprecated. Instead, #selector(methodName) should be used.
        subscribeToNotification(UIKeyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIKeyboardWillHideNotification, selector: #selector(keyboardWillHide))
        subscribeToNotification(UIKeyboardDidShowNotification, selector: #selector(keyboardDidShow))
        subscribeToNotification(UIKeyboardDidHideNotification, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Search Actions
    
    @IBAction func searchByPhrase(sender: AnyObject) {

        userDidTapView(self)
        setUIEnabled(false)
        
        if !phraseTextField.text!.isEmpty {
            photoTitleLabel.text = "Searching..."
            
            let methodParameters: [String: String!] =
                [Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                 Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
                 Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
                 Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
                 Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                 Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
                 Constants.FlickrParameterKeys.Text: phraseTextField.text
                ]
            displayImageFromFlickrBySearch(methodParameters)
        } else {
            setUIEnabled(true)
            photoTitleLabel.text = "Phrase Empty."
        }
    }
    
    @IBAction func searchByLatLon(sender: AnyObject) {

        userDidTapView(self)
        setUIEnabled(false)
        
        if isTextFieldValid(latitudeTextField, forRange: Constants.Flickr.SearchLatRange) && isTextFieldValid(longitudeTextField, forRange: Constants.Flickr.SearchLonRange) {
            photoTitleLabel.text = "Searching..."
        
            let methodParameters: [String: String!] =
                [Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                 Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
                 Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
                 Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
                 Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                 Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
                 Constants.FlickrParameterKeys.BoundingBox: bboxString()
                ]
            displayImageFromFlickrBySearch(methodParameters)
        }
        else {
            setUIEnabled(true)
            photoTitleLabel.text = "Lat should be [-90, 90].\nLon should be [-180, 180]."
        }
    }
    
    private func bboxString() -> String {
        
        guard let userLon = Double(longitudeTextField.text!),
            userLat = Double(latitudeTextField.text!) else {
                return "0,0,0,0"
        }
        let minimum_longitude = max(userLon - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLonRange.0)
        let minimum_latitude = max(userLat - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLatRange.0)
        let maximum_longitude = min(userLon + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLonRange.1)
        let maximum_latitude = min(userLat + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLatRange.1)
        
        return "\(minimum_longitude),\(minimum_latitude),\(maximum_longitude),\(maximum_latitude)"
    }
    
    // MARK: Flickr API
    
    private func displayImageFromFlickrBySearch(methodParameters: [String:AnyObject]) {
        
        let request = NSURLRequest(URL: flickrURLFromParameters(methodParameters))
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, repsonse, error) in
            
            func displayError(error: String) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.photoTitleLabel.text = "No photo returned. Try again."
                    self.photoImageView.image = nil
                }
            }
            
            guard error == nil else {
                displayError((error?.localizedDescription)!)
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                displayError("Can't parse to JSON object")
                return
            }
            
            guard let photos = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String: AnyObject],
                numOfPages = photos[Constants.FlickrResponseKeys.Pages] as? Int else {
                    displayError("Can't convert to NS data types")
                    return
            }
            
            let pageLimit = min(40, numOfPages)
            let randomPageNum = Int(arc4random_uniform(UInt32(pageLimit))) + 1
            self.displayImageFromFlickrBySearch(methodParameters, withPageNumber: randomPageNum)
            print(randomPageNum)
        }
        
        task.resume()
    }
    
    private func displayImageFromFlickrBySearch(methodParameters: [String:AnyObject], withPageNumber: Int) {
        var newParameters = methodParameters
        newParameters[Constants.FlickrParameterKeys.Page] = withPageNumber
        let request = NSURLRequest(URL: flickrURLFromParameters(newParameters))
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, repsonse, error) in
            
            func displayError(error: String) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.photoTitleLabel.text = "No photo returned. Try again."
                    self.photoImageView.image = nil
                }
            }
            
            guard error == nil else {
                displayError((error?.localizedDescription)!)
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                displayError("Can't parse to JSON object")
                return
            }
            
            guard let photos = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String: AnyObject],
                photo = photos[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                    displayError("Can't convert to NS data types")
                    return
            }
            
            let randomIndex = Int(arc4random_uniform(UInt32(photo.count)))
            let photoDict = photo[randomIndex]
            
            performUIUpdatesOnMain({ 
                let urlString = photoDict[Constants.FlickrResponseKeys.MediumURL] as? String
                let imgURL = NSURL(string: urlString!)
                let imgData = NSData(contentsOfURL: imgURL!)
                self.setUIEnabled(true)
                self.photoImageView.image = UIImage(data: imgData!)
                self.photoTitleLabel.text = photoDict[Constants.FlickrResponseKeys.Title] as? String
            })
        }
        
        task.resume()
    }
    
    // MARK: Helper for Creating a URL from Parameters
    
    private func flickrURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
}

// MARK: - ViewController: UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(phraseTextField)
        resignIfFirstResponder(latitudeTextField)
        resignIfFirstResponder(longitudeTextField)
    }
    
    // MARK: TextField Validation
    
    private func isTextFieldValid(textField: UITextField, forRange: (Double, Double)) -> Bool {
        if let value = Double(textField.text!) where !textField.text!.isEmpty {
            return isValueInRange(value, min: forRange.0, max: forRange.1)
        } else {
            return false
        }
    }
    
    private func isValueInRange(value: Double, min: Double, max: Double) -> Bool {
        return !(value < min || value > max)
    }
}

// MARK: - ViewController (Configure UI)

extension ViewController {
    
    private func setUIEnabled(enabled: Bool) {
        photoTitleLabel.enabled = enabled
        phraseTextField.enabled = enabled
        latitudeTextField.enabled = enabled
        longitudeTextField.enabled = enabled
        phraseSearchButton.enabled = enabled
        latLonSearchButton.enabled = enabled
        
        // adjust search button alphas
        if enabled {
            phraseSearchButton.alpha = 1.0
            latLonSearchButton.alpha = 1.0
        } else {
            phraseSearchButton.alpha = 0.5
            latLonSearchButton.alpha = 0.5
        }
    }
}

// MARK: - ViewController (Notifications)

extension ViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}