//
//  PickImageViewController.swift
//  MemeApp
//
//  Created by Ashutosh Purushottam on 5/23/16.
//  Copyright © 2016 Vivid Designs. All rights reserved.
//

import UIKit

class PickImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.0
    ]
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Clear background for text fields
        topTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.backgroundColor = UIColor.clearColor()
        // No border on text fields
        topTextField.borderStyle = .None
        bottomTextField.borderStyle = .None
        // attributes for text fields
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        // set delegates of text fields
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
    }
    
    // MARK: - Actions

    @IBAction func pickImageFromAlbum(sender: AnyObject)
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject)
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate methods

    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if (topTextField.editing && topTextField.text == "TOP")
        {
            textField.text = ""
        }
        if(bottomTextField.editing && bottomTextField.text == "BOTTOM")
        {
            bottomTextField.text = ""
        }
    }

    // Make sure textfields are not left empty

    func textFieldDidEndEditing(textField: UITextField)
    {
        if(topTextField.text == "")
        {
            topTextField.text = "TOP"
        }
        if(bottomTextField.text == "")
        {
            bottomTextField.text = "BOTTOM"
        }
    }
    
    // MARK: - Subscribe/Unsubscribe from keyboard notification
    
    func subscribeToKeyboardNotification()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PickImageViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PickImageViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotification()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Methods for responding to notification about keyboard

    func keyboardWillShow(notification: NSNotification)
    {
        if(bottomTextField.editing)
        {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        view.frame.origin.y = 0
    }
    
    // MARK: - Helper method to get keyboard height

    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo!
        let keyboardDimension = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardDimension.CGRectValue().height
    }
    
    
    

}

