//
//  KPInformationCardView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/2/9.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationCardView: UIView {

    var container: UIView!
    var locationInfoLabel: UILabel!
    var titleInfoLabel: UILabel!
    
    var bottomContainer: UIView!
    var starIcon: UIImageView!
    var rateLabel: KPLayerLabel!
    var businessInfoLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = KPColorPalette.KPMainColor_v2.shadow_darkColor?.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        
        container = UIView()
        container.layer.cornerRadius = 2.0
        container.layer.masksToBounds = true
        addSubview(container)
        container.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        container.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:|[$self]|"])
        
        titleInfoLabel = UILabel()
        titleInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.header)
        titleInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        titleInfoLabel.text = "西雅圖極品咖啡 台大店"
        container.addSubview(titleInfoLabel)
        titleInfoLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        titleInfoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        locationInfoLabel = UILabel()
        locationInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        locationInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        locationInfoLabel.text = "台北 大安區"
        container.addSubview(locationInfoLabel)
        locationInfoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        locationInfoLabel.addConstraints(fromStringArray: ["V:[$self]-10-[$view0]"],
                                         views: [titleInfoLabel])
        
        bottomContainer = UIView()
        container.addSubview(bottomContainer)
        bottomContainer.addConstraintForCenterAligningToSuperview(in: .horizontal)
        bottomContainer.addConstraints(fromStringArray: ["V:[$view0]-10-[$self]"],
                                       views: [titleInfoLabel])
        
        starIcon = UIImageView(image: R.image.icon_star_filled())
        starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
        bottomContainer.addSubview(starIcon)
        starIcon.addConstraints(fromStringArray: ["H:|[$self(18)]",
                                                  "V:|[$self(18)]|"])
        
        rateLabel = KPLayerLabel()
        rateLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        rateLabel.text = "4.8"
        rateLabel.isOpaque = true
        rateLabel.layer.masksToBounds = true
        bottomContainer.addSubview(rateLabel)
        rateLabel.addConstraints(fromStringArray: ["H:[$view0]-3-[$self]"],
                                 views: [starIcon])
        rateLabel.addConstraintForCenterAligning(to: starIcon,
                                                 in: .vertical,
                                                 constant: 0)
        
        
        businessInfoLabel = UILabel()
        businessInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        businessInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        businessInfoLabel.text = "平日：12:00 - 19:30"
        bottomContainer.addSubview(businessInfoLabel)
        businessInfoLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]|"],
                                         views: [rateLabel])
        businessInfoLabel.addConstraintForCenterAligning(to: starIcon,
                                                         in: .vertical,
                                                         constant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
