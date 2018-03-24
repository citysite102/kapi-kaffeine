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
    
    fileprivate var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var photos: [UIImage] = []
    
//    override init(frame: CGRect) {
//        super.init(frame: CGRect.zero)
//        
//        takePhotoButton = UIButton()
//        takePhotoButton.setImage(R.image.icon_camera(), for: .normal)
//        takePhotoButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level6!),
//                                           for: .normal)
//        takePhotoButton.layer.cornerRadius = 5
//        takePhotoButton.clipsToBounds = true
//        takePhotoButton.addTarget(self, action: #selector(handleTakePhotoButtonOnTap(_:)), for: .touchUpInside)
//        addSubview(takePhotoButton)
//        takePhotoButton.addConstraints(fromStringArray: ["H:|[$self(80)]", "V:|[$self(80)]"])
//        
//        let collectionViewFlowLayout = UICollectionViewFlowLayout()
//        collectionViewFlowLayout.itemSize = CGSize(width: 80, height: 120)
//        collectionViewFlowLayout.minimumLineSpacing = 10
//        collectionViewFlowLayout.scrollDirection = .horizontal
//        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        
//        photoCollectionView = UICollectionView(frame: CGRect.zero,
//                                               collectionViewLayout: collectionViewFlowLayout)
//        photoCollectionView.backgroundColor = UIColor.white
//        photoCollectionView.showsHorizontalScrollIndicator = false
//        photoCollectionView.register(KPPhotoUploadCollectionViewCell.self,
//                                     forCellWithReuseIdentifier: "photoUploadCell")
//        photoCollectionView.dataSource = self
//        photoCollectionView.delegate = self
//        addSubview(photoCollectionView)
//        
//        photoCollectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-20-[$self]|"],
//                                           views:[takePhotoButton])
//        
//        collectionViewHeightConstraint = photoCollectionView.heightAnchor.constraint(equalToConstant: 0)
//        collectionViewHeightConstraint.isActive = true
//    }
    
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
        takePhotoButton.addTarget(self, action: #selector(handleTakePhotoButtonOnTap(_:)), for: .touchUpInside)
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
        
        photoCollectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-20-[$self]-20-|"],
                                           views:[takePhotoButton])
        
        collectionViewHeightConstraint = photoCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleTakePhotoButtonOnTap(_ sender: UIButton) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { (action) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            UIApplication.shared.topViewController.present(imagePickerController, animated: true, completion: nil)
        })
        controller.addAction(UIAlertAction(title: "開啟相機", style: .default) { (action) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            UIApplication.shared.topViewController.present(imagePickerController, animated: true, completion: nil)
        })
        
        controller.addAction(UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        })
        
        UIApplication.shared.topViewController.present(controller, animated: true) {
            
        }
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


extension KPPhotoUploadView : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                UIView.animate(withDuration: 0.25, animations: {
                    if self.photos.count == 0 {
                        self.collectionViewHeightConstraint.constant = 120
                    }
                    self.photos.append(image)
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    self.photoCollectionView.insertItems(at: [IndexPath.init(row: self.photos.count - 1, section: 0)])
                })
            }
        }
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


