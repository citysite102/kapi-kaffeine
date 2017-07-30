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
    
    // 取得相關的所有評分資訊
    var rateDataModel: KPRateDataModel?
    
    // 取得已評分過的評分資訊
    var hasRatedDataModel: KPSimpleRateModel?
    var dismissButton: KPBounceButton!
    var moreButton: KPBounceButton!
    var shareButton: KPBounceButton!
    
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
    var shopInformationView: KPInformationSharedInfoView!
    var locationInformationView: KPInformationSharedInfoView!
    var rateInformationView: KPInformationSharedInfoView!
    var commentInformationView: KPInformationSharedInfoView!
    var photoInformationView: KPInformationSharedInfoView!
    var recommendInformationView: KPInformationSharedInfoView!
    var commentInfoView: KPShopCommentInfoView!
    var loadingIndicator: UIActivityIndicatorView!
    lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level5
        label.text = "載入中..."
        return label
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = informationDataModel.name
        navigationController?.delegate = self
        
        dismissButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30),
                                       image: R.image.icon_close()!)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 7, 8, 7)
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
        negativeSpacer.width = -7
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightBarItem]
        
        
        actionController = UIAlertController(title: nil,
                                             message: nil,
                                             preferredStyle: .actionSheet)
        actionController.view.tintColor = KPColorPalette.KPTextColor.grayColor_level2
        let editButton = UIAlertAction(title: "編輯店家資料",
                                       style: .default) {
                                        [unowned self] (_) in
                                        KPPopoverView.popoverUnsupportedView()
//                                        let controller = KPModalViewController()
//                                        controller.edgeInset = UIEdgeInsets(top: 0,
//                                                                            left: 0,
//                                                                            bottom: 0,
//                                                                            right: 0)
//                                        let newStoreController = KPNewStoreController()
//                                        let navigationController =
//                                            UINavigationController(rootViewController: newStoreController)
//                                        controller.contentController = navigationController
//                                        controller.presentModalView()
        }
        
        let reportButton = UIAlertAction(title: "回報問題",
                                         style: .default) {
                                            [unowned self] (_) in
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
                                        [unowned self] (_) in
                                        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                                            UIApplication.shared.open(URL(string:
                                                "comgooglemaps://?daddr=\(self.informationDataModel.latitude!),\(self.informationDataModel.longitude!)&mapmode=standard")!,
                                                                      options: [:],
                                                                      completionHandler: nil)
                                        } else {
                                            print("Can't use comgooglemaps://")
                                        }

        }
        
        let appleAction = UIAlertAction(title: "使用地圖開啟",
                                         style: .default) {
                                            [unowned self] (_) in
                                            let coordinates = CLLocationCoordinate2DMake(self.informationDataModel.latitude!,
                                                                                         self.informationDataModel.longitude!)
                                            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                                            let mapItem = MKMapItem(placemark: placemark)
                                            mapItem.openInMaps(launchOptions: nil)
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
        
        informationHeaderView.morePhotoButton.setTitle(informationDataModel.photoCount == 0 ?
            "上傳\n照片" :
            "\(informationDataModel.photoCount!) \n張照片"
            , for: .normal)
        informationHeaderView.scoreLabel.text = String(format: "%.1f", informationDataModel.averageRate?.doubleValue ?? 0.0)
        informationHeaderView.facebookButton.isHidden = !(informationDataModel.facebookURL != nil)
        if let photoURL = informationDataModel.covers?["google_l"] {
            informationHeaderView.shopPhoto.af_setImage(withURL: URL(string: photoURL)!,
                                                        placeholderImage: nil,
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
        } else {
            
        }
        
//        informationHeaderView.shopPhoto.image = R.image.demo_6()
        
        //informationDataModel
        scrollContainer.addSubview(informationHeaderView)
        informationHeaderView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]"])
        
        informationHeaderView.addConstraintForHavingSameWidth(with: view)
        informationHeaderView.morePhotoButton.addTarget(self,
                                                        action: #selector(KPInformationViewController.handleMorePhotoButtonOnTapped),
                                                        for: UIControlEvents.touchUpInside)
        informationHeaderView.facebookButton.addTarget(self,
                                                       action: #selector(KPInformationViewController.handleFacebookButtonOnTapped),
                                                        for: UIControlEvents.touchUpInside)
        informationHeaderView.scoreHandler = { [unowned self] in
            if var rates = self.rateDataModel?.rates {
                
                if let cafeModel = self.rateDataModel?.base {
                    cafeModel.displayName = "Cafe Nomad"
                    rates.append(cafeModel)
                }
                
                if rates.count > 0 {
                    let allRatingController = KPAllRatingViewController()
                    allRatingController.ratings = rates
                    print("RatesInfo:\(rates)")
                    self.navigationController?.pushViewController(viewController: allRatingController,
                                                             animated: true,
                                                             completion: {}
                    )
                }
            }
        }
        
        
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator.tintColor = KPColorPalette.KPMainColor.mainColor
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
        
        informationHeaderButtonBar = KPInformationHeaderButtonBar(frame: .zero)
        informationHeaderButtonBar.informationController = self
        scrollContainer.addSubview(informationHeaderButtonBar)
        informationHeaderButtonBar.addConstraints(fromStringArray: ["H:|[$self]|"],
                                                  views: [informationHeaderView])
        
        animatedHeaderConstraint =
            informationHeaderButtonBar.addConstraint(from: "V:[$view0][$self]",
                                                     views:[informationHeaderView]).first as! NSLayoutConstraint
        
        let informationView: KPShopInfoView = KPShopInfoView(informationDataModel)
        informationView.otherTimeButton.addTarget(self,
                                                  action: #selector(KPInformationViewController.handleOtherTimeButtonOnTapped),
                                                  for: .touchUpInside)
        
        if informationDataModel.businessHour != nil {
            let shopStatus = informationDataModel.businessHour!.shopStatus
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
                                                             "V:[$view0]-16-[$self]"],
                                                      views: [informationHeaderButtonBar])

        locationInformationView = KPInformationSharedInfoView()
        locationInformationView.infoTitleLabel.text = "位置訊息"
        locationInformationView.infoSupplementLabel.text = "距離 \(String(format: "%.1f", informationDataModel.distanceInMeter ?? 0))m"
        locationInformationView.actions = [
            Action(title:"街景模式",
                   style:.normal,
                   color:KPColorPalette.KPMainColor.mainColor_sub!,
                   icon:R.image.icon_street(),
                   handler:{ [unowned self] (infoView) -> () in
                    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                        UIApplication.shared.open(URL(string:
                            "comgooglemaps://?center=\(self.informationDataModel.latitude!),\(self.informationDataModel.longitude!)&mapmode=streetview")!,
                                                  options: [:],
                                                  completionHandler: nil)
                    } else {
                        print("Can't use comgooglemaps://")
                    }
            }),
            Action(title:"開啟導航",
                   style:.normal,
                   color:KPColorPalette.KPMainColor.mainColor!,
                   icon:(R.image.icon_navi()?.withRenderingMode(.alwaysTemplate))!,
                   handler:{ [unowned self] (infoView) -> () in
                    self.present(self.mapActionController,
                                 animated: true,
                                 completion: nil)

            })
        ]
        
        scrollContainer.addSubview(locationInformationView)
        locationInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                 "V:[$view0]-24-[$self(292)]"],
                                                views: [shopInformationView])

        let shopRateInfoView = KPShopRateInfoView()
        shopRateInfoView.dataModel = informationDataModel
        rateInformationView = KPInformationSharedInfoView()
        rateInformationView.infoView = shopRateInfoView
        rateInformationView.infoTitleLabel.text = "店家評分"
        rateInformationView.infoSupplementLabel.text = "\(informationDataModel.rateCount ?? 0) 人已評分"
        rateInformationView.actions = [Action(title:"我要評分",
                                              style:.normal,
                                              color:KPColorPalette.KPMainColor.mainColor!,
                                              icon:(R.image.icon_star()?.withRenderingMode(.alwaysTemplate))!,
                                              handler:{ [unowned self] (infoView) -> () in
                                                    
                                                if KPUserManager.sharedManager.currentUser == nil {
                                                    KPPopoverView.popoverLoginView()
                                                } else {
                                                    let controller = KPModalViewController()
                                                    controller.edgeInset = UIEdgeInsets(top: UIDevice().isCompact ? 0 : 40,
                                                                                            left: 0,
                                                                                            bottom: 0,
                                                                                            right: 0)
                                                    controller.cornerRadius = UIDevice().isCompact ?
                                                        [] :
                                                        [.topRight, .topLeft]
                                                    let ratingViewController = KPRatingViewController()
                                                        
                                                    if self.hasRatedDataModel != nil {
                                                        ratingViewController.defaultRateModel = self.hasRatedDataModel
                                                    }
                                                    controller.contentController = ratingViewController
                                                    controller.presentModalView()
                                                }
        })]
        scrollContainer.addSubview(rateInformationView)
        rateInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-24-[$self]"],
                                                views: [locationInformationView])
        
        
        commentInfoView = KPShopCommentInfoView()
        commentInfoView.informationController = self
        commentInformationView = KPInformationSharedInfoView()
        commentInformationView.emptyLabel.text = "目前尚無留言，給點建議或分享吧:D"
        commentInformationView.infoView = commentInfoView
        commentInformationView.infoTitleLabel.text = "留言評價"
        scrollContainer.addSubview(commentInformationView)
        commentInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                "V:[$view0]-24-[$self]"],
                                                    views: [rateInformationView])
        
        if let commentCount = informationDataModel.commentCount {
            commentInformationView.infoSupplementLabel.text = "\(commentCount) 人已留言"
            commentInformationView.isEmpty = (commentCount == 0)
            updateCommentsLayout(Int(commentCount))
        }
        
        
        let photoInfoView = KPShopPhotoInfoView()
        photoInfoView.informationController = self
        photoInformationView = KPInformationSharedInfoView()
        photoInformationView.emptyLabel.text = "目前尚無照片，成為第一個上傳的人吧:D"
        photoInformationView.infoView = photoInfoView
        photoInformationView.infoTitleLabel.text = "店家照片"
        
        if let photoCount = informationDataModel.photoCount {
            photoInformationView.infoSupplementLabel.text = "\(photoCount) 張照片"
            photoInformationView.isEmpty = (photoCount == 0)
        } else {
            photoInformationView.infoSupplementLabel.text = "0 張照片"
            photoInformationView.isEmpty = true
        }
        scrollContainer.addSubview(photoInformationView)
        photoInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$view0]-24-[$self]"],
                                                    views: [commentInformationView])
        photoInformationView.actions = [Action(title: "上傳照片",
                                               style:.normal,
                                               color:KPColorPalette.KPMainColor.mainColor!,
                                               icon:(R.image.icon_camera()?.withRenderingMode( .alwaysTemplate))!,
                                               handler:{(infoView) -> () in
                                                if KPUserManager.sharedManager.currentUser == nil       {
                                                    KPPopoverView.popoverLoginView()
                                                } else {
                                                    KPPopoverView.popoverUnsupportedView()
                                                }
        })]
        
        let shopRecommendView = KPShopRecommendView()
        shopRecommendView.informationController = self
        shopRecommendView.displayDataModels = KPServiceHandler.sharedHandler.relatedDisplayModel
        recommendInformationView = KPInformationSharedInfoView()
        recommendInformationView.infoView = shopRecommendView
        recommendInformationView.infoTitleLabel.text = "你可能也會喜歡"
        scrollContainer.addSubview(recommendInformationView)
        recommendInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-24-[$self]-32-|"],
                                                     views: [photoInformationView])
        
        NotificationCenter.default.addObserver(forName: Notification.Name(KPNotification.information.rateInformation),
                                               object: nil,
                                               queue: nil) { (_) in
                                                self.refreshRatings()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(KPNotification.information.commentInformation),
                                               object: nil,
                                               queue: nil) { (_) in
                                                self.refreshComments()
        }
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UI Update
    
    func syncRemoteData() {
        
        dataLoading = true
        KPServiceHandler.sharedHandler.fetchStoreInformation(informationDataModel.identifier) {
            [unowned self] (result) in
            self.informationHeaderButtonBar.informationDataModel = result
            self.informationHeaderView.scoreLabel.text = String(format: "%.1f",
                                                                result?.averageRate?.doubleValue ?? 0.0)
            self.dataLoading = false
        }
        
        // 取得 Comment 資料
        refreshComments()
        
        // 取得 Rating 資料
        refreshRatings()
        
        // 取得 Photo 資料
        KPServiceHandler.sharedHandler.getPhotos {
            [unowned self] (successed, photos) in
            if successed == true && photos != nil {
                var index: Int = 0
                for urlString in photos! {
                    if let url = URL(string: urlString) {
                        self.displayPhotoInformations.append(PhotoInformation(title: "", imageURL: url, index: index))
                        index += 1
                    }
                }
                if self.displayPhotoInformations.count == 0 {
                    
                    let transition = CATransition()
                    transition.duration = 0.2
                    transition.type = kCATransitionFade
                    self.informationHeaderView.shopPhoto.image = R.image.image_noImage()
                    self.informationHeaderView.shopPhoto.isUserInteractionEnabled = false
                    self.informationHeaderView.shopPhoto.layer.add(transition, forKey: nil)
                    self.informationHeaderView.morePhotoButton.titleLabel?.text = "上傳\n照片"
                }
            } else {
                // Handle Error
            }
        }
    }
    
    
    func refreshRatings() {
        
        // 取得 Rating 資料
        KPServiceHandler.sharedHandler.getRatings {
            [unowned self] (successed, rate) in
            if successed && rate != nil {
                (self.rateInformationView.infoView as! KPShopRateInfoView).rateData = rate
                // 加上 base 的數量
                let rateCount = (rate?.base != nil) ? (rate?.rates?.count)!+1 : (rate?.rates?.count)!
                
                self.informationHeaderButtonBar.rateButton.numberValue = rateCount
                self.informationHeaderButtonBar.rateButton.selected =
                    (KPUserManager.sharedManager.currentUser?.hasRated(self.informationDataModel.identifier)) ?? false
                self.rateInformationView.infoSupplementLabel.text = "\(rateCount) 人已評分"
                self.rateDataModel = rate
                
                if ((KPUserManager.sharedManager.currentUser?.hasRated) != nil) {
                    if let rate = self.rateDataModel?.rates?.first(where:
                        {$0.memberID == KPUserManager.sharedManager.currentUser?.identifier}) {
                        self.hasRatedDataModel = rate
                    }
                }
                
                if self.hasRatedDataModel != nil {
                    DispatchQueue.main.async {
                        self.rateInformationView.actionButtons[0].setTitle("修改評分", for: .normal)
                        self.informationHeaderButtonBar.rateButton.titleLabel.text = "修改評分"
                    }
                }
                
            } else {
                self.informationHeaderButtonBar.rateButton.numberValue = 0
                self.informationHeaderButtonBar.rateButton.selected = false
                self.rateInformationView.infoSupplementLabel.text = "0 人已評分"
            }
        }
    }
    
    
    func updateCommentsLayout(_ commentCount: Int) {
        if commentCount == 0 {
            self.commentInformationView.infoSupplementLabel.text = "0 人已留言"
            self.commentInformationView.isEmpty = true
            self.commentInformationView.actions = [Action(title:"我要評價",
                                                          style:.normal,
                                                          color:KPColorPalette.KPMainColor.mainColor!,
                                                          icon:(R.image.icon_comment()?.withRenderingMode(.alwaysTemplate))!,
                                                          handler:{ [unowned self] (infoView) -> () in
                                                            
                                                            if KPUserManager.sharedManager.currentUser == nil {
                                                                KPPopoverView.popoverLoginView()
                                                            } else {
                                                                if KPUserManager.sharedManager.currentUser == nil {
                                                                    KPPopoverView.popoverLoginView()
                                                                } else {
                                                                    let newCommentViewController = KPNewCommentController()
                                                                    if self.hasRatedDataModel != nil {
                                                                        DispatchQueue.main.async {
                                                                            newCommentViewController.hideRatingViews = true
                                                                        }
                                                                    }
                                                                    
                                                                    self.navigationController?.pushViewController(viewController: newCommentViewController,
                                                                                                                  animated: true,
                                                                                                                  completion: {})
                                                                }
                                                            }
            })
            ]
        } else {
            self.commentInformationView.actions = [
                Action(title:"看更多評價(\(commentCount))",
                    style:.normal,
                    color:KPColorPalette.KPMainColor.mainColor_sub!,
                    icon:nil,
                    handler:{ [unowned self] (infoView) -> () in
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
                       handler:{ [unowned self] (infoView) -> () in
                        if KPUserManager.sharedManager.currentUser == nil {
                            KPPopoverView.popoverLoginView()
                        } else {
                            let newCommentViewController = KPNewCommentController()
                            
                            if self.hasRatedDataModel != nil {
                                DispatchQueue.main.async {
                                    newCommentViewController.hideRatingViews = true
                                }
                            }
                            
                            self.navigationController?.pushViewController(viewController: newCommentViewController,
                                                                          animated: true,
                                                                          completion: {})
                        }
                })
            ]
        }

    }
    
    func refreshComments() {
        
        // 取得 Comment 資料
        KPServiceHandler.sharedHandler.getComments {
            [unowned self] (successed, comments) in
            if successed && comments != nil {
                self.commentInfoView.comments = comments!
                self.commentInformationView.infoSupplementLabel.text = "\(comments?.count ?? 0) 人已留言"
                
                self.commentInfoView.tableView.layoutIfNeeded()
                self.commentInfoView.tableViewHeightConstraint.constant = self.commentInfoView.tableView.contentSize.height
                self.commentInformationView.setNeedsLayout()
                self.commentInformationView.layoutIfNeeded()
                
                if let commentCountValue = comments?.count {
                    self.updateCommentsLayout(commentCountValue)
                    self.commentInformationView.isEmpty = (commentCountValue == 0)
                    self.informationHeaderButtonBar.commentButton.numberValue = commentCountValue
                    self.informationHeaderButtonBar.commentButton.selected =
                        (KPUserManager.sharedManager.currentUser?.hasReviewed(self.informationDataModel.identifier)) ?? false
                } else {
                    self.commentInfoView.tableViewHeightConstraint.constant = 64
                    self.commentInformationView.isEmpty = true
                }
            } else {
                self.commentInfoView.comments = [KPCommentModel]()
                self.commentInformationView.infoSupplementLabel.text = "0 人已留言"
                self.commentInfoView.tableView.layoutIfNeeded()
                self.commentInfoView.tableViewHeightConstraint.constant = 64
                self.commentInformationView.setNeedsLayout()
                self.commentInformationView.layoutIfNeeded()
                self.commentInformationView.isEmpty = true
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
    
    func handleMorePhotoButtonOnTapped() {
        if self.displayPhotoInformations.count == 0 {
            KPPopoverView.popoverUnsupportedView()
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
    
    func handleFacebookButtonOnTapped() {
        UIApplication.shared.open(URL(string: informationDataModel.facebookURL!)!,
                                  options: [:]) { (_) in
                                    
        }
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
        scrollContainer.contentOffset = CGPoint(x: 0,
                                                y: scrollContainer.contentOffset.y <= -120 ?
                                                    -120 :
                                                    scrollContainer.contentOffset.y)
        
        if scrollContainer.contentOffset.y <= 0 && scrollContainer.contentOffset.y >= -120 {
            let scaleRatio = 1 - scrollContainer.contentOffset.y/300
            let scaleRatioContainer = 1 - scrollContainer.contentOffset.y/240
            let oldFrame = informationHeaderView.shopPhotoContainer.frame
            
            animatedHeaderConstraint.constant = 0
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
            animatedHeaderConstraint.constant = -scrollContainer.contentOffset.y*9/20
            informationHeaderView.shopPhoto.transform = CGAffineTransform(translationX: 0,
                                                                          y: scrollContainer.contentOffset.y*9/20)
            informationHeaderView.isUserInteractionEnabled = false
            view.layoutIfNeeded()
        }
    }
}

extension KPInformationViewController: KPInformationHeaderViewDelegate {
    func headerPhotoTapped(_ headerView: KPInformationHeaderView) {
        
        if self.displayPhotoInformations.count == 0 {
            return
        }
        
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
        photoDisplayController.displayedPhotoInformations = self.displayPhotoInformations
        
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

