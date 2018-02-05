//
//  KPSearchViewRecentCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchViewRecentCell: UITableViewCell {

    
    var recentIcon: UIImageView!
    
    lazy var shopNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPMainColor_v2.mainColor
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        recentIcon = UIImageView.init(image: R.image.icon_recent()!)
        recentIcon.tintColor = KPColorPalette.KPMainColor_v2.mainColor_light
        addSubview(recentIcon)
        recentIcon.addConstraints(fromStringArray: ["H:|-16-[$self(28)]",
                                                    "V:[$self(28)]"],
                                    views: [shopNameLabel])
        recentIcon.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        addSubview(shopNameLabel)
        shopNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]-16-|"],
                                     views:[recentIcon])
        shopNameLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        let separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
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
