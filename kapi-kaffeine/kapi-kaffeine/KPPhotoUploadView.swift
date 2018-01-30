//
//  KPPhotoUploadView.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 30/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPPhotoUploadView: UIView {

    fileprivate var takePhotoButton: UIButton!
    fileprivate var photoCollectionView: UICollectionView!
    
    init(_ title: String) {
        super.init(frame: CGRect.zero)
        
        let lineView = UIView()
        lineView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level5
        addSubview(lineView)
        lineView.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:|[$self(0.5)]"])
        
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:|-20-[$self]"])
        
        
        takePhotoButton = UIButton()
        takePhotoButton.setImage(R.image.icon_camera(), for: .normal)
        takePhotoButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level6!),
                                           for: .normal)
        takePhotoButton.layer.cornerRadius = 5
        takePhotoButton.clipsToBounds = true
        addSubview(takePhotoButton)
        takePhotoButton.addConstraints(fromStringArray: ["H:|-20-[$self(80)]", "V:[$view0]-[$self(80)]"],
                                       views: [titleLabel])
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 80, height: 120)
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        photoCollectionView = UICollectionView(frame: CGRect.zero,
                                               collectionViewLayout: collectionViewFlowLayout)
        photoCollectionView.backgroundColor = UIColor.white
        photoCollectionView.showsHorizontalScrollIndicator = false
        photoCollectionView.register(KPPhotoUploadCollectionViewCell.self,
                                     forCellWithReuseIdentifier: "photoUploadCell")
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        addSubview(photoCollectionView)
        
        photoCollectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-20-[$self(120)]-20-|"],
                                           views:[takePhotoButton])

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension KPPhotoUploadView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "photoUploadCell", for: indexPath)
    }
    
}


