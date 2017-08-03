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
        
        backgroundColor = KPColorPalette.KPMainColor.mainColor
        tagTitle = UILabel()
        tagTitle.font = UIFont.systemFont(ofSize: 13.0)
        tagTitle.textColor = KPColorPalette.KPTextColor.whiteColor
        addSubview(tagTitle)
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
