//
//  DetailMemedViewController.swift
//  MeMe
//
//  Created by Seungwook Jeong on 2017. 1. 25..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

let memeTextAttributes = [
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSForegroundColorAttributeName : UIColor.white,
    NSStrokeColorAttributeName : UIColor.black,
    NSStrokeWidthAttributeName: -5.0
    ] as [String : Any]


class MemeDetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var detailedTopTextField: UITextField!
    @IBOutlet weak var detailedBottomTextField: UITextField!
    @IBOutlet weak var detailedImageView: UIImageView!
    @IBOutlet weak var detailedViewToolBar: UIToolbar!
    
    
    var editButtonFlag = false
    var meme : AppDelegate.Meme?
    var memedImage : AppDelegate.Meme? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldAttributes()
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailedImageView.image = memedImage?.originalImage
        detailedTopTextField.text = memedImage?.topText
        detailedBottomTextField.text = memedImage?.bottomText
        
        self.subscribeToKeyboardNotifications()
        isEnabledElement(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func setTextFieldAttributes(){
        detailedTopTextField.delegate = self
        detailedBottomTextField.delegate = self
        
        detailedTopTextField.defaultTextAttributes = memeTextAttributes
        detailedBottomTextField.defaultTextAttributes = memeTextAttributes
        
        detailedBottomTextField.textAlignment = .center
        detailedTopTextField.textAlignment = .center

    }
    
    func isEnabledElement(_ isEnabled : Bool){
        detailedTopTextField.isEnabled = isEnabled
        detailedBottomTextField.isEnabled = isEnabled
        cancelButton.isEnabled = isEnabled
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /* move the frame up */
    func keyboardWillShow(_ notification:Notification) {
        
        self.view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    /* move the frame into position */
    func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    /* return Keyboard height */
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_ :)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func hiddenUI(hidden: Bool){
        self.detailedViewToolBar.isHidden = hidden
        self.navigationController?.navigationBar.isHidden = hidden
    }
    
    func completionHandler(activityType: UIActivityType?, shared: Bool, items: [Any]?, error: Error?) {
        if (shared) {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme!)
            dismiss(animated: true, completion: nil)
            
            
            editButtonFlag = false
            editButton.title = "Edit"
            isEnabledElement(false)
            tabBarController?.tabBar.isHidden = false
        }
        else {
            print("Cancel to share")
        }
    }
    
    func generateMemedImage() -> UIImage {
        //hidden navigation Bar, Toolbar
        hiddenUI(hidden: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show navigation Bar, Toolbar
        hiddenUI(hidden: false)
        return memedImage
    }
    
    func save() {
        meme = AppDelegate.Meme(topText: detailedTopTextField.text!, bottomText: detailedBottomTextField.text!, originalImage: detailedImageView.image!, memedImage: generateMemedImage())
    }

    
    @IBAction func editMemedImage(_ sender: Any) {
        if editButtonFlag == true {
            save()
            let memedImage : Any = meme?.memedImage as Any
            let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
            
            activityViewController.completionWithItemsHandler = completionHandler

            
        } else {
            editButtonFlag = true
            editButton.title = "Save"
            isEnabledElement(true)
            
        }
        
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        isEnabledElement(false)
        editButton.title = "Edit"
    }
    
}
