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

class KPMainMapViewController: UIViewController, GMSMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var mainController:KPMainViewController!
    var collectionView: UICollectionView!
    var mapView: GMSMapView {
        get {
            return self.view as! GMSMapView
        }
    }
    
    var mapMarkers: [GMSMarker] = []
    var displayDataModel: [KPDataModel]! {
        didSet {
            (self.view as! GMSMapView).clear()
            self.mapMarkers = []
            for datamodel in self.displayDataModel  {
                if let latstr = datamodel.latitude, let latitude = Double(latstr),
                    let longstr = datamodel.longitude, let longitude = Double(longstr) {
                    
                    let position = CLLocationCoordinate2DMake(latitude, longitude)

                    let marker = GMSMarker(position: position)
                    
                    marker.title = datamodel.name
                    marker.icon = UIImage(named: "icon_mapMarker")
                    marker.map = (self.view as! GMSMapView)
                    marker.userData = datamodel
                    
                    self.mapMarkers.append(marker)
                }
            }
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

        // Do any additional setup after loading the view.
        
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
        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$self(140)]-20-|"])
        

        
        if let dataURL = Bundle.main.url(forResource: "cafes", withExtension: "json") {
            do {
                let data = try String(contentsOf: dataURL)
                self.displayDataModel = Mapper<KPDataModel>().mapArray(JSONString: data) ?? []
            } catch {
                print("Failed to load cafes.json file")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        let pageWidth = UIScreen.main.bounds.size.width - 60
        let currentOffset = targetContentOffset.pointee.x//scrollView.contentOffset.x
        
        
        let index = floor((currentOffset + (pageWidth + 15)/2)/(pageWidth + 15))

        self.mapView.selectedMarker = self.mapMarkers[Int(index)]
        self.mapView.moveCamera(GMSCameraUpdate.setCamera(GMSCameraPosition.camera(withTarget: self.mapView.selectedMarker!.position , zoom: self.mapView.camera.zoom)))
//        self.mapView.camera = GMSCameraPosition.camera(withTarget: self.mapView.selectedMarker!.position , zoom: self.mapView.camera.zoom)
        
        targetContentOffset.pointee.x = -30 + index * (pageWidth + 15)
        scrollView.setContentOffset(CGPoint(x: -30 + index * (pageWidth + 15), y: 0), animated: true)
        
    }
    
    
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.icon = UIImage(named: "icon_mapMarkerSelected")
        let infoWindow = KPMainMapMarkerInfoWindow(dataModel: marker.userData as! KPDataModel)
        if let selectedIndex =  self.displayDataModel.index(where: {($0.name == (marker.userData as! KPDataModel).name)}) {
            self.collectionView.scrollToItem(at: IndexPath.init(row: selectedIndex, section: 0),
                                             at: UICollectionViewScrollPosition.centeredHorizontally,
                                             animated: true)
        }
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = UIImage(named: "icon_mapMarker")
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        // Tap info window
    }

}
