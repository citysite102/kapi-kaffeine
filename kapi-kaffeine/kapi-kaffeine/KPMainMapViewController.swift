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

class KPMainMapViewController: UIViewController, GMSMapViewDelegate {
    
    weak var mainController:KPMainViewController!
    
    var displayDataModel: [KPDataModel]! {
        didSet {
            (self.view as! GMSMapView).clear()
            for datamodel in self.displayDataModel  {
                if let latstr = datamodel.latitude, let latitude = Double(latstr),
                    let longstr = datamodel.longitude, let longitude = Double(longstr) {
                    
                    let position = CLLocationCoordinate2DMake(latitude, longitude)

                    let marker = GMSMarker(position: position)
                    
                    marker.title = datamodel.name
                    marker.icon = UIImage(named: "icon_mapMarker")
                    marker.map = (self.view as! GMSMapView)
                    marker.userData = datamodel
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
    
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.icon = UIImage(named: "icon_mapMarkerSelected")
        let infoWindow = KPMainMapMarkerInfoWindow(dataModel: marker.userData as! KPDataModel)
        
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = UIImage(named: "icon_mapMarker")
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        // Tap info window
    }

}
