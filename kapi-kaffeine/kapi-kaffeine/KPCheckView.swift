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
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
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
            checkBox.boxLineWidth = 2.0
            checkBox.stateChangeAnimation = .bounce(.fill)
        }
        
        addSubview(checkBox)
        addSubview(titleLabel)
        
        checkBox.addConstraints(fromStringArray: ["V:|[$self(20)]|",
                                                  "H:|[$self(20)]"])
        
        titleLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]|"],
                                  views: [checkBox])
        titleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkBox.handleTap(checkBox.tapGesture)
    }
    
    
}
