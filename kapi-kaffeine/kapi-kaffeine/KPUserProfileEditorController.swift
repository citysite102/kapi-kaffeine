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
    var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        
        
        scrollContainer = UIView()
        scrollView.addSubview(scrollContainer)
        scrollContainer.addConstraintForHavingSameWidth(with: view)
        scrollContainer.addConstraint(from: "V:|[$self]|")
        
        let nameLabel = generateNewTitleLabel(title: "使用者名稱")
        scrollContainer.addSubview(nameLabel)
        
        let nameField = generateNewTextField()
        nameField.text = "Samuel Kao"
        scrollContainer.addSubview(nameField)
        
        let nameSepartor = generateSeparatorLine()
        scrollContainer.addSubview(nameSepartor)
        
        
        let emailLabel = generateNewTitleLabel(title: "E-mail信箱")
        scrollContainer.addSubview(emailLabel)
        
        let emailField = generateNewTextField()
        emailField.text = "samuel@kapi.com"
        scrollContainer.addSubview(emailField)
        
        let emailSepartor = generateSeparatorLine()
        scrollContainer.addSubview(emailSepartor)
        
        
        let regionLabel = generateNewTitleLabel(title: "地區")
        scrollContainer.addSubview(regionLabel)
        
        let regionField = generateNewTextField()
        regionField.text = "台北市"
        scrollContainer.addSubview(regionField)
        
        
        let regionSepartor = generateSeparatorLine()
        scrollContainer.addSubview(regionSepartor)
        
        let introLabel = generateNewTitleLabel(title: "自我介紹(30字內)")
        scrollContainer.addSubview(introLabel)
        
        let introTextView = UITextView()
        introTextView.delegate = self
        introTextView.backgroundColor = UIColor.red
        introTextView.font = UIFont.systemFont(ofSize: 18)
        introTextView.isEditable = true
        scrollContainer.addSubview(introTextView)
        
        nameLabel.addConstraints(fromStringArray: ["V:|-[$self]-4-[$view0]-14-[$view1(1)]-14-[$view2]-4-[$view3]-14-[$view4(1)]-14-[$view5]-4-[$view6]-14-[$view7(1)]-14-[$view8]-4-[$view9(300)]-|",
                                                   "H:|-[$self]-|",
                                                   "H:|-[$view0]-|",
                                                   "H:|[$view1]|",
                                                   "H:|-[$view2]-|",
                                                   "H:|-[$view3]-|",
                                                   "H:|[$view4]|",
                                                   "H:|-[$view5]-|",
                                                   "H:|-[$view6]-|",
                                                   "H:|[$view7]|",
                                                   "H:|-[$view8]-|",
                                                   "H:|-[$view9]-|"],
                                views: [nameField, nameSepartor, emailLabel, emailField, emailSepartor, regionLabel, regionField, regionSepartor, introLabel, introTextView])
        
        registerForNotification()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(tapGesture:)))
        tapGesture.cancelsTouchesInView = false
        _scrollContainerView.addGestureRecognizer(tapGesture)
        
    }
    
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }

}
