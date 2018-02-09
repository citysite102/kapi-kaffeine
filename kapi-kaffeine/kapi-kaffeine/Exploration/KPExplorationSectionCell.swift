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
    var gradientView: UIView!
    var imageMaskLayer: CAGradientLayer?
    var collectButton: KPBounceButton!
    
    var regionLabel: UILabel!
    var nameLabel: UILabel!
    var rateLabel: UILabel!
    var rateCountLabel: UILabel!
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
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self]"])
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                   attribute: NSLayoutAttribute.height,
                                                   relatedBy: NSLayoutRelation.equal,
                                                   toItem: imageView,
                                                   attribute: NSLayoutAttribute.width,
                                                   multiplier: 0.8,
                                                   constant: 0))
        
        
        gradientView = UIView()
        imageView.addSubview(gradientView)
        gradientView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                      "H:|[$self]|"])
        
        collectButton = KPBounceButton(frame: CGRect.zero,
                                       image: R.image.icon_collect_border()!)
        collectButton.tintColor = KPColorPalette.KPBackgroundColor.whiteColor
        imageView.addSubview(collectButton)
        collectButton.addConstraints(fromStringArray: ["V:|-4-[$self(24)]",
                                                       "H:[$self(24)]-4-|"])

        nameLabel = UILabel()
        contentView.addSubview(nameLabel)
        nameLabel.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:[$view0]-(>=6)-[$self]"],
                                 views: [imageView])
        nameLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        nameLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        nameLabel.text = "老木咖啡"
        
        regionLabel = UILabel()
        contentView.addSubview(regionLabel)
        regionLabel.addConstraints(fromStringArray: ["H:|[$self]|",
                                                     "V:[$view0]-5-[$self]"],
                                   views: [nameLabel])
        regionLabel.font = UIFont.systemFont(ofSize: 11)
        regionLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor_light
        regionLabel.text = "台北市, 大安區"

        
        starIcon = UIImageView(image: R.image.icon_star_filled())
        starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
        contentView.addSubview(starIcon)
        starIcon.addConstraints(fromStringArray: ["H:|[$self(13)]",
                                                  "V:[$view0]-7-[$self(13)]"],
                                views: [regionLabel])
        
        rateLabel = UILabel()
        contentView.addSubview(rateLabel)
        rateLabel.addConstraints(fromStringArray: ["H:[$view0]-2-[$self]"],
                                 views: [starIcon])
        rateLabel.font = UIFont.boldSystemFont(ofSize: 11)
        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        rateLabel.text = "4.8"
        rateLabel.addConstraintForCenterAligning(to: starIcon,
                                                 in: .vertical)
        
        rateCountLabel = UILabel()
        contentView.addSubview(rateCountLabel)
        rateCountLabel.addConstraints(fromStringArray: ["H:[$view0]-2-[$self]"],
                                      views: [rateLabel])
        rateCountLabel.font = UIFont.systemFont(ofSize: 11)
        rateCountLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_hint
        rateCountLabel.text = "(24)"
        rateCountLabel.addConstraintForCenterAligning(to: starIcon,
                                                      in: .vertical)
        
//        rateLabel = UILabel()
//        contentView.addSubview(rateLabel)
//        rateLabel.addConstraints(fromStringArray: ["H:|[$self]",
//                                                   "V:[$view0]-6-[$self]|"],
//                                   views: [regionLabel])
//        rateLabel.font = UIFont.boldSystemFont(ofSize: 11)
//        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
//        rateLabel.text = "4.8(24)"
//
//        starIcon = UIImageView(image: R.image.icon_star_filled())
//        starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
//        contentView.addSubview(starIcon)
//        starIcon.addConstraints(fromStringArray: ["H:[$view0]-2-[$self(13)]",
//                                                  "V:[$self(13)]"],
//                                views:[rateLabel])
//        starIcon.addConstraintForCenterAligning(to: rateLabel,
//                                                in: .vertical)
        
//        visitedLabel = UILabel()
//        contentView.addSubview(visitedLabel)
//        visitedLabel.addConstraints(fromStringArray: ["H:[$self]|"])
//        visitedLabel.addConstraintForCenterAligning(to: rateLabel,
//                                                    in: .vertical)
//        visitedLabel.font = UIFont.systemFont(ofSize: 12)
//        visitedLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
//        visitedLabel.text = "132人已去過"

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageMaskLayer == nil && gradientView.frameSize.width != 0 {
            imageMaskLayer = CAGradientLayer()
            imageMaskLayer!.opacity = 0.5
            imageMaskLayer!.frame = CGRect(x: 0, y: 0,
                                           width: imageView.frame.width,
                                           height: imageView.frame.height)
            imageMaskLayer!.colors = [UIColor.init(r: 0, g: 0, b: 0, a: 0.7).cgColor,
                                     UIColor.init(r: 0, g: 0, b: 0, a: 0.0).cgColor]
            imageMaskLayer!.startPoint = CGPoint(x: 1.0, y: 0.0)
            imageMaskLayer!.endPoint = CGPoint(x: 0.3, y: 0.7)
            gradientView.layer.addSublayer(imageMaskLayer!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
