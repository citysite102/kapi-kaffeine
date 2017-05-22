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
    var featureContentViews: [UIView] = [UIView]();
    
    var featureContents: [String]! {
        didSet {
            
            for oldContentView in featureContentViews {
                oldContentView.removeFromSuperview();
            }
            
            featureContentViews.removeAll();
            
            for (index, content) in featureContents.enumerated() {
                
                let featureView = UIView.init();
                
                featureView.layer.borderWidth = 1.0;
                featureView.layer.borderColor = KPColorPalette.KPMainColor.mainColor?.cgColor;
                featureView.layer.cornerRadius = 12.0;
                self.featureContainer.addSubview(featureView);
                self.featureContentViews.append(featureView);
                
                if index == 0 {
                    featureView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
                                                                 "H:|[$self]"]);
                } else if index == featureContents.count-1 {
                    featureView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
                                                                 "H:[$view0]-4-[$self]|"],
                                               views: [self.featureContentViews[index-1]]);
                } else {
                    featureView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
                                                                 "H:[$view0]-4-[$self]"],
                                               views: [self.featureContentViews[index-1]]);
                }
                
                
                let contentLabel = UILabel.init();
                
                contentLabel.font = UIFont.systemFont(ofSize: 12.0);
                contentLabel.textColor = KPColorPalette.KPTextColor.mainColor;
                contentLabel.text = content;
                featureView.addSubview(contentLabel);
                contentLabel.addConstraints(fromStringArray: ["H:|-8-[$self]-8-|"]);
                contentLabel.addConstraintForCenterAligningToSuperview(in: .vertical);
                
            }
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
        self.titleLabel.addConstraints(fromStringArray: ["V:|-16-[$self]",
                                                         "H:|-16-[$self]"]);
        
        self.featureContainer = UIView.init();
        self.addSubview(self.featureContainer);
        self.featureContainer.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]", "H:|-16-[$self]"],
                                             views: [self.titleLabel]);
        
        self.openTimeIcon = UIImageView.init(image: R.image.icon_map());
        self.addSubview(self.openTimeIcon);
        self.openTimeIcon.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(20)]",
                                                           "H:|-16-[$self(20)]"],
                                         views: [self.featureContainer]);
        
        self.openHint = UIView.init();
        self.openHint.layer.cornerRadius = 3.0;
        self.openHint.backgroundColor = KPColorPalette.KPShopStatusColor.opened;
        self.addSubview(self.openHint);
        self.openHint.addConstraints(fromStringArray: ["V:[$self(6)]",
                                                       "H:[$view0]-4-[$self(6)]"],
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
        
        self.otherTimeButton = UIButton.init(type: .custom);
        self.otherTimeButton.setTitle("其他營業時間", for: .normal);
        self.otherTimeButton.setTitleColor(UIColor.white, for: .normal);
        self.otherTimeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        self.otherTimeButton.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        self.otherTimeButton.layer.cornerRadius = 4.0;
        self.addSubview(self.otherTimeButton);
        self.otherTimeButton.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(92)]", "V:[$self(24)]"],
                                            views: [self.openLabel]);
        self.otherTimeButton.addConstraintForCenterAligning(to: self.openLabel,
                                                            in: .vertical);
        
        self.phoneIcon = UIImageView.init(image: R.image.icon_clock());
        self.addSubview(self.phoneIcon);
        self.phoneIcon.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(20)]",
                                                        "H:|-16-[$self(20)]"],
                                         views: [self.openTimeIcon]);
        
        self.phoneLabel = UILabel.init();
        self.phoneLabel.font = UIFont.systemFont(ofSize: 14);
        self.phoneLabel.text = "測試";
        self.phoneLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1;
        self.addSubview(self.phoneLabel);
        self.phoneLabel.addConstraints(fromStringArray: ["H:[$view0]-4-[$self]"],
                                      views: [self.phoneIcon]);
        self.phoneLabel.addConstraintForCenterAligning(to: self.phoneIcon,
                                                       in: .vertical);
        
        self.locationIcon = UIImageView.init(image: R.image.icon_map());
        self.addSubview(self.locationIcon);
        self.locationIcon.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(20)]",
                                                           "H:|-16-[$self(20)]"],
                                      views: [self.phoneIcon]);
        
        self.locationLabel = UILabel.init();
        self.locationLabel.font = UIFont.systemFont(ofSize: 14);
        self.locationLabel.text = "測試";
        self.locationLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1;
        self.addSubview(self.locationLabel);
        self.locationLabel.addConstraints(fromStringArray: ["H:[$view0]-4-[$self]"],
                                          views: [self.locationIcon]);
        self.locationLabel.addConstraintForCenterAligning(to: self.locationIcon,
                                                          in: .vertical);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
