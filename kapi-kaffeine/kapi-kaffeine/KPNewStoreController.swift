//
//  KPNewStoreController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GooglePlaces

struct KPNewStoreControllerConstants {
    static let leftPadding = 168
}

class KPNewStoreController: KPViewController, UITextFieldDelegate {
    
    enum EditorType {
        case modify
        case add
    }
    
    var _scrollContainerView: UIView {
        get {
            return containerView
        }
    }
    
    var _activeTextField: UIView? {
        get {
            return activeTextField
        }
    }
    
    var _scrollView: UIScrollView {
        get {
            return scrollView
        }
    }
    
    var dismissButton: KPBounceButton!
    var sendButton: UIButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    var tapGesture: UITapGestureRecognizer!
    
    var sectionOneContainer: UIView!
    var sectionTwoContainer: UIView!
    
    var sectionOneHeaderLabel: UILabel!
    var sectionTwoHeaderLabel: UILabel!
    
    var timeLimitLabel: UILabel!
    var timeRadioBoxOne: KPCheckView!
    var timeRadioBoxTwo: KPCheckView!
    var timeRadioBoxThree: KPCheckView!
    var timeRadioBoxFour: KPCheckView!
    
    var socketLabel: UILabel!
    var socketRadioBoxOne: KPCheckView!
    var socketRadioBoxTwo: KPCheckView!
    var socketRadioBoxThree: KPCheckView!
    var socketRadioBoxFour: KPCheckView!
    
    var standDeskLabel: UILabel!
    var standDeskCheckBoxOne: KPCheckView!
    var standDeskCheckBoxTwo: KPCheckView!
    var standDeskCheckBoxThree: KPCheckView!
    
    var nameSubTitleView: KPSubTitleEditView!
    var citySubTitleView: KPSubTitleEditView!
    var priceSubTitleView: KPSubTitleEditView!
    var featureSubTitleView: KPSubTitleEditView!
    var sizingCell: KPFeatureTagCell!
    
    var activeTextField: UITextField?
    
    var addressSubTitleView: KPSubTitleEditView!
    var addressMapView: GMSMapView!
    var phoneSubTitleView: KPSubTitleEditView!
    var facebookSubTitleView: KPSubTitleEditView!
    var photoUploadSubTitleView: KPSubTitlePhotoUploadView!
    
    var menuPhotoUploadSubTitleView: KPSubTitlePhotoUploadView!
    
    var nameInputController: KPSubtitleInputController!
    var ratingController: KPRatingViewController!
    var countrySelectController: KPCountrySelectController?
    var priceSelectController: KPPriceSelectController?
    var businessHourController: KPBusinessHourViewController?
    var mapInputController: KPMapInputViewController!
    
    var featureCollectionView: UICollectionView!
    var featureCollectionViewHeightConstraint: NSLayoutConstraint!
    var rateCheckedView: KPItemCheckedView!
    var businessHourCheckedView: KPItemCheckedView!
    
    var dataModel: KPDataModel?
    var rateDataModel: KPSimpleRateModel?
    
    var selectedCoordinate: CLLocationCoordinate2D!  {
        didSet {
            if addressMapView != nil {
                addressMapView.clear()
                addressMapView.camera = GMSCameraPosition.camera(withTarget: selectedCoordinate,
                                                                 zoom: addressMapView.camera.zoom)
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: selectedCoordinate.latitude,
                                                                        longitude: selectedCoordinate.longitude))
                marker.map = addressMapView
            }
        }
    }
    
    var type: EditorType
    
    func headerLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = title
        return label
    }
    
    init(_ etype:EditorType) {
        type = etype
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        
        // Navigation Bar ==============================================
        
        if type == .add {
            navigationController?.navigationBar.topItem?.title = "新增店家"
        } else if type == .modify {
            navigationController?.navigationBar.topItem?.title = "修改店家"
        }

        dismissButton = KPBounceButton(frame: CGRect.zero,
                                       image: R.image.icon_close()!)
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 8, 14)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(handleDismissButtonOnTapped),
                                for: .touchUpInside)

        let barItem = UIBarButtonItem(customView: dismissButton)

        sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        if type == .add {
            sendButton.setTitle("新增", for: .normal)
        } else if type == .modify {
            sendButton.setTitle("送出", for: .normal)
        }
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendButton.tintColor = KPColorPalette.KPTextColor.mainColor
        sendButton.addTarget(self,
                             action: #selector(KPNewStoreController.handleSendButtonOnTapped),
                             for: .touchUpInside)

        let rightbarItem = UIBarButtonItem(customView: sendButton)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)

        rightbarItem.isEnabled = true
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightbarItem]
        
        
        
        // ============================================================


        scrollView = UIScrollView()
        scrollView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                    "H:|[$self]|"])
        scrollView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:|[$self]|"])
        containerView.addConstraintForHavingSameWidth(with: view)
        
        sectionOneHeaderLabel = headerLabel("請協助填寫店家相關資訊")
        containerView.addSubview(sectionOneHeaderLabel)
        sectionOneHeaderLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                               "V:|-16-[$self]"])
        
        sectionOneContainer = UIView()
        sectionOneContainer.backgroundColor = UIColor.white
        containerView.addSubview(sectionOneContainer)
        sectionOneContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-8-[$self]"],
                                           views: [sectionOneHeaderLabel])
     
        
        // name
        
        nameSubTitleView = KPSubTitleEditView(.Bottom,
                                              .Fixed,
                                              "店家名稱")
        nameSubTitleView.placeHolderContent = "請輸入店家名稱"
        nameSubTitleView.customInputAction = {
            [unowned self] () -> Void in
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            if self.nameInputController == nil {
                self.nameInputController = KPSubtitleInputController()
                self.nameInputController.delegate = self
                self.nameInputController.identifiedKey = "name"
            }
            controller.contentController = self.nameInputController
            controller.presentModalView()
        }
        sectionOneContainer.addSubview(nameSubTitleView)
        nameSubTitleView.content = dataModel?.name ?? ""
        nameSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                          "V:|[$self(72)]"])
        
        
        // city
        
        citySubTitleView = KPSubTitleEditView(.Bottom,
                                              .Fixed,
                                              "所在城市")
        citySubTitleView.placeHolderContent = "請選擇城市"
        citySubTitleView.customInputAction = {
            [unowned self] () -> Void in
            
            self.view.endEditing(true)
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: UIDevice().isCompact ? 48 : 56,
                                                     left: 0,
                                                     bottom: 0,
                                                     right: 0)
            controller.cornerRadius = [.topRight, .topLeft]
            if self.countrySelectController == nil {
                self.countrySelectController = KPCountrySelectController()
                self.countrySelectController!.identifiedKey = "country"
                self.countrySelectController!.delegate = self
            }
            controller.contentController = self.countrySelectController
            controller.presentModalView()
        }
        citySubTitleView.content = KPCityRegionModel.getRegionStringWithKey(dataModel?.city) ?? ""
        sectionOneContainer.addSubview(citySubTitleView)
        citySubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                          "V:[$view0][$self(72)]"],
                                        views:[nameSubTitleView])
        
        
        // price
        
        priceSubTitleView = KPSubTitleEditView(.Bottom,
                                               .Fixed,
                                               "價格區間")
        priceSubTitleView.placeHolderContent = "請選擇價格區間"
        priceSubTitleView.customInputAction = {
            [unowned self] () -> Void in
            
            self.view.endEditing(true)
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: UIDevice().isCompact ? 48 : 56,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            controller.cornerRadius = [.topRight, .topLeft]
            if self.priceSelectController == nil {
                self.priceSelectController = KPPriceSelectController()
                self.priceSelectController!.identifiedKey = "price"
                self.priceSelectController!.delegate = self
            }
            controller.contentController = self.priceSelectController
            controller.presentModalView()
        }
        sectionOneContainer.addSubview(priceSubTitleView)
        if let priceIndex = dataModel?.priceAverage?.intValue,
            priceIndex >= 0 {
            priceSubTitleView.content = KPPriceSelectController.priceRanges[priceIndex]
            
        }
        priceSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                           "V:[$view0][$self(72)]"],
                                         views:[citySubTitleView])
        
        
        // feature tags
        
        featureSubTitleView = KPSubTitleEditView(.Bottom,
                                                 .Custom,
                                                 "選擇店家特色標籤")
        sectionOneContainer.addSubview(featureSubTitleView)
        featureSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0][$self]"],
                                        views:[priceSubTitleView])
        
        sizingCell = KPFeatureTagCell()
        
        
        let flowLayout = KPFeatureTagLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        
        featureCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: flowLayout)
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        featureCollectionView.backgroundColor = UIColor.clear
        featureCollectionView.allowsMultipleSelection = true
        featureCollectionView.register(KPFeatureTagCell.self,
                                       forCellWithReuseIdentifier: "cell")
        
        featureCollectionViewHeightConstraint = featureCollectionView.addConstraint(forHeight: 100)
        
        featureCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        featureSubTitleView.customInfoView = featureCollectionView
        
        
        // business hour
        
        businessHourCheckedView = KPItemCheckedView("填寫營業時間",
                                                    "未填寫",
                                                    "已填寫",
                                                    .Bottom)
        sectionOneContainer.addSubview(businessHourCheckedView)
        businessHourCheckedView.customInputAction = {
            [unowned self] () -> Void in
            
            self.view.endEditing(true)
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: UIDevice().isSuperCompact ? 32 : 72,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            if self.businessHourController == nil {
                self.businessHourController = KPBusinessHourViewController()
                self.businessHourController!.identifiedKey = "time"
                self.businessHourController!.delegate = self
            }
            controller.contentController = self.businessHourController
            controller.cornerRadius = [.topRight, .topLeft]
            controller.presentModalView()
        }
        
        if let businessHour = dataModel?.businessHour {
            businessHourController = KPBusinessHourViewController()
            businessHourController!.identifiedKey = "time"
            businessHourController!.delegate = self
            businessHourController!.setBusinessHour(businessHour.originalData)
            businessHourCheckedView.checked = true
        }
        
        
        if type == .add {
        
            // rate
            rateCheckedView = KPItemCheckedView("幫店家評分",
                                                "未評分",
                                                "已評分(3.0)",
                                                .Bottom)
            sectionOneContainer.addSubview(rateCheckedView)
            rateCheckedView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0][$self(64)]"],
                                               views:[featureSubTitleView])
            rateCheckedView.customInputAction = {
                [unowned self] () -> Void in
                
                self.view.endEditing(true)
                let controller = KPModalViewController()
                controller.edgeInset = UIEdgeInsets(top: UIDevice().isSuperCompact ? 32 : 72,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
                controller.cornerRadius = [.topRight, .topLeft, .bottomLeft, .bottomRight]
                if self.ratingController == nil {
                    self.ratingController = KPRatingViewController()
                    self.ratingController.identifiedKey = "rate"
                    self.ratingController.isRemote = false
                    self.ratingController.delegate = self
                }
                controller.contentController = self.ratingController
                controller.presentModalView()
            }
            
            if let rateDataModel = rateDataModel {
                ratingController = KPRatingViewController()
                ratingController.identifiedKey = "rate"
                ratingController.isRemote = false
                ratingController.delegate = self
                ratingController.defaultRateModel = rateDataModel
                rateCheckedView.checkContent = String(format: "已評分(%.1f)", rateDataModel.averageRate)
                rateCheckedView.checked = true
            }
            
            businessHourCheckedView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                     "V:[$view0][$self(64)]|"],
                                                   views:[rateCheckedView])
            
        } else if type == .modify {
            
            businessHourCheckedView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                     "V:[$view0][$self(64)]|"],
                                                   views:[featureSubTitleView])
            
        }
        
        
        sectionTwoHeaderLabel = headerLabel("其他選項")
        containerView.addSubview(sectionTwoHeaderLabel)
        sectionTwoHeaderLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                               "V:[$view0]-16-[$self]"],
                                             views:[sectionOneContainer])
        
        sectionTwoContainer = UIView()
        sectionTwoContainer.backgroundColor = UIColor.white
        containerView.addSubview(sectionTwoContainer)
        sectionTwoContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-8-[$self]-8-|"],
                                           views: [sectionTwoHeaderLabel])
        
        timeLimitLabel = headerLabel("有無時間限制")
        sectionTwoContainer.addSubview(timeLimitLabel)
        timeLimitLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                        "V:|-16-[$self]"])
        timeRadioBoxOne = KPCheckView(.radio, "有限時")
        timeRadioBoxOne.customValue = 1
        sectionTwoContainer.addSubview(timeRadioBoxOne)
        timeRadioBoxOne.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                         "V:[$view0]-16-[$self]"],
                                       views: [timeLimitLabel])
        timeRadioBoxTwo = KPCheckView(.radio, "客滿/人多限時")
        timeRadioBoxTwo.customValue = 3
        sectionTwoContainer.addSubview(timeRadioBoxTwo)
        timeRadioBoxTwo.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                         "V:[$view0]-16-[$self]"],
                                       views: [timeRadioBoxOne])
        timeRadioBoxThree = KPCheckView(.radio, "不限時")
        timeRadioBoxThree.customValue = 2
        sectionTwoContainer.addSubview(timeRadioBoxThree)
        timeRadioBoxThree.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                         views: [timeRadioBoxTwo])
        
        timeRadioBoxFour = KPCheckView(.radio, "不太確定")
        timeRadioBoxFour.customValue = 4
        sectionTwoContainer.addSubview(timeRadioBoxFour)
        timeRadioBoxFour.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                          "V:[$view0]-16-[$self]"],
                                        views: [timeRadioBoxThree])
        
        
        timeRadioBoxOne.deselectCheckViews = [timeRadioBoxTwo,
                                              timeRadioBoxThree,
                                              timeRadioBoxFour]
        timeRadioBoxTwo.deselectCheckViews = [timeRadioBoxOne,
                                              timeRadioBoxThree,
                                              timeRadioBoxFour]
        timeRadioBoxThree.deselectCheckViews = [timeRadioBoxTwo,
                                                timeRadioBoxOne,
                                                timeRadioBoxFour]
        timeRadioBoxFour.deselectCheckViews = [timeRadioBoxTwo,
                                               timeRadioBoxOne,
                                               timeRadioBoxThree]
        
        let limitedTime = dataModel?.limitedTime?.intValue ?? 4
        switch limitedTime {
        case 1:
            timeRadioBoxOne.checkBox.checkState = .checked
        case 2:
            timeRadioBoxThree.checkBox.checkState = .checked
        case 3:
            timeRadioBoxTwo.checkBox.checkState = .checked
        default:
            timeRadioBoxFour.checkBox.checkState = .checked
        }
            

        
        socketLabel = headerLabel("插座數量")
        sectionTwoContainer.addSubview(socketLabel)
        socketLabel.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                     "V:|-16-[$self]"],
                                   metrics:[KPNewStoreControllerConstants.leftPadding])
        
        socketRadioBoxOne = KPCheckView(.radio, "無插座")
        socketRadioBoxOne.customValue = 5
        sectionTwoContainer.addSubview(socketRadioBoxOne)
        socketRadioBoxOne.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                         metrics:[KPNewStoreControllerConstants.leftPadding],
                                         views: [socketLabel])
        socketRadioBoxTwo = KPCheckView(.radio, "部分座位有")
        socketRadioBoxTwo.customValue = 2
        sectionTwoContainer.addSubview(socketRadioBoxTwo)
        socketRadioBoxTwo.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                         metrics:[KPNewStoreControllerConstants.leftPadding],
                                         views: [socketRadioBoxOne])
        socketRadioBoxThree = KPCheckView(.radio, "很多插座")
        socketRadioBoxThree.customValue = 1
        sectionTwoContainer.addSubview(socketRadioBoxThree)
        socketRadioBoxThree.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                             "V:[$view0]-16-[$self]"],
                                           metrics:[KPNewStoreControllerConstants.leftPadding],
                                           views: [socketRadioBoxTwo])
        
        socketRadioBoxFour = KPCheckView(.radio, "不太確定")
        socketRadioBoxFour.customValue = 4
        sectionTwoContainer.addSubview(socketRadioBoxFour)
        socketRadioBoxFour.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                            "V:[$view0]-16-[$self]"],
                                          metrics:[KPNewStoreControllerConstants.leftPadding],
                                          views: [socketRadioBoxThree])
        
        socketRadioBoxOne.deselectCheckViews = [socketRadioBoxTwo,
                                                socketRadioBoxThree,
                                                socketRadioBoxFour]
        socketRadioBoxTwo.deselectCheckViews = [socketRadioBoxOne,
                                                socketRadioBoxThree,
                                                socketRadioBoxFour]
        socketRadioBoxThree.deselectCheckViews = [socketRadioBoxOne,
                                                  socketRadioBoxTwo,
                                                  socketRadioBoxFour]
        socketRadioBoxFour.deselectCheckViews = [socketRadioBoxOne,
                                                 socketRadioBoxTwo,
                                                 socketRadioBoxThree]
        
        let socket = dataModel?.socket?.intValue ?? 4
        switch socket {
        case 1:
            socketRadioBoxThree.checkBox.checkState = .checked
        case 2:
            socketRadioBoxTwo.checkBox.checkState = .checked
        case 5:
            socketRadioBoxOne.checkBox.checkState = .checked
        default:
            socketRadioBoxFour.checkBox.checkState = .checked
        }
        
        
        standDeskLabel = headerLabel("其他")
        sectionTwoContainer.addSubview(standDeskLabel)
        standDeskLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                        "V:[$view0]-16-[$self]"],
                                      views: [timeRadioBoxFour])
        standDeskCheckBoxOne = KPCheckView(.radio, "有站立桌，可站立工作")
        standDeskCheckBoxOne.customValue = 1
        sectionTwoContainer.addSubview(standDeskCheckBoxOne)
        standDeskCheckBoxOne.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                              "V:[$view0]-16-[$self]"],
                                         views: [standDeskLabel])
        
        standDeskCheckBoxTwo = KPCheckView(.radio, "無站立桌")
        standDeskCheckBoxTwo.customValue = 2
        sectionTwoContainer.addSubview(standDeskCheckBoxTwo)
        standDeskCheckBoxTwo.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                              "V:[$view0]-16-[$self]"],
                                            views: [standDeskCheckBoxOne])
        
        standDeskCheckBoxThree = KPCheckView(.radio, "不太確定")
        standDeskCheckBoxThree.customValue = 4
        sectionTwoContainer.addSubview(standDeskCheckBoxThree)
        standDeskCheckBoxThree.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:[$view0]-16-[$self]"],
                                              views: [standDeskCheckBoxTwo])
        
        standDeskCheckBoxOne.deselectCheckViews = [standDeskCheckBoxTwo,
                                                   standDeskCheckBoxThree]
        standDeskCheckBoxTwo.deselectCheckViews = [standDeskCheckBoxOne,
                                                   standDeskCheckBoxThree]
        standDeskCheckBoxThree.deselectCheckViews = [standDeskCheckBoxTwo,
                                                     standDeskCheckBoxOne]
        
        
        let standDesk = dataModel?.standingDesk?.intValue ?? 4
        switch standDesk {
        case 1:
            standDeskCheckBoxOne.checkBox.checkState = .checked
        case 2:
            standDeskCheckBoxTwo.checkBox.checkState = .checked
        default:
            standDeskCheckBoxThree.checkBox.checkState = .checked
        }
        
        
        if let latitude = dataModel?.latitude, let longitude = dataModel?.longitude {
            selectedCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else if let position = KPLocationManager.sharedInstance().currentLocation {
            selectedCoordinate = position.coordinate
        } else {
            selectedCoordinate = CLLocationCoordinate2D(latitude: 25.0470462, longitude: 121.5156119)
        }
        let camera = GMSCameraPosition.camera(withLatitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude, zoom: 18.0)
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude))
        addressMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        marker.map = addressMapView
        sectionTwoContainer.addSubview(addressMapView)
        addressMapView.isUserInteractionEnabled = false
        
        let mapCover = UIView()
        mapCover.backgroundColor = UIColor.clear
        sectionTwoContainer.addSubview(mapCover)
        mapCover.addConstraintForAligning(to: .all, of: addressMapView, constant: 0)
        
        
        let mapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAddressMapViewOnTap(_:)))
        mapCover.addGestureRecognizer(mapGesture)
        
        addressSubTitleView = KPSubTitleEditView(.Top,
                                                 .MultiLine,
                                                 "店家地址")
        addressSubTitleView.placeHolderContent = "請輸入店家地址"
        sectionTwoContainer.addSubview(addressSubTitleView)
        addressSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|", "H:|-16-[$view1]-16-|",
                                                             "V:[$view0]-16-[$self][$view1(120)]"],
                                           views: [standDeskCheckBoxThree, addressMapView])
        addressSubTitleView.delegate = self
        addressSubTitleView.content = dataModel?.address ?? ""

        phoneSubTitleView = KPSubTitleEditView(.Both,
                                               .Edited,
                                               "店家電話")
        phoneSubTitleView.placeHolderContent = "請輸入店家電話"
        phoneSubTitleView.inputKeyboardType = .phonePad
        sectionTwoContainer.addSubview(phoneSubTitleView)
        phoneSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                           "V:[$view0]-16-[$self(72)]"],
                                           views: [addressMapView])
        phoneSubTitleView.content = dataModel?.phone ?? ""
        
        facebookSubTitleView = KPSubTitleEditView(.Bottom,
                                                  .Edited,
                                                  "Facebook 連結")
        facebookSubTitleView.placeHolderContent = "請輸入店家 Facebook 連結"
        sectionTwoContainer.addSubview(facebookSubTitleView)
        facebookSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$view0][$self(72)]"],
                                         views: [phoneSubTitleView])
        facebookSubTitleView.content = dataModel?.facebookURL
        
        if type == .add {
        
            menuPhotoUploadSubTitleView = KPSubTitlePhotoUploadView(title: "上傳菜單")
            menuPhotoUploadSubTitleView.controller = self
            sectionTwoContainer.addSubview(menuPhotoUploadSubTitleView)
            menuPhotoUploadSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]"],
                                                       views: [facebookSubTitleView])
            
            photoUploadSubTitleView = KPSubTitlePhotoUploadView(title: "上傳店家照片")
            photoUploadSubTitleView.controller = self
            sectionTwoContainer.addSubview(photoUploadSubTitleView)
            photoUploadSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]-16-|"],
                                                   views: [menuPhotoUploadSubTitleView])
            
        } else if type == .modify {
            facebookSubTitleView.addConstraint(from: "V:[$self]-16-|")
        }
        
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTapGesture(tapGesture:)))
        tapGesture.cancelsTouchesInView = false
        containerView.addGestureRecognizer(tapGesture)

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    deinit {
        featureCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let changeValue = change,
               let size = changeValue[NSKeyValueChangeKey.newKey] as? CGSize {
                featureCollectionViewHeightConstraint.constant = size.height + 10
                view.layoutIfNeeded()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    

    func handleDismissButtonOnTapped() {
        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.new_dismiss_button)
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func handleSendButtonOnTapped() {
        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.new_send_button)
        if KPUserManager.sharedManager.currentUser == nil {
            KPPopoverView.popoverLoginView()
        
        } else if type == .add {
        
            if nameSubTitleView.editTextField.text == nil ||
                nameSubTitleView.editTextField.text?.count == 0 {
                nameSubTitleView.sType = .Warning
                KPPopoverView.popoverNotification("新增失敗",
                                                  "店家名稱尚未填寫！",
                                                  150,
                                                  nil);
                return;
            }
            
            if citySubTitleView.editTextField.text == nil ||
                citySubTitleView.editTextField.text?.count == 0 {
                citySubTitleView.sType = .Warning
                KPPopoverView.popoverNotification("新增失敗",
                                                  "店家所在城市尚未選擇！",
                                                  150,
                                                  nil);
                return;
            }
            
            if addressSubTitleView.editTextView.text == nil ||
                addressSubTitleView.editTextView.text?.count == 0 {
                addressSubTitleView.sType = .Warning
                KPPopoverView.popoverNotification("新增失敗",
                                                  "店家地址尚未填寫！",
                                                  150,
                                                  nil);
                return;
            }
            
            if phoneSubTitleView.editTextField.text == nil ||
                phoneSubTitleView.editTextField.text?.count == 0 {
                phoneSubTitleView.sType = .Warning
                KPPopoverView.popoverNotification("新增失敗",
                                                  "店家電話尚未填寫！",
                                                  150,
                                                  nil);
                return;
            }
            
            var tags = [KPDataTagModel]()
            
            if let indexPaths = featureCollectionView.indexPathsForSelectedItems {
                for indexPath in indexPaths {
                    tags.append(KPServiceHandler.sharedHandler.featureTags[indexPath.row])
                }
            }
            
            var businessHour: [String: String]
            if businessHourCheckedView.checked == false || businessHourController == nil {
                businessHour = [:]
            } else {
                businessHour = (businessHourController?.returnValue as? [String: String]) ?? [:]
            }
            
            KPServiceHandler.sharedHandler.addNewShop(nameSubTitleView.editTextField.text ?? "",
                                                      addressSubTitleView.editTextView.text ?? "",
                                                      KPCityRegionModel.getCountryWithRegionString(citySubTitleView.editTextField.text) ?? "",
                                                      KPCityRegionModel.getKeyWithRegionString(citySubTitleView.editTextField.text) ?? "",
                                                      selectedCoordinate.latitude,
                                                      selectedCoordinate.longitude,
                                                      facebookSubTitleView.editTextField.text ?? "",
                                                      timeRadioBoxOne.groupValue as! Int,
                                                      standDeskCheckBoxOne.groupValue as! Int,
                                                      socketRadioBoxOne.groupValue as! Int,
                                                      ratingController?.ratingViews[0].currentRate ?? 0,
                                                      ratingController?.ratingViews[1].currentRate ?? 0,
                                                      ratingController?.ratingViews[2].currentRate ?? 0,
                                                      ratingController?.ratingViews[3].currentRate ?? 0,
                                                      ratingController?.ratingViews[4].currentRate ?? 0,
                                                      ratingController?.ratingViews[5].currentRate ?? 0,
                                                      ratingController?.ratingViews[6].currentRate ?? 0,
                                                      phoneSubTitleView.editTextField.text ?? "",
                                                      tags,
                                                      businessHour,
                                                      KPPriceSelectController.priceRanges.index(of: priceSubTitleView.editTextField.text ?? "") ?? -1,
                                                      menuPhotoUploadSubTitleView.images,
                                                      photoUploadSubTitleView.images) {[unowned self] (success) in
                                                        if success == true {
                                                            KPPopoverView.popoverStoreInReviewNotification()
                                                            self.appModalController()?.dismissControllerWithDefaultDuration()
                                                        } else {
                                                            KPPopoverView.popoverNotification("新增失敗",
                                                                                              "發生錯誤，請再試一次！",
                                                                                              150,
                                                                                              nil);
                                                        }

            }
        } else {
            
            
            if nameSubTitleView.editTextField.text == nil ||
                nameSubTitleView.editTextField.text?.count == 0 {
                nameSubTitleView.sType = .Warning
                KPPopoverView.popoverNotification("修改失敗",
                                                  "店家名稱尚未填寫！",
                                                  150,
                                                  nil);
                return;
            }
            
            if citySubTitleView.editTextField.text == nil ||
                citySubTitleView.editTextField.text?.count == 0 {
                citySubTitleView.sType = .Warning
                KPPopoverView.popoverNotification("修改失敗",
                                                  "店家所在城市尚未選擇！",
                                                  150,
                                                  nil);
                return;
            }
            
            if addressSubTitleView.editTextView.text == nil ||
                addressSubTitleView.editTextView.text?.count == 0 {
                addressSubTitleView.sType = .Warning
                KPPopoverView.popoverNotification("修改失敗",
                                                  "店家地址尚未填寫！",
                                                  150,
                                                  nil);
                return;
            }
            
            if phoneSubTitleView.editTextField.text == nil ||
                phoneSubTitleView.editTextField.text?.count == 0 {
                phoneSubTitleView.sType = .Warning
                KPPopoverView.popoverNotification("修改失敗",
                                                  "店家電話尚未填寫！",
                                                  150,
                                                  nil);
                return;
            }
            
            
            var tags = [KPDataTagModel]()
            
            if let indexPaths = featureCollectionView.indexPathsForSelectedItems {
                for indexPath in indexPaths {
                    tags.append(KPServiceHandler.sharedHandler.featureTags[indexPath.row])
                }
            }
            
            var businessHour: [String: String]
            if businessHourCheckedView.checked == false || businessHourController == nil {
                businessHour = [:]
            } else if let businessData = businessHourController?.returnValue as? [String: String]  {
                businessHour = businessData
            } else {
                businessHour = dataModel?.businessHour?.originalData ?? [:]
            }
            
            KPServiceHandler.sharedHandler.modifyCafeData(dataModel!.identifier,
                                                          nameSubTitleView.editTextField.text ?? "",
                                                          addressSubTitleView.editTextView.text ?? "",
                                                          KPCityRegionModel.getKeyWithRegionString(citySubTitleView.editTextField.text) ?? "",
                                                          selectedCoordinate.latitude,
                                                          selectedCoordinate.longitude,
                                                          facebookSubTitleView.editTextField.text ?? "",
                                                          timeRadioBoxOne.groupValue as! Int,
                                                          standDeskCheckBoxOne.groupValue as! Int,
                                                          socketRadioBoxOne.groupValue as! Int,
                                                          phoneSubTitleView.editTextField.text ?? "",
                                                          tags,
                                                          businessHour,
                                                          KPPriceSelectController.priceRanges.index(of: priceSubTitleView.editTextField.text ?? "") ?? -1) {[unowned self] (success) in
                                                            if success == true {
                                                                KPPopoverView.popoverStoreInReviewNotification()
                                                                self.appModalController()?.dismissControllerWithDefaultDuration()
                                                            } else {
                                                                KPPopoverView.popoverNotification("修改失敗",
                                                                                                  "發生錯誤，請再試一次！",
                                                                                                  150,
                                                                                                  nil);
                                                            }
                                                        
            }
        }
    }
    
    func handleAddressMapViewOnTap(_ gesture: UITapGestureRecognizer) {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        if self.mapInputController == nil {
            self.mapInputController = KPMapInputViewController()
            self.mapInputController.sendButton.addTarget(self,
                                                         action: #selector(KPNewStoreController.handleMapInputViewSendButtonOnTap(_:)),
                                                         for: .touchUpInside)
        }
        
        self.mapInputController.coordinate = selectedCoordinate
        
        controller.contentController = self.mapInputController
        controller.presentModalView()
    }
    
    func handleMapInputViewSendButtonOnTap(_ sender: UIButton) {
        self.mapInputController.appModalController()?.dismissControllerWithDefaultDuration()
        addressSubTitleView.editTextView.text = mapInputController.address
        addressSubTitleView.editTextView.delegate?.textViewDidChange?(addressSubTitleView.editTextView)
        selectedCoordinate = mapInputController.coordinate
    }
    
    func keyboardWillShown(notification: Notification) {
        
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let ooooframe = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        var keyboardFrame = UIApplication.shared.windows[0].convert(ooooframe!, to: view)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height, 0.0)
        
        _scrollView.contentInset = contentInsets
        _scrollView.scrollIndicatorInsets = contentInsets
        
        
        if let field = _activeTextField {
            keyboardFrame.size.height += 64
            keyboardFrame.origin.y -= 44
            let fieldFrame = _scrollContainerView.convert(field.frame, to: view)
            if (keyboardFrame.contains(fieldFrame)) {
                let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
                
                UIView.animate(withDuration: duration!, animations: {
                    self._scrollView.contentOffset = CGPoint(x: 0, y: self._scrollView.contentOffset.y + (fieldFrame.origin.y - keyboardFrame.origin.y - 20))
                })
            }
        }
        
    }
    
    func keyboardWillBeHidden(notification: Notification) {
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)
        _scrollView.contentInset = contentInsets
        _scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func geoLocate(address:String!) {
        let gc:CLGeocoder = CLGeocoder()
        
        gc.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks, placemarks.count > 0,
            let latitude = placemarks.first?.location?.coordinate.latitude,
            let longitude = placemarks.first?.location?.coordinate.longitude {
                self.selectedCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
    }
}

extension KPNewStoreController: KPSubtitleInputDelegate {
    
    func outputValueSet(_ controller: KPSubtitleInputController) {
        
        if controller.identifiedKey == "name" {
            if let placeInformation = controller.outputValue as? GMSPlace {
                nameSubTitleView.content = placeInformation.name
                phoneSubTitleView.content = placeInformation.phoneNumber ?? ""
                if let formattedAddress = placeInformation.formattedAddress {
                    addressSubTitleView.content = formattedAddress
                    addressSubTitleView.placeHolderContent = formattedAddress.count > 0 ? "" : "請輸入店家地址"
                } else {
                    addressSubTitleView.content = ""
                    addressSubTitleView.placeHolderContent = "請輸入店家地址"
                }
                facebookSubTitleView.content = placeInformation.website?.absoluteString ?? ""
                
                if let addressComponents = placeInformation.addressComponents {
                    for component in addressComponents {
                        if component.type == "administrative_area_level_1" {
                            citySubTitleView.content = component.name
                        }
                    }
                }
                selectedCoordinate = placeInformation.coordinate
            } else {
                nameSubTitleView.content = controller.outputValue as? String
            }
        }
    }
}

extension KPNewStoreController: KPSharedSettingDelegate {
    
    func returnValueSet(_ controller: KPSharedSettingViewController) {
        if controller.identifiedKey == "country" {
            self.citySubTitleView.content = controller.returnValue as! String
        } else if controller.identifiedKey == "price" {
            self.priceSubTitleView.content = controller.returnValue as! String
        } else if controller.identifiedKey == "rate" {
            self.rateCheckedView.checkContent = String(format: "已評分(%.1f)",
                                                       (controller.returnValue as! (Int, Int, Int, Int, Int, Int, Int, CGFloat)).7)
            self.rateCheckedView.checked = true
        } else if controller.identifiedKey == "time" {
            self.businessHourCheckedView.checked = true
        }
    }
}

extension KPNewStoreController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return KPServiceHandler.sharedHandler.featureTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell",
                                                      for: indexPath) as! KPFeatureTagCell
        cell.featureLabel.text = KPServiceHandler.sharedHandler.featureTags[indexPath.row].name
        
        if let features = dataModel?.featureContents,
            features.contains(KPServiceHandler.sharedHandler.featureTags[indexPath.row].identifier) {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizingCell.featureLabel.text = KPServiceHandler.sharedHandler.featureTags[indexPath.row].name
        return CGSize(width: sizingCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize).width,
                      height: 30)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        featureSubTitleView.layer.shouldRasterize = true
//        featureSubTitleView.layer.rasterizationScale = UIScreen.main.scale
//    }
//    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        featureSubTitleView.layer.shouldRasterize = true
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension KPNewStoreController: KPSubTitleEditViewDelegate {
    func subTitleEditViewDidEndEditing(_ subTitleEditView: KPSubTitleEditView) {
        if subTitleEditView == addressSubTitleView {
            geoLocate(address: addressSubTitleView.editTextView.text)
        }
    }
}
