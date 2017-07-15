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
    var clusterRenderer: GMUDefaultClusterRenderer!

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
    
    private var clusterManager: GMUClusterManager!
    
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
                let showc: Bool = isCollectionViewShow
                DispatchQueue.main.async {
                    self.view.bringSubview(toFront: self.collectionView)
                    if showc {
                        self.displayDataModel =  self.allDataModel.filter { (dataModel) -> Bool in
                            let bounds = GMSCoordinateBounds(region: self.mapView.projection.visibleRegion())
                            return bounds.contains(dataModel.position)
                        }
                        self.collectionViewBottomConstraint.constant = -16
                    } else {
                        self.collectionViewBottomConstraint.constant = 100
                    }
                    
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
    
    var displayDataModel: [KPDataModel] = [] {
        didSet {
            self.collectionView?.reloadData()
            if  self.mapView != nil,
                let dataModel = self.mapView.selectedMarker?.userData as? KPDataModel,
                let selectedIndex =  self.displayDataModel.index(where: {($0.name == dataModel.name)}) {
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.collectionView.alpha = 0
                    }, completion: { (_) in
                        self.collectionView.contentOffset = CGPoint(x: -30 + CGFloat(selectedIndex) * (UIScreen.main.bounds.size.width - 60 + 15), y: 0)
                        self.view.layoutIfNeeded()
                        self.view.bringSubview(toFront: self.collectionView)
                    })
                    
                    UIView.animate(withDuration: 0.2, delay: 0.3, options: UIViewAnimationOptions.curveLinear, animations: {
                        self.collectionView.alpha = 1
                    }, completion: { (_) in
                        
                    })
                }
            }
        }
    }
    
    var allDataModel: [KPDataModel] = [] {
        didSet {
            self.clusterManager.clearItems()
            for datamodel in self.allDataModel  {
                self.clusterManager.add(datamodel)
            }
            
            // Call cluster() after items have been added to perform the clustering
            // and rendering on map.
            self.clusterManager.cluster()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.018744, longitude: 121.532785, zoom: 18.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = self
        mapView.preferredFrameRate = .maximum
        
//        do {
//            // Set the map style by passing the URL of the local file.
//            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
//                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
//            } else {
//                NSLog("Unable to find style.json")
//            }
//        } catch {
//            NSLog("One or more of the map styles failed to load. \(error)")
//        }
        
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
        currentLocationButton.setImage(R.image.icon_currentLocation(), for: .normal)
        currentLocationButton.addTarget(self,
                                        action: #selector(moveToMyLocation as (Void) -> Void), for: .touchUpInside)
        currentLocationButton.alpha = 0.7
        self.view.addSubview(currentLocationButton)
        currentLocationButton.addConstraints(fromStringArray: ["H:[$self(40)]-16-|",
                                                               "V:|-120-[$self(40)]"])
        
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
        
        KPLocationManager.sharedInstance().addObserver(self, forKeyPath: "currentLocation", options: .new, context: nil)
        
        snapshotView = UIImageView()
        snapshotView.contentMode = .top
        snapshotView.clipsToBounds = true
        snapshotView.isHidden = true
        view.addSubview(snapshotView)
        snapshotView.addConstraints(fromStringArray: ["V:|-100-[$self]|",
                                                      "H:|[$self]|"])
        
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
                if let ddddd = completion {
                    ddddd(true)
                }
            })
            CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
            self.mapView.animate(to: GMSCameraPosition.camera(withTarget: location,
                                                              zoom: 18))
            CATransaction.commit()
            
        } else {
            if completion != nil {
                completion!(false)
            }
        }
    }
    
    // MARK: UI Event
    
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
    
    func handleNearestButtonOnTap(_ sender: UIButton) {
        
        clusterRenderer.animatesClusters = false
        
        moveToMyLocation { (success) in
            if success {
                self.clusterRenderer.animatesClusters = true
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    self.reloadNeeded = false
                    let test = self.isCollectionViewShow
                    self.isCollectionViewShow = test
                    if let renderer = self.clusterRenderer,
                        let currentLocation = KPLocationManager.sharedInstance().currentLocation {
                        var nearestMarker: GMSMarker?
                        
                        var nearestDistance: Double = Double.greatestFiniteMagnitude
                        for marker in renderer.markers() {
                            if nearestMarker == nil {
                                nearestMarker = marker
                            } else {
                                let distance = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude).distance(from: currentLocation)
                                if distance < nearestDistance {
                                    nearestDistance = distance
                                    nearestMarker = marker
                                }
                            }
                        }
                        
                        if nearestMarker != nil {
                            CATransaction.begin()
                            CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
                            self.mapView.animate(to: GMSCameraPosition.camera(withTarget: nearestMarker!.position , zoom: self.mapView.camera.zoom))
                            CATransaction.commit()
                            CATransaction.setCompletionBlock({
                                self.reloadNeeded = false
                                self.mapView.selectedMarker = nearestMarker!
                            })
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                                if nearestMarker?.userData is KPDataModel {
                                    self.isCollectionViewShow = true
                                } else {
                                    self.mapView.animate(toZoom: self.mapView.camera.zoom+1)
                                }
                            })
                        }
                    }
                })

            }
        }
        
//        if let renderer = clusterRenderer as? GMUDefaultClusterRenderer,
//           let currentLocation = KPLocationManager.sharedInstance().currentLocation {
//            var nearestMarker: GMSMarker?
//            
//            var nearestDistance: Double = Double.greatestFiniteMagnitude
//            for marker in renderer.markers() {
//                if nearestMarker == nil {
//                    nearestMarker = marker
//                } else {
//                    let distance = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude).distance(from: currentLocation)
//                    if distance < nearestDistance {
//                        nearestDistance = distance
//                        nearestMarker = marker
//                    }
//                }
//            }
//
//            if nearestMarker != nil {
//                CATransaction.begin()
//                CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
//                self.mapView.animate(to: GMSCameraPosition.camera(withTarget: nearestMarker!.position , zoom: self.mapView.camera.zoom))
//                CATransaction.commit()
//                CATransaction.setCompletionBlock({
//                    self.reloadNeeded = false
//                    self.mapView.selectedMarker = nearestMarker!
//                })
//                
//                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
//                    if nearestMarker?.userData is KPDataModel {
//                        self.isCollectionViewShow = true
//                    } else {
//                        self.mapView.animate(toZoom: self.mapView.camera.zoom+1)
//                    }
//                })
//            }
//        }
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
        print("Position:\(position.target.latitude) and \(position.target.longitude)")
        
        if !isCollectionViewShow && self.nearestButton.alpha != 0.75 {
            UIView.animate(withDuration: 0.15,
                           animations: {
                            self.nearestButton.alpha = 0.75
                            self.addButton.alpha = 0.75
            })
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.nearestButton.alpha = 1.0
                        self.addButton.alpha = 1.0
                        
                        
                        self.mainController.searchHeaderView.searchTagView.transform = CGAffineTransform(translationX: 0,
                                                                                                         y: 0)
                        self.mapView.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.mainController.mainListViewController?.tableView.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.mainController.mainListViewController?.snapshotView.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.mainController.mainListViewController?.currentSearchTagTranslateY = 0
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
