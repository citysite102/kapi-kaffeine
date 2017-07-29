//
//  KPSubTitleEditView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GooglePlaces
import pop

protocol KPSubTitleEditViewDelegate: class {
    func subTitleEditViewDidEndEditing(_ subTitleEditView: KPSubTitleEditView)
}

class KPSubTitleEditView: UIView {
    
    weak var delegate: KPSubTitleEditViewDelegate?

    enum BorderType {
        case Top
        case Bottom
        case Both
        case None
    }
    
    enum DisplayType {
        case Fixed
        case Edited
        case Custom
        case MultiLine
    }
    
    enum StatusType {
        case Normal
        case Warning
    }
    
    
    var inputKeyboardType: UIKeyboardType! {
        didSet {
            self.editTextField.keyboardType = inputKeyboardType
        }
    }
    
    var placeHolderContent: String! = "" {
        didSet {
            if dType == .MultiLine {
                placeHolderLabel.text = placeHolderContent
            } else {
                let placeholder = NSMutableAttributedString(string: placeHolderContent)
                placeholder.addAttribute(NSForegroundColorAttributeName,
                                         value: KPColorPalette.KPTextColor.default_placeholder!,
                                         range: NSRange.init(location: 0, length: placeHolderContent.characters.count))
                editTextField.attributedPlaceholder = placeholder
            }
        }
    }
    
    var content: String! {
        didSet {
            if dType == .MultiLine {
                self.editTextView.text = content
            } else {
                self.editTextField.text = content
            }
        }
    }
    
    var customInfoView: UIView! {
        didSet {
            addSubview(customInfoView)
            customInfoView.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]-8-|",
                                                            "H:|-16-[$self]-16-|"],
                                          views:[self.subTitleLabel])
        }
    }
    
    var customInputAction: (() -> Void)!
    var tapGesture: UITapGestureRecognizer!
    var sType: StatusType! {
        didSet {
            if sType == .Normal {
                if dType == .MultiLine {
                    placeHolderLabel.textColor = KPColorPalette.KPTextColor.default_placeholder!
                    placeHolderLabel.text = placeHolderContent
                    editTextView.layer.pop_removeAllAnimations()
                } else {
                    let placeholder = NSMutableAttributedString(string: placeHolderContent)
                    placeholder.addAttribute(NSForegroundColorAttributeName,
                                             value: KPColorPalette.KPTextColor.default_placeholder!,
                                             range: NSRange.init(location: 0, length: placeHolderContent.characters.count))
                    editTextField.attributedPlaceholder = placeholder
                    editTextField.layer.pop_removeAllAnimations()
                }
            } else if sType == .Warning {
                let content = "Oops! 記得填寫這個欄位喔!"
                if dType == .MultiLine {
                    placeHolderLabel.textColor = KPColorPalette.KPTextColor.warningColor!
                    placeHolderLabel.text = content
                    
                    let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
                    anim?.springBounciness = 15
                    anim?.velocity = 400
                    editTextView.layer.pop_add(anim, forKey: "warning")
                } else {
                    let placeholder = NSMutableAttributedString(string: content)
                    placeholder.addAttribute(NSForegroundColorAttributeName,
                                             value: KPColorPalette.KPTextColor.warningColor!,
                                             range: NSRange.init(location: 0, length: content.characters.count))
                    editTextField.attributedPlaceholder = placeholder
                    
                    let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
                    anim?.springBounciness = 15
                    anim?.velocity = 400
                    editTextField.layer.pop_add(anim, forKey: "warning")
                }
            }
        }
    }
    
    private var bType: BorderType!
    private var dType: DisplayType!
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        return label
    }()
    
    lazy var editTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = KPColorPalette.KPTextColor.grayColor_level2
        textField.placeholder = "請輸入..."
        textField.delegate = self
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var editTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = KPColorPalette.KPTextColor.grayColor_level2
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        textView.returnKeyType = .done
        return textView
    }()
    
    var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = KPColorPalette.KPTextColor.default_placeholder!
        return label
    }()
    
    var editTextViewHeightConstaint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ borderType: BorderType = .Bottom,
                     _ displayType: DisplayType = .Edited,
                     _ title: String?) {
        self.init(frame: .zero)
        
        bType = borderType
        dType = displayType
        sType = .Normal
        subTitleLabel.text = title
        
        
        switch dType! {
        case .Fixed:
            editTextField.isEnabled = false
            addSubview(editTextField)
            makeUI()
        case .Edited:
            editTextField.isEnabled = true
            addSubview(editTextField)
            makeUI()
        case .Custom:
            editTextField.isHidden = true
            makeTitleUI()
            makeBorder()
        case .MultiLine:
            makeTitleUI()
            makeBorder()
            addSubview(editTextView)
            editTextView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                          "V:[$view0]-10-[$self]-16-|"],
                                        views:[subTitleLabel])
            
            editTextView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            let newSize = editTextView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            editTextViewHeightConstaint = editTextView.addConstraint(forHeight: newSize.height)
            editTextView.addSubview(placeHolderLabel)
            placeHolderLabel.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]"])
        }
        
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTapGesture(tapGesture:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    func makeUI() {
        makeTitleUI()
        editTextField.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$view0]-10-[$self]"],
                                     views:[subTitleLabel])
        makeBorder()
    }
    
    func makeTitleUI() {
        addSubview(subTitleLabel)
        subTitleLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                       "V:|-16-[$self]"])
    }
    
    func makeBorder() {
        let topBorderView = UIView()
        let bottomBorderView = UIView()
        
        topBorderView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        bottomBorderView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        
        switch bType! {
        case .Bottom:
            addSubview(bottomBorderView)
            bottomBorderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$self(1)]|"])
        case .Top:
            addSubview(topBorderView)
            topBorderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                           "V:|[$self(1)]"])
        case .Both:
            addSubview(topBorderView)
            topBorderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                           "V:|[$self(1)]"])
            addSubview(bottomBorderView)
            bottomBorderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$self(1)]|"])
        default:
            break
        }
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        if editTextField.isEnabled {
            editTextField.becomeFirstResponder()
        } else {
            customInputAction()
        }
    }
    
}

extension KPSubTitleEditView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let returnKey = (string as NSString).range(of: "\n").location == NSNotFound
        
        if !returnKey {
            textField.resignFirstResponder()
            return false
        }
        
        sType = .Normal
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.subTitleEditViewDidEndEditing(self)
    }
    
}

extension KPSubTitleEditView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        sType = .Normal
        
        if textView.text.characters.count == 0 {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
        
        let fixedWidth = textView.frame.size.width

        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        editTextViewHeightConstaint.constant = newSize.height
        textView.layoutIfNeeded()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let returnKey = (text as NSString).range(of: "\n").location == NSNotFound
        
        if !returnKey {
            textView.resignFirstResponder()
            return false
        }
        
        sType = .Normal
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.subTitleEditViewDidEndEditing(self)
    }
    
}

