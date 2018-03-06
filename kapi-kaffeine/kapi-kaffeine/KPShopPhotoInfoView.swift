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
    
    var photoSubTitleLabel: UILabel!
    var collectionView: UICollectionView!
    var collectionLayout: UICollectionViewFlowLayout!
    var verticleBottomConstraint: NSLayoutConstraint!
    var isMenu: Bool! = false {
        didSet {
            DispatchQueue.main.async {
                self.photoSubTitleLabel.text = "菜單"
            }
        }
    }
    
    var smallerVerticlePadding: Bool = false {
        didSet {
            
            if let verticleConstraint = self.verticleBottomConstraint {
            
                if verticleConstraint.constant != 32 && !smallerVerticlePadding  {
                    self.removeConstraint(verticleConstraint)
                    self.verticleBottomConstraint = self.collectionView.addConstraint(from: "V:[$self]-32-|").first as! NSLayoutConstraint
                } else if verticleConstraint.constant != 24 && smallerVerticlePadding {
                    self.removeConstraint(verticleConstraint)
                    self.verticleBottomConstraint = self.collectionView.addConstraint(from: "V:[$self]-24-|").first as! NSLayoutConstraint
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    var displayPhotoInformations: [PhotoInformation] = [] {
        didSet {
            DispatchQueue.main.async {
                
                if self.verticleBottomConstraint != nil {
                    self.removeConstraint(self.verticleBottomConstraint)
                }
                
                if self.displayPhotoInformations.count > 0 {
                    self.photoSubTitleLabel.removeAllRelatedConstraintsInSuperView()
                    self.collectionView.removeAllRelatedConstraintsInSuperView()
                    if self.isMenu {
                        self.photoSubTitleLabel.addConstraints(fromStringArray: ["V:|-(-56)-[$self]",
                                                                                 "H:|-($metric0)-[$self]-($metric0)-|"],
                                                               metrics:[KPLayoutConstant.information_horizontal_offset])
                        self.verticleBottomConstraint = self.collectionView.addConstraint(from: "V:[$self]-24-|").first as! NSLayoutConstraint
                        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                             "V:[$view0]-12-[$self]"],
                                                           views:[self.photoSubTitleLabel])
                        self.collectionView.addConstraint(forHeight: 100)
                    } else {
                        self.photoSubTitleLabel.addConstraints(fromStringArray: ["V:|[$self]",
                                                                            "H:|-($metric0)-[$self]-($metric0)-|"],
                                                          metrics:[KPLayoutConstant.information_horizontal_offset])
                        self.verticleBottomConstraint = self.smallerVerticlePadding ?
                        self.collectionView.addConstraint(from: "V:[$self]-24-|").first as! NSLayoutConstraint
                            : self.collectionView.addConstraint(from: "V:[$self]-32-|").first as! NSLayoutConstraint
                        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                             "V:[$view0]-12-[$self]"],
                                                           views:[self.photoSubTitleLabel])
                        self.collectionView.addConstraint(forHeight: 100)
                    }
                }
                self.collectionView.layoutIfNeeded()
                self.collectionView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        
        // Label
        photoSubTitleLabel = UILabel()
        photoSubTitleLabel.text = "店家照片"
        photoSubTitleLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent,
                                                weight: UIFont.Weight.regular)
        photoSubTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        addSubview(photoSubTitleLabel)

        self.collectionLayout = UICollectionViewFlowLayout()
        self.collectionLayout.scrollDirection = .horizontal
        self.collectionLayout.sectionInset = UIEdgeInsetsMake(0,
                                                              CGFloat(KPLayoutConstant.information_horizontal_offset),
                                                              0,
                                                              CGFloat(KPLayoutConstant.information_horizontal_offset))
        self.collectionLayout.minimumLineSpacing = 12.0
        self.collectionLayout.itemSize = CGSize(width: 100, height: 100)
        
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
        return displayPhotoInformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPShopPhotoInfoView.KPShopPhotoInfoViewCellReuseIdentifier,
                                                      for: indexPath) as! KPShopPhotoCell
        cell.shopPhoto.af_setImage(withURL: displayPhotoInformations[indexPath.row].thumbnailURL,
                                   placeholderImage: UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level6!),
                                   filter: nil,
                                   progress: nil,
                                   progressQueue: DispatchQueue.global(),
                                   imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                   runImageTransitionIfCached: false,
                                   completion: { (response) in

                                    if let responseImage = response.result.value {
                                        cell.shopPhoto.image = responseImage
                                    } else {
                                        cell.shopPhoto.image = R.image.image_failed_s()
                                    }
        })
        
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
