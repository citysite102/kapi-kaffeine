//
//  KPArticleCell.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 21/11/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPArticleCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 4
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 2
        titleLabel.text = "測試用"
        contentView.addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["H:|-10-[$self]",
                                                    "V:[$self]-16-|"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch Began")
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.96,
                                               y: 0.96)
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch End")
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch Cancel")
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
        super.touchesCancelled(touches, with: event)
    }
}
