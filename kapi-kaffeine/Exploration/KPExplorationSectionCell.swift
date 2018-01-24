//
//  KPExplorationSectionCell.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 22/11/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPExplorationSectionCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var regionLabel: UILabel!
    var nameLabel: UILabel!
    var rateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 2
        contentView.backgroundColor = UIColor.white
        
        imageView = UIImageView()
        imageView.layer.shouldRasterize = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self]"])
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                   attribute: NSLayoutAttribute.height,
                                                   relatedBy: NSLayoutRelation.equal,
                                                   toItem: imageView,
                                                   attribute: NSLayoutAttribute.width,
                                                   multiplier: 0.9,
                                                   constant: 0))

        nameLabel = UILabel()
        contentView.addSubview(nameLabel)
        nameLabel.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:[$view0]-(>=4)-[$self]"],
                                 views: [imageView])
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        nameLabel.text = "老木咖啡"
        
        regionLabel = UILabel()
        contentView.addSubview(regionLabel)
        regionLabel.addConstraints(fromStringArray: ["H:|[$self]|",
                                                     "V:[$view0]-4-[$self]"],
                                   views: [nameLabel])
        regionLabel.font = UIFont.systemFont(ofSize: 12)
        regionLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        regionLabel.text = "台北市, 大安區"
        
        rateLabel = UILabel()
        contentView.addSubview(rateLabel)
        rateLabel.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:[$view0]-4-[$self]|"],
                                   views: [regionLabel])
        rateLabel.font = UIFont.systemFont(ofSize: 12)
        rateLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        rateLabel.text = "4.8"
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
