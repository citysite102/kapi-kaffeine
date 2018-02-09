//
//  KPShopPhotoInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopPhotoInfoView: UIView {

    static let KPShopPhotoInfoViewCellReuseIdentifier = "cell"
    weak open var informationController: KPInformationViewController?
    
    var collectionView:UICollectionView!
    var collectionLayout:UICollectionViewFlowLayout!
    var isMenu: Bool! = false
    
    var displayPhotoInformations: [PhotoInformation] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.displayPhotoInformations.count > 0 {
                    self.collectionView.removeAllRelatedConstraintsInSuperView()
                    self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                         "V:|[$self]-($metric0)-|"],
                                                       metrics:[KPLayoutConstant.information_horizontal_offset])
                    self.collectionView.addConstraint(forHeight: 96)
                }
                self.collectionView.layoutIfNeeded()
                self.collectionView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = KPColorPalette.KPTextColor.whiteColor
        
        //Collection view
        self.collectionLayout = UICollectionViewFlowLayout()
        self.collectionLayout.scrollDirection = .horizontal
        self.collectionLayout.sectionInset = UIEdgeInsetsMake(0,
                                                              CGFloat(KPLayoutConstant.information_horizontal_offset),
                                                              0,
                                                              CGFloat(KPLayoutConstant.information_horizontal_offset))
        self.collectionLayout.minimumLineSpacing = 8.0
        self.collectionLayout.itemSize = CGSize(width: 96, height: 96)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.delaysContentTouches = true
        self.collectionView.register(KPShopPhotoCell.self,
                                     forCellWithReuseIdentifier: KPShopPhotoInfoView.KPShopPhotoInfoViewCellReuseIdentifier)
        
        self.addSubview(self.collectionView)
        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:|[$self]-($metric0)-|"], metrics:[KPLayoutConstant.information_horizontal_offset])
        self.collectionView.addConstraint(forHeight: 96)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KPShopPhotoInfoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return displayPhotoInformations.count
        return isMenu ? 1 : 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPShopPhotoInfoView.KPShopPhotoInfoViewCellReuseIdentifier,
                                                      for: indexPath) as! KPShopPhotoCell
        cell.shopPhoto.image = isMenu ? R.image.demo_menu() : R.image.demo_7()
//        cell.shopPhoto.af_setImage(withURL: displayPhotoInformations[indexPath.row].thumbnailURL,
//                                   placeholderImage: UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level6!),
//                                   filter: nil,
//                                   progress: nil,
//                                   progressQueue: DispatchQueue.global(),
//                                   imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
//                                   runImageTransitionIfCached: false,
//                                   completion: { (response) in
//
//                                    if let responseImage = response.result.value {
//                                        cell.shopPhoto.image = responseImage
//                                    } else {
//                                        cell.shopPhoto.image = R.image.image_failed_s()
//                                    }
//        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let galleryController = KPPhotoGalleryViewController()
        galleryController.displayedPhotoInformations = displayPhotoInformations
        informationController?.navigationController?.pushViewController(viewController: galleryController,
                                                                        animated: true,
                                                                        completion: {}
        )
    }
    
}
