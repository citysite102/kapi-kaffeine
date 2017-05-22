//
//  KPFeatureTagCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPFeatureTagCell: UICollectionViewCell {
    
    lazy var featureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor_light
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        layer.borderWidth = 1.0
        layer.borderColor = KPColorPalette.KPMainColor.mainColor_light?.cgColor
        addSubview(featureLabel)
        featureLabel.addConstraint(from: "H:|-8-[$self]-8-|")
        featureLabel.addConstraint(from: "V:|-2-[$self]-2-|")
        featureLabel.preferredMaxLayoutWidth = 64
    }
    
    override var isSelected: Bool {
        didSet {
            layer.backgroundColor = isSelected ? KPColorPalette.KPMainColor.mainColor_light?.cgColor : UIColor.white.cgColor
            self.featureLabel.textColor = isSelected ? UIColor.white : KPColorPalette.KPMainColor.mainColor_light
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.height/2
    }
}
