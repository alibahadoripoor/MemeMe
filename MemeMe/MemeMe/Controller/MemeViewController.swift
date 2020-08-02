//
//  ViewController.swift
//  MemeMe
//
//  Created by Ali Bahadori on 10.07.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController{

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
   
    // MARK: Image Picker
    
    var pickerController: UIImagePickerController!
    
    // MARK: Meme Model
    
    var meme: Meme!
    
    //MARK: Other Variables
    
    let topText = "TOP"
    let bottomText = "BOTTOM"
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Actions
    
    @IBAction func shareImage(_ sender: Any) {
        meme.memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [meme.memedImage!], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = { [weak self] (type, ok, items, error) in
            guard let self = self else { return }
            if ok {
                self.save()
            }
        }
        
        present(activityVC, animated: true)
    }

    @IBAction func cancel(_ sender: Any) {
        meme = Meme(topText: topText, bottomText: bottomText, originalImage: nil, memedImage: nil)
        reloadUI()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
}

extension MemeViewController{
    
    // MARK: Keyboard Setup Functions
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: UI Functions
    
    private func configureUI(){
        meme = Meme(topText: topText, bottomText: bottomText, originalImage: nil, memedImage: nil)
        
        pickerController = UIImagePickerController()
        pickerController.delegate = self

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setupTextField(topTextField)
        setupTextField(bottomTextField)
        
        reloadUI()
    }
    
    private func setupTextField(_ textField: UITextField) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth: -2
        ]
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.borderStyle = .none
    }
    
    private func reloadUI(){
        imageView.image = meme.originalImage
        topTextField.text = meme.topText
        bottomTextField.text = meme.bottomText
        
        if meme.originalImage != nil{
            shareButton.isEnabled = true
        }else{
            shareButton.isEnabled = false
        }
    }
    
    private func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        setToolbarsState(true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        setToolbarsState(false)

        return memedImage
    }
    
    private func setToolbarsState(_ hidden: Bool){
        navigationController?.navigationBar.isHidden = hidden
        bottomToolbar.isHidden = hidden
    }
    
    private func save(){
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Image Picker Delegates

extension MemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            meme.originalImage = image
            reloadUI()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Text Field Delegates

extension MemeViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0{
            meme.topText = textField.text!
        }
        if textField.tag == 1{
            meme.bottomText = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
