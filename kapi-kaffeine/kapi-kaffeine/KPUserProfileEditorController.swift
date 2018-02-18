//
//  KPUserProfileEditorController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 29/06/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import MobileCoreServices

class KPUserPhotoEditView: UIView {
    
    var photoImageView: UIImageView!
    
    var userPhoto: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        addSubview(photoImageView)
        photoImageView.addConstraint(from: "H:|-16-[$self(45)]")
        photoImageView.addConstraint(forHeight: 45)
        photoImageView.addConstraintForCenterAligningToSuperview(in: .vertical)
        photoImageView.layer.cornerRadius = 5
        photoImageView.clipsToBounds = true
        
        let photoLabel = UILabel()
        photoLabel.font = UIFont.systemFont(ofSize: 14)
        photoLabel.text = "更換使用者頭像"
        photoLabel.textColor = KPColorPalette.KPTextColor.mainColor
        addSubview(photoLabel)
        photoLabel.addConstraint(from: "H:[$view0]-16-[$self]", views: [photoImageView])
        photoLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class KPUserProfileEditorController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var _scrollContainerView: UIView {
        get {
            return scrollContainer
        }
    }
    
    var _activeTextField: UIView? {
        get {
            return activeField
        }
    }

    
    var _scrollView: UIScrollView {
        get {
            return scrollView
        }
    }
    
    var scrollView: UIScrollView!
    var scrollContainer: UIView!
    var dismissButton: KPBounceButton!
    var saveButton: UIButton!
    var activeField: UIView?
    
    var photoEditView: KPUserPhotoEditView!
    var nameField: KPSubTitleEditView!
    var emailField: KPSubTitleEditView!
    var regionField: KPSubTitleEditView!
    
    var introTextView: UITextView!
    var introTextNumberLabel: UILabel!
    var introTextViewPlaceHolder: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "資料編輯"
        navigationItem.hidesBackButton = true
        
        dismissButton = KPBounceButton(frame: CGRect.zero,
                                       image: R.image.icon_close()!)
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 8, 14)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        dismissButton.addTarget(self,
                                action: #selector(KPUserProfileEditorController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: dismissButton);
        
        saveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 24));
        saveButton.setTitle("儲存", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.tintColor = KPColorPalette.KPTextColor.mainColor;
        saveButton.addTarget(self,
                             action: #selector(KPUserProfileEditorController.handleSaveButtonOnTapped),
                             for: .touchUpInside)
        
        let rightbarItem = UIBarButtonItem(customView: saveButton);
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        
        let rightNegativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                                  target: nil,
                                                  action: nil)
        
        negativeSpacer.width = -5
        rightNegativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [rightNegativeSpacer, rightbarItem]
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                    "V:|[$self]|"])
        
        scrollContainer = UIView()
        scrollView.addSubview(scrollContainer)
        scrollContainer.addConstraintForHavingSameWidth(with: view)
        scrollContainer.addConstraint(from: "V:|[$self]|")
        
        
        let topline = UIView()
        topline.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        scrollContainer.addSubview(topline)
        topline.addConstraints(fromStringArray: ["H:|[$self]|", "V:|-(-1)-[$self(1)]"])
        
        photoEditView = KPUserPhotoEditView()
        scrollContainer.addSubview(photoEditView)
        
        let photoTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapGesture(tapGesture:)))
        photoEditView.addGestureRecognizer(photoTapGesture)
        
        nameField = KPSubTitleEditView(.Both, .Edited, "使用者名稱")
        nameField.content = ""
        scrollContainer.addSubview(nameField)

        emailField = KPSubTitleEditView(.Bottom, .Edited, "E-mail信箱")
        emailField.content = ""
        scrollContainer.addSubview(emailField)
        
        regionField = KPSubTitleEditView(.Bottom, .Edited, "地區")
        regionField.content = ""
        scrollContainer.addSubview(regionField)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = "自我介紹(30字內)"
        scrollContainer.addSubview(label)
        
        
        introTextView = UITextView()
        introTextView.delegate = self
        introTextView.textColor = KPColorPalette.KPTextColor.grayColor_level2
        introTextView.font = regionField.editTextField.font
        introTextView.textContainerInset = UIEdgeInsets.zero
        introTextView.textContainer.lineFragmentPadding = 0
        introTextView.isScrollEnabled = false
        scrollContainer.addSubview(introTextView)
        
        introTextViewPlaceHolder = UILabel()
        introTextViewPlaceHolder.font = introTextView.font
        introTextViewPlaceHolder.textColor = KPColorPalette.KPTextColor.default_placeholder
        introTextViewPlaceHolder.text = "請輸入自我介紹"
        introTextView.addSubview(introTextViewPlaceHolder)
        introTextViewPlaceHolder.addConstraints(fromStringArray: ["V:|[$self]"])
        
        introTextNumberLabel = UILabel()
        introTextNumberLabel.font = UIFont.systemFont(ofSize: 12)
        introTextNumberLabel.textColor = KPColorPalette.KPTextColor.mainColor
        scrollContainer.addSubview(introTextNumberLabel)
        
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        scrollContainer.addSubview(bottomLine)
        bottomLine.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$self(1)]-(-1)-|"])
        
        
        
        if let user =  KPUserManager.sharedManager.currentUser {
            nameField.content = user.displayName
            emailField.content = user.email
            regionField.content = user.defaultLocation
            introTextView.text = user.intro
            if let photoURLString = user.photoURL,
               let photoURL = URL(string: photoURLString) {
                photoEditView.photoImageView.af_setImage(withURL: photoURL)
            }
        }
        
        
        if introTextView.text.count == 0 {
            introTextNumberLabel.isHidden = true
            introTextViewPlaceHolder.isHidden = false
        } else {
            introTextNumberLabel.text = "\(introTextView.text.count)/30"
            introTextNumberLabel.isHidden = false
            introTextViewPlaceHolder.isHidden = true
        }
        
        
        nameField.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "H:|[$view0]|",
                                                   "H:|[$view1]|",
                                                   "H:|-16-[$view2]",
                                                   "H:|-16-[$view3]-16-|",
                                                   "H:[$view4]-16-|",
                                                   "H:|[$view5]|",
                                                   "V:|[$view5(72)][$self(72)][$view0(72)][$view1(72)]-16-[$view2]-8-[$view3(50)][view4]-|"],
                                 views: [emailField, regionField, label, introTextView, introTextNumberLabel, photoEditView])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(tapGesture:)))
        tapGesture.cancelsTouchesInView = false
        _scrollContainerView.addGestureRecognizer(tapGesture)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    
    @objc func keyboardWillShown(notification: Notification) {
        
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let ooooframe = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        var keyboardFrame = UIApplication.shared.windows[0].convert(ooooframe!, to: view)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height, 0.0)
        
        _scrollView.contentInset = contentInsets
        _scrollView.scrollIndicatorInsets = contentInsets
        
        
        if let field = _activeTextField {
            keyboardFrame.size.height += 64
            keyboardFrame.origin.y -= 44
            let fieldFrame = _scrollContainerView.convert(field.frame, to: view)
            if (keyboardFrame.contains(fieldFrame)) {
                let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
                
                UIView.animate(withDuration: duration!, animations: {
                    self._scrollView.contentOffset = CGPoint(x: 0, y: self._scrollView.contentOffset.y + (fieldFrame.origin.y - keyboardFrame.origin.y - 20))
                })
            }
        }
        
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)
        _scrollView.contentInset = contentInsets
        _scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
    
    
    @objc func handlePhotoTapGesture(tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
        
        
        KPPopoverView.popoverUnsupportedView()
//        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        controller.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { (action) in
//            let imagePickerController = UIImagePickerController()
//            imagePickerController.allowsEditing = false
//            imagePickerController.sourceType = .photoLibrary
//            imagePickerController.delegate = self
//            imagePickerController.mediaTypes = [kUTTypeImage as String]
//            self.present(imagePickerController, animated: true, completion: nil)
//        })
//        controller.addAction(UIAlertAction(title: "開啟相機", style: .default) { (action) in
//            let imagePickerController = UIImagePickerController()
//            imagePickerController.allowsEditing = false
//            imagePickerController.sourceType = .camera
//            imagePickerController.delegate = self
//            imagePickerController.mediaTypes = [kUTTypeImage as String]
//            self.present(imagePickerController, animated: true, completion: nil)
//        })
//        
//        controller.addAction(UIAlertAction(title: "取消", style: .cancel) { (action) in
//
//        })
//        
//        self.present(controller, animated: true) { 
//            
//        }
    }

    @objc func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func handleDismissButtonOnTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func handleSaveButtonOnTapped() {
        
        if let user = KPUserManager.sharedManager.currentUser {
            
            user.displayName = nameField.editTextField.text
            user.email = emailField.editTextField.text
            user.defaultLocation = regionField.editTextField.text
            user.intro = introTextView.text
            // TODO: Photo
            
            KPServiceHandler.sharedHandler.modifyRemoteUserData(user, { (successed) in
                if successed == true {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
            
            
        }
        
    }
    
    fileprivate func generateNewTitleLabel(title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        titleLabel.text = title
        return titleLabel
    }
    
    fileprivate func generateNewTextField() -> UITextField {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = KPColorPalette.KPTextColor.grayColor
        textField.delegate = self
        textField.returnKeyType = .done
        return textField
    }
    
    fileprivate func generateSeparatorLine() -> UIView {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        return view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoEditView.photoImageView.image = image
        }
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    // MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeField = nil
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 {
            introTextNumberLabel.isHidden = true
            introTextViewPlaceHolder.isHidden = false
        } else {
            introTextNumberLabel.isHidden = false
            introTextViewPlaceHolder.isHidden = true
        }
        introTextNumberLabel.text = "\(textView.text.count)/30"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count - range.length + text.count > 30 {
            return false
        }
        return true
    }

}
