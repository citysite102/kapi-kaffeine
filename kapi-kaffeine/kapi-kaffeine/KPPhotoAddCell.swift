//
//  KPPhotoAddCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/14.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPPhotoAddCell: UICollectionViewCell {
    
    let iconCamera = UIImageView(image: R.image.icon_camera()?.withRenderingMode(.alwaysTemplate))
    lazy var addPhotoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    lazy var overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.2
        return overlay
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame);

        backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level5
        
        addSubview(iconCamera)
        iconCamera.tintColor = UIColor.white
        iconCamera.addConstraintForCenterAligningToSuperview(in: .horizontal)
        iconCamera.addConstraintForCenterAligningToSuperview(in: .vertical, constant: -8)
        
        addSubview(addPhotoLabel)
        addPhotoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        addPhotoLabel.addConstraintForCenterAligningToSuperview(in: .vertical, constant: 16)
        addPhotoLabel.text = "上傳\n照片"
        
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
