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
    var informationDataModel: KPDataModel!
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
                
                let featureView = UIView()
                
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
    var openLabel: UILabel!
    var otherTimeButton: UIButton!
    var phoneIcon: UIImageView!
    var phoneLabel: UITextView!
    var locationIcon: UIImageView!
    var locationLabel: UILabel!
    var priceIcon: UIImageView!
    var priceLabel: UILabel!
    
    let priceContents = ["NT$1-100元 / 人",
                         "NT$101-200元 / 人",
                         "NT$201-300元 / 人",
                         "NT$301-400元 / 人",
                         "大於NT$400元 / 人"]
    
    convenience init(_ informationDataModel: KPDataModel) {
        self.init(frame: .zero)
        
        self.informationDataModel = informationDataModel
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1
        titleLabel.alpha = 0
        addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["V:|-20-[$self]",
                                                    "H:|-16-[$self]"])
        
        if informationDataModel.featureContents.count > 0 {
            featureContainer = UIView()
            addSubview(featureContainer)
            featureContainer.addConstraints(fromStringArray: ["V:|-24-[$self]",
                                                              "H:|-16-[$self]"],
                                            views: [titleLabel])
            featureContents = informationDataModel.featureContents
            
            openTimeIcon = UIImageView(image: R.image.icon_tradehour())
            openTimeIcon.tintColor = KPColorPalette.KPMainColor_v2.textColor_level1
            addSubview(openTimeIcon)
            openTimeIcon.addConstraints(fromStringArray: ["V:|[$self(20)]",
                                                          "H:|-16-[$self(20)]"],
                                        views: [featureContainer])
        } else {
            openTimeIcon = UIImageView(image: R.image.icon_tradehour())
            openTimeIcon.tintColor = KPColorPalette.KPMainColor_v2.textColor_level1
            addSubview(openTimeIcon)
            openTimeIcon.addConstraints(fromStringArray: ["V:|[$self(20)]",
                                                          "H:|-16-[$self(20)]"],
                                        views: [titleLabel])
        }
        
        
        openLabel = UILabel()
        openLabel.font = UIFont.systemFont(ofSize: 14)
        openLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        addSubview(openLabel)
        openLabel.addConstraints(fromStringArray: ["H:[$view0]-5-[$self]"],
                                 views: [openTimeIcon, titleLabel])
        openLabel.addConstraintForCenterAligning(to: openTimeIcon, in: .vertical)
        
        openHint = UIView()
        openHint.layer.cornerRadius = 3.0
        openHint.backgroundColor = KPColorPalette.KPShopStatusColor.opened
        addSubview(openHint)
        openHint.addConstraints(fromStringArray: ["V:[$self(6)]",
                                                  "H:[$view0]-8-[$self(6)]"],
                                views: [openLabel])
        openHint.addConstraintForCenterAligning(to: openTimeIcon,
                                                in: .vertical)
        
        otherTimeButton = UIButton(type: .custom)
        otherTimeButton.tintColor = KPColorPalette.KPMainColor.mainColor
        otherTimeButton.setTitle("其他營業時間", for: .normal)
        otherTimeButton.setTitleColor(UIColor.white, for: .normal)
        otherTimeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        otherTimeButton.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
        otherTimeButton.layer.cornerRadius = 4.0
        addSubview(otherTimeButton)
        otherTimeButton.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(92)]-(>=16)-|",
                                                         "V:[$self(24)]"],
                                       views: [openLabel])
        otherTimeButton.addConstraintForCenterAligning(to: openLabel,
                                                       in: .vertical)
        
        priceIcon = UIImageView(image: R.image.icon_money_l())
        priceIcon.tintColor = KPColorPalette.KPMainColor_v2.textColor_level1
        addSubview(priceIcon)
        priceIcon.addConstraints(fromStringArray: ["V:[$self(20)]",
                                                   "H:|-16-[$self(20)]"],
                                 views: [openTimeIcon])
        
        priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = informationDataModel.address != nil ?
            KPColorPalette.KPTextColor_v2.mainColor_title :
            KPColorPalette.KPTextColor_v2.mainColor_subtitle
        addSubview(priceLabel)
        priceLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                    "V:[$view1]-16-[$self]"],
                                  views: [priceIcon, openLabel])
        priceIcon.addConstraintForCenterAligning(to: priceLabel,
                                                 in: .vertical)
        
        
        phoneIcon = UIImageView(image: R.image.icon_phone())
        phoneIcon.tintColor = KPColorPalette.KPMainColor_v2.textColor_level1
        addSubview(phoneIcon)
        phoneIcon.addConstraints(fromStringArray: ["V:[$self(20)]",
                                                   "H:|-16-[$self(20)]"],
                                 views: [priceIcon])
        
        phoneLabel = UITextView()
        phoneLabel.isEditable = false
        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        phoneLabel.dataDetectorTypes = .phoneNumber
        phoneLabel.textContainerInset = UIEdgeInsetsMake(1, 0, 0, 0)
        phoneLabel.textContainer.lineFragmentPadding = 0
        phoneLabel.textColor = informationDataModel.phone != nil ?
            KPColorPalette.KPTextColor_v2.mainColor_title :
            KPColorPalette.KPTextColor_v2.mainColor_subtitle
        addSubview(phoneLabel)
        phoneLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]-16-|",
                                                    "V:[$view1]-12-[$self(20)]"],
                                  views: [phoneIcon, priceLabel])
        phoneIcon.addConstraintForCenterAligning(to: phoneLabel,
                                                 in: .vertical)
        
        locationIcon = UIImageView(image: R.image.icon_pin())
        locationIcon.tintColor = KPColorPalette.KPMainColor_v2.textColor_level1
        addSubview(locationIcon)
        locationIcon.addConstraints(fromStringArray: ["V:[$self(20)]",
                                                      "H:|-16-[$self(20)]"],
                                    views: [phoneIcon])
        
        locationLabel = UILabel()
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.numberOfLines = 0
        locationLabel.textColor = informationDataModel.address != nil ?
            KPColorPalette.KPTextColor_v2.mainColor_title :
            KPColorPalette.KPTextColor_v2.mainColor_subtitle
        addSubview(locationLabel)
        locationLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]-20-|",
                                                       "V:[$view1]-12-[$self]-16-|"],
                                     views: [locationIcon,
                                             phoneLabel])
        locationIcon.addConstraintForCenterAligning(to: locationLabel,
                                                    in: .vertical)
        
        
        titleLabel.setText(text: informationDataModel.closed ?
            ("(已歇業) " + informationDataModel.name) :
            informationDataModel.name,
                           lineSpacing: 3.0)
        locationLabel.setText(text: informationDataModel.address ?? "暫無資料",
                              lineSpacing: 3.0)
        phoneLabel.text = informationDataModel.phone ?? "暫無資料"
        priceLabel.setText(text: priceContents[(informationDataModel.priceAverage?.intValue ?? 0) != -1 ? informationDataModel.priceAverage?.intValue ?? 0 : 0],
                           lineSpacing: 3.0)
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
