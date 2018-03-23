//
//  KPMainMapMarkerInfoWindow.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 11/04/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPMainMapMarkerInfoWindow: UIView {
    
    var contentView: UIView!
    var containerView: UIView!

    init(dataModel: KPDataModel) {
        
        let textRect = NSString(string: dataModel.name).boundingRect(with: CGSize(width: 300, height: 38),
                                                                     options: .usesFontLeading,
                                                                     attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.sub_header)],
                                                                     context: nil)
        
        let commentRect = NSString(string: "3 則評論").boundingRect(with: CGSize(width: 300,
                                                                                     height: 38),
                                                                        options: .usesFontLeading,
                                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.infoContent)],
                                                                        context: nil)
        
        let priceRect = NSString(string: "$$$ 100-200").boundingRect(with: CGSize(width: 300,
                                                                                   height: 38),
                                                                      options: .usesFontLeading,
                                                                      attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.infoContent)],
                                                                      context: nil)
 
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: commentRect.width + priceRect.width + 12 > textRect.width ?
                                    commentRect.width + priceRect.width + 48 :
                                    textRect.width + 36,
                                 height: 84))
        
        contentView = UIView(frame: CGRect(x: 6,
                                           y: 6,
                                           width: frame.size.width-12,
                                           height: frame.size.height-20))

        contentView.layer.shadowColor = UIColor.black.cgColor;
        contentView.layer.shadowOpacity = 0.4;
        contentView.layer.shadowRadius = 3.0;
        contentView.layer.shadowOffset = CGSize.init(width: 0, height: 2.0);
        
        addSubview(contentView)

//        let imageView = UIImageView(image: R.image.icon_coffee_cup())
//        imageView.contentMode = .scaleAspectFit
        
        
        containerView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: frame.size.width-12,
                                             height: frame.size.height-20))
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 3
        containerView.layer.masksToBounds = true
        
        contentView.addSubview(containerView)
        
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: KPFontSize.sub_header)
        titleLabel.text = dataModel.name
        
        let starImageView = UIImageView(image: R.image.icon_star_filled())
        starImageView.tintColor = KPColorPalette.KPMainColor_v2.starColor
        starImageView.contentMode = .scaleAspectFit

        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.boldSystemFont(ofSize: KPFontSize.subContent)
        scoreLabel.text = String(format: "%.1f", dataModel.averageRate?.doubleValue ?? 0.0)
        scoreLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        
        let commentLabel = UILabel()
        commentLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        commentLabel.text = "3 則評論"
        commentLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        priceLabel.text = "$$$ 100-200"
        priceLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        
        let mapArrow = UIImageView(image: R.image.map_arrow())
        mapArrow.contentMode = .scaleAspectFit
        
//        self.contentView.addSubview(imageView)
        self.containerView.addSubview(titleLabel)
//        self.contentView.addSubview(starImageView)
//        self.contentView.addSubview(scoreLabel)
        self.containerView.addSubview(commentLabel)
        self.containerView.addSubview(priceLabel)
        self.contentView.addSubview(mapArrow)
    
        
//        imageView.addConstraints(fromStringArray: ["H:|-10-[$self(24)]-4-[$view0]-8-|",
//                                                   "V:|-6-[$self(24)]"],
//                                 views: [titleLabel])
//        titleLabel.addConstraintForCenterAligning(to: imageView,
//                                                  in: .vertical)
        titleLabel.addConstraints(fromStringArray: ["V:|-10-[$self]",
                                                    "H:|-12-[$self]-12-|"])
        commentLabel.addConstraints(fromStringArray: ["V:[$self]-10-|",
                                                      "H:|-12-[$self]"])
        priceLabel.addConstraints(fromStringArray: ["V:[$self]-10-|",
                                                    "H:[$view0]-12-[$self]"],
                                  views:[commentLabel])
        
        
//        imageView.addConstraints(fromStringArray: ["H:|-6-[$self(32)][$view0]-12-[$view1]-4-[$view2(20)]-12-|",
//                                                   "V:[$self(20)]",
//                                                   "V:|[$view0]|",
//                                                   "V:|[$view1]|",
//                                                   "V:[$view2(32)]"],
//                                 views: [titleLabel, scoreLabel, starImageView])
        mapArrow.addConstraints(fromStringArray: ["V:[$self(8)]-(-8)-|",
                                                  "H:[$self(14)]"])
        mapArrow.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        
        NSLayoutConstraint.activate([
//            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            starImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
//        scoreLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
//        titleLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
