//
//  KPDetailViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/11.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import MapKit
import BenzeneFoundation
import SKPhotoBrowser


class KPInformationViewController: KPViewController {

    var informationDataModel: KPDataModel! {
        didSet {
            KPServiceHandler.sharedHandler.currentDisplayModel = informationDataModel
        }
    }
    
    var detailedInformationDataModel: KPDetailedDataModel! {
        didSet {
            
        }
    }
    
    var viewHasAppeared: Bool = false
    var showBackButton: Bool = false
    var dismissWithDefaultType: Bool = false
    
    // 取得相關的所有評分資訊
    var rateDataModel: KPRateDataModel?
    
    // 取得相關的評論資訊
    var hasCommentDataModel: KPCommentModel?
    var comments: [KPCommentModel?] = [KPCommentModel?]()
    
    // 取得已評分過的評分資訊
    var hasRatedDataModel: KPSimpleRateModel?
    var dismissButton: KPBounceButton!
    var moreButton: KPBounceButton!
    var shareButton: KPBounceButton!
    
    var titleLabel: UILabel!
    var topBarContainer: UIView!
    var separator_top: UIView!
    
    var toolBarContainer: UIView!
    var separator: UIView!
    
    
    var transitionController: KPPhotoDisplayTransition = KPPhotoDisplayTransition()
    var percentDrivenTransition: UIPercentDrivenInteractiveTransition!
    var currentPhotoIndexPath: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
        
            informationHeaderView.shopPhoto.af_setImage(withURL: displayPhotoInformations[currentPhotoIndexPath.row].imageURL,
                                                        placeholderImage: UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level6!),
                                                        filter: nil,
                                                        progress: nil,
                                                        progressQueue: DispatchQueue.global(),
                                                        imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                                        runImageTransitionIfCached: false,
                                                        completion: nil)
        }
    }
    
    var displayPhotoInformations: [PhotoInformation] = [] {
        didSet {
            (photoInformationView.infoView as! KPShopPhotoInfoView).displayPhotoInformations = displayPhotoInformations
        }
    }
    
    var displayMenuInformations: [PhotoInformation] = [] {
        didSet {
            (menuInformationView.infoView as! KPShopPhotoInfoView).displayPhotoInformations = displayMenuInformations
        }
    }
    
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
    var mapActionController: UIAlertController!
    var scrollContainer: UIScrollView!
    var informationHeaderView: KPInformationHeaderView!
    var informationHeaderButtonBar: KPInformationHeaderButtonBar!
    
    var cardInformationContainer: KPInformationCardView!
    var shopInformationView: KPInformationSharedInfoView!
    var locationInformationView: KPInformationSharedInfoView!
    var rateInformationView: KPInformationSharedInfoView!
    var commentInformationView: KPInformationSharedInfoView!
    var photoInformationView: KPInformationSharedInfoView!
    var menuInformationView: KPInformationSharedInfoView!
    
    enum ImagePickerType {
        case photo
        case menu
        case none
    }
    
    var pickerType: ImagePickerType = .none
    
    var recommendInformationView: KPInformationSharedInfoView!
    var commentInfoView: KPShopCommentInfoView!
    var informationView: KPShopInfoView!
    var loadingIndicator: UIActivityIndicatorView!
    var currentPhotoIndex: Int!
    lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level5
        label.text = "載入中..."
        return label
    }()
    
    lazy var addButton: KPShadowButton = {
        let shadowButton = KPShadowButton()
        shadowButton.button.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.whiteColor!), for: .normal)
        shadowButton.button.setImage(R.image.icon_add(), for: .normal)
        
        shadowButton.button.tintColor = KPColorPalette.KPMainColor_v2.mainColor
        shadowButton.button.imageView?.contentMode = .scaleAspectFit
//        shadowButton.button.imageEdgeInsets = UIEdgeInsets(top: 6,
//                                                           left: 6,
//                                                           bottom: 6,
//                                                           right: 6)
        shadowButton.layer.cornerRadius = 30
        return shadowButton
    }()
    
    var allCommentHasShown: Bool = false
    var dataLoading: Bool = true {
        didSet {
            if dataLoading {
                self.informationHeaderButtonBar.isHidden = true
                self.informationHeaderButtonBar.alpha = 0.0
                
                self.shopInformationView.isHidden = true
                self.shopInformationView.alpha = 0.0
                
                self.locationInformationView.isHidden = true
                self.locationInformationView.alpha = 0.0
                
                self.informationHeaderButtonBar.layer.transform = CATransform3DMakeTranslation(0, 55, 0)
                self.shopInformationView.layer.transform = CATransform3DMakeTranslation(0, 75, 0)
                self.locationInformationView.layer.transform = CATransform3DMakeTranslation(0, 95, 0)
                
                self.scrollContainer.isUserInteractionEnabled = false
            } else {
                self.loadingIndicator.stopAnimating()
                self.loadingLabel.isHidden = true
                self.showInformationContents(true)
            }
        }
    }
    var animatedHeaderConstraint: NSLayoutConstraint!
    var navBarFixBound: CGRect!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if KPPopoverView.sharedPopoverView.contentView != nil {
            KPPopoverView.sharedPopoverView.dismiss()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KPAnalyticManager.sendPageViewEvent(KPAnalyticsEventValue.page.detail_page)
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        navigationItem.title = informationDataModel.name
        navigationController?.delegate = self
        
        actionController = UIAlertController(title: nil,
                                             message: nil,
                                             preferredStyle: .actionSheet)
        let editButton = UIAlertAction(title: "編輯店家資料",
                                       style: .default) {
                                        [unowned self] (_) in
//                                        let controller = KPModalViewController()
//                                        controller.edgeInset = UIEdgeInsets(top: 0,
//                                                                            left: 0,
//                                                                            bottom: 0,
//                                                                            right: 0)
//                                        let newStoreController = KPNewStoreController(.modify)
//                                        newStoreController.dataModel = self.informationDataModel
//                                        newStoreController.rateDataModel = self.hasRatedDataModel
//                                        let navigationController =
//                                            UINavigationController(rootViewController: newStoreController)
//                                        controller.contentController = navigationController
//                                        controller.presentModalView()
        }
        
        let reportButton = UIAlertAction(title: "錯誤回報",
                                         style: .default) { (_) in
                                            let controller = KPModalViewController()
                                            controller.edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                            let settingController = KPReportController()
                                            let navigationController = UINavigationController(rootViewController: settingController)
                                            controller.contentController = navigationController
                                            controller.presentModalView()
        }
        
        let closeButton = UIAlertAction(title: "回報店家已歇業",
                                        style: .default) {(_) in
                                            KPServiceHandler.sharedHandler.reportStoreClosed({ (_) in
                                                
                                            })
        }
        
        let cancelButton = UIAlertAction(title: "取消",
                                         style: .destructive) { (_) in
                                            print("取消")
        }
        
        actionController.addAction(editButton)
        actionController.addAction(reportButton)
        actionController.addAction(closeButton)
        actionController.addAction(cancelButton)
        
        
        mapActionController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        mapActionController.view.tintColor = KPColorPalette.KPTextColor.grayColor_level2
        let googleAction = UIAlertAction(title: "使用Google地圖開啟",
                                       style: .default) {
                                        [weak self] (_) in
                                        if let weSelf = self {
                                            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                                                UIApplication.shared.open(URL(string:
                                                    "comgooglemaps://?daddr=\(weSelf.informationDataModel.latitude!),\(weSelf.informationDataModel.longitude!)&mapmode=standard")!,
                                                                          options: [:],
                                                                          completionHandler: nil)
                                            } else {
                                                print("Can't use comgooglemaps://")
                                            }
                                        }

        }
        
        let appleAction = UIAlertAction(title: "使用地圖開啟",
                                         style: .default) {
                                            [weak self] (_) in
                                            if let weSelf = self {
                                                let coordinates = CLLocationCoordinate2DMake(weSelf.informationDataModel.latitude!,
                                                                                             weSelf.informationDataModel.longitude!)
                                                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                                                let mapItem = MKMapItem(placemark: placemark)
                                                mapItem.openInMaps(launchOptions: nil)
                                            }
        }
        
        let mapCancelAction = UIAlertAction(title: "取消",
                                            style: .destructive) { (_) in
                                                print("取消 Map")
        }
        
        mapActionController.addAction(googleAction)
        mapActionController.addAction(appleAction)
        mapActionController.addAction(mapCancelAction)

        scrollContainer = UIScrollView()
        scrollContainer.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        scrollContainer.delegate = self
        scrollContainer.canCancelContentTouches = false
        view.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        
        informationHeaderView = KPInformationHeaderView(frame: CGRect.zero)
        informationHeaderView.delegate = self
        informationHeaderView.informationController = self
        informationHeaderView.scoreLabel.text = String(format: "%.1f", informationDataModel.averageRate?.doubleValue ?? 0.0)
        informationHeaderView.facebookButton.isHidden = !(informationDataModel.facebookURL != nil)
        informationHeaderView.shopPhoto.image = R.image.demo_7()
        
//        if let photoURL = informationDataModel.covers?["kapi_l"] ?? informationDataModel.covers?["google_l"] {
//            informationHeaderView.shopPhoto.af_setImage(withURL: URL(string: photoURL)!,
//                                                        placeholderImage: nil,
//                                                        filter: nil,
//                                                        progress: nil,
//                                                        progressQueue: DispatchQueue.global(),
//                                                        imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
//                                                        runImageTransitionIfCached: true,
//                                                        completion: { response in
//                                                            if let responseImage = response.result.value {
//                                                                self.informationHeaderView.shopPhoto.image =  responseImage
//                                                            }
//                })
//        } else {
//
//        }
        
        //informationDataModel
        scrollContainer.addSubview(informationHeaderView)
        informationHeaderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                               "V:|-(-20)-[$self]"])
        
        informationHeaderView.addConstraintForHavingSameWidth(with: view)
        informationHeaderView.morePhotoButton.addTarget(self,
                                                        action: #selector(KPInformationViewController.handleMorePhotoButtonOnTapped),
                                                        for: UIControlEvents.touchUpInside)
        informationHeaderView.facebookButton.addTarget(self,
                                                       action: #selector(KPInformationViewController.handleFacebookButtonOnTapped),
                                                        for: UIControlEvents.touchUpInside)
        informationHeaderView.scoreHandler = {
            [weak self] () -> Void in
            if let weSelf = self {
                if var rates = weSelf.rateDataModel?.rates {
                    
                    if let cafeModel = weSelf.rateDataModel?.base {
                        cafeModel.displayName = "Cafe Nomad"
                        rates.append(cafeModel)
                    }
                    
                    if rates.count > 0 {
                        let allRatingController = KPAllRatingViewController()
                        allRatingController.ratings = rates
                        print("RatesInfo:\(rates)")
                        weSelf.navigationController?.pushViewController(viewController: allRatingController,
                                                                 animated: true,
                                                                 completion: {}
                        )
                    }
                }
            }
        }
        
        
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator.tintColor = KPColorPalette.KPMainColor_v2.mainColor
        scrollContainer.addSubview(loadingIndicator)
        loadingIndicator.addConstraints(fromStringArray: ["V:[$view0]-24-[$self]"],
                                        views:[informationHeaderView])
        loadingIndicator.addConstraintForCenterAligningToSuperview(in: .horizontal)
        loadingIndicator.startAnimating()
        
        scrollContainer.addSubview(loadingLabel)
        loadingLabel.isHidden = true
        loadingLabel.addConstraints(fromStringArray: ["V:[$view0]-10-[$self]"],
                                    views:[loadingIndicator])
        loadingLabel.addConstraintForCenterAligningToSuperview(in: .horizontal,
                                                               constant:2)
        
        cardInformationContainer = KPInformationCardView()
        scrollContainer.addSubview(cardInformationContainer)
        cardInformationContainer.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                                  "V:[$view0]-(-70)-[$self(140)]"],
                                                views: [informationHeaderView])
        
        informationView = KPShopInfoView(informationDataModel)
//        informationView.otherTimeButton.addTarget(self,
//                                                  action: #selector(KPInformationViewController.handleOtherTimeButtonOnTapped),
//                                                  for: .touchUpInside)
//
//        if informationDataModel.businessHour != nil {
//            let shopStatus = informationDataModel.businessHour!.shopStatus
//            informationView.openLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1
//            informationView.openLabel.text = shopStatus.status
//            informationView.openHint.backgroundColor = shopStatus.isOpening ?
//                KPColorPalette.KPShopStatusColor.opened :
//                KPColorPalette.KPShopStatusColor.closed
//        } else {
//            informationView.openLabel.textColor = KPColorPalette.KPTextColor.grayColor_level5
//            informationView.openHint.backgroundColor = KPColorPalette.KPTextColor.grayColor_level5
//            informationView.openLabel.text = "暫無資料"
//            informationView.otherTimeButton.isHidden = true
//        }
        
        shopInformationView = KPInformationSharedInfoView()
        shopInformationView.infoView = informationView
        shopInformationView.infoTitleLabel.text = "店家資訊"
        scrollContainer.addSubview(shopInformationView)
        shopInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-100-[$self]"],
                                           views: [informationHeaderView])
        
        
        
        commentInfoView = KPShopCommentInfoView()
        commentInfoView.informationController = self
        commentInformationView = KPInformationSharedInfoView()
        commentInformationView.emptyLabel.text = "幫忙給點建議或分享吧:D"
        commentInformationView.infoView = commentInfoView
        commentInformationView.infoTitleLabel.text = "留言評論"
        commentInformationView.infoSupplementLabel.text = "查看所有評論"
        scrollContainer.addSubview(commentInformationView)
        commentInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                "V:[$view0]-24-[$self]"],
                                              views: [shopInformationView])
        
//        if let commentCount = informationDataModel.commentCount {
//            commentInformationView.infoSupplementLabel.text = "\(commentCount) 人已留言"
//            commentInformationView.isEmpty = (commentCount == 0)
//            updateCommentsLayout(Int(truncating: commentCount))
//        }
        
        
        let photoInfoView = KPShopPhotoInfoView()
        photoInfoView.informationController = self
        photoInformationView = KPInformationSharedInfoView()
        photoInformationView.emptyLabel.text = "成為第一個上傳的人吧:D"
        photoInformationView.infoView = photoInfoView
        photoInformationView.infoTitleLabel.text = "店家照片"
        photoInformationView.infoSupplementLabel.text = "查看所有照片"
        scrollContainer.addSubview(photoInformationView)
        photoInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$view0]-24-[$self]"],
                                            views: [commentInformationView])
        //        photoInformationView.actions = [Action(title: "上傳照片",
        //                                               style:.normal,
        //                                               color:KPColorPalette.KPMainColor_v2.mainColor!,
        //                                               icon:(R.image.icon_camera()?.withRenderingMode( .alwaysTemplate))!,
        //                                               handler:{[unowned self] (infoView) -> () in
        //                                                self.photoUpload()
        //        })]
        
        
        
        let menuInfoView = KPShopPhotoInfoView()
        menuInfoView.isMenu = true
        menuInfoView.informationController = self
        menuInformationView = KPInformationSharedInfoView()
        menuInformationView.emptyLabel.text = "成為第一個上傳的人吧:D"
        menuInformationView.infoView = menuInfoView
        menuInformationView.infoTitleLabel.text = "菜單"
        scrollContainer.addSubview(menuInformationView)
        menuInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-(-8)-[$self]"],
                                           views: [photoInformationView])
        //        menuInformationView.actions = [Action(title: "上傳菜單",
        //                                               style:.normal,
        //                                               color:KPColorPalette.KPMainColor_v2.mainColor!,
        //                                               icon:(R.image.icon_camera()?.withRenderingMode( .alwaysTemplate))!,
        //                                               handler:{[unowned self] (infoView) -> () in
        //                                                self.menuUpload()
        //        })]
        
        scrollContainer.bringSubview(toFront: photoInformationView)
        
        
        
        

        let shopRateInfoView = KPShopRateInfoView()
        shopRateInfoView.dataModel = informationDataModel
        rateInformationView = KPInformationSharedInfoView()
        rateInformationView.infoView = shopRateInfoView
        rateInformationView.infoTitleLabel.text = "店家評分"
        rateInformationView.infoSupplementLabel.text = "\(informationDataModel.rateCount ?? 0) 人已評分"
//        rateInformationView.actions = [Action(title:"我要評分",
//                                              style:.normal,
//                                              color:KPColorPalette.KPMainColor_v2.mainColor!,
//                                              icon:(R.image.icon_star()?.withRenderingMode(.alwaysTemplate))!,
//                                              handler:{
//                                                [weak self] (infoView) -> () in
//                                                if let weSelf = self {
//                                                    if KPUserManager.sharedManager.currentUser == nil {
//                                                        KPPopoverView.popoverLoginView()
//                                                    } else {
//                                                        if KPServiceHandler.sharedHandler.isCurrentShopClosed {
//                                                            KPPopoverView.popoverClosedView()
//                                                        } else {
//                                                            let controller = KPModalViewController()
//                                                            controller.edgeInset = UIEdgeInsets(top: UIDevice().isSuperCompact ? 32 : 72,
//                                                                                                    left: 0,
//                                                                                                    bottom: 0,
//                                                                                                    right: 0)
//                                                            controller.cornerRadius = [.topRight, .topLeft]
//                                                            let ratingViewController = KPRatingViewController()
//
//                                                            if weSelf.hasRatedDataModel != nil {
//                                                                ratingViewController.defaultRateModel = weSelf.hasRatedDataModel
//                                                            }
//                                                            controller.contentController = ratingViewController
//                                                            controller.presentModalView()
//                                                        }
//                                                    }
//                                                }
//        })]
        scrollContainer.addSubview(rateInformationView)
        rateInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-24-[$self]"],
                                                views: [menuInformationView])
        
        
        locationInformationView = KPInformationSharedInfoView()
        locationInformationView.infoTitleLabel.text = "位置訊息"
        if let distanceInMeter = informationDataModel.distanceInMeter {
            var distance = distanceInMeter
            var unit = "m"
            if distance > 1000 {
                unit = "km"
                distance = distance/1000
            }
            locationInformationView.infoSupplementLabel.text = String(format: "%.1f%@", distance, unit)
        } else {
            locationInformationView.infoSupplementLabel.text = "開啟導航"
        }
        //        locationInformationView.actions = [
        //            Action(title:"街景模式",
        //                   style:.normal,
        //                   color:KPColorPalette.KPMainColor_v2.mainColor_sub!,
        //                   icon:R.image.icon_street(),
        //                   handler:{
        //                    [weak self] (infoView) -> () in
        //                    if let weSelf = self {
        //                        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
        //                            UIApplication.shared.open(URL(string:
        //                                "comgooglemaps://?center=\(weSelf.informationDataModel.latitude!),\(weSelf.informationDataModel.longitude!)&mapmode=streetview")!,
        //                                                      options: [:],
        //                                                      completionHandler: nil)
        //                        } else {
        //                            print("Can't use comgooglemaps://")
        //                        }
        //                    }
        //            }),
        //            Action(title:"開啟導航",
        //                   style:.normal,
        //                   color:KPColorPalette.KPMainColor_v2.mainColor!,
        //                   icon:(R.image.icon_navi()?.withRenderingMode(.alwaysTemplate))!,
        //                   handler:{ [weak self] (infoView) -> () in
        //                    KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.store_navigation_button)
        //                    if let weSelf = self {
        //                        weSelf.present(weSelf.mapActionController,
        //                                       animated: true,
        //                                       completion: nil)
        //                    }
        //
        //            })
        //        ]
        
        scrollContainer.addSubview(locationInformationView)
        locationInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                 "V:[$view0]-24-[$self(292)]"],
                                               views: [rateInformationView])
        

        let shopRecommendView = KPShopRecommendView()
        shopRecommendView.informationController = self
        shopRecommendView.displayDataModels = KPServiceHandler.sharedHandler.relatedDisplayModel
        recommendInformationView = KPInformationSharedInfoView()
        recommendInformationView.infoView = shopRecommendView
        recommendInformationView.infoTitleLabel.text = "你可能也會喜歡"
        scrollContainer.addSubview(recommendInformationView)
        recommendInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-24-[$self]-16-|"],
                                                     views: [locationInformationView])

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshRatings),
                                               name: Notification.Name(KPNotification.information.rateInformation),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshComments),
                                               name: Notification.Name(KPNotification.information.commentInformation),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshPhoto),
                                               name: Notification.Name(KPNotification.information.photoInformation),
                                               object: nil)
        
        currentPhotoIndex = 0
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayStatusbar = true
        
        updateToolBar()
//        syncRemoteData()
        
        
        
        UIView.animate(withDuration: 2,
                       animations: {
                        
        }) { (_) in
            // 動畫成功會做的事情
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let shopLocationInfoView = KPShopLocationInfoView()
        
        shopLocationInfoView.dataModel = informationDataModel
        locationInformationView.infoView = shopLocationInfoView
        navBarFixBound = navigationController!.navigationBar.bounds
        viewHasAppeared = true
        informationHeaderView.shopPhoto.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateToolBar() {
        
        topBarContainer = UIView()
        topBarContainer.backgroundColor = UIColor.white
        topBarContainer.alpha = 0
        view.addSubview(topBarContainer)
        topBarContainer.addConstraints(fromStringArray: ["V:|[$self($metric0)]",
                                                         "H:|[$self]|"], metrics:[KPLayoutConstant.topBar_height])
        separator_top = UIView()
        separator_top.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        topBarContainer.addSubview(separator_top)
        separator_top.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:[$self($metric0)]|"], metrics:[KPLayoutConstant.separator_height])
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        
        toolBarContainer = UIView()
        toolBarContainer.isHidden = true
        toolBarContainer.backgroundColor = UIColor.white
        view.addSubview(toolBarContainer)
        toolBarContainer.addConstraints(fromStringArray: ["V:[$self($metric0)]|",
                                                          "H:|[$self]|"], metrics:[KPLayoutConstant.bottomBar_height])
        toolBarContainer.addSubview(separator)
        separator.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self($metric0)]"], metrics:[KPLayoutConstant.separator_height])
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: KPFontSize.mainContent)
        titleLabel.textColor = KPColorPalette.KPTextColor_v2.whiteColor
        titleLabel.text = informationDataModel.name
        view.addSubview(titleLabel)
        titleLabel.addConstraint(from: "H:[$self(<=280)]")
        titleLabel.addConstraintForCenterAligning(to: topBarContainer,
                                                  in: .vertical,
                                                  constant: 8)
        titleLabel.addConstraintForCenterAligning(to: topBarContainer,
                                                  in: .horizontal,
                                                  constant: 0)
        
        dismissButton = KPBounceButton(frame: CGRect.zero,
                                       image: R.image.icon_close()!)
        dismissButton.tintColor = KPColorPalette.KPTextColor_v2.whiteColor
        dismissButton.alpha = 0.9
        view.addSubview(dismissButton)
        dismissButton.addConstraints(fromStringArray: ["V:[$self($metric0)]",
                                                       "H:|-16-[$self($metric0)]"], metrics:[KPLayoutConstant.dismissButton_size])
        dismissButton.addConstraintForCenterAligning(to: topBarContainer,
                                                     in: .vertical,
                                                     constant: 8)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        dismissButton.addTarget(self,
                                action: #selector(handleDismissButtonOnTapped), for: .touchUpInside)
        
        moreButton = KPBounceButton(frame: CGRect.zero,
                                    image: R.image.icon_more()!)
        moreButton.tintColor = KPColorPalette.KPTextColor_v2.whiteColor
        moreButton.addTarget(self,
                             action: #selector(KPInformationViewController.handleMoreButtonOnTapped),
                             for: .touchUpInside)
        view.addSubview(moreButton)
        moreButton.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        moreButton.addConstraints(fromStringArray: ["V:[$self(24)]",
                                                    "H:[$self(24)]-16-|"])
        moreButton.addConstraintForCenterAligning(to: topBarContainer,
                                                     in: .vertical,
                                                     constant: 8)
        
        
        informationHeaderButtonBar = KPInformationHeaderButtonBar(frame: .zero)
        informationHeaderButtonBar.informationController = self
        toolBarContainer.addSubview(informationHeaderButtonBar)
        informationHeaderButtonBar.addConstraints(fromStringArray: ["H:[$self]|",
                                                                    "V:|-1-[$self]|"])
        
        
        view.addSubview(addButton)
        addButton.addConstraints(fromStringArray: ["H:[$self(60)]-16-|",
                                                   "V:[$self(60)]-24-|"])
        
        
    }
    // MARK: UI Update
    
    func syncRemoteData() {
        
        dataLoading = true
        
        refreshComments()
        refreshRatings()
        refreshPhoto()
        refreshMenu()
        
        KPServiceHandler.sharedHandler.fetchStoreInformation(informationDataModel.identifier) {
            [weak self] (result) in
            if let weSelf = self {
                weSelf.informationHeaderButtonBar.informationDataModel = result
                weSelf.informationHeaderView.scoreLabel.text = String(format: "%.1f",
                                                                    result?.averageRate?.doubleValue ?? 0.0)
                weSelf.dataLoading = false
            }
        }
    }
    
    
    func refreshMenu() {
        KPServiceHandler.sharedHandler.getMenus {
            [weak self] (successed, photos) in
            if let weSelf = self {
                if successed == true && photos != nil {
                    var index: Int = 0
                    var photoInformations: [PhotoInformation] = []
                    for urlInfo in photos! {
                        let urlString = urlInfo["url"] as? String ?? ""
                        let thumbnailString = urlInfo["thumbnail"] as? String ?? ""
                        if let url = URL(string: urlString),
                           let thumbnailurl = URL(string: thumbnailString) {
                            photoInformations.append(PhotoInformation(title: "",
                                                                      imageURL: url,
                                                                      thumbnailURL: thumbnailurl,
                                                                      index: index))
                            index += 1
                        }
                    }
                    weSelf.displayMenuInformations = photoInformations
                    
                    if weSelf.displayMenuInformations.count == 0 {
                        weSelf.menuInformationView.isEmpty = true
                    } else {
                        weSelf.menuInformationView.infoSupplementLabel.text = "\(weSelf.displayMenuInformations.count) 張照片"
                        weSelf.menuInformationView.isEmpty = false
                    }
                } else {
                    weSelf.menuInformationView.infoSupplementLabel.text = "尚無照片"
                    weSelf.menuInformationView.isEmpty = true
                }
            }
        }
    }
    
    
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
                    weSelf.displayPhotoInformations = photoInformations
                    
                    if weSelf.displayPhotoInformations.count == 0 {
                        let transition = CATransition()
                        transition.duration = 0.2
                        transition.type = kCATransitionFade
                        weSelf.informationHeaderView.shopPhoto.image = R.image.image_noImage()
                        weSelf.informationHeaderView.shopPhoto.isUserInteractionEnabled = false
                        weSelf.informationHeaderView.shopPhoto.layer.add(transition, forKey: nil)
                        weSelf.informationHeaderView.morePhotoButton.titleLabel?.text = "上傳\n照片"
                        weSelf.photoInformationView.infoSupplementLabel.text = "尚無照片"
                        weSelf.photoInformationView.isEmpty = true
                        weSelf.informationHeaderView.morePhotoButton.setTitle("上傳\n照片", for: .normal)
                    } else {
                        weSelf.photoInformationView.infoSupplementLabel.text = "\(weSelf.displayPhotoInformations.count) 張照片"
                        weSelf.photoInformationView.isEmpty = false
                        weSelf.informationHeaderView.morePhotoButton.setTitle("\(weSelf.displayPhotoInformations.count) \n張照片",
                            for: .normal)
                        
                    }
                } else {
                    let transition = CATransition()
                    transition.duration = 0.2
                    transition.type = kCATransitionFade
                    weSelf.informationHeaderView.shopPhoto.image = R.image.image_noImage()
                    weSelf.informationHeaderView.shopPhoto.isUserInteractionEnabled = false
                    weSelf.informationHeaderView.shopPhoto.layer.add(transition, forKey: nil)
                    weSelf.informationHeaderView.morePhotoButton.titleLabel?.text = "上傳\n照片"
                    weSelf.photoInformationView.infoSupplementLabel.text = "尚無照片"
                    weSelf.photoInformationView.isEmpty = true
                    weSelf.informationHeaderView.morePhotoButton.setTitle("上傳\n照片", for: .normal)
                }
            }
        }
    }
    
    @objc func refreshRatings() {
        
        // 取得 Rating 資料
        KPServiceHandler.sharedHandler.getRatings {
            [weak self] (successed, rate) in
            if let weSelf = self {
                if successed && rate != nil {
                    (weSelf.rateInformationView.infoView as! KPShopRateInfoView).rateData = rate
                    // 加上 base 的數量
                    let rateCount = (rate?.base != nil) ? (rate?.rates?.count)!+1 : (rate?.rates?.count)!
                    
                    weSelf.informationHeaderButtonBar.rateButton.numberValue = rateCount
                    weSelf.informationHeaderButtonBar.rateButton.selected =
                        (KPUserManager.sharedManager.currentUser?.hasRated(weSelf.informationDataModel.identifier)) ?? false
                    weSelf.rateInformationView.infoSupplementLabel.text = "\(rateCount) 人已評分"
                    weSelf.rateDataModel = rate
                    
                    if ((KPUserManager.sharedManager.currentUser?.hasRated) != nil) {
                        if let rate = weSelf.rateDataModel?.rates?.first(where:
                            {$0.memberID == KPUserManager.sharedManager.currentUser?.identifier}) {
                            weSelf.hasRatedDataModel = rate
                        }
                    }
                    
                    if weSelf.hasRatedDataModel != nil {
                        DispatchQueue.main.async {
                            weSelf.rateInformationView.actionButtons[0].setTitle("修改評分", for: .normal)
                            weSelf.informationHeaderButtonBar.rateButton.titleLabel.text = "修改評分"
                        }
                    }
                    
                } else {
                    weSelf.informationHeaderButtonBar.rateButton.numberValue = 0
                    weSelf.informationHeaderButtonBar.rateButton.selected = false
                    weSelf.rateInformationView.infoSupplementLabel.text = "尚無評分"
                }
            }
        }
    }
    
    
    func updateCommentsLayout(_ commentCount: Int) {
        if commentCount == 0 {
            self.commentInformationView.infoSupplementLabel.text = "尚無留言"
            self.commentInformationView.isEmpty = true
            self.commentInformationView.actions = [Action(title:"我要評論",
                                                          style:.normal,
                                                          color:KPColorPalette.KPMainColor_v2.mainColor!,
                                                          icon:(R.image.icon_comment()?.withRenderingMode(.alwaysTemplate))!,
                                                          handler:{ [weak self] (infoView) -> () in
                                                            if let weSelf = self {
                                                                if KPUserManager.sharedManager.currentUser == nil {
                                                                    KPPopoverView.popoverLoginView()
                                                                } else {
                                                                    if KPServiceHandler.sharedHandler.isCurrentShopClosed {
                                                                        KPPopoverView.popoverClosedView()
                                                                    } else {
                                                                        let newCommentViewController = KPNewCommentController()
                                                                        if weSelf.hasRatedDataModel != nil {
                                                                            DispatchQueue.main.async {
                                                                                newCommentViewController.hideRatingViews = true
                                                                            }
                                                                        }
                                                                        
                                                                        weSelf.navigationController?.pushViewController(viewController: newCommentViewController,
                                                                                                                      animated: true,
                                                                                                                      completion: {})
                                                                    }
                                                                }
                                                            }
            })
            ]
        } else {
            if self.hasCommentDataModel != nil {
                self.commentInformationView.actions = [
                    Action(title:"看更多評論(\(commentCount))",
                        style:.normal,
                        color:KPColorPalette.KPMainColor_v2.mainColor_sub!,
                        icon:nil,
                        handler:{ [weak self] (infoView) -> () in
                            if let weSelf = self {
                                let commentViewController = KPAllCommentController()
                                commentViewController.informationController = self
                                commentViewController.comments = weSelf.comments as! [KPCommentModel]
                                commentViewController.animated = !weSelf.allCommentHasShown
                                weSelf.allCommentHasShown = true
                                weSelf.navigationController?.pushViewController(viewController: commentViewController,
                                                                                animated: true,
                                                                                completion: {})
                            }
                    }),
                    Action(title:"修改評論",
                           style:.normal,
                           color:KPColorPalette.KPMainColor_v2.mainColor!,
                           icon:(R.image.icon_comment()?.withRenderingMode(.alwaysTemplate))!,
                           handler:{ [weak self] (infoView) -> () in
                            if let weSelf = self {
                                if KPUserManager.sharedManager.currentUser == nil {
                                    KPPopoverView.popoverLoginView()
                                } else {
                                    if KPServiceHandler.sharedHandler.isCurrentShopClosed {
                                        KPPopoverView.popoverClosedView()
                                    } else {
                                        let editCommentViewController = KPEditCommentController()
                                            editCommentViewController.defaultCommentModel =  weSelf.hasCommentDataModel!
                                            weSelf.navigationController?.pushViewController(viewController: editCommentViewController,
                                                                                                                 animated: true,
                                                                                                                 completion: {})
                                    }
                                }
                            }
                    })
                ]
            } else {
                self.commentInformationView.actions = [
                    Action(title:"看更多評論(\(commentCount))",
                        style:.normal,
                        color:KPColorPalette.KPMainColor_v2.mainColor_sub!,
                        icon:nil,
                        handler:{ [weak self] (infoView) -> () in
                            if let weSelf = self {
                                let commentViewController = KPAllCommentController()
                                commentViewController.informationController = self
                                commentViewController.comments = weSelf.comments as! [KPCommentModel]
                                commentViewController.animated = !weSelf.allCommentHasShown
                                weSelf.allCommentHasShown = true
                                weSelf.navigationController?.pushViewController(viewController: commentViewController,
                                                                                animated: true,
                                                                                completion: {})
                            }
                    }),
                    Action(title:"我要評論",
                           style:.normal,
                           color:KPColorPalette.KPMainColor_v2.mainColor!,
                           icon:(R.image.icon_comment()?.withRenderingMode(.alwaysTemplate))!,
                           handler:{ [weak self] (infoView) -> () in
                            if let weSelf = self {
                                if KPUserManager.sharedManager.currentUser == nil {
                                    KPPopoverView.popoverLoginView()
                                } else {
                                    if KPServiceHandler.sharedHandler.isCurrentShopClosed {
                                        KPPopoverView.popoverClosedView()
                                    } else {
                                        let newCommentViewController = KPNewCommentController()
                                        
                                        if weSelf.hasRatedDataModel != nil {
                                            DispatchQueue.main.async {
                                                newCommentViewController.hideRatingViews = true
                                            }
                                        }
                                        
                                        weSelf.navigationController?.pushViewController(viewController: newCommentViewController,
                                                                                        animated: true,
                                                                                        completion: {})
                                    }
                                }
                            }
                    })
                ]
            }
        }

    }
    
    @objc func refreshComments() {
        
        // 取得 Comment 資料
        KPServiceHandler.sharedHandler.getComments {
            [weak self] (successed, comments) in
            if let weSelf = self {
                if successed && comments != nil {
                    weSelf.comments = comments!
                    weSelf.commentInfoView.comments = comments!
                    weSelf.commentInformationView.infoSupplementLabel.text = "\(comments?.count ?? 0) 人已留言"
                    weSelf.commentInfoView.tableView.layoutIfNeeded()
                    weSelf.commentInfoView.tableViewHeightConstraint.constant = weSelf.commentInfoView.tableView.contentSize.height
                    weSelf.commentInformationView.setNeedsLayout()
                    weSelf.commentInformationView.layoutIfNeeded()
                    
                    if let comments = comments {
                        let oComments = comments.filter({ (comment) -> Bool in
                            comment.memberID == KPUserManager.sharedManager.currentUser?.identifier
                        })
                        
                        if let oComment = oComments.first {
                            weSelf.hasCommentDataModel = oComment
                            weSelf.informationHeaderButtonBar.commentButton.titleLabel.text = "修改評論"
                        }
                        
                        let commentCountValue = comments.count
                        weSelf.updateCommentsLayout(commentCountValue)
                        weSelf.commentInformationView.isEmpty = (commentCountValue == 0)
                        weSelf.informationHeaderButtonBar.commentButton.numberValue = commentCountValue
                        weSelf.informationHeaderButtonBar.commentButton.selected =
                            (KPUserManager.sharedManager.currentUser?.hasReviewed(weSelf.informationDataModel.identifier)) ?? false
                        
                    } else {
                        weSelf.commentInfoView.tableViewHeightConstraint.constant = 64
                        weSelf.commentInformationView.isEmpty = true
                    }
                } else {
                    weSelf.commentInfoView.comments = [KPCommentModel]()
                    weSelf.commentInformationView.infoSupplementLabel.text = "尚無留言"
                    weSelf.commentInfoView.tableView.layoutIfNeeded()
                    weSelf.commentInfoView.tableViewHeightConstraint.constant = 64
                    weSelf.commentInformationView.setNeedsLayout()
                    weSelf.commentInformationView.layoutIfNeeded()
                    weSelf.commentInformationView.isEmpty = true
                }
            }
        }
    }
    
    // MARK: Animation
    
    func showInformationContents(_ animated: Bool) {
        
        informationHeaderButtonBar.isHidden = false
        shopInformationView.isHidden = false
        locationInformationView.isHidden = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { 
            self.informationHeaderButtonBar.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
            self.shopInformationView.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
            self.locationInformationView.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
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
        locationInformationView.layer.add(translateAnimation, forKey: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.informationHeaderButtonBar.alpha = 1.0
                        self.shopInformationView.alpha = 1.0
                        self.locationInformationView.alpha = 1.0
        }) { (_) in
            self.scrollContainer.isUserInteractionEnabled = true
        }
        
        CATransaction.commit()
    }
    
    // MARK: UI Event
    
    func photoUpload() {
        if KPUserManager.sharedManager.currentUser == nil {
            KPPopoverView.popoverLoginView()
        } else {
            if KPServiceHandler.sharedHandler.isCurrentShopClosed {
                KPPopoverView.popoverClosedView()
            } else {
                let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                controller.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { (action) in
                    self.pickerType = .photo
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.allowsEditing = false
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = self
                    self.present(imagePickerController, animated: true, completion: nil)
                })
                controller.addAction(UIAlertAction(title: "開啟相機", style: .default) { (action) in
                    self.pickerType = .photo
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.allowsEditing = false
                    imagePickerController.sourceType = .camera
                    imagePickerController.delegate = self
                    self.present(imagePickerController, animated: true, completion: nil)
                })
                
                controller.addAction(UIAlertAction(title: "取消", style: .cancel) { (action) in
                    
                })
                
                self.present(controller, animated: true) {
                    
                }
            }
        }
    }
    
    func menuUpload() {
        if KPUserManager.sharedManager.currentUser == nil {
            KPPopoverView.popoverLoginView()
        } else {
            if KPServiceHandler.sharedHandler.isCurrentShopClosed {
                KPPopoverView.popoverClosedView()
            } else {
                let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                controller.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { (action) in
                    self.pickerType = .menu
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.allowsEditing = false
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = self
                    self.present(imagePickerController, animated: true, completion: nil)
                })
                controller.addAction(UIAlertAction(title: "開啟相機", style: .default) { (action) in
                    self.pickerType = .menu
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.allowsEditing = false
                    imagePickerController.sourceType = .camera
                    imagePickerController.delegate = self
                    self.present(imagePickerController, animated: true, completion: nil)
                })
                
                controller.addAction(UIAlertAction(title: "取消", style: .cancel) { (action) in
                    
                })
                
                self.present(controller, animated: true) {
                    
                }
            }
        }
    }
    
    @objc func handleMorePhotoButtonOnTapped() {
        if self.displayPhotoInformations.count == 0 {
            photoUpload()
        } else {
            let galleryController = KPPhotoGalleryViewController()
            galleryController.displayedPhotoInformations = self.displayPhotoInformations
            dismissButton.isHidden = true
            navigationController?.pushViewController(viewController: galleryController,
                                                          animated: true,
                                                          completion: {}
            )
        }
    }
    
    @objc func handleFacebookButtonOnTapped() {
        UIApplication.shared.open(URL(string: informationDataModel.facebookURL!)!,
                                  options: [:]) { (_) in
                                    
        }
    }
    
    
    @objc func handleOtherTimeButtonOnTapped() {
        
        let controller = KPModalViewController()
        let businessTimeViewController = KPBusinessTimeViewController()
        
//        controller.contentSize = CGSize(width: 276, height: 416)
//        controller.cornerRadius = [.topRight, .topLeft, .bottomLeft, .bottomRight]
        controller.edgeInset = UIEdgeInsetsMake(0, 0, 0, 0)
        controller.dismissWhenTouchingOnBackground = true
        controller.presentationStyle = .popout
        businessTimeViewController.businessTime = informationDataModel.businessHour
        businessTimeViewController.titleLabel.setText(text: informationDataModel.name,
                                                      lineSpacing: 3.0)
        controller.contentController = businessTimeViewController
        controller.presentModalView()
    }
    
    @objc func handleDismissButtonOnTapped() {
        if self.navigationController?.viewControllers.first is KPUserProfileViewController {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismissWithDefaultType = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleMoreButtonOnTapped() {
        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.store_more_button)
        present(actionController,
                animated: true,
                completion: nil)
    }
    
    @objc func handleShareButtonOnTapped() {
        
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
            transitionController.transitionType = .damping
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
        self.informationHeaderView.isHidden = true
    }
    
    func tranisitionCleanup(){
        self.informationHeaderView.isHidden = false
    }
    
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
        
        if viewHasAppeared {
            
            // 處理 Tool Bar
            if self.scrollContainer.contentOffset.y >= 120 {
                topBarContainer.alpha = (self.scrollContainer.contentOffset.y - 120) / 40
                dismissButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
                moreButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
                titleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
            } else {
                topBarContainer.alpha = 0
                dismissButton.tintColor = KPColorPalette.KPTextColor_v2.whiteColor
                moreButton.tintColor = KPColorPalette.KPTextColor_v2.whiteColor
                titleLabel.textColor = KPColorPalette.KPTextColor_v2.whiteColor
            }
            
            
            
            
            scrollContainer.contentOffset = CGPoint(x: 0,
                                                    y: scrollContainer.contentOffset.y <= -120 ?
                                                        -120 :
                                                        scrollContainer.contentOffset.y)
            
            if scrollContainer.contentOffset.y <= 0 && scrollContainer.contentOffset.y >= -120 {
                let scaleRatio = 1 - scrollContainer.contentOffset.y/300
                let scaleRatioContainer = 1 - scrollContainer.contentOffset.y/240
                let oldFrame = informationHeaderView.shopPhotoContainer.frame
                
//                animatedHeaderConstraint.constant = 0
                informationHeaderView.shopPhoto.transform = .identity
                informationHeaderView.isUserInteractionEnabled = true
                
                informationHeaderView.shopPhotoContainer.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
                informationHeaderView.shopPhotoContainer.frame = oldFrame
                informationHeaderView.shopPhotoContainer.transform = .identity
                informationHeaderView.shopPhotoContainer.transform = CGAffineTransform(scaleX: scaleRatioContainer,
                                                                                       y: scaleRatioContainer)
                informationHeaderView.shopPhoto.transform = .identity
                informationHeaderView.shopPhoto.transform = CGAffineTransform(scaleX: scaleRatio,
                                                                              y: scaleRatio)
                
                self.view.layoutIfNeeded()
            } else if scrollContainer.contentOffset.y > 0 && scrollContainer.contentOffset.y < 200 {
//                animatedHeaderConstraint.constant = -scrollContainer.contentOffset.y*9/20
                informationHeaderView.shopPhoto.transform = CGAffineTransform(translationX: 0,
                                                                              y: scrollContainer.contentOffset.y*9/20)
                informationHeaderView.isUserInteractionEnabled = false
                view.layoutIfNeeded()
            }
        }
    }
}

extension KPInformationViewController: KPInformationHeaderViewDelegate {
    func headerPhotoTapped(_ headerView: KPInformationHeaderView) {
        
        if self.displayPhotoInformations.count == 0 {
            return
        }
        
//        let photoDisplayController = KPPhotoDisplayViewController()
//        photoDisplayController.transitioningDelegate = self
//        photoDisplayController.backgroundSnapshot = navigationController!.view.snapshotView(afterScreenUpdates: true)
//        photoDisplayController.displayedPhotoInformations = self.displayPhotoInformations
//        
//        present(photoDisplayController, animated: true, completion: {
//        })
        
        var photoSource: [SKPhotoProtocol] = [SKPhotoProtocol]()
        for (index, photoInfo) in self.displayPhotoInformations.enumerated() {
            if let shopImage = self.informationHeaderView.shopPhoto.image, index == currentPhotoIndex {
                photoSource.append(SKPhoto.photoWithImage(shopImage))
            } else {
                photoSource.append(SKPhoto.photoWithImageURL(photoInfo.imageURL.absoluteString))
            }
        }
        
        let browser = SKPhotoBrowser(originImage: headerView.shopPhoto.image!,
                                     photos: photoSource,
                                     animatedFromView: headerView.shopPhoto)
        browser.initializePageIndex(currentPhotoIndex)
        browser.delegate = self
        present(browser, animated: true, completion: {})
    }
}

extension KPInformationViewController: SKPhotoBrowserDelegate {
    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        return self.informationHeaderView.shopPhoto
    }
    
    func didShowPhotoAtIndex(_ index: Int) {
        self.informationHeaderView.shopPhoto.isHidden = true
    }
    
    func didDismissAtPageIndex(_ index: Int) {
        self.informationHeaderView.shopPhoto.isHidden = false
    }
    
    func willDismissAtPageIndex(_ index: Int) {
        currentPhotoIndex = index
        informationHeaderView.shopPhoto.af_setImage(withURL: displayPhotoInformations[index].imageURL,
                                                    placeholderImage: UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level6!),
                                                    filter: nil,
                                                    progress: nil,
                                                    progressQueue: DispatchQueue.global(),
                                                    imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                                    runImageTransitionIfCached: false,
                                                    completion: nil)
    }
}


extension KPInformationViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                if self.pickerType == .menu {
                    KPServiceHandler.sharedHandler.uploadMenus([image],
                                                               self.informationDataModel.identifier,
                                                               true,
                                                               { (success) in
                                                                if success {
                                                                    print("upload successed")
                                                                } else {
                                                                    print("upload failed")
                                                                }
                    })
                } else if self.pickerType == .photo {
                    KPServiceHandler.sharedHandler.uploadPhotos([image],
                                                                self.informationDataModel.identifier,
                                                                true,
                                                                { (success) in
                        if success {
                            print("upload successed")
                        } else {
                            print("upload failed")
                        }
                    })
                }
                self.pickerType = .none
            }
        }
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

