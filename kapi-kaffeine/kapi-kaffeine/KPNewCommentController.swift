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
    var sendButtonItem: UIBarButtonItem!
    var textFieldContainerView: UIView!
    var inputTextView: UITextView!
    var placeholderLabel: UILabel!
    var paragraphStyle: NSMutableParagraphStyle!
    var tapGesture: UITapGestureRecognizer!
    
    var ratingHeaderLabel: UILabel!
    var ratingContainer: UIView!
    var ratingCheckbox: KPCheckView!
    var resignTapGesture: UITapGestureRecognizer!
    var hideRatingViews: Bool! = false {
        didSet {
            if ratingContainer != nil {
                ratingHeaderLabel.isHidden = hideRatingViews
                ratingContainer.isHidden = hideRatingViews
            }
        }
    }
    
    lazy var separator_one: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    let ratingTitles = ["Wifi穩定", "安靜程度",
                        "價格實惠", "座位數量",
                        "咖啡品質", "餐點美味", "環境舒適"]
    let ratingImages = [R.image.icon_wifi(), R.image.icon_sleep(),
                        R.image.icon_money(), R.image.icon_seat(),
                        R.image.icon_cup(), R.image.icon_cutlery(),
                        R.image.icon_pic()]
    var ratingViews = [KPRatingView]()
    var ratingView: KPRatingView!
    
    lazy var textFieldHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: KPFontSize.header,
                                       weight: UIFont.Weight.regular)
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
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
        navigationItem.title = "新增評論"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backButton = KPBounceButton(frame: CGRect.zero,
                                        image: R.image.icon_back()!)
        backButton.widthAnchor.constraint(equalToConstant: CGFloat(KPLayoutConstant.dismissButton_size)).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: CGFloat(KPLayoutConstant.dismissButton_size)).isActive = true
        backButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        backButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        backButton.addTarget(self,
                             action: #selector(KPNewCommentController.handleDismissButtonOnTapped),
                             for: UIControlEvents.touchUpInside)
        
        let barItem = UIBarButtonItem(customView: backButton)
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
        
        
        scrollContainer = UIScrollView()
        scrollContainer.delaysContentTouches = true
        scrollContainer.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        scrollContainer.canCancelContentTouches = false
        view.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        
        textFieldContainerView = UIView()
        textFieldContainerView.backgroundColor = UIColor.white
        scrollContainer.addSubview(textFieldContainerView)
        textFieldContainerView.addConstraints(fromStringArray: ["V:|[$self(280)]",
                                                                "H:|[$self]|"])
        textFieldContainerView.addConstraintForHavingSameWidth(with: view)
        
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTapGesture(tapGesture:)))
        textFieldContainerView.addGestureRecognizer(tapGesture)
        
//        textFieldContainerView.addSubview(textFieldHeaderLabel)
//        textFieldHeaderLabel.addConstraints(fromStringArray: ["V:|-24-[$self]",
//                                                              "H:|-16-[$self]"])
        
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        
        inputTextView = UITextView()
        inputTextView.delegate = self
        inputTextView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        inputTextView.returnKeyType = .done
        inputTextView.layer.cornerRadius = 4.0
        inputTextView.layer.masksToBounds = true
        inputTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        inputTextView.textContainerInset = UIEdgeInsetsMake(8, 4, 40, 4)
        inputTextView.typingAttributes = [NSAttributedStringKey.paragraphStyle.rawValue: paragraphStyle,
                                          NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: KPFontSize.mainContent),
                                          NSAttributedStringKey.foregroundColor.rawValue: KPColorPalette.KPTextColor.grayColor_level2!]
        
        textFieldContainerView.addSubview(inputTextView)
//        inputTextView.addConstraints(fromStringArray: ["V:[$view0]-14-[$self]-24-|",
//                                                       "H:|-12-[$self]-12-|"],
//                                     views: [textFieldHeaderLabel])
        inputTextView.addConstraints(fromStringArray: ["V:|-12-[$self]-24-|",
                                                       "H:|-16-[$self]-16-|"])
        
        placeholderLabel = UILabel()
        placeholderLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        placeholderLabel.textColor = KPColorPalette.KPTextColor.grayColor_level4
        placeholderLabel.text = "Ex:東西很好吃，環境也很舒適..."
        textFieldContainerView.addSubview(placeholderLabel)
        placeholderLabel.addConstraints(fromStringArray: ["V:|-22-[$self]",
                                                          "H:|-26-[$self]-16-|"])
        
        textFieldContainerView.addSubview(remainingTextLabel)
        remainingTextLabel.addConstraints(fromStringArray: ["V:[$self]-32-|",
                                                            "H:[$self]-24-|"])
        
        
        ratingContainer = UIView()
        ratingContainer.isHidden = hideRatingViews
        ratingContainer.backgroundColor = UIColor.white
        scrollContainer.addSubview(ratingContainer)
        ratingContainer.addConstraints(fromStringArray: ["V:[$view0][$self]-16-|",
                                                         "H:|[$self]|"],
                                       views: [textFieldContainerView])
        
        ratingHeaderLabel = UILabel()
        ratingHeaderLabel.isHidden = hideRatingViews
        ratingHeaderLabel.font = UIFont.systemFont(ofSize: KPFontSize.sub_header,
                                                   weight: UIFont.Weight.regular)
        ratingHeaderLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        ratingHeaderLabel.text = "為店家評分"
        ratingContainer.addSubview(ratingHeaderLabel)
        ratingHeaderLabel.addConstraints(fromStringArray: ["V:|-8-[$self]",
                                                           "H:|-16-[$self]"])
        
        ratingView = KPRatingView()
        ratingContainer.addSubview(ratingView)
        ratingView.addConstraints(fromStringArray: ["V:[$view0]-12-[$self]-20-|",
                                                    "H:|-14-[$self]-16-|"],
                                  views: [ratingHeaderLabel])
        
        
        resignTapGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(handleResignTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
//        ratingCheckbox = KPCheckView(.checkmark, "評分")
//        ratingCheckbox.titleLabel.font = UIFont.systemFont(ofSize: 14.0)
//        ratingCheckbox.checkBox.boxType = .square
//        ratingContainer.addSubview(ratingCheckbox)
//        ratingCheckbox.addConstraints(fromStringArray: ["H:|-16-[$self]",
//                                                        "V:|-16-[$self]"])
//
//        ratingCheckbox.checkBox.addTarget(self,
//                                          action: #selector(KPNewCommentController.checkBoxValueChanged(_:)),
//                                          for: .valueChanged)
        
//        for (index, title) in ratingTitles.enumerated() {
//            let ratingView = KPRatingView()
//            ratingViews.append(ratingView)
//            ratingContainer.addSubview(ratingView)
//            ratingView.enable = false
//            if index == 0 {
//                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
//                                                            "V:[$view0]-16-[$self]"],
//                                          views: [ratingCheckbox])
//            } else {
//                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
//                                                            "V:[$view0]-12-[$self]"],
//                                          views: [self.ratingViews[index-1]])
//            }
//        }
//        ratingViews.last!.addConstraint(from: "V:[$self]-16-|")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        sendButtonItem.customView!.alpha = inputTextView.text.count > 0 ? 1.0 : 0.6
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleResignTapGesture(_ tapGesture: UITapGestureRecognizer) {
        if inputTextView.isFirstResponder {
            inputTextView.resignFirstResponder()
        }
    }
    
    @objc func checkBoxValueChanged(_ sender: KPCheckBox) {
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

    @objc func handleDismissButtonOnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSendButtonOnTapped() {
        inputTextView.resignFirstResponder()
        KPServiceHandler.sharedHandler.addCommentAndRatings(inputTextView.text,
                                                            NSNumber(value: self.ratingView.currentRate),
                                                            NSNumber(value: self.ratingView.currentRate),
                                                            NSNumber(value: self.ratingView.currentRate),
                                                            NSNumber(value: self.ratingView.currentRate),
                                                            NSNumber(value: self.ratingView.currentRate),
                                                            NSNumber(value: self.ratingView.currentRate),
                                                            NSNumber(value: self.ratingView.currentRate),
                                                            { (successed) in
                                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                                                                              execute: {
                                                                                                self.navigationController?.popViewController(animated: true)
                                                                })
                                                            }
        
        )
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
        
        sendButtonItem.isEnabled = newLength > 0
//        sendButtonItem.customView!.alpha = newLength > 0 ? 1.0 : 0.6
        
        if !returnKey {
            textView.resignFirstResponder()
            return false
        }
        
        return newLength <= KPNewCommentController.commentMaximumTextLength && returnKey
    }
}
