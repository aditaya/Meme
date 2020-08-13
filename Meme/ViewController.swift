//
//  ViewController.swift
//  Meme
//
//  Created by Vineet Mahali on 10/08/20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var pickImageViewer: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -4.0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text Field Loaded
        commonTextAttributes(textField: topTextField, textSource: "TOP")
        commonTextAttributes(textField: bottomTextField, textSource: "BOTTOM")
        
//        share button disabled
        shareButton.isEnabled = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
// MARK: - Text Field Editing Begin
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        
        return true
    }
    
// MARK: - Function to Declare attributes of Text Field
    
    func commonTextAttributes(textField: UITextField, textSource text: String){
        
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear
        textField.delegate = self
        
    }
  
// MARK: - Declare Image Source
    
    func processImageSource(sourceType: UIImagePickerController.SourceType){
        
        shareButton.isEnabled = true
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // MARK: - Keyboard Method
    
    func subscribeToKeyboardNotifications() {
//   notification add observer for Keyboard will show & Hide
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
  //   notification remove observer for Keyboard will show & Hide
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
//        keyboard wil show function & to shift view frame
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    
    @objc func keyboardWillHide(_ notification:Notification){
//        Hide keyboard and place frame to origin
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
//        Keyboard height function
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    // MARK: - Button clicked to Pick an Image From Photo library or Camera
    
    @IBAction func pickAnImageFromPhotoLibrary(_ sender: UIBarButtonItem) {
        
        processImageSource(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        processImageSource(sourceType: .camera)
    }
    
    
    
    
   // MARK: - Image Picker Controller & Did Cancel method
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            pickImageViewer.image = image
        }else if let editedImage = info[.editedImage] as? UIImage {
            pickImageViewer.image = editedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
// MARK: - Share Meme Image
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
    //Generate a memed Image
               let sharedMemedImage: UIImage = generateMemedImage()

               //Get Instance of ActivityViewController
               //pass the AcitivityViewController  a memedImage as an activity item
               let activityController = UIActivityViewController(activityItems: [sharedMemedImage], applicationActivities: nil)
               
               
               //pass the activitview controller as a memed image
               activityController.completionWithItemsHandler = { (activity, success, items, error) -> Void in
                   
                   if(success) {
                       self.save()
                   }
               }
               
               //Present the ActivityViewController
               self.present(activityController, animated: true, completion: nil)
             
        }
           
           //Mark save meme
           func save(){
               
               // Create a meme
               let sharedMemedImage: UIImage = generateMemedImage()
               _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!,
               originalImage: pickImageViewer.image!, memedImage: sharedMemedImage)
               
            
        
               
           }
           
// MARK: - combine image and test to create memedImage
           func generateMemedImage() -> UIImage{
               
               
               // TODO: Hide toobar and navbar
              
               toolBar.isHidden = true
               navigationBar.isHidden = true
               
               //Rendeare view to an image
               UIGraphicsBeginImageContext(self.view.frame.size)
               view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
               let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
               UIGraphicsEndImageContext()
               
               //TODO: Show toobar and navbar
               navigationBar.isHidden = false
               toolBar.isHidden = false
             
               
               return memedImage
           }
}

