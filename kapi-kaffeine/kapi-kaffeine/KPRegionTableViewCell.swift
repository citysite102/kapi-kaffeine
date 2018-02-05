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
    var separator: UIView!
    var shouldShowSeparator: Bool! = true {
        didSet {
            self.separator.isHidden = !shouldShowSeparator
        }
    }
    private var expanded: Bool!

    func setExpanded(_ expanded: Bool, _ animated: Bool) {
        self.expanded = expanded
        if animated {
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
        } else {
            if expanded {
                self.expandIcon.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                self.expandIcon.transform = CGAffineTransform.identity
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
        regionIcon.addConstraints(fromStringArray: ["V:|-20-[$self(24)]-20-|",
                                                    "H:|-18-[$self(24)]"])
        
        regionLabel = UILabel()
        regionLabel.font = UIFont.systemFont(ofSize: 16)
        regionLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        regionLabel.layer.masksToBounds = true
        addSubview(regionLabel)
        regionLabel.addConstraints(fromStringArray: ["H:[$view0]-24-[$self]"],
                                        views: [regionIcon])
        regionLabel.addConstraintForCenterAligning(to: regionIcon, in: .vertical)
        
        expandIcon = UIImageView(image: R.image.icon_down())
        expandIcon.tintColor = KPColorPalette.KPMainColor_v2.mainColor_light
        addSubview(expandIcon)
        expandIcon.addConstraints(fromStringArray: ["V:|-20-[$self(24)]-20-|",
                                                    "H:[$self(24)]-16-|"])
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        contentView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|-16-[$self]-16-|"])
        
        expanded = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
//        backgroundColor = highlighted ?
//            KPColorPalette.KPBackgroundColor.mainColor_light_10 :
//            UIColor.white
    }
}
