//
//  MemeViewController.swift
//  MemeApp
//
//  Created by Abdulla Hasanov on 11/14/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

// keyboard issue solution partly from:
// stackoverflow.com/questions/28813339/move-a-view-up-only-when-the-keyboard-covers-an-input-field

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate,
            UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var savedMeme: Meme?
    
    var activeField: UITextField?
    
    let TOP_TEXT_PLACEHOLDER = "TOP"
    let BOTTOM_TEXT_PLACEHOLDER = "BOTTOM"
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -5
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotificatios()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTextField(topTextField)
        initTextField(bottomTextField)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
    }
    
    func initTextField(_ textField: UITextField) {
        textField.defaultTextAttributes.merge(memeTextAttributes) {(_, new) in new}
        textField.delegate = self
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("Image picking canceled")
    }
    
    @IBAction func cancel(_ sender: Any) {
        savedMeme = nil
        topTextField.text = TOP_TEXT_PLACEHOLDER
        bottomTextField.text = BOTTOM_TEXT_PLACEHOLDER
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    @IBAction func share(_ sender: Any) {
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(type,completed,items,error) in
                if let _ = error {
                    print("Something gone wrong")
                    return
                }
                if completed {
                    self.save()
                }
            }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func save() {
        let bottomText = bottomTextField.text!
        let topText = topTextField.text!
        let originalImage = imagePickerView.image ?? nil
        if originalImage == nil {
            return
        }
        let memedImage = generateMemedImage()
        savedMeme = Meme(topText: topText, bottomText: bottomText,
                               originalImage: originalImage!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        updateUI(false)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        updateUI(true)
        return memedImage
    }
    
    func updateUI(_ showBars: Bool) {
        toolbar.isHidden = !showBars
        navigationBar.isHidden = !showBars
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == TOP_TEXT_PLACEHOLDER || textField.text == BOTTOM_TEXT_PLACEHOLDER {
            textField.text = ""
        }
        activeField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            if(text.isEmpty) {
                setPlaceHolder(textField)
            }
        }
        activeField = nil
        return true
    }
    
    func setPlaceHolder(_ textField: UITextField) {
        if(textField.tag == 0) {
            textField.text = TOP_TEXT_PLACEHOLDER
        } else {
            textField.text = BOTTOM_TEXT_PLACEHOLDER
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = pickedImage
            imagePickerView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
        }
    }

    @IBAction func pickAnImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        switch sender.tag {
        case 0:
            imagePicker.sourceType = .photoLibrary
        case 1:
            imagePicker.sourceType = .camera
        default:
            print("no source type for this button")
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var aRect: CGRect = self.view.frame
        aRect.size.height -= getKeyboardHeight(notification)
        if let _ = activeField {
            if(!aRect.contains(activeField!.frame.origin)) {
                view.frame.origin.y = -getKeyboardHeight(notification)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                                object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unsubscribeFromKeyboardNotificatios() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
}

