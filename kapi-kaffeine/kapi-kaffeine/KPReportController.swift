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
    var sendButtonItem: UIBarButtonItem!
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
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        let backButton = KPBounceButton(frame: CGRect.zero,
                                        image: R.image.icon_back()!)
        backButton.widthAnchor.constraint(equalToConstant: CGFloat(KPLayoutConstant.dismissButton_size)).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: CGFloat(KPLayoutConstant.dismissButton_size)).isActive = true
        backButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        backButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        backButton.addTarget(self,
                             action: #selector(KPReportController.handleDismissButtonOnTapped),
                             for: UIControlEvents.touchUpInside)

        let barItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItems = [barItem]
        
        sendButtonItem = UIBarButtonItem(title: "送出",
                                         style: .plain,
                                         target: self,
                                         action: #selector(KPReportController.handleSendButtonOnTapped))
        sendButtonItem.setTitleTextAttributes([NSAttributedStringKey.font:
            UIFont.systemFont(ofSize: KPFontSize.mainContent)], for: .normal)
        sendButtonItem.isEnabled = false
        navigationItem.rightBarButtonItems = [sendButtonItem]
        
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
        inputTextView.typingAttributes = [NSAttributedStringKey.paragraphStyle.rawValue: paragraphStyle,
                                          NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 17),
                                          NSAttributedStringKey.foregroundColor.rawValue: KPColorPalette.KPTextColor.grayColor_level2!]
        
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

    @objc func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    @objc func handleSendButtonOnTapped() {
        inputTextView.resignFirstResponder()
        KPServiceHandler.sharedHandler.sendReport("送出去啦！！") { (_) in
            self.appModalController()?.dismissControllerWithDefaultDuration()
        }
    }
    
    @objc func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        if inputTextView.isFirstResponder {
            inputTextView.resignFirstResponder()
        } else {
            inputTextView.becomeFirstResponder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.count > 0 ? true : false
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
        placeholderLabel.isHidden = textView.text.count > 0 ? true : false
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
        
        sendButtonItem.isEnabled = newLength > 0
        
        if !returnKey {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}

