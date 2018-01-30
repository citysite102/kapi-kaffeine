//
//  KPSearchViewDefaultCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchViewDefaultCell: UITableViewCell {

    var starIcon: UIImageView!
    
    lazy var shopNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level2
        return label
    }()
    
    lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = KPColorPalette.KPMainColor_v2.starColor
        label.text = "4.0"
        return label
    }()
    
    lazy var distanceNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level3
        label.text = "距離"
        return label
    }()
    
//    lazy var distanceLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16.0)
//        label.textColor = KPColorPalette.KPTextColor.mainColor
//        label.text = "840m"
//        return label
//    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(shopNameLabel)
        shopNameLabel.addConstraints(fromStringArray: ["H:|-16-[$self(<=240)]"])
        shopNameLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        starIcon = UIImageView(image: R.image.icon_star_filled())
        starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
        addSubview(starIcon)
        starIcon.addConstraints(fromStringArray: ["H:[$self(20)]-16-|",
                                                  "V:[$self(20)]"])
        starIcon.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        addSubview(rateLabel)
        rateLabel.addConstraints(fromStringArray: ["H:[$self]-4-[$view0]"],
                                views: [starIcon])
        rateLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
//        addSubview(distanceLabel)
//        distanceLabel.addConstraints(fromStringArray: ["H:[$self]-16-|"])
//        distanceLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
//
//        addSubview(distanceNameLabel)
//        distanceNameLabel.addConstraints(fromStringArray: ["H:[$self]-4-[$view0]"],
//                                         views:[distanceLabel])
//        distanceNameLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        let separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|-16-[$self]|"])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
