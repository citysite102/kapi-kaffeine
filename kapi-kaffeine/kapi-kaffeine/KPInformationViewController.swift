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
import Floaty
import ImagePicker

class KPInformationViewController: KPViewController {

    var informationDataModel: KPDataModel!
    var detailedInformationDataModel: KPDetailedDataModel! {
        didSet {
         
            KPServiceHandler.sharedHandler.currentDisplayModel = KPDataModel(JSON: detailedInformationDataModel.toJSON())
            DispatchQueue.main.async {
                self.titleLabel.text = self.detailedInformationDataModel.name
                if let relatedCount = KPServiceHandler.sharedHandler.relatedDisplayModel?.count  {
                    self.shopInformationView.separator.isHidden = relatedCount == 0 ? true : false
                    self.recommendInformationView.isHidden = relatedCount == 0 ? true : false
                    self.shopRecommendView.displayDataModels = KPServiceHandler.sharedHandler.relatedDisplayModel
                } else {
                    self.shopRecommendView.displayDataModels = KPServiceHandler.sharedHandler.relatedDisplayModel
                    self.shopInformationView.separator.isHidden = true
                    self.recommendInformationView.isHidden = true
                    self.recommendInformationView.removeAllRelatedConstraintsInSuperView()
                    self.shopInformationView.addConstraints(fromStringArray: ["V:[$self]-16-|"],
                                                       views: [self.commentInformationView])
                }
                
                // 實作地圖 Action
                let googleAction = UIAlertAction(title: "使用Google地圖開啟",
                                                 style: .default) {
                                                    [weak self] (_) in
                                                    if let weSelf = self {
                                                        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                                                            UIApplication.shared.open(URL(string:
                                                                "comgooglemaps://?daddr=\(weSelf.detailedInformationDataModel.latitude!),\(weSelf.detailedInformationDataModel.longitude!)&mapmode=standard")!,
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
                                                        let coordinates = CLLocationCoordinate2DMake(weSelf.detailedInformationDataModel.latitude!,
                                                                                                     weSelf.detailedInformationDataModel.longitude!)
                                                        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                                                        let mapItem = MKMapItem(placemark: placemark)
                                                        mapItem.openInMaps(launchOptions: nil)
                                                    }
                }
                
                let mapCancelAction = UIAlertAction(title: "取消",
                                                    style: .destructive) { (_) in
                                                        print("取消 Map")
                }
                
                self.mapActionController.addAction(googleAction)
                self.mapActionController.addAction(appleAction)
                self.mapActionController.addAction(mapCancelAction)
                
                
                // Header
                self.informationHeaderView.scoreLabel.text = String(format: "%.1f", self.detailedInformationDataModel.averageRate?.doubleValue ?? 0.0)
                self.informationHeaderView.facebookButton.isHidden = !(self.detailedInformationDataModel.facebookURL != nil)
                
                if let photoURL = self.detailedInformationDataModel.imageURL_l ?? self.detailedInformationDataModel.googleURL_l {
                    self.informationHeaderView.shopPhoto.af_setImage(withURL: photoURL,
                                                                     placeholderImage: nil,
                                                                     filter: nil,
                                                                     progress: nil,
                                                                     progressQueue:  DispatchQueue.global(),
                                                                         imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                                                    runImageTransitionIfCached: true,
                                                                    completion: { response in
                                                                        if let responseImage = response.result.value {
                                                                            self.informationHeaderView.shopPhoto.image =  responseImage
                                                                    }
                    })
                } else {
                    
                }
                
                
                // Card Info
                
                self.cardInformationContainer.titleInfoLabel.text = self.detailedInformationDataModel.name
                var distName: String = ""
                
                if let distIndex = self.detailedInformationDataModel.address.index(of: "區") {
                    let startIndex = self.detailedInformationDataModel.address.index(distIndex, offsetBy:-2)
                    distName = String(self.detailedInformationDataModel.address[startIndex...distIndex])
                }
                
                self.cardInformationContainer.locationInfoLabel.text =  (KPInfoMapping.citiesMapping[self.detailedInformationDataModel.city]
                    ?? "") +
                    (distName != "" ? ", \(distName)" : "")
                
                self.cardInformationContainer.rateLabel.text = String(format: "%.1f",
                                                                 (self.detailedInformationDataModel.averageRate?.doubleValue) ?? 0)
                
                // Comment
                if let commentCount = self.detailedInformationDataModel.commentCount {
                    self.commentInformationView.infoSupplementLabel.text = "\(commentCount) 人已留言"
                    self.commentInformationView.isEmpty = (commentCount == 0)
                    self.updateCommentsLayout(Int(truncating: commentCount))
                }
                
                // Rate
                
//                self.shopRateInfoView.dataModel = self.detailedInformationDataModel
//                self.rateInformationView.infoTitleLabel.text = "店家評分(\(self.detailedInformationDataModel.rateCount ?? 0))"
//                self.rateInformationView.infoSupplementLabel.text = "\(self.detailedInformationDataModel.rateCount ?? 0) 人已評分"
                
                
                // Shop Information
                
                self.informationView.informationDataModel = self.detailedInformationDataModel
                
            }
            
            
            
            
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
    
    var cardInformationContainer: KPInformationCardView!
    var shopInformationView: KPInformationSharedInfoView!
    var rateInformationView: KPInformationSharedInfoView!
    var shopRateInfoView: KPShopRateInfoView!
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
    var shopRecommendView: KPShopRecommendView!
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
    
    var allCommentHasShown: Bool = false
    var dataLoading: Bool = true {
        didSet {
            if dataLoading {
                
                self.cardInformationContainer.isHidden = true
                self.cardInformationContainer.alpha = 0.0
                self.cardInformationContainer.layer.transform = CATransform3DMakeTranslation(0, 75, 0)
                self.photoInformationView.isHidden = true
                self.photoInformationView.alpha = 0.0
                self.photoInformationView.layer.transform = CATransform3DMakeTranslation(0, 75, 0)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if KPPopoverView.sharedPopoverView.contentView != nil {
            KPPopoverView.sharedPopoverView.dismiss()
        }
        navigationController?.setNavigationBarHidden(false,
                                                     animated: false)
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KPAnalyticManager.sendPageViewEvent(KPAnalyticsEventValue.page.detail_page)
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        navigationController?.delegate = self
        
        actionController = UIAlertController(title: nil,
                                             message: nil,
                                             preferredStyle: .actionSheet)
//        let editButton = UIAlertAction(title: "編輯店家資料",
//                                       style: .default) {
//                                        [unowned self] (_) in
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
//        }
        
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
        
        actionController.addAction(reportButton)
        actionController.addAction(closeButton)
        actionController.addAction(cancelButton)
        
        
        mapActionController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        mapActionController.view.tintColor = KPColorPalette.KPTextColor.grayColor_level2
        

        scrollContainer = UIScrollView()
        scrollContainer.backgroundColor = UIColor.white
        scrollContainer.delegate = self
        scrollContainer.canCancelContentTouches = false
        view.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        
        informationHeaderView = KPInformationHeaderView(frame: CGRect.zero)
        informationHeaderView.delegate = self
        informationHeaderView.informationController = self
        
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
        loadingIndicator.addConstraints(fromStringArray: ["V:[$view0]-32-[$self]"],
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
        cardInformationContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0][$self]"],
                                                views: [informationHeaderView])
        
        let photoInfoView = KPShopPhotoInfoView()
        photoInfoView.informationController = self
        photoInformationView = KPInformationSharedInfoView()
        photoInformationView.emptyLabel.text = "成為第一個上傳的人吧:D"
        photoInformationView.infoView = photoInfoView
        photoInformationView.infoTitleLabel.text = "照片"
        photoInformationView.infoSupplementLabel.text = "查看所有照片"
        scrollContainer.addSubview(photoInformationView)
        photoInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$view0]-8-[$self]"],
                                            views: [cardInformationContainer])
        
        let menuInfoView = KPShopPhotoInfoView()
        menuInfoView.isMenu = true
        menuInfoView.informationController = self
        menuInformationView = KPInformationSharedInfoView()
        menuInformationView.infoView = menuInfoView
        scrollContainer.addSubview(menuInformationView)
        menuInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0][$self]"],
                                           views: [photoInformationView])
        
        commentInfoView = KPShopCommentInfoView()
        commentInfoView.informationController = self
        commentInformationView = KPInformationSharedInfoView()
        commentInformationView.emptyLabel.text = "幫忙給點建議或分享吧:D"
        commentInformationView.infoView = commentInfoView
        commentInformationView.infoTitleLabel.text = "留言評論"
        commentInformationView.infoSupplementLabel.text = "查看所有評論"
        scrollContainer.addSubview(commentInformationView)
        commentInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                "V:[$view0]-16-[$self]"],
                                              views: [menuInformationView])
    
        
//        shopRateInfoView = KPShopRateInfoView()
//        rateInformationView = KPInformationSharedInfoView()
//        rateInformationView.infoView = shopRateInfoView
//        scrollContainer.addSubview(rateInformationView)
//        rateInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
//                                                             "V:[$view0]-16-[$self]"],
//                                                views: [commentInformationView])
        
        
        informationView = KPShopInfoView()
        shopInformationView = KPInformationSharedInfoView()
        shopInformationView.infoView = informationView
        shopInformationView.infoTitleLabel.text = "店家資訊"
        scrollContainer.addSubview(shopInformationView)
        
        if self.navigationController != nil {
            shopInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                 "V:[$view0]-16-[$self]"],
                                               views: [commentInformationView])
        } else {
            shopInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                 "V:[$view0]-16-[$self]-16-|"],
                                               views: [commentInformationView])
        }
        
        
        shopInformationView.actions = [
            Action(title:"街景模式",
                   style:.normal,
                   color:KPColorPalette.KPMainColor_v2.mainColor_sub!,
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
                   color:KPColorPalette.KPMainColor_v2.mainColor!,
                   icon:(R.image.icon_navi()?.withRenderingMode(.alwaysTemplate))!,
                   handler:{ [weak self] (infoView) -> () in
                    KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.store_navigation_button)
                    if let weSelf = self {
                        weSelf.present(weSelf.mapActionController,
                                       animated: true,
                                       completion: nil)
                    }
                    
            })
        ]

        
        
        
//        locationInformationView = KPInformationSharedInfoView()
//        locationInformationView.infoTitleLabel.text = "位置訊息"
//        if let distanceInMeter = informationDataModel.distanceInMeter {
//            var distance = distanceInMeter
//            var unit = "m"
//            if distance > 1000 {
//                unit = "km"
//                distance = distance/1000
//            }
//            locationInformationView.infoSupplementLabel.text = String(format: "%.1f%@", distance, unit)
//        } else {
//            locationInformationView.infoSupplementLabel.text = "開啟導航"
//        }
//        scrollContainer.addSubview(locationInformationView)
//        locationInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
//                                                                 "V:[$view0]-16-[$self(292)]"],
//                                               views: [shopInformationView])
        

        shopRecommendView = KPShopRecommendView()
        shopRecommendView.informationController = self
        recommendInformationView = KPInformationSharedInfoView()
        recommendInformationView.infoView = shopRecommendView
        recommendInformationView.infoTitleLabel.text = "你可能也會喜歡"
        if self.navigationController != nil {
            scrollContainer.addSubview(recommendInformationView)
            recommendInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                      "V:[$view0]-16-[$self]-16-|"],
                                                         views: [shopInformationView])
        }

        
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
        syncRemoteData()
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.navigationController != nil {
            navBarFixBound = navigationController!.navigationBar.bounds
        }
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
                                                         "H:|[$self]|"], metrics:[KPLayoutConstant.topBar_height-4])
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: KPFontSize.sub_header)
        titleLabel.textColor = KPColorPalette.KPTextColor_v2.whiteColor
        titleLabel.alpha = 0.0
        view.addSubview(titleLabel)
        titleLabel.addConstraint(from: "H:[$self(<=280)]")
        titleLabel.addConstraintForCenterAligning(to: topBarContainer,
                                                  in: .vertical,
                                                  constant: 12)
        titleLabel.addConstraintForCenterAligning(to: topBarContainer,
                                                  in: .horizontal,
                                                  constant: 0)
        
        dismissButton = KPBounceButton(frame: CGRect.zero,
                                       image: showBackButton ? R.image.icon_back()! : R.image.icon_close()!)
        dismissButton.tintColor = KPColorPalette.KPTextColor_v2.whiteColor
        dismissButton.alpha = 1.0
        view.addSubview(dismissButton)
        dismissButton.addConstraints(fromStringArray: ["V:[$self($metric0)]",
                                                       "H:|-16-[$self($metric0)]"], metrics:[KPLayoutConstant.dismissButton_size])
        dismissButton.addConstraintForCenterAligning(to: topBarContainer,
                                                     in: .vertical,
                                                     constant: 12)
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
        moreButton.addConstraints(fromStringArray: ["V:[$self($metric0)]",
                                                    "H:[$self($metric0)]-16-|"], metrics:[KPLayoutConstant.dismissButton_size])
        moreButton.addConstraintForCenterAligning(to: topBarContainer,
                                                     in: .vertical,
                                                     constant: 12)
        
    }
    // MARK: UI Update
    
    func syncRemoteData() {
        
        dataLoading = true
        
        KPServiceHandler.sharedHandler.fetchStoreInformation(informationDataModel.identifier) {
            [weak self] (result) in
            if let weSelf = self {
                weSelf.detailedInformationDataModel = result
                weSelf.refreshRatings()
                weSelf.refreshComments()
                weSelf.refreshPhoto()
                weSelf.refreshMenu()
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5,
                                              execute: {
                                                weSelf.dataLoading = false
                })
            }
        }
    }
    
    
    func refreshMenu() {
        KPServiceHandler.sharedHandler.getMenus {
            [weak self] (successed, photos) in
            if let weSelf = self {
                
                DispatchQueue.main.async {
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
                            weSelf.menuInformationView.showEmptyContent = false
                            weSelf.menuInformationView.separator.isHidden = true
//                            (weSelf.photoInformationView.infoView as! KPShopPhotoInfoView).smallerVerticlePadding = false
                            weSelf.photoInformationView.actions = [Action(title:"上傳照片",
                                                                          style:.normal,
                                                                          color:KPColorPalette.KPMainColor_v2.mainColor!,
                                                                          icon:(R.image.icon_star()?.withRenderingMode(.alwaysTemplate))!,
                                                                          handler:{
                                                                            [weak self] (infoView) -> () in
                                                                            if let weSelf = self {
                                                                                if KPUserManager.sharedManager.currentUser == nil {
                                                                                    KPPopoverView.popoverLoginView()
                                                                                } else {
                                                                                    
                                                                                }
                                                                            }
                            })]
                            
                        } else {
                            weSelf.menuInformationView.infoSupplementLabel.text = ""
                            weSelf.menuInformationView.isEmpty = false
//                            (weSelf.photoInformationView.infoView as! KPShopPhotoInfoView).smallerVerticlePadding = false
                            weSelf.photoInformationView.separator.isHidden = true
                            weSelf.menuInformationView.actions = [Action(title:"上傳照片",
                                                                         style:.normal,
                                                                         color:KPColorPalette.KPMainColor_v2.mainColor!,
                                                                         icon:(R.image.icon_star()?.withRenderingMode(.alwaysTemplate))!,
                                                                         handler:{
                                                                            [weak self] (infoView) -> () in
                                                                            if let weSelf = self {
                                                                                if KPUserManager.sharedManager.currentUser == nil {
                                                                                    KPPopoverView.popoverLoginView()
                                                                                } else {
                                                                                    
                                                                                }
                                                                            }
                            })]
                        }
                    } else {
                        weSelf.menuInformationView.infoSupplementLabel.text = "尚無照片"
                        weSelf.menuInformationView.isEmpty = true
                    }
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
                        weSelf.informationHeaderView.shopPhoto.image = R.image.image_first_photo()
                        weSelf.informationHeaderView.shopPhoto.isUserInteractionEnabled = false
                        weSelf.informationHeaderView.shopPhoto.layer.add(transition, forKey: nil)
                        weSelf.informationHeaderView.morePhotoButton.titleLabel?.text = "上傳\n照片"
                        weSelf.photoInformationView.infoTitleLabel.text = "照片（\(weSelf.displayPhotoInformations.count)）"
                        weSelf.photoInformationView.infoSupplementLabel.text = "尚無照片"
                        weSelf.photoInformationView.isEmpty = true
                        weSelf.informationHeaderView.morePhotoButton.setTitle("上傳\n照片", for: .normal)
                    } else {
                        weSelf.photoInformationView.infoSupplementLabel.text = "\(weSelf.displayPhotoInformations.count) 張照片"
                        weSelf.photoInformationView.isEmpty = false
                        weSelf.photoInformationView.infoTitleLabel.text = "照片(\(weSelf.displayPhotoInformations.count))"
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
//                    (weSelf.rateInformationView.infoView as! KPShopRateInfoView).rateData = rate
//                    // 加上 base 的數量
//                    let rateCount = (rate?.base != nil) ? (rate?.rates?.count)!+1 : (rate?.rates?.count)!
//
//                    weSelf.rateInformationView.infoTitleLabel.text = "店家評分(\(rateCount))"
//                    weSelf.rateInformationView.infoSupplementLabel.text = "\(rateCount) 人已評分"
//                    weSelf.rateDataModel = rate
                    
                    if ((KPUserManager.sharedManager.currentUser?.hasRated) != nil) {
                        if let rate = weSelf.rateDataModel?.rates?.first(where:
                            {$0.memberID == KPUserManager.sharedManager.currentUser?.identifier}) {
                            weSelf.hasRatedDataModel = rate
                        }
                    }
                    
                    if weSelf.hasRatedDataModel != nil {
                        DispatchQueue.main.async {
//                            weSelf.rateInformationView.actionButtons[0].setTitle("修改評分", for: .normal)
                        }
                    }
                    
                } else {
//                    weSelf.rateInformationView.infoSupplementLabel.text = ""
                }
            }
        }
    }
    
    
    func updateCommentsLayout(_ commentCount: Int) {
        if commentCount == 0 {
            self.commentInformationView.infoSupplementLabel.text = ""
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
                        }
                        
                        let commentCountValue = comments.count
                        weSelf.updateCommentsLayout(commentCountValue)
                        weSelf.commentInformationView.isEmpty = (commentCountValue == 0)
                        
                    } else {
                        weSelf.commentInfoView.tableViewHeightConstraint.constant = 64
                        weSelf.commentInformationView.isEmpty = true
                    }
                } else {
                    weSelf.commentInfoView.comments = [KPCommentModel]()
                    weSelf.commentInformationView.infoSupplementLabel.text = ""
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
        
        cardInformationContainer.isHidden = false
        photoInformationView.isHidden = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.cardInformationContainer.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
            self.photoInformationView.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
        }
        
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.51, 0.98, 0.43, 1)
        let translateAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        translateAnimation.duration = 0.65
        translateAnimation.toValue = 0
        translateAnimation.isRemovedOnCompletion = false
        translateAnimation.fillMode = kCAFillModeBoth
        translateAnimation.timingFunction = timingFunction
        
        cardInformationContainer.layer.add(translateAnimation, forKey: nil)
        photoInformationView.layer.add(translateAnimation, forKey: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.cardInformationContainer.alpha = 1.0
                        self.photoInformationView.alpha = 1.0
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
                self.pickerType = .photo
                let imagePickerController = ImagePickerController()
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
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
                self.pickerType = .menu
                let imagePickerController = ImagePickerController()
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
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
        UIApplication.shared.open(URL(string: detailedInformationDataModel.facebookURL!)!,
                                  options: [:]) { (_) in
                                    
        }
    }
    
    
    @objc func handleOtherTimeButtonOnTapped() {
        
        let controller = KPModalViewController()
        let businessTimeViewController = KPBusinessTimeViewController()
        
        controller.edgeInset = UIEdgeInsetsMake(0, 0, 0, 0)
        controller.dismissWhenTouchingOnBackground = true
        controller.presentationStyle = .popout
        businessTimeViewController.businessTime = detailedInformationDataModel.businessHour
        businessTimeViewController.titleLabel.setText(text: detailedInformationDataModel.name,
                                                      lineSpacing: 3.0)
        controller.contentController = businessTimeViewController
        controller.presentModalView()
    }
    
    @objc func handleDismissButtonOnTapped() {
        if self.navigationController?.viewControllers.first is KPInformationViewController && self.navigationController?.viewControllers.first != self {
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

// MARK: - ImageTransitionProtocol

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

// MARK: - UINavigationControllerDelegate

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

// MARK: - UIScrollViewDelegate

extension KPInformationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if viewHasAppeared {
            
            // 處理 Tool Bar
            if self.scrollContainer.contentOffset.y >= 120 {
                topBarContainer.alpha = (self.scrollContainer.contentOffset.y - 120) / 40
                titleLabel.alpha = (self.scrollContainer.contentOffset.y - 120) / 40
                dismissButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
                moreButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
                moreButton.selectedTintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
                titleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
                
                let notification = Notification(name: Notification.Name(KPNotification.statusBar.statusBarShouldDefault))
                NotificationCenter.default.post(notification)
                
            } else {
                topBarContainer.alpha = 0
                titleLabel.alpha = 0
                dismissButton.tintColor = KPColorPalette.KPTextColor_v2.whiteColor
                moreButton.tintColor = KPColorPalette.KPTextColor_v2.whiteColor
                moreButton.selectedTintColor = KPColorPalette.KPTextColor_v2.whiteColor
                titleLabel.textColor = KPColorPalette.KPTextColor_v2.whiteColor
                
                let notification = Notification(name: Notification.Name(KPNotification.statusBar.statusBarShouldLight))
                NotificationCenter.default.post(notification)
                
            }
            
            
            
            
            scrollContainer.contentOffset = CGPoint(x: 0,
                                                    y: scrollContainer.contentOffset.y <= -120 ?
                                                        -120 :
                                                        scrollContainer.contentOffset.y)
            
            if scrollContainer.contentOffset.y <= 0 && scrollContainer.contentOffset.y >= -120 {
                let scaleRatio = 1 - scrollContainer.contentOffset.y/300
                let scaleRatioContainer = 1 - scrollContainer.contentOffset.y/240
                let oldFrame = informationHeaderView.shopPhotoContainer.frame
                
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

// MARK: - KPInformationHeaderViewDelegate

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
        
        
        let browser = KPPhotoBrowser(originImage: headerView.shopPhoto.image!,
                                     photos: photoSource,
                                     animatedFromView: headerView.shopPhoto)
        browser.initializePageIndex(currentPhotoIndex)
        browser.delegate = self
        present(browser, animated: true, completion: {})
    }
}

// MARK: - SKPhotoBrowserDelegate

extension KPInformationViewController: SKPhotoBrowserDelegate {
    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        return self.informationHeaderView.shopPhoto
    }
    
    func didShowPhotoAtIndex(_ index: Int) {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.informationHeaderView.shopPhoto.alpha = 0
        }) { (_) in
            self.informationHeaderView.shopPhoto.isHidden = true
        }
    }
    
    func didDismissAtPageIndex(_ index: Int) {
        self.informationHeaderView.shopPhoto.isHidden = false
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.informationHeaderView.shopPhoto.alpha = 1.0
        }) { (_) in
        }
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


extension KPInformationViewController : UIImagePickerControllerDelegate, ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true) {
            if self.pickerType == .menu {
                KPServiceHandler.sharedHandler.uploadMenus(images,
                                                           self.detailedInformationDataModel.identifier,
                                                           true,
                                                           { (success) in
                                                            if success {
                                                                print("upload successed")
                                                            } else {
                                                                print("upload failed")
                                                            }
                })
            } else if self.pickerType == .photo {
                KPServiceHandler.sharedHandler.uploadPhotos(images,
                                                            self.detailedInformationDataModel.identifier,
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
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
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

