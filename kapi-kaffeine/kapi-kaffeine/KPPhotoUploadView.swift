//
//  KPPhotoUploadView.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 30/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit
import ImagePicker

class KPPhotoUploadView: UIView {

    fileprivate var takePhotoButton: UIButton!
    fileprivate var photoCollectionView: UICollectionView!
    
    fileprivate var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var photos: [UIImage] = []
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        takePhotoButton = UIButton()
        takePhotoButton.setImage(R.image.icon_camera(), for: .normal)
        takePhotoButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level6!),
                                           for: .normal)
        takePhotoButton.layer.cornerRadius = 5
        takePhotoButton.clipsToBounds = true
        takePhotoButton.addTarget(self, action: #selector(handleTakePhotoButtonOnTap(_:)), for: .touchUpInside)
        addSubview(takePhotoButton)
        takePhotoButton.addConstraints(fromStringArray: ["H:|[$self(80)]", "V:|[$self(80)]"])
        
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
        
        photoCollectionView.addConstraints(fromStringArray: ["H:|-(-20)-[$self]-(-20)-|", "V:[$view0]-20-[$self]|"],
                                           views:[takePhotoButton])
        
        collectionViewHeightConstraint = photoCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleTakePhotoButtonOnTap(_ sender: UIButton) {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        UIApplication.shared.topViewController.present(imagePickerController, animated: true, completion: nil)
        
    }
    
}

extension KPPhotoUploadView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoUploadCell", for: indexPath) as! KPPhotoUploadCollectionViewCell
        cell.delegate = self
        cell.photoImageView.image = photos[indexPath.row]
        return cell
    }
}


extension KPPhotoUploadView: ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true) {
            UIView.animate(withDuration: 0.25, animations: {
                if self.photos.count == 0 {
                    self.collectionViewHeightConstraint.constant = 120
                }
                self.photos.append(contentsOf: images)
                self.layoutIfNeeded()
            }, completion: { (finished) in
                var indexPathList: [IndexPath] = []
                for i in  self.photos.count - images.count ... self.photos.count - 1 {
                    indexPathList.append(IndexPath.init(row: i, section: 0))
                }
                self.photoCollectionView.insertItems(at: indexPathList)
            })
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

extension KPPhotoUploadView: KPPhotoUploadCollectionViewCellDelegate {
    
    func photoUploadCellDeleteButtonOnTap(_ uploadCell: KPPhotoUploadCollectionViewCell) {
        if let indexPath = photoCollectionView.indexPath(for: uploadCell) {
            self.photos.remove(at: indexPath.row)
            self.photoCollectionView.performBatchUpdates({
                self.photoCollectionView.deleteItems(at: [indexPath])
            }, completion: { (finished) in
                if self.photos.count == 0 {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.collectionViewHeightConstraint.constant = 0
                        self.layoutIfNeeded()
                    })
                }
            })
        }
    }
    
}


