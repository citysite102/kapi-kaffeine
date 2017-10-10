//
//  KPReportController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/13.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPReportController: KPViewController {

    var scrollContainer: UIScrollView!
    var dismissButton: KPBounceButton!
    var sendButton: UIButton!
    var textFieldContainerView: UIView!
    var inputTextView: UITextView!
    var placeholderLabel: UILabel!
    var paragraphStyle: NSMutableParagraphStyle!
    var tapGesture: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "錯誤回報"
        navigationItem.hidesBackButton = true
        
        dismissButton = KPBounceButton(frame: CGRect.zero,
                                       image: R.image.icon_close()!)
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 8, 14)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        dismissButton.addTarget(self,
                                action: #selector(KPNewCommentController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: dismissButton);
        
        sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 24));
        sendButton.setTitle("送出", for: .normal)
        sendButton.isEnabled = false
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendButton.tintColor = KPColorPalette.KPMainColor.mainColor
        sendButton.isEnabled = false
        sendButton.addTarget(self,
                             action: #selector(KPNewCommentController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        
        let rightbarItem = UIBarButtonItem(customView: sendButton);
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
        
        scrollContainer = UIScrollView()
        scrollContainer.delaysContentTouches = true
        scrollContainer.backgroundColor = UIColor.white
        scrollContainer.canCancelContentTouches = false
        view.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        
        textFieldContainerView = UIView()
        textFieldContainerView.backgroundColor = UIColor.white
        scrollContainer.addSubview(textFieldContainerView)
        textFieldContainerView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                                "H:|[$self]|"])
        textFieldContainerView.addConstraintForHavingSameWidth(with: view)
        textFieldContainerView.addConstraintForHavingSameHeight(with: view)
        
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTapGesture(tapGesture:)))
        textFieldContainerView.addGestureRecognizer(tapGesture)
        
        
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        
        inputTextView = UITextView()
        inputTextView.delegate = self
        inputTextView.returnKeyType = .done
        inputTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        inputTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        inputTextView.typingAttributes = [NSParagraphStyleAttributeName: paragraphStyle,
                                          NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                                          NSForegroundColorAttributeName: KPColorPalette.KPTextColor.grayColor_level2!]
        
        textFieldContainerView.addSubview(inputTextView)
        inputTextView.addConstraints(fromStringArray: ["V:|-16-[$self]-16-|",
                                                       "H:|-12-[$self]-12-|"])
        
        
        placeholderLabel = UILabel()
        placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        placeholderLabel.textColor = KPColorPalette.KPTextColor.grayColor_level4
        placeholderLabel.text = "我發現了一隻蟲..."
        textFieldContainerView.addSubview(placeholderLabel)
        placeholderLabel.addConstraints(fromStringArray: ["V:|-16-[$self]",
                                                          "H:|-12-[$self]-12-|"])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func handleSendButtonOnTapped() {
        inputTextView.resignFirstResponder()
        KPServiceHandler.sharedHandler.sendReport("送出去啦！！") { (_) in
            self.appModalController()?.dismissControllerWithDefaultDuration()
        }
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        if inputTextView.isFirstResponder {
            inputTextView.resignFirstResponder()
        } else {
            inputTextView.becomeFirstResponder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.characters.count > 0 ? true : false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.placeholderLabel.alpha = 0
        }) { (_) in
            self.placeholderLabel.isHidden = true
            self.placeholderLabel.alpha = 1.0
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.characters.count > 0 ? true : false
    }
}

extension KPReportController: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let textContent = textView.text! as NSString
        
        let oldLength = textContent.length
        let replacementLength = (text as NSString).length
        let rangeLength = range.length
        
        let newLength = oldLength - rangeLength + replacementLength
        let returnKey = (text as NSString).range(of: "\n").location == NSNotFound
        
        sendButton.isEnabled = newLength > 0
        
        if !returnKey {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}

