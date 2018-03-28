//
//  KPInputRecommendCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInputRecommendCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level1
        label.text = "老木咖啡"
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level4
        label.text = "台北市大安區忠孝東路20號102樓"
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.icon_pin())
        imageView.tintColor = KPColorPalette.KPTextColor.grayColor_level5
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        iconImageView.addConstraints(fromStringArray: ["|-20-[$self]"])
        iconImageView.addConstraintForCenterAligningToSuperview(in: .vertical)
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        contentView.addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["H:[$view0]-[$self]-|", "V:|-20-[$self]"],
                                  views: [iconImageView])
//        titleLabel.addConstraints(fromStringArray: ["H:|-16-[$self(<=180)]"])
//        titleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        contentView.addSubview(addressLabel)
        addressLabel.addConstraints(fromStringArray: ["H:[$view0]-[$self]-|", "V:[$view1]-4-[$self]"],
                                    views: [iconImageView, titleLabel])
//        addressLabel.addConstraints(fromStringArray: ["H:[$self(<=140)]-16-|"])
//        addressLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        let separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        contentView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$view0]-20-[$self(1)]|",
                                                   "H:|-16-[$self]|"],
                                 views: [addressLabel])
        
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
    }

}
