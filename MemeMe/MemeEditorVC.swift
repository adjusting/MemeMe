//
//  ViewController.swift
//  MemeMe
//
//  Created by Justin Gareau on 6/3/17.
//  Copyright © 2017 Justin Gareau. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navbar: UIToolbar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let topDelegate = TopTextFieldDelegate()
    let bottomDelegate = BottomTextFieldDelegate()
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -5]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfield(topTextField, with: "TOP")
        topTextField.delegate = topDelegate
        setupTextfield(bottomTextField, with: "BOTTOM")
        bottomTextField.delegate = bottomDelegate
        shareButton.isEnabled = false
    }

    func setupTextfield(_ textField: UITextField, with text:String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
   }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(sourceType:.photoLibrary)
    }

    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(sourceType:.camera)
    }

    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let controller = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        present(controller, animated: true, completion: {self.save()})
    }
    
    @IBAction func cancel(_ sender: Any) {
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        
        hideToolbars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(false)
        
        return memedImage
    }
    
    func hideToolbars(_ flag:Bool) {
        navbar.isHidden = flag
        toolbar.isHidden = flag
    }
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }
}

extension MemeEditorVC: UIImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: false, completion: nil)
        shareButton.isEnabled = true
    }

}

 extension MemeEditorVC: UINavigationControllerDelegate {
    
}

