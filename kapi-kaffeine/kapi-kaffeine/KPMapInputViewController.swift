//
//  KPMapInputViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 17/07/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPMapInputViewController: KPSharedSettingViewController, GMSMapViewDelegate {
    
    var mapView: GMSMapView!
    var marker: GMSMarker!
    
    var geocoder: GMSGeocoder!
    
    var addressLabel: UILabel!
    
    var address: String?
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = "請選擇店家位置"
        
        geocoder = GMSGeocoder()
        
        marker = GMSMarker()
        
        var latitude: Double = 25.018744,  longtitude: Double = 121.532785
        if let position = coordinate {
            latitude = position.latitude
            longtitude = position.longitude
            marker.position = position
            geocoder.reverseGeocodeCoordinate(position) {[unowned self] (geocodeResponse, error) in
                if let gmsaddress = geocodeResponse?.firstResult(),
                    let addressLines = gmsaddress.lines {
                    var address = ""
                    for line in addressLines {
                        address += "\(line) "
                    }
                    self.address = address
                }
            }
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longtitude, zoom: 18.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = self
        mapView.preferredFrameRate = .maximum
        
    
        containerView.addSubview(self.mapView)
        mapView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        
        mapView.addConstraintForHavingSameHeight(with: scrollView)
        
        marker.map = mapView
        
        sendButton.setTitle("完成", for: .normal)
        
        let container = UIView()
        scrollView.addSubview(container)
        container.backgroundColor = UIColor.white
        container.addConstraints(fromStringArray: ["H:|-24-[$self]-24-|", "V:[$self]-16-|"])
        
        addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .center
        addressLabel.textColor = KPColorPalette.KPTextColor.grayColor
        container.addSubview(addressLabel)
        addressLabel.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|", "V:|-16-[$self]-16-|"])
        addressLabel.setText(text: "點選地圖以選擇店家地址", lineSpacing: 3.0)
        
        container.layer.cornerRadius = 4
        container.layer.borderWidth = 0.5
        container.layer.borderColor = KPColorPalette.KPBackgroundColor.grayColor_level6?.cgColor
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.2
        container.layer.shadowRadius = 3.0
        container.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let coo = coordinate {
            mapView.camera = GMSCameraPosition.camera(withTarget: coo,
                                                      zoom: mapView.camera.zoom)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
        geocoder.reverseGeocodeCoordinate(coordinate) {[unowned self] (geocodeResponse, error) in
            if let gmsaddress = geocodeResponse?.firstResult(),
                let addressLines = gmsaddress.lines {
                var address = ""
                for line in addressLines {
                    address += "\(line) "
                }
                self.addressLabel.setText(text: address, lineSpacing: 3.0)
                self.address = address
                self.coordinate = coordinate
            }
        }
    }

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
        geocoder.reverseGeocodeCoordinate(coordinate) {[unowned self] (geocodeResponse, error) in
            if let gmsaddress = geocodeResponse?.firstResult(),
               let addressLines = gmsaddress.lines {
                var address = ""
                for line in addressLines {
                    address += "\(line) "
                }
                self.addressLabel.setText(text: address, lineSpacing: 3.0)
                self.address = address
                self.coordinate = coordinate
            }
        }
    }

}
