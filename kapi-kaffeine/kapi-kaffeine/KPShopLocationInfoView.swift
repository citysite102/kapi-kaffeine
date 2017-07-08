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
            let position = CLLocationCoordinate2DMake(dataModel.latitude, dataModel.longitude)
            let marker = GMSMarker(position: position)
            marker.title = dataModel.name
            marker.icon = R.image.icon_mapMarker()
            marker.map = self.mapView
            marker.userData = dataModel
            
            let circle = GMSCircle(position: CLLocationCoordinate2DMake(dataModel.latitude+0.000073, dataModel.longitude), radius: 25)
            circle.strokeWidth = 2
            circle.strokeColor = KPColorPalette.KPMainColor.mainColor?.withAlphaComponent(0.5)
            circle.fillColor = KPColorPalette.KPMainColor.mainColor_light?.withAlphaComponent(0.3)
            circle.map = mapView
            
            self.mapView.selectedMarker = marker
            self.mapView.camera = GMSCameraPosition.camera(withTarget: position, zoom: self.mapView.camera.zoom)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.018744, longitude: 121.532785, zoom: 18.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = self
        
        self.addSubview(mapView)
        
        mapView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        
        self.mapView.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.icon = R.image.icon_mapMarkerSelected()
        let infoWindow = KPMainMapMarkerInfoWindow(dataModel: marker.userData as! KPDataModel)
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = R.image.icon_mapMarker()
    }

}
