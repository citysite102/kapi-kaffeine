//
//  KPShopInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopInfoView: UIView {

    var titleLabel: UILabel!;
    var featureContainer: UIView!;
    
    var featureContents: [String]! {
        didSet {
            
        }
    }
    
    var openTimeIcon: UIImageView!;
    var openHint: UIView!;
    var openLabel: UILabel!;
    var otherTimeButton: UIButton!;
    var phoneIcon: UIImageView!;
    var phoneLabel: UILabel!;
    var locationIcon: UIImageView!;
    var locationLabel: UILabel!;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.titleLabel = UILabel.init();
        self.titleLabel.font = UIFont.systemFont(ofSize: 16);
        self.titleLabel.text = "測試";
        self.titleLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1;
        self.addSubview(self.titleLabel);
        self.titleLabel.addConstraints(fromStringArray: ["V:|-16-[$self]", "H:|-16-[$self]"]);
        
        self.featureContainer = UIView.init();
        self.addSubview(self.featureContainer);
        self.featureContainer.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]", "H:|-16-[$self]"],
                                             views: [self.titleLabel]);
        
        self.openTimeIcon = UIImageView.init(image: UIImage.init(named: "icon_clock"));
        self.addSubview(self.openTimeIcon);
        self.openTimeIcon.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(24)]", "H:|-16-[$self(24)]"],
                                         views: [self.featureContainer]);
        
        self.openHint = UIView.init();
        self.openHint.layer.cornerRadius = 3.0;
        self.openHint.backgroundColor = KPColorPalette.KPShopStatusColor.opened;
        self.addSubview(self.openHint);
        self.openHint.addConstraints(fromStringArray: ["V:[$self(6)]", "H:[$view0]-4-[$self(6)]"],
                                     views: [self.openTimeIcon]);
        self.openHint.addConstraintForCenterAligning(to: self.openTimeIcon, in: .vertical);
        
        self.openLabel = UILabel.init();
        self.openLabel.font = UIFont.systemFont(ofSize: 14);
        self.openLabel.text = "測試";
        self.openLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1;
        self.addSubview(self.openLabel);
        self.openLabel.addConstraints(fromStringArray: ["H:[$view0]-4-[$self]"],
                                      views: [self.openHint]);
        self.openLabel.addConstraintForCenterAligning(to: self.openTimeIcon, in: .vertical);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
