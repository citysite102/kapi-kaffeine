//
//  KPPreferenceHintButton.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPPreferenceHintButton: UIButton {

    var hintCountContainer: UIView!
    var hintCountLabel: UILabel!
    var hintCount: Int = 0 {
        didSet {
            self.hintCountContainer.alpha = (hintCount == 0) ? 0.0 : 1.0
            self.imageView?.alpha = (hintCount == 0) ? 1.0 : 0.0
            self.hintCountLabel.text = "\(hintCount)"
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hintCountContainer = UIView()
        hintCountContainer.backgroundColor = UIColor.white
        hintCountContainer.layer.cornerRadius = 2.0
        hintCountContainer.layer.masksToBounds = true
        hintCountContainer.alpha = 0
        addSubview(hintCountContainer)
        
        hintCountLabel = UILabel()
        hintCountLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        hintCountLabel.textColor = KPColorPalette.KPTextColor.mainColor
        hintCountLabel.text = "1"
        hintCountContainer.addSubview(hintCountLabel)
        hintCountLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        hintCountLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        hintCountContainer.frameSize = CGSize(width: 18, height: 18)
        hintCountContainer.center = CGPoint(x: (imageView?.frame.origin.x)! +
                                                (imageView?.frame.size.width)!/2,
                                            y: (imageView?.frame.origin.y)! +
                                                (imageView?.frame.size.height)!/2)
    }
    
}
