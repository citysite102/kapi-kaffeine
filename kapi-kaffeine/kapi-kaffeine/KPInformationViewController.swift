//
//  KPDetailViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/11.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import BenzeneFoundation

class KPInformationViewController: KPViewController {

    
    var informationDataModel: KPDataModel! {
        didSet {
            KPServiceHandler.sharedHandler.currentDisplayModel = informationDataModel
        }
    }
    
    var dismissButton: KPBounceButton!
    var moreButton: KPBounceButton!
    var shareButton: KPBounceButton!
    
    var transitionController: KPPhotoDisplayTransition = KPPhotoDisplayTransition()
    var percentDrivenTransition: UIPercentDrivenInteractiveTransition!
    var currentPhotoIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    var snapshotPhotoView: UIView  {
        get {
            let snapShotView = UIImageView(image: informationHeaderView.shopPhoto.image)
            snapShotView.frame = informationHeaderView.shopPhoto.frame
            return snapShotView
        }
    }
    
    var currentScreenSnapshotImage: UIImage {
        get {
            UIGraphicsBeginImageContext(CGSize(width: view.frameSize.width,
                                               height: view.frameSize.height))
            UIGraphicsBeginImageContextWithOptions(CGSize(width: view.frameSize.width,
                                                          height: view.frameSize.height),
                                                   true, 0)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshotImage!
        }
    }
    
    var actionController: UIAlertController!
    var scrollContainer: UIScrollView!
    var informationHeaderView: KPInformationHeaderView!
    var informationHeaderButtonBar: KPInformationHeaderButtonBar!
    var shopInformationView: KPInformationSharedInfoView!
    var locationInformationView: KPInformationSharedInfoView!
    var rateInformationView: KPInformationSharedInfoView!
    var commentInformationView: KPInformationSharedInfoView!
    var photoInformationView: KPInformationSharedInfoView!
    var recommendInformationView: KPInformationSharedInfoView!
    var commentInfoView: KPShopCommentInfoView!
    var loadingIndicator: UIActivityIndicatorView!
    
    var allCommentHasShown: Bool = false
    var dataLoading: Bool = true {
        didSet {
            if dataLoading {
                self.informationHeaderButtonBar.isHidden = true
                self.informationHeaderButtonBar.alpha = 0.0
                
                self.shopInformationView.isHidden = true
                self.shopInformationView.alpha = 0.0
                
                self.informationHeaderButtonBar.layer.transform = CATransform3DMakeTranslation(0, 55, 0)
                self.shopInformationView.layer.transform = CATransform3DMakeTranslation(0, 75, 0)
                
                self.scrollContainer.isUserInteractionEnabled = false
            } else {
                self.loadingIndicator.stopAnimating()
                self.showInformationContents(true)
            }
        }
    }
    var animatedHeaderConstraint: NSLayoutConstraint!
    
    var navBarFixBound: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = informationDataModel.name
        navigationController?.delegate = self
        
        dismissButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30),
                                       image: R.image.icon_close()!)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        
        moreButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30),
                                    image: R.image.icon_more()!)
        moreButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        moreButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        moreButton.addTarget(self,
                             action: #selector(KPInformationViewController.handleMoreButtonOnTapped),
                             for: .touchUpInside)
        
        shareButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30),
                                     image: R.image.icon_share()!)
        shareButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        shareButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        shareButton.addTarget(self,
                              action: #selector(KPInformationViewController.handleShareButtonOnTapped),
                              for: .touchUpInside)
        

        let barItem = UIBarButtonItem(customView: dismissButton)
        let rightBarItem = UIBarButtonItem(customView: moreButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightBarItem]
        
        
        actionController = UIAlertController(title: nil,
                                             message: nil,
                                             preferredStyle: .actionSheet)
        actionController.view.tintColor = KPColorPalette.KPTextColor.grayColor_level2
        let editButton = UIAlertAction(title: "編輯店家資料",
                                       style: .default) { (_) in
                                        let controller = KPModalViewController()
                                        controller.edgeInset = UIEdgeInsets(top: 0,
                                                                            left: 0,
                                                                            bottom: 0,
                                                                            right: 0)
                                        let newStoreController = KPNewStoreController()
                                        let navigationController =
                                            UINavigationController(rootViewController: newStoreController)
                                        controller.contentController = navigationController
                                        controller.presentModalView()
        }
        
        let reportButton = UIAlertAction(title: "回報問題",
                                         style: .default) { (_) in
                                           print("回報問題")
        }
        
        let cancelButton = UIAlertAction(title: "取消",
                                         style: .destructive) { (_) in
                                            print("取消")
        }
        
        actionController.addAction(editButton)
        actionController.addAction(reportButton)
        actionController.addAction(cancelButton)
        
        
        scrollContainer = UIScrollView()
        scrollContainer.backgroundColor = KPColorPalette.KPMainColor.grayColor_level7
        scrollContainer.delegate = self
        scrollContainer.canCancelContentTouches = false
        view.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        
        informationHeaderView = KPInformationHeaderView(frame: CGRect.zero)
        informationHeaderView.delegate = self
        informationHeaderView.informationController = self
        if let photoURL = informationDataModel.covers?["google_l"] {
            informationHeaderView.shopPhoto.af_setImage(withURL: URL(string: photoURL)!,
                                                        placeholderImage: UIImage(color:KPColorPalette.KPBackgroundColor.grayColor_level6!),
                                                        filter: nil,
                                                        progress: nil,
                                                            progressQueue: DispatchQueue.global(),
                                                            imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                                            runImageTransitionIfCached: true,
                                                            completion: { response in
                                                                if let responseImage = response.result.value {
                                                                    self.informationHeaderView.shopPhoto.image =  responseImage
                                                                }
                })
        }
        //informationDataModel
        scrollContainer.addSubview(informationHeaderView)
        informationHeaderView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]"])
        
        informationHeaderView.addConstraintForHavingSameWidth(with: view)
        informationHeaderView.morePhotoButton.addTarget(self,
                                                        action: #selector(KPInformationViewController.handleMorePhotoButtonOnTapped),
                                                        for: UIControlEvents.touchUpInside)
        
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator.tintColor = KPColorPalette.KPMainColor.mainColor
        scrollContainer.addSubview(loadingIndicator)
        loadingIndicator.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]"],
                                        views:[informationHeaderView])
        loadingIndicator.addConstraintForCenterAligningToSuperview(in: .horizontal)
        loadingIndicator.startAnimating()
        
        informationHeaderButtonBar = KPInformationHeaderButtonBar(frame: .zero,
                                                                  informationDataModel: informationDataModel)
        informationHeaderButtonBar.informationController = self
        scrollContainer.addSubview(informationHeaderButtonBar)
        informationHeaderButtonBar.addConstraints(fromStringArray: ["H:|[$self]|"],
                                                  views: [informationHeaderView])
        
        
        animatedHeaderConstraint =
            informationHeaderButtonBar.addConstraint(from: "V:[$view0][$self]",
                                                     views:[informationHeaderView]).first as! NSLayoutConstraint
        
        let informationView: KPShopInfoView = KPShopInfoView()
        informationView.featureContents = informationDataModel.featureContents
        informationView.titleLabel.text = informationDataModel.name
        informationView.locationLabel.text = informationDataModel.address ?? "暫無資料"
        informationView.phoneLabel.text = informationDataModel.phone ?? "暫無資料"
        informationView.otherTimeButton.addTarget(self, action: #selector(KPInformationViewController.handleOtherTimeButtonOnTapped), for: .touchUpInside)
        
        if informationDataModel.businessHour != nil {
            let shopStatus = informationDataModel.businessHour.shopStatus
            informationView.openLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1
            informationView.openLabel.text = shopStatus.status
            informationView.openHint.backgroundColor = shopStatus.isOpening ?
                KPColorPalette.KPShopStatusColor.opened :
                KPColorPalette.KPShopStatusColor.closed
        } else {
            informationView.openLabel.textColor = KPColorPalette.KPTextColor.grayColor_level5
            informationView.openHint.backgroundColor = KPColorPalette.KPTextColor.grayColor_level5
            informationView.openLabel.text = "暫無資料"
            informationView.otherTimeButton.isHidden = true
        }
        
        shopInformationView = KPInformationSharedInfoView()
        shopInformationView.infoView = informationView
        shopInformationView.infoTitleLabel.text = "店家資訊"
        scrollContainer.addSubview(shopInformationView)
        shopInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-16-[$self(210)]"],
                                                      views: [informationHeaderButtonBar])
        
        locationInformationView = KPInformationSharedInfoView()
        locationInformationView.infoTitleLabel.text = "位置訊息"
        locationInformationView.infoSupplementLabel.text = "距離 600m"
        locationInformationView.actions = [Action(title:"開啟導航",
                                                 style:.normal,
                                                 color:KPColorPalette.KPMainColor.mainColor!,
                                                 icon:(R.image.icon_navi()?.withRenderingMode(.alwaysTemplate))!,
                                                 handler:{(infoView) -> () in
                                                    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                                                        UIApplication.shared.open(URL(string:
                                                            "comgooglemaps://?daddr=\(self.informationDataModel.latitude!),\(self.informationDataModel.longitude!)&mapmode=standard")!,
                                                                                  options: [:],
                                                                                  completionHandler: nil)
                                                    } else {
                                                        print("Can't use comgooglemaps://")
                                                    }
        }),
                                                Action(title:"街景模式",
                                                 style:.normal,
                                                 color:KPColorPalette.KPMainColor.mainColor!,
                                                 icon:(R.image.icon_map()?.withRenderingMode(.alwaysTemplate))!,
                                                 handler:{(infoView) -> () in
                                                    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                                                        UIApplication.shared.open(URL(string:
                                                            "comgooglemaps://?center=\(self.informationDataModel.latitude!),\(self.informationDataModel.longitude!)&mapmode=streetview")!, options: [:], completionHandler: nil)
                                                    } else {
                                                        print("Can't use comgooglemaps://")
                                                    }
                                                })
        ]
        
        scrollContainer.addSubview(locationInformationView)
        locationInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                 "V:[$view0]-24-[$self(292)]"],
                                                views: [shopInformationView])
        
        let shopRateInfoView = KPShopRateInfoView()
        rateInformationView = KPInformationSharedInfoView()
        rateInformationView.infoView = shopRateInfoView
        rateInformationView.infoTitleLabel.text = "店家評分"
        rateInformationView.infoSupplementLabel.text = "\(informationDataModel.rateCount ?? 0) 人已評分"
        rateInformationView.actions = [Action(title:"我要評分",
                                                   style:.normal,
                                                   color:KPColorPalette.KPMainColor.mainColor!,
                                                   icon:(R.image.icon_star()?.withRenderingMode(.alwaysTemplate))!,
                                                   handler:{(infoView) -> () in
                                                    let controller = KPModalViewController()
                                                    controller.edgeInset = UIEdgeInsets(top: UIDevice().isCompact ? 16 : 48,
                                                                                        left: 0,
                                                                                        bottom: 0,
                                                                                        right: 0)
                                                    controller.cornerRadius = [.topRight, .topLeft]
                                                    let ratingViewController = KPRatingViewController()
                                                    controller.contentController = ratingViewController
                                                    controller.presentModalView()
        })]
        scrollContainer.addSubview(rateInformationView)
        rateInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-24-[$self]"],
                                                views: [locationInformationView])
        
        
        commentInfoView = KPShopCommentInfoView()
        commentInformationView = KPInformationSharedInfoView()
        commentInformationView.infoView = commentInfoView
        commentInformationView.infoTitleLabel.text = "留言評價"
        commentInformationView.infoSupplementLabel.text = "\(informationDataModel.commentCount ?? 0) 人已留言"
        scrollContainer.addSubview(commentInformationView)
        commentInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                "V:[$view0]-24-[$self]"],
                                                    views: [rateInformationView])
        
        if informationDataModel.commentCount == nil {
            commentInformationView.actions = [Action(title:"我要評價",
                                                     style:.normal,
                                                     color:KPColorPalette.KPMainColor.mainColor!,
                                                     icon:(R.image.icon_comment()?.withRenderingMode(.alwaysTemplate))!,
                                                     handler:{(infoView) -> () in
                                                        let newCommentViewController = KPNewCommentController()
                                                        self.navigationController?.pushViewController(viewController: newCommentViewController,
                                                                                                      animated: true,
                                                                                                      completion: {})
                                              })
            ]
        } else {
            commentInformationView.actions = [Action(title:"看更多評價(\(informationDataModel.commentCount ?? 0))",
                                                          style:.normal,
                                                          color:KPColorPalette.KPMainColor.mainColor!,
                                                          icon:nil,
                                                          handler:{(infoView) -> () in
                                                            let commentViewController = KPAllCommentController()
                                                            commentViewController.comments = self.commentInfoView.comments
                                                            commentViewController.animated = !self.allCommentHasShown
                                                            self.allCommentHasShown = true
                                                            self.navigationController?.pushViewController(viewController: commentViewController,
                                                                                                          animated: true,
                                                                                                          completion: {})
            }),
                                                    Action(title:"我要評價",
                                                           style:.normal,
                                                           color:KPColorPalette.KPMainColor.mainColor!,
                                                           icon:(R.image.icon_comment()?.withRenderingMode(.alwaysTemplate))!,
                                                           handler:{(infoView) -> () in
                                                            let newCommentViewController = KPNewCommentController()
                                                            self.navigationController?.pushViewController(viewController: newCommentViewController,
                                                                                                          animated: true,
                                                                                                          completion: {})
                                                    })
            ]
        }
        
        let photoInfoView = KPShopPhotoInfoView()
        photoInformationView = KPInformationSharedInfoView()
        photoInformationView.infoView = photoInfoView
        photoInformationView.infoTitleLabel.text = "店家照片"
        photoInformationView.infoSupplementLabel.text = "\(informationDataModel.photoCount ?? 0) 張照片"
        scrollContainer.addSubview(photoInformationView)
        photoInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$view0]-24-[$self]"],
                                                    views: [commentInformationView])
        photoInformationView.actions = [Action(title:"上傳照片",
                                                   style:.normal,
                                                   color:KPColorPalette.KPMainColor.mainColor!,
                                                   icon:(R.image.icon_map()?.withRenderingMode(.alwaysTemplate))!,
                                                   handler:{(infoView) -> () in
                                                    print("Photo button 1 Tapped")
        })]
        
        let shopRecommendView = KPShopRecommendView()
        shopRecommendView.displayDataModel = [informationDataModel,
                                              informationDataModel,
                                              informationDataModel]
        recommendInformationView = KPInformationSharedInfoView()
        recommendInformationView.infoView = shopRecommendView
        recommendInformationView.infoTitleLabel.text = "你可能也會喜歡"
        scrollContainer.addSubview(recommendInformationView)
        recommendInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-24-[$self]-32-|"],
                                                     views: [photoInformationView])
        
        syncRemoteData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let shopLocationInfoView = KPShopLocationInfoView()
        
        shopLocationInfoView.dataModel = informationDataModel
        locationInformationView.infoView = shopLocationInfoView
        navBarFixBound = navigationController!.navigationBar.bounds
        informationHeaderView.shopPhoto.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Fix table view height according to fix cell
//        commentInfoView = commentInformationView.infoView as! KPShopCommentInfoView
//        commentInfoView.tableViewHeightConstraint.constant = commentInfoView.tableView.contentSize.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UI Update
    
    func syncRemoteData() {
        
        dataLoading = true
        
        KPServiceHandler.sharedHandler.fetchStoreInformation(informationDataModel.identifier) {
            (result) in
            self.informationHeaderButtonBar.informationDataModel = result
            self.dataLoading = false
//                if result != nil, let comments = result?.comments {
//                    self.commentInfoView.comments = comments
//                }
        }
        
        // 取得 Comment 資料
        KPServiceHandler.sharedHandler.getComments { (successed, comments) in
            if successed && comments != nil {
                self.commentInfoView.comments = comments!
                self.commentInformationView.setNeedsLayout()
                self.commentInformationView.layoutIfNeeded()
                
                let commentInfoView = self.commentInformationView.infoView as! KPShopCommentInfoView
                commentInfoView.tableViewHeightConstraint.constant = commentInfoView.tableView.contentSize.height
            }
        }
        
        // 取得 Rating 資料
        KPServiceHandler.sharedHandler.getRatings { (successed, rating) in
            if successed {
                (self.rateInformationView.infoView as! KPShopRateInfoView).rateData = rating
            }
        }
        
        // 取得 Photo 資料
        KPServiceHandler.sharedHandler.getPhotos { (successed, photos) in
            
        }

        
    }
    
    // MARK: Animation
    
    func showInformationContents(_ animated: Bool) {
        
        informationHeaderButtonBar.isHidden = false
        shopInformationView.isHidden = false

        
        CATransaction.begin()
        CATransaction.setCompletionBlock { 
            self.informationHeaderButtonBar.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
            self.shopInformationView.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
        }
        
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.51, 0.98, 0.43, 1)
        let translateAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        translateAnimation.duration = 0.65
        translateAnimation.toValue = 0
        translateAnimation.isRemovedOnCompletion = false
        translateAnimation.fillMode = kCAFillModeBoth
        translateAnimation.timingFunction = timingFunction
        
        informationHeaderButtonBar.layer.add(translateAnimation, forKey: nil)
        shopInformationView.layer.add(translateAnimation, forKey: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.informationHeaderButtonBar.alpha = 1.0
                        self.shopInformationView.alpha = 1.0
        }) { (_) in
            self.scrollContainer.isUserInteractionEnabled = true
        }
        
        CATransaction.commit()
    }
    
    // MARK: UI Event
    
    func handleMorePhotoButtonOnTapped() {
        let galleryController = KPPhotoGalleryViewController()
        
        galleryController.diplayedPhotoInformations =
            [PhotoInformation(title:"Title", image:R.image.demo_1()!, index:0),
             PhotoInformation(title:"Title", image:R.image.demo_2()!, index:1),
             PhotoInformation(title:"Title", image:R.image.demo_3()!, index:2),
             PhotoInformation(title:"Title", image:R.image.demo_4()!, index:3),
             PhotoInformation(title:"Title", image:R.image.demo_5()!, index:4),
             PhotoInformation(title:"Title", image:R.image.demo_6()!, index:5)]
        
        dismissButton.isHidden = true
        navigationController?.pushViewController(viewController: galleryController,
                                                      animated: true,
                                                      completion: {}
        )
    }
    
    func handleOtherTimeButtonOnTapped() {
        
        let controller = KPModalViewController()
        let businessTimeViewController = KPBusinessTimeViewController()
        
        controller.contentSize = CGSize(width: 276, height: 416)
        controller.cornerRadius = [.topRight, .topLeft, .bottomLeft, .bottomRight]
        controller.dismissWhenTouchingOnBackground = true
        businessTimeViewController.businessTime = informationDataModel.businessHour
        businessTimeViewController.titleLabel.text = informationDataModel.name
        controller.contentController = businessTimeViewController
        controller.presentModalView()
    }
    
    func handleDismissButtonOnTapped() {
        
        if self.navigationController?.viewControllers.first is KPUserProfileViewController {
            self.navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func handleMoreButtonOnTapped() {
        present(actionController,
                animated: true,
                completion: nil)
    }
    
    func handleShareButtonOnTapped() {
        
    }
    
}


// MARK: View Transition

extension KPInformationViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let photoViewController = presented as? KPPhotoDisplayViewController {
            photoViewController.selectedIndexPath = currentPhotoIndexPath
            transitionController.setupImageTransition(informationHeaderView.shopPhoto.image!,
                                                      fromDelegate: self,
                                                      toDelegate: photoViewController)
            return transitionController
        } else {
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let photoViewController = dismissed as? KPPhotoDisplayViewController {
            currentPhotoIndexPath = photoViewController.selectedIndexPath
            transitionController.setupImageTransition(informationHeaderView.shopPhoto.image!,
                                                      fromDelegate: photoViewController,
                                                      toDelegate: self)
            return transitionController
        } else {
            return nil
        }
    }
}

extension KPInformationViewController: ImageTransitionProtocol {
    
    func tranisitionSetup(){
//        hideSelectedCell = true
    }
    
    func tranisitionCleanup(){
//        hideSelectedCell = false
    }
    
    // 3: return window frame of selected image
    func imageWindowFrame() -> CGRect{
        return view.convert(informationHeaderView.shopPhoto.frame, to: nil)
    }
}

extension KPInformationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if viewController is KPPhotoGalleryViewController {
            dismissButton.isHidden = true
        } else {
            dismissButton.isHidden = false
        }
    }
}

extension KPInformationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollContainer.contentOffset = CGPoint(x: 0,
                                                y: scrollContainer.contentOffset.y <= -120 ?
                                                    -120 :
                                                    scrollContainer.contentOffset.y)
        
        if scrollContainer.contentOffset.y < 0 && scrollContainer.contentOffset.y >= -120 {
            let scaleRatio = 1 - scrollContainer.contentOffset.y/300
            let scaleRatioContainer = 1 - scrollContainer.contentOffset.y/240
            let oldFrame = informationHeaderView.shopPhotoContainer.frame
            
            animatedHeaderConstraint.constant = 0
            informationHeaderView.shopPhoto.transform = .identity
            
            informationHeaderView.shopPhotoContainer.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            informationHeaderView.shopPhotoContainer.frame = oldFrame
            informationHeaderView.shopPhotoContainer.transform = .identity
            informationHeaderView.shopPhotoContainer.transform = CGAffineTransform(scaleX: scaleRatioContainer,
                                                                                   y: scaleRatioContainer)
            informationHeaderView.shopPhoto.transform = .identity
            informationHeaderView.shopPhoto.transform = CGAffineTransform(scaleX: scaleRatio,
                                                                          y: scaleRatio)
            
            self.view.layoutIfNeeded()
        } else if scrollContainer.contentOffset.y >= 0 && scrollContainer.contentOffset.y < 200 {
            animatedHeaderConstraint.constant = -scrollContainer.contentOffset.y*9/20
            informationHeaderView.shopPhoto.transform = CGAffineTransform(translationX: 0,
                                                                          y: scrollContainer.contentOffset.y*9/20)
            view.layoutIfNeeded()
        }
    }
}

extension KPInformationViewController: KPInformationHeaderViewDelegate {
    func headerPhotoTapped(_ headerView: KPInformationHeaderView) {
        let photoDisplayController = KPPhotoDisplayViewController()
//        let galleryController = KPPhotoGalleryViewController()
//        galleryController.view.isHidden = true
//        galleryController.view.backgroundColor = UIColor.clear
//        galleryController.view.backgroundColor = UIColor.init(patternImage: currentScreenSnapshotImage)
//        galleryController.navigationController?.view.isHidden = true
//        galleryController.navigationController?.setNavigationBarHidden(true, animated: false)
        
//        galleryController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        photoDisplayController.photoGalleryController = galleryController
        photoDisplayController.transitioningDelegate = self
//        headerView.shopPhoto.isHidden = true
        photoDisplayController.backgroundSnapshot = navigationController!.view.snapshotView(afterScreenUpdates: true)
        photoDisplayController.diplayedPhotoInformations =
            [PhotoInformation(title:"Title", image:R.image.demo_1()!, index:0),
             PhotoInformation(title:"Title", image:R.image.demo_2()!, index:1),
             PhotoInformation(title:"Title", image:R.image.demo_3()!, index:2),
             PhotoInformation(title:"Title", image:R.image.demo_4()!, index:3),
             PhotoInformation(title:"Title", image:R.image.demo_5()!, index:4),
             PhotoInformation(title:"Title", image:R.image.demo_6()!, index:5)]
        
        present(photoDisplayController, animated: true, completion: {
//            UIView.animate(withDuration: 0.5) { () -> Void in
//                photoDisplayController.setNeedsStatusBarAppearanceUpdate()
//            }
        })
//        navigationController?.pushViewController(viewController: galleryController,
//                                                      animated: false,
//                                                      completion: { 
//                                                        galleryController.present(photoDisplayController,
//                                                                                  animated: true) {
//                                                        }
//        })
//        
//        present(galleryController, animated: false) {
//            galleryController.present(photoDisplayController, animated: true) {
//            }
//        }
    }
}

extension UINavigationController {
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}

