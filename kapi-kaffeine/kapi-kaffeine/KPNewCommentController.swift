//
//  KPNewCommentController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/16.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPNewCommentController: KPViewController {

    
    static let commentMaximumTextLength: Int = 200
    
    
    var scrollContainer: UIScrollView!
    var dismissButton: KPBounceButton!
    var sendButton: UIButton!
    var textFieldContainerView: UIView!
    var tapGesture: UITapGestureRecognizer!
    
    var ratingHeaderLabel: UILabel!
    var ratingContainer: UIView!
    var ratingCheckbox: KPCheckView!
    
    let ratingTitles = ["Wifi穩定", "安靜程度",
                        "價格實惠", "座位數量",
                        "咖啡品質", "餐點美味", "環境舒適"]
    let ratingImages = [R.image.icon_wifi(), R.image.icon_sleep(),
                        R.image.icon_money(), R.image.icon_seat(),
                        R.image.icon_cup(), R.image.icon_cutlery(),
                        R.image.icon_pic()]
    var ratingViews = [KPRatingView]()
    
    lazy var textFieldHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = "請留下你的評價"
        return label
    }()
    
    lazy var remainingTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = "0/\(commentMaximumTextLength)"
        return label
    }()
    
    var inputTextView: UITextView!
    var placeholderLabel: UILabel!
    var paragraphStyle: NSMutableParagraphStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = "新增評價"
        navigationItem.hidesBackButton = true
        
        dismissButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24));
        dismissButton.setImage(R.image.icon_back()?.withRenderingMode(.alwaysTemplate),
                            for: .normal);
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        dismissButton.addTarget(self,
                             action: #selector(KPNewCommentController.handleDismissButtonOnTapped),
                             for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: dismissButton);
        
        sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 24));
        sendButton.setTitle("發佈", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendButton.tintColor = KPColorPalette.KPTextColor.mainColor;
        sendButton.addTarget(self,
                             action: #selector(KPNewCommentController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        
        let rightbarItem = UIBarButtonItem(customView: sendButton);
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightbarItem]
        
        
        scrollContainer = UIScrollView()
        scrollContainer.delaysContentTouches = true
        scrollContainer.backgroundColor = KPColorPalette.KPMainColor.grayColor_level7
        scrollContainer.canCancelContentTouches = false
        view.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        
        textFieldContainerView = UIView()
        textFieldContainerView.backgroundColor = UIColor.white
        scrollContainer.addSubview(textFieldContainerView)
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
        inputTextView.typingAttributes = [NSParagraphStyleAttributeName: paragraphStyle,
                                          NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                                          NSForegroundColorAttributeName: KPColorPalette.KPTextColor.grayColor_level2!]
        
        textFieldContainerView.addSubview(inputTextView)
        inputTextView.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]|",
                                                       "H:|-12-[$self]-16-|"],
                                     views: [textFieldHeaderLabel])
        
        
        placeholderLabel = UILabel()
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
        
        ratingHeaderLabel = UILabel()
        ratingHeaderLabel.font = UIFont.systemFont(ofSize: 13)
        ratingHeaderLabel.textColor = KPColorPalette.KPTextColor.mainColor
        ratingHeaderLabel.text = "為店家評分"
        scrollContainer.addSubview(ratingHeaderLabel)
        ratingHeaderLabel.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]",
                                                           "H:|-8-[$self]"],
                                         views:[textFieldContainerView])
        
        ratingContainer = UIView()
        ratingContainer.backgroundColor = UIColor.white
        scrollContainer.addSubview(ratingContainer)
        ratingContainer.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]-16-|",
                                                         "H:|[$self]|"],
                                       views: [ratingHeaderLabel])
        
        
        ratingCheckbox = KPCheckView(.checkmark, "評分")
        ratingCheckbox.titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        ratingCheckbox.checkBox.boxType = .square
        ratingContainer.addSubview(ratingCheckbox)
        ratingCheckbox.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                        "V:|-16-[$self]"])
        
        ratingCheckbox.checkBox.addTarget(self,
                                          action: #selector(KPNewCommentController.checkBoxValueChanged(_:)),
                                          for: .valueChanged)
        
        for (index, title) in ratingTitles.enumerated() {
            let ratingView = KPRatingView(.star,
                                               ratingImages[index]!,
                                               title)
            ratingViews.append(ratingView)
            ratingContainer.addSubview(ratingView)
            
            if index == 0 {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-16-[$self]"],
                                          views:[ratingCheckbox])
            } else {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-12-[$self]"],
                                          views: [self.ratingViews[index-1]])
            }
        }
        ratingViews.last!.addConstraint(from: "V:[$self]-16-|")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkBoxValueChanged(_ sender: KPCheckBox) {
        switch sender.checkState {
        case .checked:
            for rateView in ratingViews {
                rateView.enable = true
            }
        case .unchecked:
            for rateView in ratingViews {
                rateView.enable = false
            }
        default:
            print("Mixed")
        }
    }

    func handleDismissButtonOnTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func handleSendButtonOnTapped() {
        inputTextView.resignFirstResponder()
        KPServiceHandler.sharedHandler.addComment(inputTextView.text) { (successed) in
            if successed {
                if self.ratingCheckbox.checkBox.checkState == .checked {
                    KPServiceHandler.sharedHandler.addRating(NSNumber(value: self.ratingViews[0].currentRate),
                                                             NSNumber(value: self.ratingViews[3].currentRate),
                                                             NSNumber(value: self.ratingViews[5].currentRate),
                                                             NSNumber(value: self.ratingViews[1].currentRate),
                                                             NSNumber(value: self.ratingViews[4].currentRate),
                                                             NSNumber(value: self.ratingViews[2].currentRate),
                                                             NSNumber(value: self.ratingViews[6].currentRate), { (successed) in
                                                                if successed {
                                                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                                                                                  execute: {
                                                                                                    self.navigationController?.popViewController(animated: true)
                                                                    })
                                                                }
                    })
                } else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                                  execute: { 
                                                self.navigationController?.popViewController(animated: true)
                    })
                }
            }
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
        placeholderLabel.isHidden = textView.text.characters.count > 0 ? true : false
    }
}

extension KPNewCommentController: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let textContent = textView.text! as NSString
        
        let oldLength = textContent.length
        let replacementLength = (text as NSString).length
        let rangeLength = range.length
        
        let newLength = oldLength - rangeLength + replacementLength
        let returnKey = (text as NSString).range(of: "\n").location == NSNotFound
        
        if !returnKey {
            textView.resignFirstResponder()
            return false
        }
        
        return newLength <= KPNewCommentController.commentMaximumTextLength && returnKey
    }
}
