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
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = "請選擇店家位置"
        seperator_one.isHidden = true
        
        geocoder = GMSGeocoder()
        
        marker = GMSMarker()
        marker.position = coordinate
        
        geocoder.reverseGeocodeCoordinate(coordinate) {[unowned self] (geocodeResponse, error) in
            if let gmsaddress = geocodeResponse?.firstResult(),
                let addressLines = gmsaddress.lines {
                var address = ""
                for line in addressLines {
                    address += "\(line) "
                }
                self.address = address
                self.addressLabel.setText(text: address, lineSpacing: 3.0)
            }
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 18.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = self
        mapView.preferredFrameRate = .maximum
        
    
        containerView.addSubview(self.mapView)
        mapView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                 "V:|[$self]|"])
        
        mapView.addConstraintForHavingSameHeight(with: scrollView)
        
        marker.map = mapView
        
        sendButton.setTitle("完成", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSendButtonOnTapped), for: .touchUpInside)
        
        let container = UIView()
        scrollView.addSubview(container)
        container.backgroundColor = UIColor.white
        container.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$self]|"])
        
        addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .center
        addressLabel.textColor = KPColorPalette.KPTextColor.grayColor
        container.addSubview(addressLabel)
        addressLabel.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|", "V:|-24-[$self]-24-|"])
        addressLabel.setText(text: address ?? "點選地圖以選擇店家地址", lineSpacing: 3.0)
        
        container.layer.shadowColor = KPColorPalette.KPMainColor_v2.shadow_darkColor?.cgColor
        container.layer.shadowOpacity = 0.2
        container.layer.shadowRadius = 4.0
        container.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        
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
    
    @objc func handleSendButtonOnTapped() {
        returnValue = (address, coordinate)
        delegate?.returnValueSet(self)
        dismiss(animated: true, completion: nil)
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
