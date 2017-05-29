//
//  KPDetailViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/11.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationViewController: KPViewController {

    
    var informationDataModel: KPDataModel!
    var dismissButton:UIButton!
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
                                                    height: view.frameSize.height));
            UIGraphicsBeginImageContextWithOptions(CGSize.init(width: view.frameSize.width,
                                                               height: view.frameSize.height),
                                                   true, 0)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshotImage!
        }
    }
    
    var scrollContainer:UIScrollView!;
    var informationHeaderView: KPInformationHeaderView!;
    var shopInformationView: KPInformationSharedInfoView!;
    var locationInformationView: KPInformationSharedInfoView!;
    var rateInformationView: KPInformationSharedInfoView!;
    var commentInformationView: KPInformationSharedInfoView!;
    var photoInformationView: KPInformationSharedInfoView!;
    var recommendInformationView: KPInformationSharedInfoView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        navigationItem.title = informationDataModel.name;
        navigationController?.delegate = self
        
        dismissButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                                    for: .normal);
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        dismissButton.addTarget(self,
                                     action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);

        let barItem = UIBarButtonItem.init(customView: dismissButton);
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        
        
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        
        scrollContainer = UIScrollView();
        scrollContainer.backgroundColor = KPColorPalette.KPMainColor.grayColor_level7;
        scrollContainer.delegate = self
        scrollContainer.canCancelContentTouches = false
        view.addSubview(scrollContainer);
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"]);
        
        informationHeaderView = KPInformationHeaderView()
        informationHeaderView.delegate = self
        if let photoURL = informationDataModel.photos?["google_l"] {
            informationHeaderView.shopPhoto.af_setImage(withURL: URL(string: photoURL)!,
                                                        placeholderImage: R.image.demo_1())
        }
        //informationDataModel
        scrollContainer.addSubview(informationHeaderView)
        informationHeaderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                               "V:|[$self]"])
        informationHeaderView.addConstraintForHavingSameWidth(with: view)
        informationHeaderView.morePhotoButton.addTarget(self,
                                                             action: #selector(KPInformationViewController.handleMorePhotoButtonOnTapped),
                                                             for: UIControlEvents.touchUpInside)
        
        
        let informationView: KPShopInfoView = KPShopInfoView();
        informationView.featureContents = informationDataModel.featureContents
        informationView.titleLabel.text = informationDataModel.name
        informationView.locationLabel.text = informationDataModel.address
        informationView.phoneLabel.text = informationDataModel.phone
        shopInformationView = KPInformationSharedInfoView();
        shopInformationView.infoView = informationView;
        shopInformationView.infoTitleLabel.text = "店家資訊";
        scrollContainer.addSubview(shopInformationView);
        shopInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-16-[$self(210)]"],
                                                      views: [informationHeaderView]);
        
        locationInformationView = KPInformationSharedInfoView();
        locationInformationView.infoTitleLabel.text = "位置訊息";
        locationInformationView.infoSupplementLabel.text = "距離 600m";
        locationInformationView.actions = [Action(title:"開啟導航",
                                                 style:.normal,
                                                 color:KPColorPalette.KPMainColor.mainColor!,
                                                 icon:(R.image.icon_map()?.withRenderingMode(.alwaysTemplate))!,
                                                 handler:{(infoView) -> () in
                                                    print("Location button 1 Tapped");
        }),
                                                Action(title:"街景模式",
                                                 style:.normal,
                                                 color:KPColorPalette.KPMainColor.mainColor!,
                                                 icon:(R.image.icon_map()?.withRenderingMode(.alwaysTemplate))!,
                                                 handler:{(infoView) -> () in
                                                    print("Location button 2 Tapped");
                                                })
        ];
        
        scrollContainer.addSubview(locationInformationView);
        locationInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                 "V:[$view0]-24-[$self(292)]"],
                                                views: [shopInformationView]);
        
        let shopRateInfoView = KPShopRateInfoView();
        shopRateInfoView.rates = informationDataModel.rates
        rateInformationView = KPInformationSharedInfoView();
        rateInformationView.infoView = shopRateInfoView;
        rateInformationView.infoTitleLabel.text = "店家評分";
        rateInformationView.infoSupplementLabel.text = "143 人已評分";
        rateInformationView.actions = [Action(title:"我要評分",
                                                   style:.normal,
                                                   color:KPColorPalette.KPMainColor.mainColor!,
                                                   icon:(R.image.icon_map()?.withRenderingMode(.alwaysTemplate))!,
                                                   handler:{(infoView) -> () in
                                                    let controller = KPModalViewController()
                                                    controller.edgeInset = UIEdgeInsets.init(top: UIDevice().isCompact ? 16 : 48,
                                                                                             left: 0,
                                                                                             bottom: 0,
                                                                                             right: 0);
                                                    controller.cornerRadius = [.topRight, .topLeft]
                                                    let ratingViewController = KPRatingViewController()
                                                    controller.contentController = ratingViewController;
                                                    controller.presentModalView();
        })];
        scrollContainer.addSubview(rateInformationView);
        rateInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-24-[$self]"],
                                                views: [locationInformationView]);
        
        
        let commentInfoView = KPShopCommentInfoView();
        commentInformationView = KPInformationSharedInfoView();
        commentInformationView.infoView = commentInfoView;
        commentInformationView.infoTitleLabel.text = "留言評價";
        commentInformationView.infoSupplementLabel.text = "82 人已留言";
        scrollContainer.addSubview(commentInformationView);
        commentInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                "V:[$view0]-24-[$self]"],
                                                    views: [rateInformationView]);
        commentInformationView.actions = [Action(title:"看更多評價(20)",
                                                      style:.normal,
                                                      color:KPColorPalette.KPMainColor.mainColor!,
                                                      icon:(R.image.icon_map()?.withRenderingMode(.alwaysTemplate))!,
                                                      handler:{(infoView) -> () in
                                                        let commentViewController = KPAllCommentController()
                                                        self.navigationController?.pushViewController(viewController: commentViewController,
                                                                                                      animated: true,
                                                                                                      completion: {})
        }),
                                                Action(title:"我要留言",
                                                       style:.normal,
                                                       color:KPColorPalette.KPMainColor.mainColor!,
                                                       icon:(R.image.icon_map()?.withRenderingMode(.alwaysTemplate))!,
                                                       handler:{(infoView) -> () in
                                                        let newCommentViewController = KPNewCommentController()
                                                        self.navigationController?.pushViewController(viewController: newCommentViewController,
                                                                                                      animated: true,
                                                                                                      completion: {})
                                                })
        ];
        
        
        let photoInfoView = KPShopPhotoInfoView();
        photoInformationView = KPInformationSharedInfoView();
        photoInformationView.infoView = photoInfoView;
        photoInformationView.infoTitleLabel.text = "店家照片";
        scrollContainer.addSubview(photoInformationView);
        photoInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$view0]-24-[$self]"],
                                                    views: [commentInformationView]);
        photoInformationView.actions = [Action(title:"上傳照片",
                                                   style:.normal,
                                                   color:KPColorPalette.KPMainColor.mainColor!,
                                                   icon:(R.image.icon_map()?.withRenderingMode(.alwaysTemplate))!,
                                                   handler:{(infoView) -> () in
                                                    print("Photo button 1 Tapped");
        })]
        
        let shopRecommendView = KPShopRecommendView();
        shopRecommendView.displayDataModel = [informationDataModel,
                                              informationDataModel,
                                              informationDataModel];
        recommendInformationView = KPInformationSharedInfoView();
        recommendInformationView.infoView = shopRecommendView;
        recommendInformationView.infoTitleLabel.text = "你可能也會喜歡";
        scrollContainer.addSubview(recommendInformationView);
        recommendInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-24-[$self]-32-|"],
                                                     views: [photoInformationView]);
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        let shopLocationInfoView = KPShopLocationInfoView();
        shopLocationInfoView.dataModel = informationDataModel
        locationInformationView.infoView = shopLocationInfoView;
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Fix table view height according to fix cell
        let commentInfoView = commentInformationView.infoView as! KPShopCommentInfoView
        commentInfoView.tableViewHeightConstraint.constant = commentInfoView.tableView.contentSize.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
        dismiss(animated: true, completion: nil);
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
        
        
        scrollContainer.contentOffset = CGPoint.init(x: 0, y: scrollContainer.contentOffset.y)
        
        if scrollContainer.contentOffset.y < 0 && scrollContainer.contentOffset.y > -100 {
            let scaleRatio = 1 - scrollContainer.contentOffset.y/250
            let scaleRatioContainer = 1 - scrollContainer.contentOffset.y/250 + 0.02
            let oldFrame = informationHeaderView.shopPhotoContainer.frame
            informationHeaderView.shopPhotoContainer.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
            informationHeaderView.shopPhotoContainer.frame = oldFrame
            informationHeaderView.shopPhotoContainer.transform = CGAffineTransform.identity
            informationHeaderView.shopPhotoContainer.transform = CGAffineTransform.init(scaleX: scaleRatioContainer,
                                                                                        y: scaleRatioContainer)
            informationHeaderView.shopPhoto.transform = CGAffineTransform.identity
            informationHeaderView.shopPhoto.transform = CGAffineTransform.init(scaleX: scaleRatio,
                                                                               y: scaleRatio)
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

