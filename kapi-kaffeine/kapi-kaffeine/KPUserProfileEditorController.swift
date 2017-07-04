//
//  KPUserProfileEditorController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 29/06/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

@objc public protocol KPKeyboardProtocol: class {
    
    var _activeTextField: UITextField? {get}
    var _scrollView: UIScrollView {get}
    var _scrollContainerView: UIView {get}

}

public extension KPKeyboardProtocol where Self: UIViewController {
    
    func registerForNotification() {
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { (notification) in            
            self.keyboardWillShown(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            self.keyboardWillBeHidden(notification: notification)
        }
    }
    
    func keyboardWillShown(notification: Notification) {
        
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let ooooframe = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        var keyboardFrame = UIApplication.shared.windows[0].convert(ooooframe!, to: view)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height, 0.0)

        _scrollView.contentInset = contentInsets
        _scrollView.scrollIndicatorInsets = contentInsets

        
        if let field = _activeTextField {
            keyboardFrame.size.height += 44
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
    
    
    func keyboardWillBeHidden(notification: Notification) {
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)
        _scrollView.contentInset = contentInsets
        _scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
}

class KPUserProfileEditorController: UIViewController, UITextFieldDelegate, UITextViewDelegate, KPKeyboardProtocol {
    
    var _scrollContainerView: UIView {
        get {
            return scrollContainer
        }
    }
    
    var _activeTextField: UITextField? {
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
    var activeField: UITextField?
    
    var introTextNumberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "資料編輯"
        navigationItem.hidesBackButton = true
        
        dismissButton = KPBounceButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
        dismissButton.setImage(R.image.icon_back()?.withRenderingMode(.alwaysTemplate),
                               for: .normal);
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        dismissButton.addTarget(self,
                                action: #selector(KPUserProfileEditorController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        let barItem = UIBarButtonItem.init(customView: dismissButton);
        
        saveButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 24));
        saveButton.setTitle("儲存", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.tintColor = KPColorPalette.KPTextColor.mainColor;
        saveButton.addTarget(self,
                             action: #selector(KPUserProfileEditorController.handleSaveButtonOnTapped),
                             for: .touchUpInside)
        
        let rightbarItem = UIBarButtonItem.init(customView: saveButton);
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightbarItem]
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                    "V:|[$self]|"])
        
        scrollContainer = UIView()
        scrollView.addSubview(scrollContainer)
        scrollContainer.addConstraintForHavingSameWidth(with: view)
        scrollContainer.addConstraint(from: "V:|[$self]|")
        
        let nameField = KPSubTitleEditView.init(.Both, .Edited, "使用者名稱")
        nameField.content = "Samuel"
        scrollContainer.addSubview(nameField)

        let emailField = KPSubTitleEditView.init(.Bottom, .Edited, "E-mail信箱")
        emailField.content = "samuel@kapi.com"
        scrollContainer.addSubview(emailField)
        
        let regionField = KPSubTitleEditView.init(.Bottom, .Edited, "地區")
        regionField.content = "新北市"
        scrollContainer.addSubview(regionField)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = "自我介紹(30字內)"
        scrollContainer.addSubview(label)
        
        
        let inputTextView = UITextView()
        inputTextView.delegate = self
        inputTextView.textColor = KPColorPalette.KPTextColor.grayColor_level2
        inputTextView.font = regionField.editTextField.font
        inputTextView.textContainerInset = UIEdgeInsets.zero
        inputTextView.textContainer.lineFragmentPadding = 0
        inputTextView.isScrollEnabled = false
        scrollContainer.addSubview(inputTextView)

        
        introTextNumberLabel = UILabel()
        introTextNumberLabel.font = UIFont.systemFont(ofSize: 12)
        introTextNumberLabel.textColor = KPColorPalette.KPTextColor.mainColor
        introTextNumberLabel.text = "0/30"
        scrollContainer.addSubview(introTextNumberLabel)
        
        
        nameField.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "H:|[$view0]|",
                                                   "H:|[$view1]|",
                                                   "H:|-16-[$view2]",
                                                   "H:|-16-[$view3]-16-|",
                                                   "H:[$view4]-16-|",
                                                   "V:|-16-[$self(72)][$view0(72)][$view1(72)]-16-[$view2]-8-[$view3(50)][view4]-|"],
                                 views: [emailField, regionField, label, inputTextView, introTextNumberLabel])
        
        registerForNotification()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(tapGesture:)))
        tapGesture.cancelsTouchesInView = false
        _scrollContainerView.addGestureRecognizer(tapGesture)
        
    }
    
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func handleDismissButtonOnTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func handleSaveButtonOnTapped() {
        
    }
    
    fileprivate func generateNewTitleLabel(title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = KPColorPalette.KPMainColor.mainColor
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
        view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level7
        return view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        introTextNumberLabel.text = "\(textView.text.characters.count)/30"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.characters.count - range.length + text.characters.count > 30 {
            return false
        }
        return true
    }

}
