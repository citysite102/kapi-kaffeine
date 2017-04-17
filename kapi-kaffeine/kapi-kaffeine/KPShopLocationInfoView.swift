//
//  KPShopLocationInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GoogleMaps

class KPShopLocationInfoView: UIView, GMSMapViewDelegate {
    
    var mapView: GMSMapView!
    
    var dataModel: KPDataModel! {
        didSet {
            if let latstr = dataModel.latitude, let latitude = Double(latstr),
                let longstr = dataModel.longitude, let longitude = Double(longstr) {
                let position = CLLocationCoordinate2DMake(latitude, longitude)
                let marker = GMSMarker(position: position)
                marker.title = dataModel.name
                marker.icon = UIImage(named: "icon_mapMarker")
                marker.map = self.mapView
                marker.userData = dataModel
                self.mapView.selectedMarker = marker
                self.mapView.camera = GMSCameraPosition.camera(withTarget: position, zoom: self.mapView.camera.zoom)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.018744, longitude: 121.532785, zoom: 18.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
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
        
        self.addSubview(mapView)
        
        mapView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.icon = UIImage(named: "icon_mapMarkerSelected")
        let infoWindow = KPMainMapMarkerInfoWindow(dataModel: marker.userData as! KPDataModel)
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
            marker.icon = UIImage(named: "icon_mapMarker")
    }

}
