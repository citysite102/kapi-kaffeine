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
    
    weak var mainController:KPMainViewController!
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
        shadowButton.button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        shadowButton.layer.cornerRadius = 5
        shadowButton.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor!
        return shadowButton
    }()
    
    lazy var addButton: KPShadowButton = {
        let shadowButton = KPShadowButton()
        shadowButton.backgroundColor = KPColorPalette.KPBackgroundColor.scoreButtonColor!
        shadowButton.button.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.scoreButtonColor!), for: .normal)
        shadowButton.button.setImage(R.image.icon_add(), for: .normal)
        shadowButton.button.tintColor = UIColor.white
        shadowButton.button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        shadowButton.layer.cornerRadius = 28
        return shadowButton
    }()
    
    var state: ControllerState! = .loading {
        didSet {
            if mainController.currentController == self {
                if state == .normal {
                    if loadingView.superview != nil {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1,
                                                      execute: {
                                                        self.loadingView.removeFromSuperview()
                        })
                    }
                } else if state == .loading {
                    self.view.addSubview(loadingView)
                    loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                                 "H:|[$self]|"])
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
                        self.collectionViewBottomConstraint.constant = -16
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
                    self.collectionViewBottomConstraint.constant = 100
                    
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
        
        self.view.addSubview(self.mapView)
        
        self.mapView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|-100-[$self]-(-40)-|"])
        
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        clusterRenderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterRenderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: clusterRenderer)
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
        
        self.mapView.isMyLocationEnabled = true
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 60, height: 80)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 15
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                               collectionViewLayout: flowLayout)
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(KPMainMapViewCollectionCell.classForCoder(),
                                     forCellWithReuseIdentifier: "cell")
        
        self.view.addSubview(self.collectionView)
        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$self(100)]"])
        self.collectionViewBottomConstraint = self.collectionView.addConstraintForAligning(to: .bottom,
                                                                                           of: self.view,
                                                                                           constant: 100).first as! NSLayoutConstraint
        
        let currentLocationButton = UIButton(type: .custom)
        currentLocationButton.setImage(R.image.icon_currentLocation_alpha(), for: .normal)
        currentLocationButton.setImage(R.image.icon_currentLocation(), for: .highlighted)
        currentLocationButton.addTarget(self,
                                        action: #selector(handleCurrentLocationButtonOnTap(_:)),
                                        for: .touchUpInside)
        self.view.addSubview(currentLocationButton)
        currentLocationButton.addConstraints(fromStringArray: ["H:[$self(40)]-12-|",
                                                               "V:|-120-[$self(40)]"])
        
        showAllButton = UIButton(type: .custom)
        showAllButton.layer.cornerRadius = 2.0
        showAllButton.layer.masksToBounds = true
        showAllButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor_light!) ,
                                         for: .normal)
        showAllButton.setTitle("顯示\n全部",
                               for: .normal)
        showAllButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        showAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        showAllButton.titleLabel?.numberOfLines = 2
        showAllButton.titleLabel?.lineBreakMode = .byWordWrapping
        self.view.addSubview(showAllButton)
        showAllButton.addConstraints(fromStringArray: ["H:[$self(32)]-16-|",
                                                       "V:[$view0]-8-[$self(32)]"],
                                     views: [currentLocationButton])
        
        
        
        view.addSubview(nearestButton)
        nearestButton.button.addTarget(self, action: #selector(handleNearestButtonOnTap(_:)), for: .touchUpInside)
        nearestButton.addConstraints(fromStringArray: ["H:|-16-[$self(90)]",
                                                       "V:[$self(40)]-16-[$view0]"],
                                     views: [collectionView])
        
        view.addSubview(addButton)
        addButton.button.addTarget(self,
                                   action: #selector(handleAddButtonTapped(_:)), for: .touchUpInside)
        addButton.addConstraints(fromStringArray: ["H:[$self(56)]-18-|",
                                                   "V:[$self(56)]-16-[$view0]"],
                                 views: [collectionView])
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) { 
            self.state = .loading
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        KPLocationManager.sharedInstance().removeObserver(self, forKeyPath: "currentLocation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receiveLocationInformation() {
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
    
    func handleMapViewSwiped(_ sender: UISwipeGestureRecognizer) {
        if isCollectionViewShow {
            isCollectionViewShow = false
        }
    }
    
    func handleAddButtonTapped(_ sender: UIButton) {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        let newStoreController = KPNewStoreController()
        let navigationController = UINavigationController(rootViewController: newStoreController)
        controller.contentController = navigationController
        controller.presentModalView()
    }
    
    func handleCurrentLocationButtonOnTap(_ sender: UIButton) {
        if CLLocationManager.authorizationStatus() != .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            KPPopoverView.popoverDefaultStyleContent("開啟定位",
                                                     "沒有開啟定位我們是要怎麼定位啦？(#`Д´)ﾉ",
                                                     "前往設定", { (popoverContent) in
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            })
        } else {
            moveToMyLocation()
        }
    }
    
    func handleNearestButtonOnTap(_ sender: UIButton) {
        
        if KPLocationManager.sharedInstance().currentLocation == nil {
            if CLLocationManager.authorizationStatus() != .authorizedAlways ||
               CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
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
    
    // MARK: UICollectionView DataSource
    
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
        self.currentDataModel = self.displayDataModel[indexPath.row]
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
                        self.addButton.alpha = 0.6
        })
        
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.mainController.searchHeaderView.searchTagView.transform = CGAffineTransform(translationX: 0,
                                                                                                         y: 0)
                        self.mapView.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.mainController.mainListViewController?.tableView.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.mainController.mainListViewController?.snapshotView.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.mainController.mainListViewController?.currentSearchTagTranslateY = 0
        })
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.nearestButton.alpha = 1.0
                        self.addButton.alpha = 1.0
        })
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        
        if self.isCollectionViewShow {
            self.isCollectionViewShow = false
        }
        
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
