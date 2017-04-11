//
//  KPSearchFooterCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchFooterCell: UICollectionViewCell {
    
    var locationLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.locationLabel.alpha = 1.0;
                self.backgroundColor = KPColorPalette.KPMainColor.mainColor;
            } else {
                self.locationLabel.alpha = 0.5;
                self.backgroundColor = UIColor.clear;
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.clear;
        
        self.locationLabel = UILabel();
        self.locationLabel.font = UIFont.systemFont(ofSize: 14.0);
        self.locationLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        self.locationLabel.alpha = 0.5;
        self.addSubview(self.locationLabel);
        self.locationLabel.addConstraintForCenterAligningToSuperview(in: .horizontal);
        self.locationLabel.addConstraintForCenterAligningToSuperview(in: .vertical);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
