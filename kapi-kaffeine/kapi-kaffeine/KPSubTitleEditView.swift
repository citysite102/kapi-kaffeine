//
//  KPSubTitleEditView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GooglePlaces

class KPSubTitleEditView: UIView {

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
    
    var placeHolderContent: String! {
        didSet {
            let placeholder = NSMutableAttributedString(string: placeHolderContent)
            placeholder.addAttribute(NSForegroundColorAttributeName,
                                     value: KPColorPalette.KPTextColor.default_placeholder!,
                                     range: NSRange.init(location: 0, length: placeHolderContent.characters.count))
            editTextField.attributedPlaceholder = placeholder
        }
    }
    
    var content: String! {
        didSet {
            self.editTextField.text = content
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
                let placeholder = NSMutableAttributedString(string: placeHolderContent)
                placeholder.addAttribute(NSForegroundColorAttributeName,
                                         value: KPColorPalette.KPTextColor.default_placeholder!,
                                         range: NSRange.init(location: 0, length: placeHolderContent.characters.count))
                editTextField.attributedPlaceholder = placeholder
            } else if sType == .Warning {
                let content = "這裡不能是空白的喔!"
                let placeholder = NSMutableAttributedString(string: content)
                placeholder.addAttribute(NSForegroundColorAttributeName,
                                         value: KPColorPalette.KPTextColor.warningColor!,
                                         range: NSRange.init(location: 0, length: content.characters.count))
                editTextField.attributedPlaceholder = placeholder
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
        }
        
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTapGesture(tapGesture:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    func makeUI() {
        makeTitleUI()
        editTextField.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$view0]-8-[$self]"],
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
        
        return true
    }
}

