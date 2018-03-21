//
//  KPArticleCell.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 21/11/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import Hero

class KPArticleCell: UICollectionViewCell {
    
    var articleHeroImageView: UIImageView!
    var gradientView: UIView!
    var imageMaskLayer: CAGradientLayer?
    var titleLabel: UILabel!
    var subLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 3
        contentView.layer.rasterizationScale = UIScreen.main.scale
        contentView.layer.shouldRasterize = true
        
        layer.shadowColor = KPColorPalette.KPMainColor_v2.shadow_darkColor?.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 8
        
        articleHeroImageView = UIImageView()
        articleHeroImageView.tag = 99
        articleHeroImageView.contentMode = .scaleAspectFill
        contentView.addSubview(articleHeroImageView)
        articleHeroImageView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:|[$self]|"])
        
        gradientView = UIView()
        gradientView.alpha = 0.0
        contentView.addSubview(gradientView)
        gradientView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                      "H:|[$self]|"])
        
        
        subLabel = UILabel()
        subLabel.font = UIFont.boldSystemFont(ofSize: 10)
        subLabel.textColor = UIColor.white
        subLabel.numberOfLines = 0
        subLabel.text = "1024 人已看過"
        contentView.addSubview(subLabel)
        subLabel.addConstraints(fromStringArray: ["H:|-10-[$self]-10-|",
                                                  "V:[$self]-10-|"])
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.setText(text: "倫敦，一座咖啡香四溢的城市",
                           lineSpacing: 3.0)
        contentView.addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["H:|-10-[$self]-10-|",
                                                    "V:[$self]-6-[$view0]"],
                                  views: [subLabel])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageMaskLayer == nil && articleHeroImageView.frameSize.width != 0 {
            imageMaskLayer = CAGradientLayer()
            imageMaskLayer!.frame = CGRect(x: 0, y: 0,
                                           width: articleHeroImageView.frameSize.width,
                                           height: articleHeroImageView.frameSize.height)
            imageMaskLayer!.colors = [UIColor.init(r: 0, g: 0, b: 0, a: 0.0).cgColor,
                                      UIColor.init(r: 0, g: 0, b: 0, a: 0.9).cgColor]
            imageMaskLayer!.startPoint = CGPoint(x: 0.5, y: 0.2)
            imageMaskLayer!.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradientView.layer.addSublayer(imageMaskLayer!)
            UIView.animate(withDuration: 1.0,
                           animations: {
                            self.gradientView.alpha = 0.4
            })
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.transform = self.isHighlighted ?
                    CGAffineTransform(scaleX: 0.96, y: 0.96) :
                    CGAffineTransform.identity
            }
        }
    }
}
