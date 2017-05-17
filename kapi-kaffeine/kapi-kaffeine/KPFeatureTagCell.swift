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
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        layer.borderWidth = 1.0
        layer.borderColor = KPColorPalette.KPMainColor.mainColor?.cgColor
        addSubview(featureLabel)
        featureLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        featureLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
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
