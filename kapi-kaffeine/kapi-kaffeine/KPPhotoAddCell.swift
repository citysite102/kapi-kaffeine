//
//  KPPhotoAddCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/14.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPPhotoAddCell: UICollectionViewCell {
    
    let iconCamera = UIImageView.init(image: R.image.icon_camero()?.withRenderingMode(.alwaysTemplate))
    lazy var addPhotoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame);

        backgroundColor = KPColorPalette.KPMainColor.mainColor
        
        addSubview(iconCamera)
        iconCamera.tintColor = UIColor.white
        iconCamera.addConstraintForCenterAligningToSuperview(in: .horizontal)
        iconCamera.addConstraintForCenterAligningToSuperview(in: .vertical, constant: -8)
        
        addSubview(addPhotoLabel)
        addPhotoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        addPhotoLabel.addConstraintForCenterAligningToSuperview(in: .vertical, constant: 16)
        addPhotoLabel.text = "上傳照片"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
