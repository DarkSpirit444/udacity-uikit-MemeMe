//
//  ViewController.swift
//  Meme Me
//
//  Created by David Teo on 4/17/16.
//  Copyright © 2016 Compete Co-op Networks. All rights reserved.
//

import UIKit

struct Meme {
    var top: String
    var bottom: String
    var image: UIImage
    var memedImage: UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    let textDelegate = MemeMeTextFieldDelegate()
    var keyboardHeight: CGFloat = 0.0
    var viewShifted: Bool = false
    var meme: Meme? = nil
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 3.0
    ]
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set text fields delegate
        topTextField.delegate = textDelegate
        bottomTextField.delegate = textDelegate
        
        // Set text fields initial text
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        
        // Set text fields center-aligned
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        // Set text fields default text attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        shareButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        if self.meme != nil {
            self.imagePickerView!.image = meme!.image
            self.topTextField.text = meme!.top
            self.bottomTextField.text = meme!.bottom
            self.topTextField.userInteractionEnabled = false
            self.bottomTextField.userInteractionEnabled = false
            self.toolbar.hidden = true
            self.topToolBar.hidden = true
        }
        
        self.viewShifted = false
        // Subscribe to the keyboard notifications, to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= self.keyboardHeight
        if self.keyboardHeight == 0.0 {
            self.viewShifted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += self.keyboardHeight
        self.viewShifted = false
    }
    
    func keyboardHeight(notification: NSNotification) {
        self.keyboardHeight = getKeyboardHeight(notification)
        if self.viewShifted {
            self.view.frame.origin.y -= self.keyboardHeight
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardHeight(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UITextFieldTextDidBeginEditingNotification, object: bottomTextField)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UITextFieldTextDidEndEditingNotification, object: bottomTextField)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidBeginEditingNotification, object: bottomTextField)
        
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidEndEditingNotification, object: bottomTextField)
    }
    
    @IBAction func Share(sender: AnyObject) {
        let memedImage = generateMemeImage()
        let activityItems: [AnyObject] = [memedImage]
        let avc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.presentViewController(avc, animated: true, completion: nil)
        avc.completionWithItemsHandler = {
            (activity, success, items, error) in
            // Create the meme
            _ = Meme(top: self.topTextField.text!, bottom: self.bottomTextField.text!, image: self.imagePickerView.image!, memedImage: memedImage)
            self.dismissViewControllerAnimated(true, completion: nil)
            self.save()
        }
    }
    
    // Create a meme object and add it to the memes array
    func save() {
        
        // Update the meme
        let meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imagePickerView.image!, memedImage: generateMemeImage() )
        
        // Add it to the memees array on the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemeImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        //toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        //toolbar.hidden = false
        
        return memedImage
    }
}

