//
//  KPPhotoGalleryViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPPhotoGalleryViewController: KPViewController {

    static let KPPhotoGalleryViewControllerCellReuseIdentifier = "cell";
    static let KPPhotoGalleryViewControllerCellAddIdentifier = "cell_add";
    
    var transitionController: KPPhotoDisplayTransition = KPPhotoDisplayTransition()
    var hideSelectedCell: Bool = false
    var dismissButton:KPBounceButton!
    var collectionView:UICollectionView!;
    var collectionLayout:UICollectionViewFlowLayout!;
    var diplayedPhotoInformations: [PhotoInformation] = [PhotoInformation]()
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
            
            let snapShotView = UIImageView.init(image: selectedCell.shopPhoto.image)
            snapShotView.frame = selectedCell.frame
            return snapShotView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = KPColorPalette.KPTextColor.whiteColor
        self.navigationItem.title = "店家照片"
        self.navigationItem.hidesBackButton = true
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        
        self.navigationItem.leftBarButtonItems = [negativeSpacer, UIBarButtonItem.init(image: R.image.icon_back(),
                                                                                       style: .plain,
                                                                                       target: self,
                                                                                       action: #selector(KPPhotoGalleryViewController.handleBackButtonOnTapped))]
        
        let itemSize = (UIScreen.main.bounds.size.width-(12*4))/3
        
        //Collection view
        self.collectionLayout = UICollectionViewFlowLayout()
        self.collectionLayout.scrollDirection = .vertical
        self.collectionLayout.minimumLineSpacing = 16.0
        self.collectionLayout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12)
        self.collectionLayout.itemSize = CGSize.init(width: itemSize, height: itemSize)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.delaysContentTouches = true
        self.collectionView.register(KPShopPhotoCell.self,
                                     forCellWithReuseIdentifier:
            KPPhotoGalleryViewController.KPPhotoGalleryViewControllerCellReuseIdentifier)
        self.collectionView.register(KPPhotoAddCell.self,
                                     forCellWithReuseIdentifier:
            KPPhotoGalleryViewController.KPPhotoGalleryViewControllerCellAddIdentifier)
        
        self.view.addSubview(self.collectionView)
        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:|[$self]|"])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleBackButtonOnTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//    
//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return .slide
//    }
    
}

extension KPPhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diplayedPhotoInformations.count;
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
            cell.shopPhoto.image = self.diplayedPhotoInformations[indexPath.row].image
            return cell;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        if indexPath.row == 0 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: {
            })
            
        } else {
            let photoDisplayController = KPPhotoDisplayViewController()
            photoDisplayController.transitioningDelegate = self
            photoDisplayController.diplayedPhotoInformations =
                [PhotoInformation(title:"Title", image:R.image.demo_1()!, index:0),
                 PhotoInformation(title:"Title", image:R.image.demo_2()!, index:1),
                 PhotoInformation(title:"Title", image:R.image.demo_3()!, index:2),
                 PhotoInformation(title:"Title", image:R.image.demo_4()!, index:3),
                 PhotoInformation(title:"Title", image:R.image.demo_5()!, index:4),
                 PhotoInformation(title:"Title", image:R.image.demo_6()!, index:5)]
            
            self.present(photoDisplayController, animated: true, completion: {
            })
        }
        
    }
}

// MARK: Image Picker

extension KPPhotoGalleryViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) { 
            
        }
    }
    
}

// MARK: View Transition

extension KPPhotoGalleryViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let photoViewController = presented as! KPPhotoDisplayViewController
        photoViewController.selectedIndexPath = selectedIndexPath
        
        let cell = collectionView.cellForItem(at: selectedIndexPath) as! KPShopPhotoCell
        transitionController.setupImageTransition(cell.shopPhoto.image!,
                                                  fromDelegate: self,
                                                  toDelegate: photoViewController)
        return transitionController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let photoViewController = dismissed as! KPPhotoDisplayViewController
        selectedIndexPath = photoViewController.selectedIndexPath
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
