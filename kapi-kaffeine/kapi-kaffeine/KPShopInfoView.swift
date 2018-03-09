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
    var informationDataModel: KPDataModel! {
        didSet {
            let position = CLLocationCoordinate2DMake(informationDataModel.latitude,
                                                      informationDataModel.longitude)
            let marker = GMSMarker(position: position)
            marker.title = informationDataModel.name
            if let rate = informationDataModel.averageRate?.doubleValue, rate >= 4.5 {
                marker.icon = R.image.icon_mapMarkerSelected()
            } else {
                marker.icon = R.image.icon_mapMarker()
            }
            marker.map = self.mapView
            marker.userData = informationDataModel
            
            let circle = GMSCircle(position: CLLocationCoordinate2DMake(informationDataModel.latitude+0.000073,
                                                                        informationDataModel.longitude), radius: 25)
            circle.strokeWidth = 2
            circle.strokeColor = KPColorPalette.KPMainColor_v2.mainColor?.withAlphaComponent(0.5)
            circle.fillColor = KPColorPalette.KPMainColor_v2.mainColor_light?.withAlphaComponent(0.3)
            circle.map = mapView
            
            self.mapView.selectedMarker = marker
            self.mapView.camera = GMSCameraPosition.camera(withTarget: position, zoom: self.mapView.camera.zoom)
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
    
    convenience init(_ informationDataModel: KPDataModel) {
        self.init(frame: .zero)
        
        self.informationDataModel = informationDataModel
        
        shopWebsiteInfoView = KPShopSubInfoView("網站",
                                                "www.abc.com",
                                                nil,
                                                false,
                                                nil)
        addSubview(shopWebsiteInfoView)
        shopWebsiteInfoView.addConstraints(fromStringArray: ["V:|-(-16)-[$self]",
                                                             "H:|-($metric0)-[$self]-($metric0)-|"],
                                           metrics:[KPLayoutConstant.information_horizontal_offset])
        
        shopPhoneInfoView = KPShopSubInfoView("聯絡電話",
                                              informationDataModel.phone ?? "尚無電話",
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
                                              false,
                                              nil)
        addSubview(shopPriceInfoView)
        shopPriceInfoView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                           "H:|-($metric0)-[$self]-($metric0)-|"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                         views:[shopFacebookInfoView])
        
        shopLocationInfoView = KPShopSubInfoView("地址",
                                                 informationDataModel.address,
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
        
        
        navigateButton = UIButton(type: .custom)
        navigateButton.setTitle("開始導航",
                                for: .normal)
        navigateButton.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        navigateButton.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_title,
                                     for: .normal)
        navigateButton.contentEdgeInsets = UIEdgeInsetsMake(10, 16, 10, 16)
        navigateButton.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        navigateButton.layer.cornerRadius = 4.0
        navigateButton.layer.borderColor = KPColorPalette.KPTextColor_v2.mainColor_title?.cgColor
        navigateButton.layer.borderWidth = 1.5
        navigateButton.layer.masksToBounds = true
        mapView.addSubview(navigateButton)
        navigateButton.addConstraintForCenterAligningToSuperview(in: .vertical)
        navigateButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
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
        let infoWindow = KPMainMapMarkerInfoWindow(dataModel: marker.userData as! KPDataModel)
        return infoWindow
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
