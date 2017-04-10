//
//  KKMapViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 05/04/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import GoogleMaps
import BenzeneFoundation
import ObjectMapper

class KKMapViewController: UIViewController, GMSMapViewDelegate {
    
    var cafeData: Array<KPDataModel> = []
    
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
        
        let position = CLLocationCoordinate2DMake(25.018744, 121.532785)
        let london = GMSMarker(position: position)
        london.title = "london"
        london.icon = UIImage(named: "icon_mapMarker")
        london.map = mapView;
        
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dataURL = Bundle.main.url(forResource: "cafes", withExtension: "json") {
            do {
                let data = try String(contentsOf: dataURL)
                self.cafeData = Mapper<KPDataModel>().mapArray(JSONString: data) ?? []
                
                (self.view as! GMSMapView).clear()

                for datamodel in self.cafeData  {
                    let position = CLLocationCoordinate2DMake(Double(datamodel.latitude  ?? "0") ?? 0,
                                                              Double(datamodel.longitude ?? "0") ?? 0)
                    let marker = GMSMarker(position: position)

                    marker.title = datamodel.name
                    marker.icon = UIImage(named: "icon_mapMarker")
                    marker.map = self.view as? GMSMapView
                    marker.userData = datamodel
                }
                
            } catch {
                
            }
            
            
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.icon = UIImage(named: "icon_mapMarkerSelected")
        let infoWindow = KKMapMarkerInfoWindow(dataModel: marker.userData as! KPDataModel)
        
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = UIImage(named: "icon_mapMarker")
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        // Tap info window
    }
    
}
