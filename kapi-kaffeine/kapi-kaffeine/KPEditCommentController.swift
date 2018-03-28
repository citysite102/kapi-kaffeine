//
//  KPEditCommentController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/8/16.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPEditCommentController: KPViewController {
    
    static let commentMaximumTextLength: Int = 200
    var containerView: UIView!
    var dismissButton: KPBounceButton!
    var sendButton: UIButton!
    var sendButtonItem: UIBarButtonItem!
    var textFieldContainerView: UIView!
    var defaultCommentModel: KPCommentModel!
    var inputTextView: UITextView!
    var placeholderLabel: UILabel!
    var paragraphStyle: NSMutableParagraphStyle!
    var tapGesture: UITapGestureRecognizer!
    
    lazy var textFieldHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        label.textColor = KPColorPalette.KPMainColor_v2.mainColor
        label.text = "請留下你的評論"
        return label
    }()
    
    lazy var remainingTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        label.textColor = KPColorPalette.KPMainColor_v2.mainColor
        label.text = "0/\(KPNewCommentController.commentMaximumTextLength)"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = "修改評論"
        navigationItem.hidesBackButton = true
        
        
        
        let barItem = UIBarButtonItem(image: R.image.icon_back(),
                                      style: .plain,
                                      target: self,
                                      action: #selector(KPEditCommentController.handleDismissButtonOnTapped))
        barItem.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        navigationItem.leftBarButtonItems = [barItem]
        
        
        sendButton = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 40,
                                            height: 24));
        sendButton.setTitle("發佈", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        sendButton.tintColor = KPColorPalette.KPTextColor.mainColor;
        sendButton.addTarget(self,
                             action: #selector(KPNewCommentController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        
        
        sendButtonItem = UIBarButtonItem(title: "發佈",
                                         style: .plain,
                                         target: self,
                                         action: #selector(KPNewCommentController.handleSendButtonOnTapped))
        sendButtonItem.setTitleTextAttributes([NSAttributedStringKey.font:
            UIFont.systemFont(ofSize: KPFontSize.mainContent)], for: .normal)
        
        sendButtonItem.isEnabled = false
        navigationItem.rightBarButtonItems = [sendButtonItem]
        
        containerView = UIView()
        containerView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        view.addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                       "H:|[$self]|"])
        
        textFieldContainerView = UIView()
        textFieldContainerView.backgroundColor = UIColor.white
        containerView.addSubview(textFieldContainerView)
        textFieldContainerView.addConstraints(fromStringArray: ["V:|[$self(240)]",
                                                                "H:|[$self]|"])
        textFieldContainerView.addConstraintForHavingSameWidth(with: view)
        
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTapGesture(tapGesture:)))
        textFieldContainerView.addGestureRecognizer(tapGesture)
        
        textFieldContainerView.addSubview(textFieldHeaderLabel)
        textFieldHeaderLabel.addConstraints(fromStringArray: ["V:|-16-[$self]",
                                                              "H:|-16-[$self]"])
        
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
        inputTextView.text = defaultCommentModel?.content ?? ""
        textFieldContainerView.addSubview(inputTextView)
        inputTextView.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]-40-|",
                                                       "H:|-12-[$self]-16-|"],
                                     views: [textFieldHeaderLabel])
        
        
        placeholderLabel = UILabel()
        placeholderLabel.isHidden = (defaultCommentModel != nil)
        placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        placeholderLabel.textColor = KPColorPalette.KPTextColor.grayColor_level4
        placeholderLabel.text = "Ex:東西很好吃，環境也很舒適..."
        textFieldContainerView.addSubview(placeholderLabel)
        placeholderLabel.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]",
                                                          "H:|-16-[$self]-16-|"],
                                        views: [textFieldHeaderLabel])
        
        textFieldContainerView.addSubview(remainingTextLabel)
        remainingTextLabel.addConstraints(fromStringArray: ["V:[$self]-16-|",
                                                            "H:[$self]-16-|"])
        remainingTextLabel.setText(text: "\(defaultCommentModel?.content?.count ?? 0)/\(KPEditCommentController.commentMaximumTextLength)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendButton.alpha = (inputTextView.text.count > 0 &&
            inputTextView.text != defaultCommentModel?.content) ?
                1.0 : 0.6
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        inputTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleResignTapGesture(_ tapGesture: UITapGestureRecognizer) {
        if inputTextView.isFirstResponder {
            inputTextView.resignFirstResponder()
        }
    }
    
    func handleDismissButtonOnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleSendButtonOnTapped() {
        inputTextView.resignFirstResponder()
//        KPPopoverView.popoverUnsupportedView()
        KPServiceHandler.sharedHandler.modifyComment(inputTextView.text, defaultCommentModel.commentID, { (successed) in
            if successed {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                              execute: {
                                                self.navigationController?.popViewController(animated: true)
                })
            }
        })
        
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
        remainingTextLabel.text = "\((textView.text! as NSString).length)/200"
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension KPEditCommentController: UITextViewDelegate {
    
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
        
        sendButton.alpha = (newLength > 0 &&
            inputTextView.text != defaultCommentModel?.content) ?
                1.0 : 0.6
        
        if !returnKey {
            textView.resignFirstResponder()
            return false
        }
        
        return newLength <= KPEditCommentController.commentMaximumTextLength && returnKey
    }
}

