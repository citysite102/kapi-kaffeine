//
//  KKMapViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 05/04/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import GoogleMaps

class KKMapViewController: UIViewController, GMSMapViewDelegate {
    
    var cafeData: Array<NSDictionary> = []
    
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
                let data = try Data(contentsOf: dataURL)
                self.cafeData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Array<NSDictionary>
                (self.view as! GMSMapView).clear()
                
                for cafe in self.cafeData {
                    let position = CLLocationCoordinate2DMake(Double(cafe.object(forKey: "latitude") as! String)!,
                                                              Double(cafe.object(forKey: "longitude") as! String)!)
                    print(position)
                    let marker = GMSMarker(position: position)
                    marker.title = cafe.object(forKey: "name") as? String
                    marker.icon = UIImage(named: "icon_mapMarker")
                    marker.map = self.view as? GMSMapView
                    
                }
                
            } catch {
                
            }
            
            
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.icon = UIImage(named: "icon_mapMarkerSelected")
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = UIImage(named: "icon_mapMarker")
    }
    
}
