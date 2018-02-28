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
    var locationIcon: UIImageView!
    var locationInfoLabel: UILabel!
    var titleInfoLabel: UILabel!
    
    var rateContainer: UIView!
    var starIcons: [UIImageView]!
    var rateLabel: KPLayerLabel!
    var businessInfoIcon: UIImageView!
    var businessInfoLabel: UILabel!
    
    var separator: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
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
        titleInfoLabel.textAlignment = .center
        titleInfoLabel.numberOfLines = 0
        container.addSubview(titleInfoLabel)
        titleInfoLabel.addConstraints(fromStringArray: ["V:|-22-[$self]",
                                                        "H:|-16-[$self]-16-|"])
        titleInfoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        rateContainer = UIView()
        container.addSubview(rateContainer)
        rateContainer.addConstraintForCenterAligningToSuperview(in: .horizontal)
        rateContainer.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]"],
                                     views: [titleInfoLabel])
        
        starIcons = [UIImageView]()
        
        for index in 0...4 {
            let starIcon = UIImageView(image: R.image.icon_star_filled())
            starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
            starIcons.append(starIcon)
            rateContainer.addSubview(starIcon)
            
            if index == 0 {
                starIcon.addConstraints(fromStringArray: ["H:|[$self(18)]",
                                                          "V:|[$self(18)]|"])
            } else {
                starIcon.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(18)]",
                                                          "V:|[$self(18)]|"],
                                        views:[starIcons[index-1]])
            }
        }
        
        rateLabel = KPLayerLabel()
        rateLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        rateLabel.text = "4.8"
        rateLabel.isOpaque = true
        rateLabel.layer.masksToBounds = true
        rateContainer.addSubview(rateLabel)
        rateLabel.addConstraints(fromStringArray: ["H:[$view0]-6-[$self]|"],
                                 views: [starIcons[4]])
        rateLabel.addConstraintForCenterAligning(to: starIcons[4],
                                                 in: .vertical,
                                                 constant: 0)
        
        
        locationInfoLabel = UILabel()
        locationInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        locationInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        locationInfoLabel.text = "台北 大安區"
        container.addSubview(locationInfoLabel)
        locationInfoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        locationInfoLabel.addConstraints(fromStringArray: ["V:[$view0]-10-[$self]"],
                                         views: [rateLabel])
        
        

        businessInfoLabel = UILabel()
        businessInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        businessInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        businessInfoLabel.text = "營業時間：平日：12:00 - 19:30"
        container.addSubview(businessInfoLabel)
        businessInfoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        businessInfoLabel.addConstraints(fromStringArray: ["V:[$view0]-10-[$self]"],
                                         views: [locationInfoLabel])
        
//        separator = UIView()
//        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
//        container.addSubview(separator)
//        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
//                                                   "H:|-($metric0)-[$self]-($metric0)-|"],
//                                 metrics:[KPLayoutConstant.information_horizontal_offset])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
