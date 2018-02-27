//
//  KPShopPhotoCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/18.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopPhotoCell: UICollectionViewCell {
    
    var shopPhoto: UIImageView!
    
    lazy var overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.2
        return overlay
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        alpha = 0.4
        
        shopPhoto = UIImageView()
        shopPhoto.contentMode = .scaleAspectFit
        shopPhoto.layer.cornerRadius = 4.0
        shopPhoto.layer.masksToBounds = true
        shopPhoto.contentMode = .scaleAspectFill
        addSubview(shopPhoto)
        shopPhoto.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self]|"])
        
        addSubview(overlayView)
        overlayView.isUserInteractionEnabled = false
        overlayView.alpha = 0.0
        overlayView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.overlayView.alpha = self.isHighlighted ? 0.2 : 0
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
