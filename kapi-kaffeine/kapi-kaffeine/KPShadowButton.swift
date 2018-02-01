//
//  KPShadowButton.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShadowButton: UIView {

    private var shadowLayer: CAShapeLayer!
    var button: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        button = UIButton(type: .custom)
        addSubview(button)
        button.addConstraints(fromStringArray: ["V:|[$self]|",
                                                "H:|[$self]|"])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                            cornerRadius:
                self.layer.cornerRadius).cgPath
            shadowLayer.fillColor = self.backgroundColor?.cgColor
            
            shadowLayer.shadowColor = KPColorPalette.KPMainColor_v2.shadow_mainColor?.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            shadowLayer.shadowOpacity = 0.4
            shadowLayer.shadowRadius = 3
            
            self.button.layer.cornerRadius = self.layer.cornerRadius
            self.button.layer.masksToBounds = true
            
            layer.insertSublayer(shadowLayer, at: 0)
        }        
    }

}
