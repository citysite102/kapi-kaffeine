//
//  KPRegionTableViewCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/21.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPRegionTableViewCell: UITableViewCell {

    var regionIcon: UIImageView!
    var regionLabel: UILabel!
    var expandIcon: UIImageView!
    var expanded: Bool! {
        didSet {
            if expanded {
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: .curveEaseIn,
                               animations: {
                                self.expandIcon.transform = CGAffineTransform(rotationAngle: .pi)
                }, completion: { (_) in
                    
                })
            } else {
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: .curveEaseIn,
                               animations: {
                                self.expandIcon.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        regionIcon = UIImageView(image: R.image.icon_taipei())
        regionIcon.tintColor = KPColorPalette.KPMainColor.mainColor_light
        regionIcon.isOpaque = true
        addSubview(regionIcon)
        regionIcon.addConstraints(fromStringArray: ["V:|-12-[$self(24)]-12-|",
                                                         "H:|-16-[$self(24)]"])
        
        regionLabel = UILabel()
        regionLabel.font = UIFont.systemFont(ofSize: 14)
        regionLabel.textColor = KPColorPalette.KPTextColor.grayColor
        regionLabel.isOpaque = true
        regionLabel.backgroundColor = UIColor.white
        regionLabel.layer.masksToBounds = true
        addSubview(regionLabel)
        regionLabel.addConstraints(fromStringArray: ["H:[$view0]-32-[$self]"],
                                        views: [regionIcon])
        regionLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        expandIcon = UIImageView(image: R.image.icon_down())
        expandIcon.tintColor = KPColorPalette.KPMainColor.mainColor
        addSubview(expandIcon)
        expandIcon.addConstraints(fromStringArray: ["V:|-12-[$self(24)]-12-|",
                                                         "H:[$self(24)]-16-|"])
        
        expanded = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
