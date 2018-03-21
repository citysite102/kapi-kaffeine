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

    init(dataModel: KPDataModel) {
        
        let textRect = NSString(string: dataModel.name).boundingRect(with: CGSize(width: 300, height: 38),
                                                                     options: .usesFontLeading,
                                                                     attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.mainContent)],
                                                                     context: nil)
        
        let commentRect = NSString(string: "3 則評論").boundingRect(with: CGSize(width: 300,
                                                                                     height: 38),
                                                                        options: .usesFontLeading,
                                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.subContent)],
                                                                        context: nil)
        
        let priceRect = NSString(string: "$$$ 100-200").boundingRect(with: CGSize(width: 300,
                                                                                   height: 38),
                                                                      options: .usesFontLeading,
                                                                      attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.subContent)],
                                                                      context: nil)
        
//        let scoreRect = NSString(string: "\(dataModel.averageRate ?? 0)").boundingRect(with: CGSize(width: 200, height: 38),
//                                                                     options: .usesFontLeading,
//                                                                     attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)],
//                                                                     context: nil)
        
//        super.init(frame: CGRect(x: 0, y: 0,
//                                 width: textRect.width + scoreRect.width + 84 ,
//                                 height: 48))

        super.init(frame: CGRect(x: 0, y: 0,
                                 width: commentRect.width + priceRect.width + 12 > textRect.width ?
                                    commentRect.width + priceRect.width + 36 :
                                    textRect.width + 24,
                                 height: 76))
        
        contentView = UIView(frame: CGRect(x: 0,
                                           y: 0,
                                           width: frame.size.width,
                                           height: frame.size.height-10))
        contentView.backgroundColor = UIColor.white
        
//        contentView.layer.borderWidth = 1
//        contentView.layer.cornerRadius = 3
        contentView.layer.borderColor = KPColorPalette.KPBackgroundColor.grayColor_level5?.cgColor
        
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowOpacity = 0.4;
        layer.shadowRadius = 4.0;
        layer.shadowOffset = CGSize.init(width: 0, height: 2.0);
        
        addSubview(contentView)

//        let imageView = UIImageView(image: R.image.icon_coffee_cup())
//        imageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: KPFontSize.mainContent)
        titleLabel.text = dataModel.name
        
        let starImageView = UIImageView(image: R.image.icon_star_filled())
        starImageView.tintColor = KPColorPalette.KPMainColor_v2.starColor
        starImageView.contentMode = .scaleAspectFit

        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.boldSystemFont(ofSize: KPFontSize.subContent)
        scoreLabel.text = String(format: "%.1f", dataModel.averageRate?.doubleValue ?? 0.0)
        scoreLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        
        let commentLabel = UILabel()
        commentLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        commentLabel.text = "3 則評論"
        commentLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        priceLabel.text = "$$$ 100-200"
        priceLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        
        let mapArrow = UIImageView(image: R.image.map_arrow())
        mapArrow.contentMode = .scaleAspectFit
        
//        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
//        self.contentView.addSubview(starImageView)
//        self.contentView.addSubview(scoreLabel)
        self.contentView.addSubview(commentLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(mapArrow)
    
        
//        imageView.addConstraints(fromStringArray: ["H:|-10-[$self(24)]-4-[$view0]-8-|",
//                                                   "V:|-6-[$self(24)]"],
//                                 views: [titleLabel])
//        titleLabel.addConstraintForCenterAligning(to: imageView,
//                                                  in: .vertical)
        titleLabel.addConstraints(fromStringArray: ["V:|-12-[$self]",
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
