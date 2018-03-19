//
//  KPMainMapViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GoogleMaps
import ObjectMapper

class KPMainMapViewController: KPViewController,
GMSMapViewDelegate,
GMUClusterManagerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
KPMainViewControllerDelegate,
GMUClusterRendererDelegate {
    
    weak var mainController: KPMainViewController!
    private var snapshotView: UIImageView!
    var collectionView: UICollectionView!
    var collectionViewBottomConstraint: NSLayoutConstraint!
    var showAllButton: UIButton!
    var clusterRenderer: GMUDefaultClusterRenderer!
    var swipeGesture: UISwipeGestureRecognizer!

    lazy var nearestButton: KPShadowButton = {
        let shadowButton = KPShadowButton()
        shadowButton.button.setTitle("離我最近", for: .normal)
        shadowButton.button.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor!), for: .normal)
        shadowButton.button.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        shadowButton.layer.cornerRadius = 5
        shadowButton.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor!
        return shadowButton
    }()
    
    lazy var searchNearButton: KPShadowButton = {
        let shadowButton = KPShadowButton()
        shadowButton.button.setTitle("搜尋這個地區", for: .normal)
        shadowButton.button.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.mainColor!),
                                               for: .normal)
        shadowButton.button.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        shadowButton.button.setTitleColor(KPColorPalette.KPTextColor_v2.whiteColor,
                                          for: .normal)
        shadowButton.layer.cornerRadius = 18
        return shadowButton
    }()
    
    lazy var currentLocationButton: KPShadowButton = {
        let shadowButton = KPShadowButton()
        shadowButton.button.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.whiteColor!), for: .normal)
        shadowButton.button.setImage(R.image.icon_location(), for: .normal)
    
        shadowButton.button.tintColor = KPColorPalette.KPMainColor_v2.mainColor
        shadowButton.button.imageView?.contentMode = .scaleAspectFit
        shadowButton.button.imageEdgeInsets = UIEdgeInsets(top: 12,
                                                           left: 12,
                                                           bottom: 12,
                                                           right: 12)
        shadowButton.layer.cornerRadius = 30
        return shadowButton
    }()
    
    lazy var mapButton: KPShadowButton = {
        let shadowButton = KPShadowButton()
        shadowButton.button.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.whiteColor!), for: .normal)
        shadowButton.button.setImage(R.image.icon_list(), for: .normal)
        shadowButton.button.setTitle("清單",
                                     for: .normal)
        shadowButton.button.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                          for: .normal)
        shadowButton.button.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        shadowButton.button.tintColor = KPColorPalette.KPMainColor_v2.mainColor
        shadowButton.button.imageView?.contentMode = .scaleAspectFit
        shadowButton.button.imageEdgeInsets = UIEdgeInsets(top: 8,
                                                           left: 8,
                                                           bottom: 8,
                                                           right: 16)
        shadowButton.layer.cornerRadius = 20
        return shadowButton
    }()
    
    var state: ControllerState! = .loading {
        didSet {
            if mainController.currentController == self {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if state == .normal {
                    if loadingView.superview != nil {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1,
                                                      execute: {
                                                        self.loadingView.dismiss()
                        })
                    }
                } else if state == .loading {
                    self.view.addSubview(loadingView)
                    loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                                 "H:|[$self]|"])
                } else if state == .failed {
                    if loadingView.superview != nil {
                        loadingView.state = .failed
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0,
                                                      execute: {
                                                        self.loadingView.dismiss()
                        })
                    }
                } else if state == .noInternet {
                    if loadingView.superview != nil {
                        loadingView.state = .failed
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0,
                                                      execute: {
                                                        self.loadingView.dismiss()
                        })
                    }
                } else if state == .barLoading {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            }
        }
    }
    
    private var clusterManager: GMUClusterManager!
    
    var loadingView: KPLoadingView!
    var mapView: GMSMapView!
    var currentDataModel:KPDataModel?
    var selectedDataModel: KPDataModel? {
        return self.currentDataModel
    }
    
    var reloadNeeded: Bool = true
    var draggingByUser: Bool = true
    
    
    var snapShotShowing: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.snapShotShowing != oldValue && self.snapShotShowing {
                    self.snapshotView.image = self.view.screenshot()
                    self.snapshotView.isHidden = false
                    self.mapView.isHidden = true
                    self.collectionView.isHidden = true
                } else if self.snapShotShowing != oldValue {
                    self.snapshotView.isHidden = true
                    self.mapView.isHidden = false
                    self.collectionView.isHidden = false
                }
            }
        }
    }
    
    var isCollectionViewShow: Bool = false {
        didSet {
            if self.collectionViewBottomConstraint != nil && self.reloadNeeded {
                self.view.bringSubview(toFront: self.collectionView)
                if isCollectionViewShow == true && self.mapView != nil {
                    self.displayDataModel =  self.allDataModel.filter { (dataModel) -> Bool in
                        let bounds = GMSCoordinateBounds(region: self.mapView.projection.visibleRegion())
                        return bounds.contains(dataModel.position)
                    }
                    self.collectionView.alpha = 1
                    
                    if oldValue == true {
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.2, animations: {
                                self.collectionView.alpha = 0
                            }, completion: { (_) in
                                self.collectionView.reloadData()
                                if let dataModel = self.mapView.selectedMarker?.userData as? KPDataModel,
                                    let selectedIndex =  self.displayDataModel.index(where: {($0.name == dataModel.name)}){
                                    self.collectionView.contentOffset = CGPoint(x: -30 + CGFloat(selectedIndex) * (UIScreen.main.bounds.size.width - 60 + 15), y: 0)
                                }
                                self.view.layoutIfNeeded()
                                self.view.bringSubview(toFront: self.collectionView)
                            })
                            
                            UIView.animate(withDuration: 0.2, delay: 0.3, options: UIViewAnimationOptions.curveLinear, animations: {
                                self.collectionView.alpha = 1
                            }, completion: { (_) in
                                
                            })
                        }
                    } else {
                        self.collectionViewBottomConstraint.constant = -10
                        self.collectionView.reloadData()
                        if let dataModel = self.mapView.selectedMarker?.userData as? KPDataModel,
                            let selectedIndex =  self.displayDataModel.index(where: {($0.name == dataModel.name)}) {
                            self.collectionView.contentOffset = CGPoint(x: -30 + CGFloat(selectedIndex) * (UIScreen.main.bounds.size.width - 60 + 15), y: 0)
                        }
                        self.collectionView.layoutIfNeeded()
                        UIView.animate(withDuration: 0.5,
                                       delay: 0,
                                       usingSpringWithDamping: 0.8,
                                       initialSpringVelocity: 0.8,
                                       options: UIViewAnimationOptions.curveEaseOut,
                                       animations: {
                                        self.view.layoutIfNeeded()
                        }, completion: { (_) in
                            
                        })
                    }
                    
                } else {
                    self.collectionViewBottomConstraint.constant = 130
                    UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.8,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: {
                                    self.view.layoutIfNeeded()
                    }, completion: { (_) in
                        
                    })
                }
            }
        }
    }
    
    var displayDataModel: [KPDataModel] = []
    
    var allDataModel: [KPDataModel] = [] {
        didSet {
            self.state = .normal
            self.clusterManager.clearItems()
            for datamodel in self.allDataModel  {
                self.clusterManager.add(datamodel)
            }
            // Call cluster() after items have been added to perform the clustering
            // and rendering on map.
            self.clusterManager.cluster()
            
            if isCollectionViewShow == true {
                isCollectionViewShow = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        KPAnalyticManager.sendPageViewEvent(KPAnalyticsEventValue.page.map_page)
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.018744, longitude: 121.532785, zoom: 18.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        mapView.preferredFrameRate = .maximum
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        view.addSubview(self.mapView)
        
        mapView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                 "V:|-140-[$self]|"])
        
        // Set up the cluster manager with the supplied icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        clusterRenderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterRenderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: clusterRenderer)
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        
        clusterManager.setDelegate(self, mapDelegate: self)
        
        mapView.isMyLocationEnabled = true
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 60, height: 108)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 15
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0,height: 0),
                                               collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(KPMainMapViewCollectionCell.classForCoder(),
                                forCellWithReuseIdentifier: "cell")
        
        view.addSubview(self.collectionView)
        collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                        "V:[$self(126)]"])
        collectionViewBottomConstraint = collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 130)
        collectionViewBottomConstraint.isActive = true
        
        view.addSubview(searchNearButton)
        searchNearButton.addConstraints(fromStringArray: ["V:|-160-[$self(36)]",
                                                          "H:[$self(104)]"])
        searchNearButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        searchNearButton.button.addTarget(self,
                                          action: #selector(handleSearchNearButtonOnTap(_:)),
                                          for: .touchUpInside)
        
        view.addSubview(mapButton)
        mapButton.addConstraints(fromStringArray: ["V:[$self(40)]-24-[$view0]",
                                                   "H:[$self(88)]"],
                                 views:[collectionView])
        mapButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        currentLocationButton.button.addTarget(self,
                                        action: #selector(handleCurrentLocationButtonOnTap(_:)),
                                        for: .touchUpInside)
        view.addSubview(currentLocationButton)
        currentLocationButton.addConstraints(fromStringArray: ["H:[$self(60)]-16-|",
                                                               "V:[$self(60)]-24-[$view0]"], views:[collectionView])
        
        showAllButton = UIButton(type: .custom)
//        showAllButton.layer.cornerRadius = 2.0
//        showAllButton.layer.masksToBounds = true
//        showAllButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor_light!) ,
//                                         for: .normal)
//        showAllButton.setTitle("顯示\n全部",
//                               for: .normal)
//        showAllButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
//        showAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        showAllButton.titleLabel?.numberOfLines = 2
//        showAllButton.titleLabel?.lineBreakMode = .byWordWrapping
//        showAllButton.isHidden = true
//        self.view.addSubview(showAllButton)
//        showAllButton.addConstraints(fromStringArray: ["H:[$self(32)]-16-|",
//                                                       "V:[$view0]-8-[$self(32)]"],
//                                     views: [currentLocationButton])
        
        
        
//        view.addSubview(nearestButton)
//        nearestButton.button.addTarget(self, action: #selector(handleNearestButtonOnTap(_:)), for: .touchUpInside)
//        nearestButton.addConstraints(fromStringArray: ["H:|-16-[$self(90)]",
//                                                       "V:[$self(40)]-16-[$view0]"],
//                                     views: [collectionView])
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveLocationInformation),
                                               name: NSNotification.Name.KPLocationDidUpdate,
                                               object: nil)
        
        snapshotView = UIImageView()
        snapshotView.contentMode = .top
        snapshotView.clipsToBounds = true
        snapshotView.isHidden = true
        view.addSubview(snapshotView)
        snapshotView.addConstraints(fromStringArray: ["V:|-100-[$self]|",
                                                      "H:|[$self]|"])
        
        swipeGesture = UISwipeGestureRecognizer(target: self,
                                                action: #selector(handleMapViewSwiped(_:)))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
        loadingView = KPLoadingView(("讀取中..", "讀取成功", "讀取失敗"))
        state = .loading
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        KPLocationManager.sharedInstance().removeObserver(self, 
                                                          forKeyPath: "currentLocation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func receiveLocationInformation() {
        moveToMyLocation()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? KPLocationManager == KPLocationManager.sharedInstance() && keyPath == "currentLocation" {
            self.moveToMyLocation(completion: nil)
            KPLocationManager.sharedInstance().removeObserver(self, forKeyPath: "currentLocation")
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func moveToMyLocation() {
        moveToMyLocation(completion: nil)
    }
    
    func moveToMyLocation(completion: ((_ success: Bool) -> Void)?) {
        if let location = KPLocationManager.sharedInstance().currentLocation?.coordinate {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                completion?(true)
            })
            CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
            self.mapView.animate(to: GMSCameraPosition.camera(withTarget: location,
                                                              zoom: 18))
            CATransaction.commit()
            
        } else {
            completion?(false)
        }
    }
    
    // MARK: UI Event
    
    @objc func handleMapViewSwiped(_ sender: UISwipeGestureRecognizer) {
        if isCollectionViewShow {
            isCollectionViewShow = false
        }
    }

//    @objc func handleAddButtonTapped(_ sender: UIButton) {
//
//        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.map_add_store_button)
//
//        let controller = KPModalViewController()
//        controller.edgeInset = UIEdgeInsets(top: 0,
//                                            left: 0,
//                                            bottom: 0,
//                                            right: 0)
//        let newStoreController = KPNewStoreController()
//        let navigationController = UINavigationController(rootViewController: newStoreController)
//        if #available(iOS 11.0, *) {
//            navigationController.navigationBar.prefersLargeTitles = true
//        } else {
//            // Fallback on earlier versions
//        }
//        controller.contentController = navigationController
//        controller.presentModalView()
//    }
    
    @objc func handleSearchNearButtonOnTap(_ sender: UIButton) {
        mainController.reFetchRemoteData(false)
    }
    
    @objc func handleCurrentLocationButtonOnTap(_ sender: UIButton) {
        
        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.map_navigation_button)
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways &&
            CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            KPPopoverView.popoverDefaultStyleContent("開啟定位",
                                                     "沒有開啟定位我們是要怎麼定位啦？(#`Д´)ﾉ",
                                                     "前往設定", { (popoverContent) in
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            })
        } else {
            moveToMyLocation()
        }
    }
    
    @objc func handleNearestButtonOnTap(_ sender: UIButton) {
        
        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.map_near_button)
        
        if KPLocationManager.sharedInstance().currentLocation == nil {
            if CLLocationManager.authorizationStatus() != .authorizedAlways &&
               CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
                KPPopoverView.popoverDefaultStyleContent("開啟定位",
                                                         "沒有開啟定位我們難道要通靈算距離膩？(#`Д´)ﾉ",
                                                         "前往設定", { (popoverContent) in
                    UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                })
            } else {
                // 選沒抓到位置 應該不太可能出現 放棄
            }
            return
        }
        
        if let nearestModel = allDataModel.min() {
            
            clusterRenderer.animatesClusters = false
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                
                self.clusterRenderer.animatesClusters = true
                DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.5, execute: {
                    if let renderer = self.clusterRenderer {
                        
                        var nearestMarker: GMSMarker? = nil
                        
                        for marker in renderer.markers() {
                            if let dataModel = marker.userData as? KPDataModel,
                                dataModel.identifier == nearestModel.identifier {
                                nearestMarker = marker
                                break;
                            }
                        }
                        
                        if nearestMarker != nil {
                            self.mapView.selectedMarker = nearestMarker!
                        }
                    }
                })

            })
            CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
            self.mapView.animate(to: GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: nearestModel.latitude,
                                                                                                 longitude: nearestModel.longitude),
                                                              zoom: 18))
            CATransaction.commit()
        
        }
        
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.displayDataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! KPMainMapViewCollectionCell
        cell.dataModel = self.displayDataModel[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataModel = self.displayDataModel[indexPath.row]
        KPAnalyticManager.sendCellClickEvent(dataModel.name,
                                             dataModel.averageRate?.stringValue,
                                             KPAnalyticsEventValue.source.source_map)
        self.currentDataModel = dataModel
        self.mainController.performSegue(withIdentifier: "datailedInformationSegue", sender: self)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = UIScreen.main.bounds.size.width - 60
        let currentOffset = targetContentOffset.pointee.x
        let index = floor((currentOffset + (pageWidth + 15)/2)/(pageWidth + 15))

        
        targetContentOffset.pointee.x = -30 + index * (pageWidth + 15)
        scrollView.setContentOffset(CGPoint(x: -30 + index * (pageWidth + 15), y: 0), animated: true)
        
        self.currentDataModel = self.displayDataModel[Int(index)]

        if let renderer = clusterRenderer,
            let marker = renderer.markers().filter({ (marker) -> Bool in
                marker.userData as? KPDataModel == self.currentDataModel
            }).first {
            self.draggingByUser = false
            CATransaction.begin()
            CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
            self.mapView.animate(to: GMSCameraPosition.camera(withTarget: marker.position , zoom: self.mapView.camera.zoom))
            CATransaction.commit()
            CATransaction.setCompletionBlock({
                self.reloadNeeded = false
                self.mapView.selectedMarker = marker
            })
        }
    
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2.0
        let pageWidth = UIScreen.main.bounds.size.width - 30;
        for cell in self.collectionView.visibleCells {
            let offset = fabs(centerX - (cell.frame.origin.x + cell.frame.size.width/2.0));
            cell.alpha = (pageWidth - offset) / pageWidth * 0.7 + 0.5;
        }
    }
    
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        draggingByUser = false
        
        // 過濾cluster的marker
        if (marker.userData as? KPDataModel) == nil {
            return nil
        }
        
        self.isCollectionViewShow = true
        
        marker.icon = R.image.icon_mapMarkerSelected()
        let infoWindow = KPMainMapMarkerInfoWindow(dataModel: marker.userData as! KPDataModel)

        reloadNeeded = true
        
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = R.image.icon_mapMarker()
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        // Tap info window
        self.currentDataModel = marker.userData as? KPDataModel
        self.mainController.performSegue(withIdentifier: "datailedInformationSegue", sender: self)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.isCollectionViewShow {
            self.isCollectionViewShow = false
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        UIView.animate(withDuration: 0.15,
                       animations: {
                        self.nearestButton.alpha = 0.6
                        self.mapButton.alpha = 0.6
                        self.currentLocationButton.alpha = 0.6
                        self.searchNearButton.alpha = 0
        })
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.mainController.searchHeaderView.searchTagView.transform = CGAffineTransform.identity
                            self.mainController.searchHeaderView.searchTagView.alpha = 1.0
                            self.mapView.transform = CGAffineTransform.identity
                        self.mainController.mainListViewController?.tableView.transform = CGAffineTransform.identity
                        self.mainController.mainListViewController?.sortContainerView.transform = CGAffineTransform.identity
                        self.mainController.mainListViewController?.snapshotView.transform = CGAffineTransform.identity
                        self.mainController.mainListViewController?.currentSearchTagTranslateY = 0
                        
                        self.searchNearButton.transform = CGAffineTransform.identity
        })
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        if (mainController.currentController == self &&
//            draggingByUser == true) ||
//            mainController.rootTabViewController.shouldMapRefetch {
//            mainController.reFetchRemoteData(false)
//            mainController.rootTabViewController.shouldMapRefetch = false
//        } else {
        if (draggingByUser == true) {
            mainController.reFetchRemoteData(false)
        } else {
            draggingByUser = true
        }
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.nearestButton.alpha = 1.0
                        self.mapButton.alpha = 1.0
                        self.currentLocationButton.alpha = 1.0
                        self.searchNearButton.alpha = 1.0
        })
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        
        if self.isCollectionViewShow {
            self.isCollectionViewShow = false
        }
        
        draggingByUser = false
        
        CATransaction.begin()
        CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
        
        self.mapView.animate(to: GMSCameraPosition.camera(withTarget: cluster.position,
                                                          zoom: self.mapView.camera.zoom + 1))
        CATransaction.commit()
        return true
    }
    
    
    func renderer(_ renderer: GMUClusterRenderer, didRenderMarker marker: GMSMarker) {
        
        marker.tracksViewChanges = false
        marker.tracksInfoWindowChanges = false
        if let model = marker.userData as? KPDataModel {
            if let averageRate = model.averageRate,
                averageRate.doubleValue >= 4.5 {
                marker.iconView = UIImageView(image: R.image.icon_mapMarkerSelected())
            } else {
                marker.iconView = UIImageView(image: R.image.icon_mapMarker())
            }
            
            if model.businessHour == nil || model.businessHour!.isOpening == true {
                marker.iconView?.alpha = 1
            } else {
                marker.iconView?.alpha = 0.6
            }
        }
    }
    
    
}
