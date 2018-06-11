//
//  KPSubTitlePhotoUploadView.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 10/08/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSubTitlePhotoUploadView: UIView {
    
    static let KPSubTitlePhotoUploadViewCellReuseIdentifier = "cell";
    static let KPSubTitlePhotoUploadViewUploadCellReuseIdentifier = "uploadCell";

    
    var subTitleView: KPSubTitleEditView!
    
    var collectionView: UICollectionView!
    var collectionLayout: UICollectionViewFlowLayout!
    
    weak var controller: UIViewController?
    
    var images = [UIImage]()
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        
        subTitleView = KPSubTitleEditView(.Bottom, .Custom, title)
        addSubview(subTitleView)
        subTitleView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        
        //Collection view
        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.sectionInset = UIEdgeInsetsMake(8, 0, 8, 0)
        collectionLayout.minimumLineSpacing = 8.0
        collectionLayout.itemSize = CGSize(width: 96, height: 96)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = true
        collectionView.register(KPShopPhotoCell.self,
                                forCellWithReuseIdentifier:
            KPSubTitlePhotoUploadView.KPSubTitlePhotoUploadViewCellReuseIdentifier)
        collectionView.register(KPPhotoAddCell.self,
                                forCellWithReuseIdentifier:
            KPSubTitlePhotoUploadView.KPSubTitlePhotoUploadViewUploadCellReuseIdentifier)
        
        addSubview(self.collectionView)
        subTitleView.customInfoView = collectionView
        collectionView.removeAllRelatedConstraintsInSuperView()
        collectionView.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]-8-|",
                                                        "H:|-16-[$self]|"],
                                      views:[subTitleView.subTitleLabel])
        
        collectionView.addConstraint(forHeight: 112)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension KPSubTitlePhotoUploadView: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                KPSubTitlePhotoUploadView.KPSubTitlePhotoUploadViewUploadCellReuseIdentifier,
                                                          for: indexPath)
            cell.layer.cornerRadius = KPLayoutConstant.corner_radius
            cell.layer.masksToBounds = true
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            KPSubTitlePhotoUploadView.KPSubTitlePhotoUploadViewCellReuseIdentifier,
                                                      for: indexPath)  as! KPShopPhotoCell
        cell.shopPhoto.image = images[indexPath.row-1]
        cell.layer.cornerRadius = KPLayoutConstant.corner_radius
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            controller?.present(imagePicker, animated: true, completion: {
                
            })
        }
    }
    
}

extension KPSubTitlePhotoUploadView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) { [unowned self] in
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.images.append(image)
                self.collectionView.insertItems(at: [IndexPath.init(row: self.images.count, section: 0)])
            }
        }
    }
    
}
