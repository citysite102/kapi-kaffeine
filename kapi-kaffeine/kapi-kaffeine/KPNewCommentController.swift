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
    
    var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = "新增評價"
        navigationItem.hidesBackButton = true
        
        dismissButton = KPBounceButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                            for: .normal);
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        dismissButton.addTarget(self,
                             action: #selector(KPNewCommentController.handleDismissButtonOnTapped),
                             for: .touchUpInside)
        let barItem = UIBarButtonItem.init(customView: self.dismissButton);
        
        sendButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 24));
        sendButton.setTitle("發佈", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendButton.tintColor = KPColorPalette.KPTextColor.mainColor;
        sendButton.addTarget(self,
                             action: #selector(KPNewCommentController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        
        let rightbarItem = UIBarButtonItem.init(customView: self.sendButton);
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightbarItem]
        
        
        scrollContainer = UIScrollView()
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
        
        tapGesture = UITapGestureRecognizer.init(target: self,
                                                 action: #selector(handleTapGesture(tapGesture:)))
        textFieldContainerView.addGestureRecognizer(tapGesture)
        
        textFieldContainerView.addSubview(textFieldHeaderLabel)
        textFieldHeaderLabel.addConstraints(fromStringArray: ["V:|-16-[$self]",
                                                              "H:|-16-[$self]"])
        
        inputTextField = UITextField()
        inputTextField.delegate = self
        inputTextField.placeholder = "Ex:東西很好吃，環境也很舒適..."
        inputTextField.addTarget(self,
                                 action: #selector(textFieldDidChange(_:)),
                                 for: .editingChanged)
        
        textFieldContainerView.addSubview(inputTextField)
        inputTextField.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]",
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
        
        
        ratingCheckbox = KPCheckView.init(.checkmark, "暫時不評分")
        ratingCheckbox.titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        ratingCheckbox.checkBox.boxType = .square
        ratingContainer.addSubview(ratingCheckbox)
        ratingCheckbox.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                        "V:|-16-[$self]"])
        
        for (index, title) in ratingTitles.enumerated() {
            let ratingView = KPRatingView.init(.star,
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

    func handleDismissButtonOnTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func handleSendButtonOnTapped() {
        inputTextField.resignFirstResponder()
        KPServiceHandler.sharedHandler.addNewComment(inputTextField.text) { (successed) in
            if successed {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                              execute: { 
                                            self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        inputTextField.becomeFirstResponder()
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        remainingTextLabel.text = "\((textField.text! as NSString).length)/200"
    }
}

extension KPNewCommentController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textContent = textField.text! as NSString
        
        let oldLength = textContent.length
        let replacementLength = (string as NSString).length
        let rangeLength = range.length
        
        let newLength = oldLength - rangeLength + replacementLength
        let returnKey = (string as NSString).range(of: "\n").location != NSNotFound
        
        return newLength <= KPNewCommentController.commentMaximumTextLength || returnKey
    }
}
