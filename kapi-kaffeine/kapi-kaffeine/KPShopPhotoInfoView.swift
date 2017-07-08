//
//  KPShopPhotoInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopPhotoInfoView: UIView {

    static let KPShopPhotoInfoViewCellReuseIdentifier = "cell";
    
    var collectionView:UICollectionView!;
    var collectionLayout:UICollectionViewFlowLayout!;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = KPColorPalette.KPTextColor.whiteColor;
        
        //Collection view
        self.collectionLayout = UICollectionViewFlowLayout();
        self.collectionLayout.scrollDirection = .horizontal;
        self.collectionLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        self.collectionLayout.minimumLineSpacing = 8.0;
        self.collectionLayout.itemSize = CGSize(width: 96, height: 96);
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout);
        self.collectionView.backgroundColor = UIColor.clear;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = false;
        self.collectionView.showsVerticalScrollIndicator = false;
        self.collectionView.delaysContentTouches = true;
        self.collectionView.register(KPShopPhotoCell.self,
                                     forCellWithReuseIdentifier: KPShopPhotoInfoView.KPShopPhotoInfoViewCellReuseIdentifier)
        
        self.addSubview(self.collectionView);
        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self(112)]|"]);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KPShopPhotoInfoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPShopPhotoInfoView.KPShopPhotoInfoViewCellReuseIdentifier,
                                                      for: indexPath) as! KPShopPhotoCell;
        
        return cell;
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath);
//        cell?.alpha = 1.0;
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath);
//        cell?.alpha = 0.4;
//    }
    
    
}
