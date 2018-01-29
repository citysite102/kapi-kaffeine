//
//  KPSearchTagButtonCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/8/3.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchTagButtonCell: UICollectionViewCell {
    
    var tagTitle: UILabel!
    lazy var overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black
        return overlay
    }()
    
    override var isHighlighted: Bool {
        didSet {
            self.overlayView.alpha = self.isHighlighted ? 0.4 : 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1.0
        layer.borderColor = KPColorPalette.KPMainColor_v2.textColor_level3?.cgColor
        layer.cornerRadius = 16.0
        layer.masksToBounds = true
        
        backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        tagTitle = UILabel()
        tagTitle.font = UIFont.systemFont(ofSize: 13.0)
        tagTitle.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        addSubview(tagTitle)
        tagTitle.addConstraints(fromStringArray: ["H:|-12-[$self]-12-|"])
        tagTitle.addConstraintForCenterAligningToSuperview(in: .vertical)
        tagTitle.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        addSubview(overlayView)
        overlayView.isUserInteractionEnabled = false
        overlayView.alpha = 0.0
        overlayView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
