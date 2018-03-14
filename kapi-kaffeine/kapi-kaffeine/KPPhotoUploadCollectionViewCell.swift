//
//  KPPhotoUploadCollectionViewCell.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 30/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol KPPhotoUploadCollectionViewCellDelegate: class {
    func photoUploadCellDeleteButtonOnTap(_ uploadCell: KPPhotoUploadCollectionViewCell)
}

class KPPhotoUploadCollectionViewCell: UICollectionViewCell {
    
    var photoImageView: UIImageView!
    var deleteButton: UIButton!
    
    weak var delegate: KPPhotoUploadCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.image = R.image.demo_3()
        photoImageView.layer.cornerRadius = 5
        photoImageView.clipsToBounds = true
        contentView.addSubview(photoImageView)
        
        photoImageView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self(80)]"])
        
        deleteButton = UIButton()
        contentView.addSubview(deleteButton)
        deleteButton.setTitle("刪除", for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        deleteButton.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_description, for: .normal)
        deleteButton.setTitleColor(KPColorPalette.KPMainColor_v2.whiteColor_level1, for: .highlighted)
        deleteButton.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]|"],
                                    views: [photoImageView])
        deleteButton.addTarget(self, action: #selector(handleDeleteButtonOnTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleDeleteButtonOnTap(_ sender: UIButton) {
        
        guard let `delegate` = delegate else {
            return
        }
        
        delegate.photoUploadCellDeleteButtonOnTap(self)
    }
    
}
