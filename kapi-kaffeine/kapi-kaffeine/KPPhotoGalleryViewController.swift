//
//  KPPhotoGalleryViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import ImagePicker

class KPPhotoGalleryViewController: KPViewController {

    static let KPPhotoGalleryViewControllerCellReuseIdentifier = "cell";
    static let KPPhotoGalleryViewControllerCellAddIdentifier = "cell_add";
    
    var transitionController: KPPhotoDisplayTransition = KPPhotoDisplayTransition()
    var hideSelectedCell: Bool = false
    var collectionView: UICollectionView!;
    var collectionLayout: UICollectionViewFlowLayout!;
    var selectedIndexPath: IndexPath!
    var selectedCellSnapshot: UIView  {
        get {
            let selectedCell = collectionView.cellForItem(at: selectedIndexPath) as! KPShopPhotoCell
//            UIGraphicsBeginImageContextWithOptions((selectedCell?.frameSize)!,
//                                                   true,
//                                                   0.0)
//            selectedCell?.layer.render(in: UIGraphicsGetCurrentContext()!)
//            let img = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext();
//            return img!;
            
            let snapShotView = UIImageView(image: selectedCell.shopPhoto.image)
            snapShotView.frame = selectedCell.frame
            return snapShotView
        }
    }
    var displayedPhotoInformations: [PhotoInformation] = [PhotoInformation]() {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = KPColorPalette.KPTextColor.whiteColor
        navigationItem.title = "店家照片"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.topItem?.title = "店家照片"
        
        
        let backButton = KPBounceButton(frame: CGRect.zero,
                                        image: R.image.icon_back()!)
        backButton.widthAnchor.constraint(equalToConstant: CGFloat(KPLayoutConstant.dismissButton_size)).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: CGFloat(KPLayoutConstant.dismissButton_size)).isActive = true
        backButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        backButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        backButton.addTarget(self,
                             action: #selector(KPPhotoGalleryViewController.handleBackButtonOnTapped),
                             for: UIControlEvents.touchUpInside)
        
        let barItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItems = [barItem]
        let itemSize = (UIScreen.main.bounds.size.width-(12*4))/3
        
        //Collection view
        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 16.0
        collectionLayout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12)
        collectionLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = true
        collectionView.register(KPShopPhotoCell.self,
                                     forCellWithReuseIdentifier:
            KPPhotoGalleryViewController.KPPhotoGalleryViewControllerCellReuseIdentifier)
        collectionView.register(KPPhotoAddCell.self,
                                     forCellWithReuseIdentifier:
            KPPhotoGalleryViewController.KPPhotoGalleryViewControllerCellAddIdentifier)
        
        view.addSubview(collectionView)
        collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                        "V:|[$self]|"])

        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayStatusbar = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshPhoto),
                                               name: Notification.Name(KPNotification.information.photoInformation),
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Photo Refresh
    
    @objc func refreshPhoto() {
        KPServiceHandler.sharedHandler.getPhotos {
            [weak self] (successed, photos) in
            if let weSelf = self {
                if successed == true && photos != nil {
                    var index: Int = 0
                    var photoInformations: [PhotoInformation] = []
                    for urlString in photos! {
                        if let url = URL(string: urlString["url"]!),
                            let thumbnailurl = URL(string: urlString["thumbnail"]!) {
                            photoInformations.append(PhotoInformation(title: "",
                                                                      imageURL: url,
                                                                      thumbnailURL: thumbnailurl,
                                                                      index: index))
                            index += 1
                        }
                    }
                    weSelf.displayedPhotoInformations = photoInformations
                } else {
                    // Handle Error
                }
            }
        }
    }
    
    
    // MARK: UI Event
    
    func photoUpload() {
        if KPUserManager.sharedManager.currentUser == nil {
            KPPopoverView.popoverLoginView()
        } else {
            if KPServiceHandler.sharedHandler.isCurrentShopClosed {
                KPPopoverView.popoverClosedView()
            } else {
                let imagePickerController = ImagePickerController()
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleBackButtonOnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Collection View

extension KPPhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedPhotoInformations.count + 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPPhotoGalleryViewController.KPPhotoGalleryViewControllerCellAddIdentifier,
                                                          for: indexPath) as! KPPhotoAddCell;
            cell.layer.cornerRadius = 4.0
            cell.layer.masksToBounds = true
            return cell;
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPPhotoGalleryViewController.KPPhotoGalleryViewControllerCellReuseIdentifier,
                                                          for: indexPath) as! KPShopPhotoCell;
            cell.layer.cornerRadius = 4.0
            cell.layer.masksToBounds = true
            cell.isUserInteractionEnabled = true
            cell.shopPhoto.af_setImage(withURL: displayedPhotoInformations[indexPath.row-1].imageURL,
                                       placeholderImage: R.image.image_loading(),
                                       filter: nil,
                                       progress: nil,
                                       progressQueue: DispatchQueue.global(),
                                       imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                       runImageTransitionIfCached: false,
                                       completion: { (response) in
                                        if response.error != nil {
                                            cell.shopPhoto.image = R.image.image_failed_s()
                                            cell.isUserInteractionEnabled = false
                                        }
                                        if let responseImage = response.result.value {
                                            cell.shopPhoto.image = responseImage
                                            cell.isUserInteractionEnabled = true
                                        }
            })
            return cell;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        if indexPath.row == 0 {
            photoUpload()
        } else {
            var photoSource: [SKPhotoProtocol] = [SKPhotoProtocol]()
            for (index, photoInfo) in self.displayedPhotoInformations.enumerated() {
                if let photoImage = (collectionView.cellForItem(at: indexPath) as! KPShopPhotoCell).shopPhoto.image,
                    index == selectedIndexPath.row-1 {
                    photoSource.append(SKPhoto.photoWithImage(photoImage))
                } else {
                    photoSource.append(SKPhoto.photoWithImageURL(photoInfo.imageURL.absoluteString))
                }
            }
            
            if let animatedCell = collectionView.cellForItem(at: indexPath) as? KPShopPhotoCell {
                let browser = SKPhotoBrowser(originImage: animatedCell.shopPhoto.image!,
                                             photos: photoSource,
                                             animatedFromView: animatedCell)
                browser.initializePageIndex(indexPath.row-1)
                browser.delegate = self
                present(browser, animated: true, completion: {})
            }
        }
    }
}

extension KPPhotoGalleryViewController: SKPhotoBrowserDelegate {
    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        return collectionView.cellForItem(at: IndexPath(item: index+1, section: 0))
    }
    
    func didShowPhotoAtIndex(_ index: Int) {
        collectionView.visibleCells.forEach({$0.isHidden = false})
        collectionView.cellForItem(at: IndexPath(item: index+1, section: 0))?.isHidden = true
    }
    
    func willDismissAtPageIndex(_ index: Int) {
        collectionView.visibleCells.forEach({$0.isHidden = false})
        collectionView.cellForItem(at: IndexPath(item: index+1, section: 0))?.isHidden = true
    }
    
    func didDismissAtPageIndex(_ index: Int) {
        collectionView.cellForItem(at: IndexPath(item: index+1, section: 0))?.isHidden = false
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
        // handle dismissing custom actions
    }
    
}

// MARK: - Image Picker

extension KPPhotoGalleryViewController: ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true) {
            // TODO: check parameters
            KPServiceHandler.sharedHandler.uploadPhotos(images,
                                                        nil,
                                                        true,
                                                        { (success) in
                                                            if success {
                                                                print("upload successed")
                                                            } else {
                                                                print("upload failed")
                                                            }
            })
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: View Transition

extension KPPhotoGalleryViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let photoViewController = presented as! KPPhotoDisplayViewController
        photoViewController.selectedIndexPath = IndexPath(row: selectedIndexPath.row - 1,
                                                          section: selectedIndexPath.section)
        
        let cell = collectionView.cellForItem(at: selectedIndexPath) as! KPShopPhotoCell
        transitionController.setupImageTransition(cell.shopPhoto.image!,
                                                  fromDelegate: self,
                                                  toDelegate: photoViewController)
        transitionController.transitionType = .damping
        return transitionController
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let photoViewController = dismissed as! KPPhotoDisplayViewController
        selectedIndexPath = IndexPath(row: photoViewController.selectedIndexPath.row + 1,
                                      section: photoViewController.selectedIndexPath.section)
        let cell = collectionView.cellForItem(at: selectedIndexPath) as! KPShopPhotoCell
        transitionController.setupImageTransition(cell.shopPhoto.image!,
                                                  fromDelegate: photoViewController,
                                                  toDelegate: self)
        return transitionController
    }
}

extension KPPhotoGalleryViewController: ImageTransitionProtocol {
    
    // 1: hide selected cell for tranisition snapshot
    func tranisitionSetup(){
        hideSelectedCell = true
    }
    
    // 2: unhide selected cell after tranisition snapshot is taken
    func tranisitionCleanup(){
        hideSelectedCell = false
    }
    
    // 3: return window frame of selected image
    func imageWindowFrame() -> CGRect{
        let attributes = collectionView.layoutAttributesForItem(at: selectedIndexPath)
        let cellRect = attributes!.frame
        return collectionView.convert(cellRect, to: nil)
    }
}
