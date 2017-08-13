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
    
    var showBackButton: Bool = false
    var dismissWithDefaultType: Bool = false
    
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
    var currentPhotoIndex: Int!
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
                                       image: showBackButton ? R.image.icon_back()! : R.image.icon_close()!)
        dismissButton.contentEdgeInsets = showBackButton ? UIEdgeInsetsMake(3, 3, 3, 3) : UIEdgeInsetsMake(6, 7, 8, 7)
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
//        actionController.view.tintColor = KPColorPalette.KPTextColor.grayColor_level2
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
        
        let reportButton = UIAlertAction(title: "錯誤回報",
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
        informationHeaderView.scoreHandler = {
            [weak self] (_) in
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
        if let distanceInMeter = informationDataModel.distanceInMeter {
            var distance = distanceInMeter
            var unit = "m"
            if distance > 1000 {
                unit = "km"
                distance = distance/1000
            }
            locationInformationView.infoSupplementLabel.text = String(format: "%.1f%@", distance, unit)
        } else {
            locationInformationView.infoSupplementLabel.text = "你身在神秘的星球"
        }
        locationInformationView.actions = [
            Action(title:"街景模式",
                   style:.normal,
                   color:KPColorPalette.KPMainColor.mainColor_sub!,
                   icon:R.image.icon_street(),
                   handler:{
                    [weak self] (infoView) -> () in
                    if let weSelf = self {
                        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                            UIApplication.shared.open(URL(string:
                                "comgooglemaps://?center=\(weSelf.informationDataModel.latitude!),\(weSelf.informationDataModel.longitude!)&mapmode=streetview")!,
                                                      options: [:],
                                                      completionHandler: nil)
                        } else {
                            print("Can't use comgooglemaps://")
                        }
                    }
            }),
            Action(title:"開啟導航",
                   style:.normal,
                   color:KPColorPalette.KPMainColor.mainColor!,
                   icon:(R.image.icon_navi()?.withRenderingMode(.alwaysTemplate))!,
                   handler:{ [weak self] (infoView) -> () in
                    if let weSelf = self {
                        weSelf.present(weSelf.mapActionController,
                                       animated: true,
                                       completion: nil)
                    }

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
                                              handler:{
                                                [weak self] (infoView) -> () in
                                                if let weSelf = self {
                                                    if KPUserManager.sharedManager.currentUser == nil {
                                                        KPPopoverView.popoverLoginView()
                                                    } else {
                                                        let controller = KPModalViewController()
                                                        controller.edgeInset = UIEdgeInsets(top: UIDevice().isSuperCompact ? 32 : 72,
                                                                                                left: 0,
                                                                                                bottom: 0,
                                                                                                right: 0)
                                                        controller.cornerRadius = [.topRight, .topLeft]
                                                        let ratingViewController = KPRatingViewController()
                                                            
                                                        if weSelf.hasRatedDataModel != nil {
                                                            ratingViewController.defaultRateModel = weSelf.hasRatedDataModel
                                                        }
                                                        controller.contentController = ratingViewController
                                                        controller.presentModalView()
                                                    }
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
        commentInformationView.infoTitleLabel.text = "留言評論"
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
        scrollContainer.addSubview(photoInformationView)
        photoInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$view0]-24-[$self]"],
                                                    views: [commentInformationView])
        photoInformationView.actions = [Action(title: "上傳照片",
                                               style:.normal,
                                               color:KPColorPalette.KPMainColor.mainColor!,
                                               icon:(R.image.icon_camera()?.withRenderingMode( .alwaysTemplate))!,
                                               handler:{[unowned self] (infoView) -> () in
                                                self.photoUpload()
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
        
        refreshComments()
        refreshRatings()
        refreshPhoto()
        
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
    
    func refreshPhoto() {
        KPServiceHandler.sharedHandler.getPhotos {
            [weak self] (successed, photos) in
            if let weSelf = self {
                if successed == true && photos != nil {
                    var index: Int = 0
                    var photoInformations: [PhotoInformation] = []
                    for urlString in photos! {
                        if let url = URL(string: urlString) {
                            photoInformations.append(PhotoInformation(title: "",
                                                                     imageURL: url,
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
                        weSelf.photoInformationView.infoSupplementLabel.text = "0 張照片"
                        weSelf.photoInformationView.isEmpty = true
                        weSelf.informationHeaderView.morePhotoButton.setTitle("上傳\n照片", for: .normal)
                    } else {
                        weSelf.photoInformationView.infoSupplementLabel.text = "\(weSelf.displayPhotoInformations.count) 張照片"
                        weSelf.photoInformationView.isEmpty = false
                        weSelf.informationHeaderView.morePhotoButton.setTitle("\(weSelf.displayPhotoInformations.count) \n張照片",
                            for: .normal)
                        
                    }
                } else {
                    // Handle Error
                }
            }
        }
    }
    
    func refreshRatings() {
        
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
                                                          color:KPColorPalette.KPMainColor.mainColor!,
                                                          icon:(R.image.icon_comment()?.withRenderingMode(.alwaysTemplate))!,
                                                          handler:{ [weak self] (infoView) -> () in
                                                            if let weSelf = self {
                                                                if KPUserManager.sharedManager.currentUser == nil {
                                                                    KPPopoverView.popoverLoginView()
                                                                } else {
                                                                    if KPUserManager.sharedManager.currentUser == nil {
                                                                        KPPopoverView.popoverLoginView()
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
            self.commentInformationView.actions = [
                Action(title:"看更多評論(\(commentCount))",
                    style:.normal,
                    color:KPColorPalette.KPMainColor.mainColor_sub!,
                    icon:nil,
                    handler:{ [weak self] (infoView) -> () in
                        if let weSelf = self {
                            let commentViewController = KPAllCommentController()
                            commentViewController.comments = weSelf.commentInfoView.comments
                            commentViewController.animated = !weSelf.allCommentHasShown
                            weSelf.allCommentHasShown = true
                            weSelf.navigationController?.pushViewController(viewController: commentViewController,
                                                                            animated: true,
                                                                            completion: {})
                        }
                }),
                Action(title:"我要評論",
                       style:.normal,
                       color:KPColorPalette.KPMainColor.mainColor!,
                       icon:(R.image.icon_comment()?.withRenderingMode(.alwaysTemplate))!,
                       handler:{ [weak self] (infoView) -> () in
                        if let weSelf = self {
                            if KPUserManager.sharedManager.currentUser == nil {
                                KPPopoverView.popoverLoginView()
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
                })
            ]
        }

    }
    
    func refreshComments() {
        
        // 取得 Comment 資料
        KPServiceHandler.sharedHandler.getComments {
            [weak self] (successed, comments) in
            if let weSelf = self {
                if successed && comments != nil {
                    weSelf.commentInfoView.comments = comments!
                    weSelf.commentInformationView.infoSupplementLabel.text = "\(comments?.count ?? 0) 人已留言"
                    
                    weSelf.commentInfoView.tableView.layoutIfNeeded()
                    weSelf.commentInfoView.tableViewHeightConstraint.constant = weSelf.commentInfoView.tableView.contentSize.height
                    weSelf.commentInformationView.setNeedsLayout()
                    weSelf.commentInformationView.layoutIfNeeded()
                    
                    if let commentCountValue = comments?.count {
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
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { (action) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = false
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                //                                                        imagePickerController.mediaTypes = [kUTTypeImage as String]
                self.present(imagePickerController, animated: true, completion: nil)
            })
            controller.addAction(UIAlertAction(title: "開啟相機", style: .default) { (action) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.allowsEditing = false
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                //                                                        imagePickerController.mediaTypes = [kUTTypeImage as String]
                self.present(imagePickerController, animated: true, completion: nil)
            })
            
            controller.addAction(UIAlertAction(title: "取消", style: .cancel) { (action) in
                
            })
            
            self.present(controller, animated: true) {
                
            }
        }
    }
    
    func handleMorePhotoButtonOnTapped() {
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
            self.dismissWithDefaultType = true
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
                KPServiceHandler.sharedHandler.uploadPhotos([image],
                                                            self.informationDataModel.identifier, { (success) in
                    if success {
                        print("upload successed")
                    } else {
                        print("upload failed")
                    }
                })
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

