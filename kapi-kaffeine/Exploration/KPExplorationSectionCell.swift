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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 2
        contentView.backgroundColor = UIColor.white

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        
        imageView = UIImageView()
        imageView.layer.shouldRasterize = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]"])

        regionLabel = UILabel()
        contentView.addSubview(regionLabel)
        regionLabel.addConstraints(fromStringArray: ["H:|-[$self]", "V:[$view0]-[$self(12)]"],
                                   views: [imageView])
        regionLabel.font = UIFont.systemFont(ofSize: 11)
        regionLabel.textColor = UIColor(hexString: "979797")
        regionLabel.text = "台北市, 大安區"
        
        nameLabel = UILabel()
        contentView.addSubview(nameLabel)
        nameLabel.addConstraints(fromStringArray: ["H:|-[$self]", "V:[$view0]-4-[$self(18)]-|"],
                                views: [regionLabel])
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = UIColor(hexString: "585858")
        nameLabel.text = "老木咖啡"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
