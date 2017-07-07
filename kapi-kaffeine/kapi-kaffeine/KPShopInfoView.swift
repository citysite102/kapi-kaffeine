//
//  KPShopInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopInfoView: UIView {

    var titleLabel: UILabel!
    var featureContainer: UIView!
    var featureContentViews: [UIView] = [UIView]()
    
    var featureContents: [String]! {
        didSet {
            
            if featureContents.count == 0 {
                featureContents = ["尚無特色"]
            }
            for oldContentView in featureContentViews {
                oldContentView.removeFromSuperview()
            }
            
            featureContentViews.removeAll()
            
            for (index, content) in featureContents.enumerated() {
                
                let featureView = UIView.init()
                
                featureView.layer.borderWidth = 1.0
                featureView.layer.borderColor = KPColorPalette.KPMainColor.mainColor?.cgColor
                featureView.layer.cornerRadius = 12.0
                featureContainer.addSubview(featureView)
                featureContentViews.append(featureView)
                
                if index == 0 {
                    featureView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
                                                                 "H:|[$self]"])
                } else if index == featureContents.count-1 {
                    featureView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
                                                                 "H:[$view0]-4-[$self]|"],
                                               views: [featureContentViews[index-1]])
                } else {
                    featureView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
                                                                 "H:[$view0]-4-[$self]"],
                                               views: [featureContentViews[index-1]])
                }
                
                
                let contentLabel = KPLayerLabel()
                
                contentLabel.font = UIFont.systemFont(ofSize: 12.0)
                contentLabel.textColor = KPColorPalette.KPTextColor.mainColor
                contentLabel.text = content
                featureView.addSubview(contentLabel)
                contentLabel.addConstraints(fromStringArray: ["H:|-8-[$self]-8-|"])
                contentLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
                
            }
        }
    }
    
    var openTimeIcon: UIImageView!
    var openHint: UIView!
    var openLabel: KPLayerLabel!
    var otherTimeButton: UIButton!
    var phoneIcon: UIImageView!
    var phoneLabel: KPLayerLabel!
    var locationIcon: UIImageView!
    var locationLabel: KPLayerLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = KPLayerLabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1
        addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["V:|-16-[$self]",
                                                         "H:|-16-[$self]"])
        
        featureContainer = UIView.init()
        addSubview(featureContainer)
        featureContainer.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]",
                                                          "H:|-16-[$self]"],
                                             views: [titleLabel])
        
        openTimeIcon = UIImageView.init(image: R.image.icon_tradehour())
        openTimeIcon.tintColor = KPColorPalette.KPMainColor.mainColor
        addSubview(openTimeIcon)
        openTimeIcon.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(20)]",
                                                      "H:|-16-[$self(20)]"],
                                         views: [featureContainer])
        
        openHint = UIView.init()
        openHint.layer.cornerRadius = 3.0
        openHint.backgroundColor = KPColorPalette.KPShopStatusColor.opened
        addSubview(openHint)
        openHint.addConstraints(fromStringArray: ["V:[$self(6)]",
                                                  "H:[$view0]-8-[$self(6)]"],
                                     views: [openTimeIcon])
        openHint.addConstraintForCenterAligning(to: openTimeIcon, in: .vertical)
        
        openLabel = KPLayerLabel()
        openLabel.font = UIFont.systemFont(ofSize: 14)
        openLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1
        addSubview(openLabel)
        openLabel.addConstraints(fromStringArray: ["H:[$view0]-6-[$self]"],
                                      views: [openHint])
        openLabel.addConstraintForCenterAligning(to: openTimeIcon, in: .vertical)
        
        otherTimeButton = UIButton.init(type: .custom)
        otherTimeButton.tintColor = KPColorPalette.KPMainColor.mainColor
        otherTimeButton.setTitle("其他營業時間", for: .normal)
        otherTimeButton.setTitleColor(UIColor.white, for: .normal)
        otherTimeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        otherTimeButton.backgroundColor = KPColorPalette.KPMainColor.mainColor
        otherTimeButton.layer.cornerRadius = 4.0
        addSubview(otherTimeButton)
        otherTimeButton.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(92)]",
                                                         "V:[$self(24)]"],
                                            views: [openLabel])
        otherTimeButton.addConstraintForCenterAligning(to: openLabel,
                                                            in: .vertical)
        
        phoneIcon = UIImageView.init(image: R.image.icon_phone())
        phoneIcon.tintColor = KPColorPalette.KPMainColor.mainColor
        addSubview(phoneIcon)
        phoneIcon.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(20)]",
                                                   "H:|-16-[$self(20)]"],
                                         views: [openTimeIcon])
        
        phoneLabel = KPLayerLabel()
        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        phoneLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1
        addSubview(phoneLabel)
        phoneLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                      views: [phoneIcon])
        phoneLabel.addConstraintForCenterAligning(to: phoneIcon,
                                                       in: .vertical)
        
        locationIcon = UIImageView.init(image: R.image.icon_pin())
        locationIcon.tintColor = KPColorPalette.KPMainColor.mainColor
        addSubview(locationIcon)
        locationIcon.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(20)]",
                                                      "H:|-16-[$self(20)]"],
                                      views: [phoneIcon])
        
        locationLabel = KPLayerLabel()
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1
        addSubview(locationLabel)
        locationLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                          views: [locationIcon])
        locationLabel.addConstraintForCenterAligning(to: locationIcon,
                                                          in: .vertical)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
