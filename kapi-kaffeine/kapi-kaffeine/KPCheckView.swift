//
//  KPCheckView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/6.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPCheckView: UIView {

    enum checkType: String, RawRepresentable {
        case radio = "radio"
        case checkmark = "Scheckmarktar"
    }

    
    var titleLabel: UILabel!
    var checkBox: KPCheckBox!
    var customValue: Int?
    var supplementInfoView: UIView? {
        didSet {
            checkBox.removeAllRelatedConstraintsInSuperView()
            titleLabel.removeAllRelatedConstraintsInSuperView()
            checkBox.addConstraints(fromStringArray: ["V:|[$self(20)]",
                                                      "H:|[$self(20)]"])
            titleLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]|"],
                                      views: [checkBox])
            titleLabel.addConstraintForCenterAligning(to: checkBox, in: .vertical)
            addSubview(supplementInfoView!)
            let _ = supplementInfoView?.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]|",
                                                                         "H:[$view0]-8-[$self]"],
                                                       views: [checkBox])
        }
    }
    
    var deselectCheckViews: [KPCheckView]? {
        didSet {
            var deselectCheckBoxs: [KPCheckBox] = [KPCheckBox]()
            for checkView in deselectCheckViews! {
                deselectCheckBoxs.append(checkView.checkBox)
            }
            checkBox.deselectCheckBoxs = deselectCheckBoxs
        }
    }
    
    var groupValue: Any? {
        
        if deselectCheckViews != nil {
            
            if checkBox.checkState == .checked {
                return customValue ?? titleLabel.text
            }
            
            for deselectCheckView in deselectCheckViews! {
                if deselectCheckView.checkBox.checkState == .checked {
                    return deselectCheckView.customValue ?? deselectCheckView.titleLabel.text
                }
            }
        }
        
        return nil
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ type: checkType = checkType.radio,
                     _ title: String) {
        
        self.init(frame: .zero)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        titleLabel.textColor = KPColorPalette.KPTextColor.grayColor_level2
        titleLabel.text = title
        
        checkBox = KPCheckBox()
        
        switch type {
        case .radio:
            checkBox.setMarkType(markType: .radio,
                                 animated: true)
            checkBox.boxLineWidth = 2.0
            checkBox.stateChangeAnimation = .bounce(.fill)
        case .checkmark:
            checkBox.setMarkType(markType: .checkmark,
                                 animated: true)
            checkBox.stateChangeAnimation = .fill
            checkBox.secondaryTintColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        }
        
        addSubview(checkBox)
        addSubview(titleLabel)
        checkBox.checkState = .unchecked
        checkBox.addConstraints(fromStringArray: ["V:|[$self(24)]|",
                                                  "H:|[$self(24)]"])
        
        titleLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]|"],
                                  views: [checkBox])
        titleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkBox.handleTap(checkBox.tapGesture)
    }
    
    
}
