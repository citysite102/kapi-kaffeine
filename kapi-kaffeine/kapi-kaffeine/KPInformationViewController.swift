//
//  KPDetailViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/11.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationViewController: KPViewController {

    
    var informationDataModel: KPDataModel! {
        didSet {
            KPServiceHandler.sharedHandler.currentDisplayModel = informationDataModel
        }
    }
    
    var dismissButton: KPBounceButton!
    var moreButton: KPBounceButton!
    var shareButton: KPBounceButton!
    
    
    var snapshotPhotoView: UIView  {
        get {
            let snapShotView = UIImageView.init(image: informationHeaderView.shopPhoto.image)
            snapShotView.frame = informationHeaderView.shopPhoto.frame
            return snapShotView
        }
    }
    
    var currentScreenSnapshotImage: UIImage {
        get {
            UIGraphicsBeginImageContext(CGSize.init(width: view.frameSize.width,
                                                    height: view.frameSize.height))
            UIGraphicsBeginImageContextWithOptions(CGSize.init(width: view.frameSize.width,
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
    
    var allCommentHasShown: Bool = false
    var animatedHeaderConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = informationDataModel.name
        navigationController?.delegate = self
        
        dismissButton = KPBounceButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        dismissButton.setImage(R.image.icon_close(),
                                    for: .normal)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        
        moreButton = KPBounceButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        moreButton.setImage(R.image.icon_grid(),
                            for: .normal)
        moreButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        moreButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        moreButton.addTarget(self,
                             action: #selector(KPInformationViewController.handleMoreButtonOnTapped),
                             for: .touchUpInside)
        
        shareButton = KPBounceButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        shareButton.setImage(R.image.icon_grid(),
                            for: .normal)
        shareButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        shareButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        shareButton.addTarget(self,
                              action: #selector(KPInformationViewController.handleShareButtonOnTapped),
                              for: .touchUpInside)
        

        let barItem = UIBarButtonItem.init(customView: dismissButton)
        let rightBarItem = UIBarButtonItem.init(customView: moreButton)
//        let rightBarItem2 = UIBarButtonItem.init(customView: shareButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightBarItem]
        
        
        actionController = UIAlertController(title: nil,
                                             message: nil,
                                             preferredStyle: .actionSheet)
        actionController.view.tintColor = KPColorPalette.KPTextColor.mainColor_light
        let editButton = UIAlertAction(title: "編輯店家資料",
                                       style: .default) { (_) in
                                        print("編輯店家資料")
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
        if let photoURL = informationDataModel.photos?["google_l"] {
            
            informationHeaderView.shopPhoto.af_setImage(withURL: URL(string: photoURL)!,
                                                        placeholderImage: R.image.demo_1()!,
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
        
        informationHeaderButtonBar = KPInformationHeaderButtonBar(frame: CGRect.zero,
                                                                  cafeIdentifier: informationDataModel.identifier)
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
        informationView.locationLabel.text = informationDataModel.address
        informationView.phoneLabel.text = informationDataModel.phone
        
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
                                                    print("Location button 1 Tapped")
                                                    
                                                    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                                                        UIApplication.shared.open(URL(string:
                                                            "comgooglemaps://?daddr=\(self.informationDataModel.latitude!),\(self.informationDataModel.longitude!)&mapmode=standard")!, options: [:], completionHandler: nil)
                                                    } else {
                                                        print("Can't use comgooglemaps://")
                                                    }
        }),
                                                Action(title:"街景模式",
                                                 style:.normal,
                                                 color:KPColorPalette.KPMainColor.mainColor!,
                                                 icon:(R.image.icon_map()?.withRenderingMode(.alwaysTemplate))!,
                                                 handler:{(infoView) -> () in
                                                    print("Location button 2 Tapped")
                                                    
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
        if informationDataModel.rates != nil {
            shopRateInfoView.rates = informationDataModel.rates
        }
        rateInformationView = KPInformationSharedInfoView()
        rateInformationView.infoView = shopRateInfoView
        rateInformationView.infoTitleLabel.text = "店家評分"
        rateInformationView.infoSupplementLabel.text = "143 人已評分"
        rateInformationView.actions = [Action(title:"我要評分",
                                                   style:.normal,
                                                   color:KPColorPalette.KPMainColor.mainColor!,
                                                   icon:(R.image.icon_star()?.withRenderingMode(.alwaysTemplate))!,
                                                   handler:{(infoView) -> () in
                                                    let controller = KPModalViewController()
                                                    controller.edgeInset = UIEdgeInsets.init(top: UIDevice().isCompact ? 16 : 48,
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
        commentInformationView.infoSupplementLabel.text = "82 人已留言"
        scrollContainer.addSubview(commentInformationView)
        commentInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                "V:[$view0]-24-[$self]"],
                                                    views: [rateInformationView])
        commentInformationView.actions = [Action(title:"看更多評價(20)",
                                                      style:.normal,
                                                      color:KPColorPalette.KPMainColor.mainColor!,
                                                      icon:nil,
                                                      handler:{(infoView) -> () in
                                                        let commentViewController = KPAllCommentController()
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
        
        let photoInfoView = KPShopPhotoInfoView()
        photoInformationView = KPInformationSharedInfoView()
        photoInformationView.infoView = photoInfoView
        photoInformationView.infoTitleLabel.text = "店家照片"
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
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Fix table view height according to fix cell
        commentInfoView = commentInformationView.infoView as! KPShopCommentInfoView
        commentInfoView.tableViewHeightConstraint.constant = commentInfoView.tableView.contentSize.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UI Update
    
    func syncRemoteData() {
        
        KPServiceHandler.sharedHandler.getComments { (successed, comments) in
            if successed && comments != nil {
                self.commentInfoView.comments = comments!
            }
        }
        
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
    
    func handleDismissButtonOnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleMoreButtonOnTapped() {
        present(actionController,
                animated: true,
                completion: nil)
    }
    
    func handleShareButtonOnTapped() {
        
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
        
//        print("Offset:\(scrollContainer.contentOffset.y)")
        
        scrollContainer.contentOffset = CGPoint.init(x: 0,
                                                     y: scrollContainer.contentOffset.y <= -120 ?
                                                        -120 :
                                                        scrollContainer.contentOffset.y)
        
        if scrollContainer.contentOffset.y < 0 && scrollContainer.contentOffset.y >= -120 {
            let scaleRatio = 1 - scrollContainer.contentOffset.y/300
            let scaleRatioContainer = 1 - scrollContainer.contentOffset.y/240
            let oldFrame = informationHeaderView.shopPhotoContainer.frame
            
            animatedHeaderConstraint.constant = 0
            informationHeaderView.shopPhoto.transform = .identity
            
            informationHeaderView.shopPhotoContainer.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
            informationHeaderView.shopPhotoContainer.frame = oldFrame
            informationHeaderView.shopPhotoContainer.transform = .identity
            informationHeaderView.shopPhotoContainer.transform = CGAffineTransform(scaleX: scaleRatioContainer,
                                                                                   y: scaleRatioContainer)
            informationHeaderView.shopPhoto.transform = .identity
            informationHeaderView.shopPhoto.transform = CGAffineTransform(scaleX: scaleRatio,
                                                                          y: scaleRatio)
            self.view.layoutIfNeeded()
        } else if scrollContainer.contentOffset.y >= 0 && scrollContainer.contentOffset.y < 150 {
            animatedHeaderConstraint.constant = -scrollContainer.contentOffset.y*3/5
            informationHeaderView.shopPhoto.transform = CGAffineTransform(translationX: 0,
                                                                          y: scrollContainer.contentOffset.y*3/5)
            self.view.layoutIfNeeded()
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

