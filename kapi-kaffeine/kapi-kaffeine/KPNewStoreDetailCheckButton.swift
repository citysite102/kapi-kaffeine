//
//  KPNewStoreDetailButton.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 30/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPNewStoreDetailCheckButton: UIButton {

//    var titleLabel: UILabel!
    var statusLabel: UILabel!
    
    fileprivate var indicatorImageView: UIImageView!
    
    init(_ title: String) {
        super.init(frame: CGRect.zero)
        
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        contentHorizontalAlignment = .left
        
        setTitle(title, for: .normal)
        setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_subtitle, for: .normal)
        titleLabel!.font = UIFont.systemFont(ofSize: 18)
        
        
//        titleLabel = UILabel()
//        titleLabel.text = title
//        titleLabel.font = UIFont.systemFont(ofSize: 18)
//        titleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
//        addSubview(titleLabel)
//        titleLabel.addConstraint(from: "H:|-20-[$self]")
//        titleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        
        indicatorImageView = UIImageView(image: R.image.icon_right())
        addSubview(indicatorImageView)
        indicatorImageView.addConstraint(from: "H:[$self(25)]-20-|")
        indicatorImageView.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        
        statusLabel = UILabel()
        statusLabel.text = "尚未填寫"
        statusLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        addSubview(statusLabel)
        statusLabel.addConstraint(from: "[$self]-10-[$view0]", views:[indicatorImageView])
        statusLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        
        let lineView = UIView()
        lineView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level5
        addSubview(lineView)
        lineView.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:|[$self(0.5)]"])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted == true {
                backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
            } else {
                backgroundColor = UIColor.white
            }
        }
    }
    
}
