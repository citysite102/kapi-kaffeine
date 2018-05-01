//
//  KPShopInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GoogleMaps

class KPShopInfoView: UIView, GMSMapViewDelegate {

    var titleLabel: UILabel!
    var otherTimeClosure: (() -> Void)?
    var informationDataModel: KPDetailedDataModel! {
        didSet {
            
            DispatchQueue.main.async {
                if self.shopWebsiteInfoView == nil {
                    
                    let infraContainer = UIView()
                    let wifiImageView = UIImageView(image: R.image.icon_wifi())
                    let limitTime = UIImageView(image: R.image.icon_time())
                    let stand = UIImageView(image: R.image.icon_stand_mac())
                    let socket = UIImageView(image: R.image.icon_socket())
                    wifiImageView.tintColor = KPColorPalette.KPTextColor_v2.mainColor_title
                    limitTime.tintColor = KPColorPalette.KPTextColor_v2.mainColor_hint_light
                    stand.tintColor = KPColorPalette.KPTextColor_v2.mainColor_title
                    socket.tintColor = KPColorPalette.KPTextColor_v2.mainColor_title
                    infraContainer.addSubview(wifiImageView)
                    infraContainer.addSubview(limitTime)
                    infraContainer.addSubview(stand)
                    infraContainer.addSubview(socket)
                    stand.addConstraints(fromStringArray: ["V:|[$self(22)]|",
                                                                   "H:|[$self(22)]"])
                    wifiImageView.addConstraints(fromStringArray: ["V:[$self(22)]",
                                                           "H:[$view0]-8-[$self(22)]"],
                                         views: [stand])
                    wifiImageView.addConstraintForCenterAligning(to: stand,
                                                                 in: .vertical,
                                                                 constant: -1)
                    limitTime.addConstraints(fromStringArray: ["V:[$self(22)]",
                                             "H:[$view0]-8-[$self(22)]"],
                                             views: [wifiImageView])
                    limitTime.addConstraintForCenterAligning(to: stand,
                                                                 in: .vertical,
                                                                 constant: 0)
                    socket.addConstraints(fromStringArray: ["V:[$self(22)]",
                                             "H:[$view0]-8-[$self(22)]|"],
                                             views: [limitTime])
                    socket.addConstraintForCenterAligning(to: stand,
                                                                 in: .vertical,
                                                                 constant: 0)
                    
                    
                    
                    self.shopInfrasInfoView = KPShopSubInfoView("設施",
                                                                "內容",
                                                                infraContainer,
                                                                nil,
                                                                false,
                                                                nil)
                    self.addSubview(self.shopInfrasInfoView)
                    self.shopInfrasInfoView.addConstraints(fromStringArray: ["V:|-(-16)-[$self]",
                                                                              "H:|-($metric0)-[$self]-($metric0)-|"],
                                                            metrics:[KPLayoutConstant.information_horizontal_offset])
                    
                    self.shopBusinessView = KPShopSubInfoView("營業時間",
                                                              "9:00 - 19:00",
                                                              nil,
                                                              nil,
                                                              false,
                                                              { (infoView) in
                                                                if !infoView.emptyContent {
                                                                    if self.otherTimeClosure != nil {
                                                                        self.otherTimeClosure!()
                                                                    }
                                                                    
                                                                }
                                                                
                    })
                    self.addSubview(self.shopBusinessView)
                    self.shopBusinessView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                                           "H:|-($metric0)-[$self]-($metric0)-|"],
                                                            metrics:[KPLayoutConstant.information_horizontal_offset],
                                                            views:[self.shopInfrasInfoView])
                    
                    
                    self.shopWebsiteInfoView = KPShopSubInfoView("網站",
                                                                 "尚未開放",
                                                                 nil,
                                                                 nil,
                                                                 true,
                                                                 nil)
                    self.addSubview(self.shopWebsiteInfoView)
                    self.shopWebsiteInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                                              "H:|-($metric0)-[$self]-($metric0)-|"],
                                                            metrics:[KPLayoutConstant.information_horizontal_offset],
                                                            views:[self.shopBusinessView])
                    
                    self.shopPhoneInfoView = KPShopSubInfoView("聯絡電話",
                                                               self.informationDataModel.phone ?? "尚無電話",
                                                               nil,
                                                               nil,
                                                               self.informationDataModel.phone == nil,
                                                               { (infoView) in
                                                                if !infoView.emptyContent {
                                                                    guard let number = URL(string: "tel://" + self.informationDataModel.phone) else { return }
                                                                    UIApplication.shared.open(number)

                                                                }
                                                                
                    })
                    self.addSubview(self.shopPhoneInfoView)
                    self.shopPhoneInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                                            "H:|-($metric0)-[$self]-($metric0)-|"],
                                                          metrics:[KPLayoutConstant.information_horizontal_offset],
                                                          views:[self.shopWebsiteInfoView])
                    
                    self.shopFacebookInfoView = KPShopSubInfoView("粉絲專頁",
                                                             self.informationDataModel.facebookID ?? "尚無專頁",
                                                             nil,
                                                             nil,
                                                             self.informationDataModel.facebookID == nil,
                                                             nil)
                    self.addSubview(self.shopFacebookInfoView)
                    self.shopFacebookInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                                               "H:|-($metric0)-[$self]-($metric0)-|"],
                                                        metrics:[KPLayoutConstant.information_horizontal_offset],
                                                        views:[self.shopPhoneInfoView])
                    
                    self.shopPriceInfoView = KPShopSubInfoView("平均消費",
                                                          self.priceContents[(self.informationDataModel.priceAverage?.intValue) ?? 1],
                                                          nil,
                                                          nil,
                                                          false,
                                                          nil)
                    self.addSubview(self.shopPriceInfoView)
                    self.shopPriceInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                                            "H:|-($metric0)-[$self]-($metric0)-|"],
                                                     metrics:[KPLayoutConstant.information_horizontal_offset],
                                                     views:[self.shopFacebookInfoView])
                    
                    self.shopLocationInfoView = KPShopSubInfoView("地址",
                                                             self.informationDataModel.address,
                                                             nil,
                                                             "開啟導航",
                                                             false,
                                                             nil)
                    self.addSubview(self.shopLocationInfoView)
                    self.shopLocationInfoView.showSeparator = false
                    self.shopLocationInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                                               "H:|-($metric0)-[$self]-($metric0)-|"],
                                                        metrics:[KPLayoutConstant.information_horizontal_offset],
                                                        views:[self.shopPriceInfoView])
                    
                    let camera = GMSCameraPosition.camera(withLatitude: 25.018744,
                                                          longitude: 121.532785, zoom: 18.0)
                    self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                    self.mapView.delegate = self
                    self.mapView.isUserInteractionEnabled = false
                    self.addSubview(self.mapView)
                    self.mapView.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]-($metric0)-|",
                                                                  "V:[$view0][$self(240)]-($metric0)-|"],
                                           metrics:[KPLayoutConstant.information_horizontal_offset],
                                           views:[self.shopLocationInfoView])
                    
                    let position = CLLocationCoordinate2DMake(self.informationDataModel.latitude,
                                                              self.informationDataModel.longitude)
                    let marker = GMSMarker(position: position)
                    marker.title = self.informationDataModel.name
                    if let rate = self.informationDataModel.averageRate?.doubleValue, rate >= 4.5 {
                        marker.icon = R.image.icon_mapMarkerSelected()
                    } else {
                        marker.icon = R.image.icon_mapMarker()
                    }
                    marker.map = self.mapView
                    marker.userData = self.informationDataModel
                    
//                    let circle = GMSCircle(position: CLLocationCoordinate2DMake(self.informationDataModel.latitude+0.000073,
//                                                                                self.informationDataModel.longitude), radius: 25)
//                    circle.strokeWidth = 2
//                    circle.strokeColor = KPColorPalette.KPMainColor_v2.mainColor?.withAlphaComponent(0.5)
//                    circle.fillColor = KPColorPalette.KPMainColor_v2.mainColor_light?.withAlphaComponent(0.3)
//                    circle.map = self.mapView
                    
                    self.mapView.selectedMarker = marker
                    self.mapView.camera = GMSCameraPosition.camera(withTarget: position, zoom: self.mapView.camera.zoom)
                }
            }
        }
    }
    
//    var featureContainer: UIView!
//    var featureContentViews: [UIView] = [UIView]()
//    var featureContents: [String]! {
//        didSet {
//
//            if featureContents.count == 0 {
//                featureContents = ["尚無特色"]
//            }
//            for oldContentView in featureContentViews {
//                oldContentView.removeFromSuperview()
//            }
//
//            featureContentViews.removeAll()
//
//            for (index, content) in featureContents.enumerated() {
//
//                let featureView = UIView()
//
//                featureView.layer.borderWidth = 1.0
//                featureView.layer.borderColor = KPColorPalette.KPMainColor_v2.mainColor?.cgColor
//                featureView.layer.cornerRadius = 12.0
//                featureContainer.addSubview(featureView)
//                featureContentViews.append(featureView)
//
//                if index == 0 {
//                    featureView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
//                                                                 "H:|[$self]"])
//                } else if index == featureContents.count-1 {
//                    featureView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
//                                                                 "H:[$view0]-4-[$self]|"],
//                                               views: [featureContentViews[index-1]])
//                } else {
//                    featureView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
//                                                                 "H:[$view0]-4-[$self]"],
//                                               views: [featureContentViews[index-1]])
//                }
//
//
//                let contentLabel = KPLayerLabel()
//
//                contentLabel.font = UIFont.systemFont(ofSize: 12.0)
//                contentLabel.textColor = KPColorPalette.KPTextColor.mainColor
//                contentLabel.text = content
//                featureView.addSubview(contentLabel)
//                contentLabel.addConstraints(fromStringArray: ["H:|-8-[$self]-8-|"])
//                contentLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
//
//            }
//        }
//    }
    
    
    var shopInfrasInfoView: KPShopSubInfoView!
    var shopBusinessView: KPShopSubInfoView!
    var shopWebsiteInfoView: KPShopSubInfoView!
    var shopPhoneInfoView: KPShopSubInfoView!
    var shopFacebookInfoView: KPShopSubInfoView!
    var shopPriceInfoView: KPShopSubInfoView!
    var shopLocationInfoView: KPShopSubInfoView!
    let priceContents = ["NT$1-100元 / 人",
                         "NT$101-200元 / 人",
                         "NT$201-300元 / 人",
                         "NT$301-400元 / 人",
                         "大於NT$400元 / 人"]
    
    var mapView: GMSMapView!
    var navigateButton: UIButton!
    
    convenience init(_ informationDataModel: KPDetailedDataModel) {
        self.init(frame: .zero)
        
        shopInfrasInfoView = KPShopSubInfoView("設施",
                                               "www.abc.com",
                                               nil,
                                               nil,
                                               false,
                                               nil)
        addSubview(shopInfrasInfoView)
        shopInfrasInfoView.addConstraints(fromStringArray: ["V:|-(-16)-[$self]",
                                                            "H:|-($metric0)-[$self]-($metric0)-|"],
                                           metrics:[KPLayoutConstant.information_horizontal_offset])
        
        
        shopBusinessView = KPShopSubInfoView("營業時間",
                                             "9:00 - 19:00",
                                             nil,
                                             nil,
                                             false,
                                             nil)
        addSubview(shopBusinessView)
        shopBusinessView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                          "H:|-($metric0)-[$self]-($metric0)-|"],
                                        metrics:[KPLayoutConstant.information_horizontal_offset],
                                        views:[shopInfrasInfoView])
        
        shopWebsiteInfoView = KPShopSubInfoView("網站",
                                                "www.abc.com",
                                                nil,
                                                nil,
                                                false,
                                                nil)
        addSubview(shopWebsiteInfoView)
        shopWebsiteInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                             "H:|-($metric0)-[$self]-($metric0)-|"],
                                           metrics:[KPLayoutConstant.information_horizontal_offset],
                                           views:[shopBusinessView])
        
        shopPhoneInfoView = KPShopSubInfoView("聯絡電話",
                                              informationDataModel.phone ?? "尚無電話",
                                              nil,
                                              nil,
                                              informationDataModel.phone == nil,
                                              nil)
        addSubview(shopPhoneInfoView)
        shopPhoneInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                           "H:|-($metric0)-[$self]-($metric0)-|"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                         views:[shopWebsiteInfoView])
        
        shopFacebookInfoView = KPShopSubInfoView("粉絲專頁",
                                                 informationDataModel.facebookID ?? "尚無專頁",
                                                 nil,
                                                 nil,
                                                 informationDataModel.facebookID == nil,
                                                 nil)
        addSubview(shopFacebookInfoView)
        shopFacebookInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                              "H:|-($metric0)-[$self]-($metric0)-|"],
                                            metrics:[KPLayoutConstant.information_horizontal_offset],
                                            views:[shopPhoneInfoView])
        
        shopPriceInfoView = KPShopSubInfoView("平均消費",
                                              priceContents[(informationDataModel.priceAverage?.intValue) ?? 1],
                                              nil,
                                              nil,
                                              false,
                                              nil)
        addSubview(shopPriceInfoView)
        shopPriceInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                           "H:|-($metric0)-[$self]-($metric0)-|"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                         views:[shopFacebookInfoView])
        
        shopLocationInfoView = KPShopSubInfoView("地址",
                                                 informationDataModel.address,
                                                 nil,
                                                 "開啟導航",
                                                 false,
                                                 nil)
        addSubview(shopLocationInfoView)
        shopLocationInfoView.showSeparator = false
        shopLocationInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                              "H:|-($metric0)-[$self]-($metric0)-|"],
                                            metrics:[KPLayoutConstant.information_horizontal_offset],
                                            views:[shopPriceInfoView])
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.018744,
                                              longitude: 121.532785, zoom: 18.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        addSubview(mapView)
        mapView.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]-($metric0)-|",
                                                 "V:[$view0][$self(240)]-($metric0)-|"],
                               metrics:[KPLayoutConstant.information_horizontal_offset],
                               views:[shopLocationInfoView])
        
        
        self.informationDataModel = informationDataModel
        
//        if informationDataModel.featureContents.count > 0 {
//            featureContainer = UIView()
//            addSubview(featureContainer)
//            featureContainer.addConstraints(fromStringArray: ["V:|-24-[$self]",
//                                                              "H:|-16-[$self]"],
//                                            views: [titleLabel])
//            featureContents = informationDataModel.featureContents
//
//            openTimeIcon = UIImageView(image: R.image.icon_tradehour())
//            openTimeIcon.tintColor = KPColorPalette.KPMainColor_v2.textColor_level1
//            addSubview(openTimeIcon)
//            openTimeIcon.addConstraints(fromStringArray: ["V:|[$self(20)]",
//                                                          "H:|-16-[$self(20)]"],
//                                        views: [featureContainer])
//        } else {
//            openTimeIcon = UIImageView(image: R.image.icon_tradehour())
//            openTimeIcon.tintColor = KPColorPalette.KPMainColor_v2.textColor_level1
//            addSubview(openTimeIcon)
//            openTimeIcon.addConstraints(fromStringArray: ["V:|[$self(20)]",
//                                                          "H:|-16-[$self(20)]"],
//                                        views: [titleLabel])
//        }
        
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = KPMainMapMarkerInfoWindow(detailDataModel: marker.userData as! KPDetailedDataModel)
        return infoWindow
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
