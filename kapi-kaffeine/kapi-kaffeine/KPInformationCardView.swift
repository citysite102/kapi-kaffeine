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
    
    var userContainer: UIView!
    var userProfileImages: [UIImage]! = [R.image.demo_p1()!,
                                         R.image.demo_p2()!,
                                         R.image.demo_p3()!,
                                         R.image.demo_p4()!,
                                         R.image.demo_p5()!]
    var userProfileImageViews: [UIView]!
    var userVisitedLabel: UILabel!
    
    
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
        titleInfoLabel.addConstraints(fromStringArray: ["V:|-($metric0)-[$self]",
                                                        "H:|-16-[$self]-16-|"],
                                      metrics:[KPLayoutConstant.information_horizontal_offset])
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
                starIcon.addConstraints(fromStringArray: ["H:[$view0]-6-[$self(18)]",
                                                          "V:|[$self(18)]|"],
                                        views:[starIcons[index-1]])
            }
        }
        
        rateLabel = KPLayerLabel()
        rateLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
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
        locationInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        locationInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        locationInfoLabel.text = "台北 大安區"
        container.addSubview(locationInfoLabel)
        locationInfoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        locationInfoLabel.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]"],
                                         views: [rateLabel])
        
        

        businessInfoLabel = UILabel()
        businessInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        businessInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        businessInfoLabel.text = "營業時間：平日：12:00 - 19:30"
        container.addSubview(businessInfoLabel)
        businessInfoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        businessInfoLabel.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                         views: [locationInfoLabel])
        
        
        userContainer = UIView()
        container.addSubview(userContainer)
        userContainer.addConstraintForCenterAligningToSuperview(in: .horizontal)
        userContainer.addConstraints(fromStringArray: ["V:[$view0]-24-[$self]-($metric0)-|"],
                                     metrics:[KPLayoutConstant.information_horizontal_offset],
                                     views: [businessInfoLabel])
        
        userProfileImageViews = [UIView]()
        
        for index in 0...4 {
            
            let sampleContainer = UIView()
            sampleContainer.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
            sampleContainer.layer.cornerRadius = 26
            sampleContainer.layer.masksToBounds = true
            userContainer.addSubview(sampleContainer)
            userProfileImageViews.append(sampleContainer)
            
            if index == 0 {
                sampleContainer.addConstraints(fromStringArray: ["V:|[$self(52)]",
                                                                 "H:|[$self(52)]"])
            } else if index == 4 {
                sampleContainer.addConstraints(fromStringArray: ["V:|[$self(52)]",
                                                                 "H:[$view0]-(-16)-[$self(52)]|"],
                                               views:[userProfileImageViews[index-1]])
            } else {
                sampleContainer.addConstraints(fromStringArray: ["V:|[$self(52)]",
                                                                 "H:[$view0]-(-16)-[$self(52)]"],
                                               views:[userProfileImageViews[index-1]])
            }
            
            
            let sampleImageView = UIImageView(image: userProfileImages[index])
            sampleContainer.addSubview(sampleImageView)
            sampleImageView.layer.cornerRadius = 24.0
            sampleImageView.contentMode = .scaleAspectFill
            sampleImageView.clipsToBounds = true
            sampleImageView.addConstraints(fromStringArray: ["V:|-2-[$self]-2-|",
                                                             "H:|-2-[$self]-2-|"])
        }
        
        userVisitedLabel = UILabel()
        userVisitedLabel.font = UIFont.systemFont(ofSize: 12)
        userVisitedLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        userVisitedLabel.text = "24 人已打卡"
        userContainer.addSubview(userVisitedLabel)
        userVisitedLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        userVisitedLabel.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]|"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                         views: [userProfileImageViews[0]])
        
        
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
