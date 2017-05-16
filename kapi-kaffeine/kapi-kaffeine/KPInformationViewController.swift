//
//  KPDetailViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/11.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationViewController: UIViewController {

    
    var informationDataModel:KPDataModel!
    var dismissButton:UIButton!
    var snapshotPhotoView: UIView  {
        get {
            let snapShotView = UIImageView.init(image: self.informationHeaderView.shopPhoto.image)
            snapShotView.frame = self.informationHeaderView.shopPhoto.frame
            return snapShotView
        }
    }
    
    var currentScreenSnapshotImage: UIImage {
        get {
            UIGraphicsBeginImageContext(CGSize.init(width: self.view.frameSize.width,
                                                    height: self.view.frameSize.height));
            UIGraphicsBeginImageContextWithOptions(CGSize.init(width: self.view.frameSize.width,
                                                               height: self.view.frameSize.height),
                                                   true, 0)
            self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
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
        self.view.backgroundColor = UIColor.white;
        self.navigationItem.title = self.informationDataModel.name;
        self.navigationController?.delegate = self
        
        self.dismissButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
        self.dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                                    for: .normal);
        self.dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        self.dismissButton.addTarget(self,
                                     action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);

        let barItem = UIBarButtonItem.init(customView: self.dismissButton);
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        
        
//        self.navigationController?.navigationBar.addSubview(self.dismissButton);
//        self.dismissButton.addConstraints(fromStringArray: ["H:|-8-[$self(24)]",
//                                                            "V:[$self(24)]"]);
        self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
//        self.dismissButton.addConstraintForCenterAligningToSuperview(in: .vertical);
        
        self.scrollContainer = UIScrollView();
        self.scrollContainer.backgroundColor = KPColorPalette.KPMainColor.grayColor_level7;
        self.scrollContainer.delegate = self
        self.scrollContainer.canCancelContentTouches = false
        self.view.addSubview(self.scrollContainer);
        self.scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:|[$self]|"]);
        
        self.informationHeaderView = KPInformationHeaderView()
        self.informationHeaderView.delegate = self
        self.scrollContainer.addSubview(self.informationHeaderView)
        self.informationHeaderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                    "V:|[$self]"])
        self.informationHeaderView.addConstraintForHavingSameWidth(with: self.view)
        self.informationHeaderView.morePhotoButton.addTarget(self,
                                                             action: #selector(KPInformationViewController.handleMorePhotoButtonOnTapped),
                                                             for: UIControlEvents.touchUpInside)
        
        
        let informationView: KPShopInfoView = KPShopInfoView();
        informationView.featureContents = ["食物好吃", "氣氛佳", "看不見桌子"];
        self.shopInformationView = KPInformationSharedInfoView();
        self.shopInformationView.infoView = informationView;
        self.shopInformationView.infoTitleLabel.text = "店家資訊";
        self.scrollContainer.addSubview(self.shopInformationView);
        self.shopInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-16-[$self(210)]"],
                                                      views: [self.informationHeaderView]);
        
        self.locationInformationView = KPInformationSharedInfoView();
        self.locationInformationView.infoTitleLabel.text = "位置訊息";
        self.locationInformationView.infoSupplementLabel.text = "距離 600m";
        self.locationInformationView.actions = [Action(title:"開啟導航",
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
        
        self.scrollContainer.addSubview(self.locationInformationView);
        self.locationInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-24-[$self(292)]"],
                                                views: [self.shopInformationView]);
        
        let shopRateInfoView = KPShopRateInfoView();
        self.rateInformationView = KPInformationSharedInfoView();
        self.rateInformationView.infoView = shopRateInfoView;
        self.rateInformationView.infoTitleLabel.text = "店家評分";
        self.rateInformationView.infoSupplementLabel.text = "143 人已評分";
        self.rateInformationView.actions = [Action(title:"我要評分",
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
        self.scrollContainer.addSubview(self.rateInformationView);
        self.rateInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-24-[$self]"],
                                                views: [self.locationInformationView]);
        
        
        let commentInfoView = KPShopCommentInfoView();
        self.commentInformationView = KPInformationSharedInfoView();
        self.commentInformationView.infoView = commentInfoView;
        self.commentInformationView.infoTitleLabel.text = "留言評價";
        self.commentInformationView.infoSupplementLabel.text = "82 人已留言";
        self.scrollContainer.addSubview(self.commentInformationView);
        self.commentInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                     "V:[$view0]-24-[$self]"],
                                                    views: [self.rateInformationView]);
        self.commentInformationView.actions = [Action(title:"看更多評價(20)",
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
        self.photoInformationView = KPInformationSharedInfoView();
        self.photoInformationView.infoView = photoInfoView;
        self.photoInformationView.infoTitleLabel.text = "店家照片";
        self.scrollContainer.addSubview(self.photoInformationView);
        self.photoInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                   "V:[$view0]-24-[$self]"],
                                                    views: [self.commentInformationView]);
        self.photoInformationView.actions = [Action(title:"上傳照片",
                                                   style:.normal,
                                                   color:KPColorPalette.KPMainColor.mainColor!,
                                                   icon:(R.image.icon_map()?.withRenderingMode(.alwaysTemplate))!,
                                                   handler:{(infoView) -> () in
                                                    print("Photo button 1 Tapped");
        })]
        
        let shopRecommendView = KPShopRecommendView();
        shopRecommendView.displayDataModel = [self.informationDataModel,
                                              self.informationDataModel,
                                              self.informationDataModel];
        self.recommendInformationView = KPInformationSharedInfoView();
        self.recommendInformationView.infoView = shopRecommendView;
        self.recommendInformationView.infoTitleLabel.text = "你可能也會喜歡";
        self.scrollContainer.addSubview(self.recommendInformationView);
        self.recommendInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                       "V:[$view0]-24-[$self]-32-|"],
                                                     views: [self.photoInformationView]);
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        let shopLocationInfoView = KPShopLocationInfoView();
        shopLocationInfoView.dataModel = informationDataModel
        self.locationInformationView.infoView = shopLocationInfoView;
        
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
        
        self.dismissButton.isHidden = true
        self.navigationController?.pushViewController(viewController: galleryController,
                                                      animated: true,
                                                      completion: {}
        )
    }
    
    func handleDismissButtonOnTapped() {
        self.dismiss(animated: true, completion: nil);
    }
    
}

extension KPInformationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if viewController is KPPhotoGalleryViewController {
            self.dismissButton.isHidden = true
        } else {
            self.dismissButton.isHidden = false
        }
    }
}

extension KPInformationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollContainer.contentOffset = CGPoint.init(x: 0,
                                                          y: self.scrollContainer.contentOffset.y)
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
        
        self.present(photoDisplayController, animated: true, completion: {
//            UIView.animate(withDuration: 0.5) { () -> Void in
//                photoDisplayController.setNeedsStatusBarAppearanceUpdate()
//            }
        })
//        self.navigationController?.pushViewController(viewController: galleryController,
//                                                      animated: false,
//                                                      completion: { 
//                                                        galleryController.present(photoDisplayController,
//                                                                                  animated: true) {
//                                                        }
//        })
//        
//        self.present(galleryController, animated: false) {
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

