//
//  KPSubTitleEditView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

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
    
    
    var placeHolderContent: String! {
        didSet {
            self.editTextField.placeholder = placeHolderContent
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
            customInfoView.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]|",
                                                            "H:|[$self]|"],
                                          views:[self.subTitleLabel])
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
                     _ title: String) {
        self.init(frame: .zero)
        
        bType = borderType
        dType = displayType
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
    }
    
    func makeUI() {
        makeTitleUI()
        editTextField.addConstraints(fromStringArray: ["H:|-16-[$self]",
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
        
        topBorderView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        bottomBorderView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        
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
            print("No border")
        }
    }
}
