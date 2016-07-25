//
//  MemeEditorViewController.swift
//  Meme
//
//  Created by Juntian Tao on 7/19/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit



class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var imageSection: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: Properties
    let textFiledDelegate = TextFieldDelegate()
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : Float(-3.0)
    ]
    
    // Objects to store the memed image and meme model
    var memedImage: UIImage!
    var meme: Meme!
    
    // MARK: Setup
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField(topTextField, defaultText: "TOP")
        configureTextField(bottomTextField, defaultText: "BOTTOM")
        
        shareButton.enabled = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: Actions
    
    // Pick an image from the photo library
    @IBAction func pickImage(sender: AnyObject) {
        showImagePicker(.PhotoLibrary)
    }
    
    // Take a new photo if the device has a camera
    @IBAction func pickFromCamera(sender: AnyObject) {
        showImagePicker(.Camera)
    }
    
    // Launch the ActivityViewController when user presses the share button
    @IBAction func share(sender: AnyObject) {
        memedImage = generateMemedImage() // Get the memed image
        
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = view // For iPad users
        
        presentViewController(activityVC, animated: true, completion: nil)
        
        // After user's action, dismiss the view controller and save the meme object
        activityVC.completionWithItemsHandler = { (s: String?, ok: Bool, items: [AnyObject]?, err: NSError?) -> Void in
            if ok {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.save()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    // Reset everything
    @IBAction func cancel(sender: AnyObject) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageSection.image = UIImage()
        shareButton.enabled = false
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
    }
    
    // MARK: Delegate work
    
    // After user picks an image (or takes a photo), show the image and enable share button
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: nil)
        imageSection.image = image
        shareButton.enabled = true
    }
    
    // MARK: Helpers
    
    func configureTextField(textField: UITextField, defaultText: String) {
        textField.text = defaultText
        textField.delegate = textFiledDelegate
        textField.defaultTextAttributes = memeTextAttributes
    }
    
    func showImagePicker(soureType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = soureType
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func generateMemedImage() -> UIImage {
        // Hide nav and tool bars
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show nav and tool bars
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    func save() {
        meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageSection.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    // MARK: Notification related
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Clean up
    override func viewWillDisappear(animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
}

