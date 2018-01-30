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
    var starIcon: UIImageView!
    var scoreLabel: UILabel!
    var visitedLabel: UILabel!
    
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
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
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
        rateLabel.addConstraints(fromStringArray: ["H:|[$self]",
                                                   "V:[$view0]-5-[$self]|"],
                                   views: [regionLabel])
        rateLabel.font = UIFont.boldSystemFont(ofSize: 12)
        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        rateLabel.text = "4.8"
        
        starIcon = UIImageView(image: R.image.icon_star_filled())
        starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
        contentView.addSubview(starIcon)
        starIcon.addConstraints(fromStringArray: ["H:[$view0]-2-[$self(12)]",
                                                  "V:[$self(12)]"],
                                views:[rateLabel])
        starIcon.addConstraintForCenterAligning(to: rateLabel,
                                                in: .vertical)
        
        visitedLabel = UILabel()
        contentView.addSubview(visitedLabel)
        visitedLabel.addConstraints(fromStringArray: ["H:[$self]|"])
        visitedLabel.addConstraintForCenterAligning(to: rateLabel,
                                                    in: .vertical)
        visitedLabel.font = UIFont.systemFont(ofSize: 12)
        visitedLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        visitedLabel.text = "132人已去過"

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
