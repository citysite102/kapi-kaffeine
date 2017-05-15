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

class KPMainMapViewController: UIViewController, GMSMapViewDelegate, GMUClusterManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, KPMainViewControllerDelegate {
    
    weak var mainController:KPMainViewController!
    var collectionView: UICollectionView!
    var mapView: GMSMapView {
        get {
            return self.view as! GMSMapView
        }
    }
    
    private var clusterManager: GMUClusterManager!
    
    var currentDataModel:KPDataModel?
    var selectedDataModel: KPDataModel? {
        return self.currentDataModel
    }
    
    
    
    var isCollectionViewShow: Bool = true {
        didSet {
            if self.collectionViewBottomConstraint != nil {
                let showc: Bool = isCollectionViewShow
                DispatchQueue.main.async {
                    self.view.bringSubview(toFront: self.collectionView)
                    if showc {
                        self.displayDataModel =  self.allDataModel.filter { (dataModel) -> Bool in
                            let bounds = GMSCoordinateBounds(region: self.mapView.projection.visibleRegion())
                            return bounds.contains(dataModel.position)
                        }
                        self.collectionViewBottomConstraint.constant = 0
                    } else {
                        self.collectionViewBottomConstraint.constant = 120
                    }
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    var collectionViewBottomConstraint: NSLayoutConstraint!
    
    var displayDataModel: [KPDataModel] = [] {
        didSet {
            self.collectionView.reloadData()
            if  let dataModel = self.mapView.selectedMarker?.userData as? KPDataModel,
                let selectedIndex =  self.displayDataModel.index(where: {($0.name == dataModel.name)}) {
                self.collectionView.setContentOffset(CGPoint(x: -30 + CGFloat(selectedIndex) * (UIScreen.main.bounds.size.width - 60 + 15), y: 0), animated: false)
            }
        }
    }
    
    var allDataModel: [KPDataModel]! {
        didSet {
            (self.view as! GMSMapView).clear()
            for datamodel in self.allDataModel  {
                self.clusterManager.add(datamodel)
            }
            
            // Call cluster() after items have been added to perform the clustering
            // and rendering on map.
            self.clusterManager.cluster()
        }
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 25.018744, longitude: 121.532785, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = self
        
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
        
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
        
        self.mapView.isMyLocationEnabled = true
        self.moveToMyLocation()
        
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
        self.collectionView.register(KPMainMapViewCollectionCell.classForCoder(),
                                     forCellWithReuseIdentifier: "cell")
        
        self.view.addSubview(self.collectionView)
        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$self(120)]"])
        self.collectionViewBottomConstraint = self.collectionView.addConstraintForAligning(to: .bottom, of: self.view, constant: 0).first as! NSLayoutConstraint
        
        
        if let dataURL = Bundle.main.url(forResource: "cafes", withExtension: "json") {
            do {
                let data = try String(contentsOf: dataURL)
                self.allDataModel = Mapper<KPDataModel>().mapArray(JSONString: data) ?? []
            } catch {
                print("Failed to load cafes.json file")
            }
        }
        
        let currentLocationButton = UIButton(type: .custom)
        currentLocationButton.setImage(UIImage(named: "icon_currentLocation"), for: .normal)
        currentLocationButton.addTarget(self, action: #selector(moveToMyLocation), for: .touchUpInside)
        self.view.addSubview(currentLocationButton)
        currentLocationButton.addConstraints(fromStringArray: ["H:[$self(40)]-15-|", "V:|-120-[$self(40)]"])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToMyLocation() {
        if let location = KPLocationManager.sharedInstance().currentLocation?.coordinate {
            CATransaction.begin()
            CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
            self.mapView.animate(to: GMSCameraPosition.camera(withTarget: location,
                                                              zoom: self.mapView.camera.zoom))
            CATransaction.commit()
        }
    }
    
    // MARK: UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.displayDataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! KPMainMapViewCollectionCell
        cell.dataModel = self.displayDataModel[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentDataModel = self.displayDataModel[indexPath.row]
        self.mainController.performSegue(withIdentifier: "datailedInformationSegue", sender: self)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = UIScreen.main.bounds.size.width - 60
        let currentOffset = targetContentOffset.pointee.x
        let index = floor((currentOffset + (pageWidth + 15)/2)/(pageWidth + 15))

//        self.mapView.selectedMarker = self.mapMarkers[Int(index)]
//        CATransaction.begin()
//        CATransaction.setValue(NSNumber(floatLiteral: 0.5), forKey: kCATransactionAnimationDuration)
//        self.mapView.animate(to: GMSCameraPosition.camera(withTarget: self.mapView.selectedMarker!.position , zoom: self.mapView.camera.zoom))
//        CATransaction.commit()
        
        targetContentOffset.pointee.x = -30 + index * (pageWidth + 15)
        scrollView.setContentOffset(CGPoint(x: -30 + index * (pageWidth + 15), y: 0), animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2.0
        let pageWidth = UIScreen.main.bounds.size.width - 30;
        for cell in self.collectionView.visibleCells {
            let offset = fabs(centerX - (cell.frame.origin.x + cell.frame.size.width/2.0));
            cell.alpha = (pageWidth - offset) / pageWidth * 0.7 + 0.3;
        }
    }
    
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        // 過濾cluster的marker
        if (marker.userData as? KPDataModel) == nil {
            return nil
        }
        
//        if self.isCollectionViewShow == false  {
            self.isCollectionViewShow = true
//        }
        
        marker.icon = UIImage(named: "icon_mapMarkerSelected")
        let infoWindow = KPMainMapMarkerInfoWindow(dataModel: marker.userData as! KPDataModel)

        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = UIImage(named: "icon_mapMarker")
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
    
    
}
