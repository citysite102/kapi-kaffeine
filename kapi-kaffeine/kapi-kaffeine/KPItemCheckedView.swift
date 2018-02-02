//
//  KPItemCheckedView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/18.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPItemCheckedView: UIView {
    
    var checkBox: KPCheckBox!
//    var checked: Bool = false {
//        didSet {
//            stateLabel.text = checked ? checkContent : uncheckContent
//            stateLabel.textColor = checked ?
//                KPColorPalette.KPTextColor.grayColor_level2 :
//                KPColorPalette.KPTextColor.grayColor_level4
//        }
//    }
    
//    var customInputAction: (() -> Void)?
    var tapGesture: UITapGestureRecognizer!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ title: String) {
        
        self.init(frame: .zero)
        
        titleLabel.text = title
        addSubview(titleLabel)
        
        titleLabel.addConstraints(fromStringArray: ["H:|[$self]",
                                                    "V:|-8-[$self]-8-|"])
        titleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        checkBox = KPCheckBox()
        checkBox.setMarkType(markType: .checkmark,
                             animated: true)
        checkBox.stateChangeAnimation = .fill
        checkBox.secondaryTintColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        checkBox.setCheckState(.unchecked, animated: false)
        addSubview(checkBox)
        
        checkBox.addConstraints(fromStringArray: ["H:[$self(24)]|",
                                                  "V:[$self(24)]"])
        checkBox.addConstraintForCenterAligningToSuperview(in: .vertical)
        checkBox.addTarget(self,
                           action: #selector(handleCheckBoxStateChanged),
                           for: UIControlEvents.valueChanged)
        
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTapGesture(tapGesture:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture(tapGesture: UITapGestureRecognizer) {
//        customInputAction?()
    }
    
    @objc func handleCheckBoxStateChanged() {
        titleLabel.textColor = self.checkBox.checkState == .checked ?
            KPColorPalette.KPTextColor_v2.mainColor_subtitle :
            KPColorPalette.KPTextColor_v2.mainColor_description
    }
}
