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

    init(detailDataModel: KPDetailedDataModel) {
        let textRect = NSString(string: detailDataModel.name).boundingRect(with: CGSize(width: 300, height: 38),
                                                                     options: .usesFontLeading,
                                                                     attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.sub_header)],
                                                                     context: nil)
        
        let commentRect = NSString(string: "\(String(describing: detailDataModel.commentCount ?? 0)) 則評論").boundingRect(with: CGSize(width: 300,
                                                                                    height: 38),
                                                                       options: .usesFontLeading,
                                                                       attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.infoContent)],
                                                                       context: nil)
        
        let priceRect = NSString(string:
            KPMainMapMarkerInfoWindow.priceContent(detailDataModel.priceAverage)).boundingRect(with:
                CGSize(width: 300,
                       height: 38),
                                                                          options: .usesFontLeading,
                                                                          attributes:   [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.infoContent)],
                                                                          context: nil)
        
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: commentRect.width + priceRect.width + 36 > textRect.width ?
                                    commentRect.width + priceRect.width + 72 :
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
        titleLabel.text = detailDataModel.name
        
        let starImageView = UIImageView(image: R.image.icon_star_filled())
        starImageView.tintColor = KPColorPalette.KPMainColor_v2.starColor
        starImageView.contentMode = .scaleAspectFit
        
        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.boldSystemFont(ofSize: KPFontSize.subContent)
        scoreLabel.text = String(format: "%.1f", detailDataModel.averageRate?.doubleValue ?? 0.0)
        scoreLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        
        let commentIcon = UIImageView(image: R.image.icon_comment_border())
        commentIcon.contentMode = .scaleAspectFit
        commentIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_description
        
        let commentLabel = UILabel()
        commentLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        commentLabel.text = "\(String(describing: detailDataModel.commentCount ?? 0)) 則評論"
        commentLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        
        priceLabel.text = KPMainMapMarkerInfoWindow.priceContent(detailDataModel.priceAverage)
        priceLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        
        let mapArrow = UIImageView(image: R.image.map_arrow())
        mapArrow.contentMode = .scaleAspectFit
        
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(commentIcon)
        self.containerView.addSubview(commentLabel)
        self.containerView.addSubview(priceLabel)
        self.contentView.addSubview(mapArrow)
        
        titleLabel.addConstraints(fromStringArray: ["V:|-10-[$self]",
                                                    "H:|-12-[$self]-12-|"])
        commentIcon.addConstraints(fromStringArray: ["V:[$self(18)]-9-|",
                                                     "H:|-13-[$self(18)]"])
        commentLabel.addConstraints(fromStringArray: ["V:[$self]-10-|",
                                                      "H:|-36-[$self]"])
        priceLabel.addConstraints(fromStringArray: ["V:[$self]-10-|",
                                                    "H:[$view0]-12-[$self]"],
                                  views:[commentLabel])
        mapArrow.addConstraints(fromStringArray: ["V:[$self(8)]-(-8)-|",
                                                  "H:[$self(14)]"])
        mapArrow.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
    }
    
    init(dataModel: KPDataModel) {
        
        let textRect = NSString(string: dataModel.name).boundingRect(with: CGSize(width: 300, height: 38),
                                                                     options: .usesFontLeading,
                                                                     attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.sub_header)],
                                                                     context: nil)
        
        let commentRect = NSString(string: "\(String(describing: dataModel.commentCount ?? 0)) 則評論").boundingRect(with: CGSize(width: 300,
                                                                                     height: 38),
                                                                        options: .usesFontLeading,
                                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.infoContent)],
                                                                        context: nil)
        
        let priceRect = NSString(string: KPMainMapMarkerInfoWindow.priceContent(dataModel.priceAverage)).boundingRect(with: CGSize(width: 300,
                                                                                   height: 38),
                                                                      options: .usesFontLeading,
                                                                      attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.infoContent)],
                                                                      context: nil)
 
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: commentRect.width + priceRect.width + 36 > textRect.width ?
                                    commentRect.width + priceRect.width + 72 :
                                    textRect.width + 36,
                                 height: 84))
        
        contentView = UIView(frame: CGRect(x: 6,
                                           y: 6,
                                           width: frame.size.width-12,
                                           height: frame.size.height-20))

        contentView.layer.shadowColor = UIColor.black.cgColor;
        contentView.layer.shadowOpacity = 0.3;
        contentView.layer.shadowRadius = 3.0;
        contentView.layer.shadowOffset = CGSize.init(width: 0, height: 4.0);
        
        addSubview(contentView)
        containerView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: frame.size.width-12,
                                             height: frame.size.height-20))
        containerView.backgroundColor = UIColor.white
//        containerView.layer.cornerRadius = 3
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
        
        let commentIcon = UIImageView(image: R.image.icon_comment_border())
        commentIcon.contentMode = .scaleAspectFit
        commentIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_description
        
        let commentLabel = UILabel()
        commentLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        commentLabel.text = "\(String(describing: dataModel.commentCount ?? 0)) 則評論"
        commentLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        priceLabel.text = KPMainMapMarkerInfoWindow.priceContent(dataModel.priceAverage)
        priceLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        
        let mapArrow = UIImageView(image: R.image.map_arrow())
        mapArrow.contentMode = .scaleAspectFit
        
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(commentIcon)
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
        commentIcon.addConstraints(fromStringArray: ["V:[$self(18)]-9-|",
                                                     "H:|-13-[$self(18)]"])
        commentLabel.addConstraints(fromStringArray: ["V:[$self]-10-|",
                                                      "H:|-36-[$self]"])
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
        
    }
    
    static func priceContent(_ priveAverage: NSNumber? = -1) -> String {
        
        if priveAverage == 0 {
            return "$ 1-100"
        } else if priveAverage == 1 {
            return "$$ 101-200"
        } else if priveAverage == 2 {
            return "$$$ 200 以上"
        } else {
            return "價格未知"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
