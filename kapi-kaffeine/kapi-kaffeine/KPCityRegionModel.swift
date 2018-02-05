//
//  KPCityRegionModel.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 29/08/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit


struct regionData {
    var name: String
    var icon: UIImage
    var cities: [String]
    var cityKeys: [String]
    var countryKeys: [String]
    var cityCoordinate: [CLLocationCoordinate2D]
    var expanded: Bool
}

class KPCityRegionModel: NSObject {

    static let defaultRegionData =
        [regionData(name:"台灣",
                    icon:R.image.icon_tw()!,
                    cities:["台北 Taipei", "基隆 Keelung", "桃園 Taoyuan", "新竹 Hsinchu",
                            "宜蘭 Yilan", "花蓮 Hualien", "台東 Taitung", "澎湖 Penghu",
                            "苗栗 Miaoli", "台中 Taichung", "南投 Nantou", "彰化 Changhua", "雲林 Yunlin",
                            "嘉義 Chiayi", "台南 Tainan", "高雄 Kaohsiung", "屏東 Pingtung"],
                    cityKeys:["taipei", "keelung", "taoyuan", "hsinchu"],
                    countryKeys:["tw", "tw", "tw", "tw",],
                    cityCoordinate: [CLLocationCoordinate2D(latitude: 25.0470462,
                                                            longitude: 121.5156119),
                                     CLLocationCoordinate2D(latitude: 25.131736,
                                                            longitude: 121.738372),
                                     CLLocationCoordinate2D(latitude: 24.989206,
                                                            longitude: 121.311351),
                                     CLLocationCoordinate2D(latitude: 24.8015771,
                                                            longitude: 120.969366)],
                    expanded: false),
         regionData(name:"日本",
                    icon:R.image.icon_jp()!,
                    cities:["東京 Tokyo", "橫濱 Tokyo", "沖繩 Osaka", "神戶 cow"],
                    cityKeys:["yilan", "hualien", "taitung", "penghu"],
                    countryKeys:["tw", "tw", "tw", "tw",],
                    cityCoordinate: [CLLocationCoordinate2D(latitude: 24.7543117,
                                                            longitude: 121.756184),
                                     CLLocationCoordinate2D(latitude: 23.9929463,
                                                            longitude: 121.5989202),
                                     CLLocationCoordinate2D(latitude: 22.791625,
                                                            longitude: 121.1233145),
                                     CLLocationCoordinate2D(latitude: 23.6294021,
                                                            longitude: 119.526859)],
                    expanded: false),
         regionData(name:"泰國",
                    icon:R.image.icon_th()!,
                    cities:["苗栗 Miaoli", "台中 Taichung", "南投 Nantou", "彰化 Changhua", "雲林 Yunlin"],
                    cityKeys:["miaoli", "taichung", "nantou", "changhua", "yunlin"],
                    countryKeys:["tw", "tw", "tw", "tw",],
                    cityCoordinate: [CLLocationCoordinate2D(latitude: 24.57002,
                                                            longitude: 120.820149),
                                     CLLocationCoordinate2D(latitude: 24.1375758,
                                                            longitude: 120.6844115),
                                     CLLocationCoordinate2D(latitude: 23.8295543,
                                                            longitude: 120.7904003),
                                     CLLocationCoordinate2D(latitude: 24.0816314,
                                                            longitude: 120.5362503),
                                     CLLocationCoordinate2D(latitude: 23.7289229,
                                                            longitude: 120.4206707)],
                    expanded: false),
         regionData(name:"英國",
                    icon:R.image.icon_en()!,
                    cities:["苗栗 Miaoli", "台中 Taichung", "南投 Nantou", "彰化 Changhua", "雲林 Yunlin"],
                    cityKeys:["miaoli", "taichung", "nantou", "changhua", "yunlin"],
                    countryKeys:["tw", "tw", "tw", "tw",],
                    cityCoordinate: [CLLocationCoordinate2D(latitude: 24.57002,
                                                            longitude: 120.820149),
                                     CLLocationCoordinate2D(latitude: 24.1375758,
                                                            longitude: 120.6844115),
                                     CLLocationCoordinate2D(latitude: 23.8295543,
                                                            longitude: 120.7904003),
                                     CLLocationCoordinate2D(latitude: 24.0816314,
                                                            longitude: 120.5362503),
                                     CLLocationCoordinate2D(latitude: 23.7289229,
                                                            longitude: 120.4206707)],
                    expanded: false)]
//                [regionData(name:"北部",
//                           icon:R.image.icon_taipei()!,
//                           cities:["台北 Taipei", "基隆 Keelung", "桃園 Taoyuan", "新竹 Hsinchu"],
//                           cityKeys:["taipei", "keelung", "taoyuan", "hsinchu"],
//                           countryKeys:["tw", "tw", "tw", "tw",],
//                           cityCoordinate: [CLLocationCoordinate2D(latitude: 25.0470462,
//                                                                   longitude: 121.5156119),
//                                            CLLocationCoordinate2D(latitude: 25.131736,
//                                                                   longitude: 121.738372),
//                                            CLLocationCoordinate2D(latitude: 24.989206,
//                                                                   longitude: 121.311351),
//                                            CLLocationCoordinate2D(latitude: 24.8015771,
//                                                                   longitude: 120.969366)],
//                           expanded: false),
//                regionData(name:"東部",
//                           icon:R.image.icon_taitung()!,
//                           cities:["宜蘭 Yilan", "花蓮 Hualien", "台東 Taitung", "澎湖 Penghu"],
//                           cityKeys:["yilan", "hualien", "taitung", "penghu"],
//                           countryKeys:["tw", "tw", "tw", "tw",],
//                           cityCoordinate: [CLLocationCoordinate2D(latitude: 24.7543117,
//                                                                   longitude: 121.756184),
//                                            CLLocationCoordinate2D(latitude: 23.9929463,
//                                                                   longitude: 121.5989202),
//                                            CLLocationCoordinate2D(latitude: 22.791625,
//                                                                   longitude: 121.1233145),
//                                            CLLocationCoordinate2D(latitude: 23.6294021,
//                                                                   longitude: 119.526859)],
//                           expanded: false),
//                regionData(name:"中部",
//                           icon:R.image.icon_taichung()!,
//                           cities:["苗栗 Miaoli", "台中 Taichung", "南投 Nantou", "彰化 Changhua", "雲林 Yunlin"],
//                           cityKeys:["miaoli", "taichung", "nantou", "changhua", "yunlin"],
//                           countryKeys:["tw", "tw", "tw", "tw",],
//                           cityCoordinate: [CLLocationCoordinate2D(latitude: 24.57002,
//                                                                   longitude: 120.820149),
//                                            CLLocationCoordinate2D(latitude: 24.1375758,
//                                                                   longitude: 120.6844115),
//                                            CLLocationCoordinate2D(latitude: 23.8295543,
//                                                                   longitude: 120.7904003),
//                                            CLLocationCoordinate2D(latitude: 24.0816314,
//                                                                   longitude: 120.5362503),
//                                            CLLocationCoordinate2D(latitude: 23.7289229,
//                                                                   longitude: 120.4206707)],
//                           expanded: false),
//                regionData(name:"南部",
//                           icon:R.image.icon_pingtung()!,
//                           cities:["嘉義 Chiayi", "台南 Tainan", "高雄 Kaohsiung", "屏東 Pingtung"],
//                           cityKeys:["chiayi", "tainan", "kaohsiung", "pingtung"],
//                           countryKeys:["tw", "tw", "tw", "tw",],
//                           cityCoordinate: [CLLocationCoordinate2D(latitude: 23.4791187,
//                                                                   longitude: 120.4389442),
//                                            CLLocationCoordinate2D(latitude: 22.9719654,
//                                                                   longitude: 120.2140395),
//                                            CLLocationCoordinate2D(latitude: 22.6397615,
//                                                                   longitude: 120.299913),
//                                            CLLocationCoordinate2D(latitude: 22.668857,
//                                                                   longitude: 120.4837693)],
//                           expanded: false),
//                regionData(name:"其他國家",
//                           icon:R.image.icon_global()!,
//                           cities:["日本 Japan", "英國 England", "美國 United States"],
//                           cityKeys:["jp", "gb", "us"],
//                           countryKeys:["jp", "gb", "us"],
//                           cityCoordinate: [CLLocationCoordinate2D(latitude: 35.6811673,
//                                                                   longitude: 139.7648576),
//                                            CLLocationCoordinate2D(latitude: 51.5316396,
//                                                                   longitude: -0.1266171),
//                                            CLLocationCoordinate2D(latitude: 37.7631955,
//                                                                   longitude: -122.4294305)],
//                           expanded: false)]
    
    static func getRegionStringWithKey(_ key: String?) -> String? {
        if key == nil {
            return nil
        }
        
        for region in defaultRegionData {
            for (index, regionkey) in region.cityKeys.enumerated() {
                if key == regionkey {
                    return region.cities[index]
                }
            }
        }
        return nil
    }
    
    static func getKeyWithRegionString(_ region: String?) -> String? {
        if region == nil || region == "" {
            return nil
        }
        
        for regionData in defaultRegionData {
            for (index, regionString) in regionData.cities.enumerated() {
                if region == regionString {
                    return regionData.cityKeys[index]
                }
            }
        }
        return nil
    }
    
    static func getCountryWithRegionString(_ region: String?) -> String? {
        if region == nil || region == "" {
            return nil
        }
        
        for regionData in defaultRegionData {
            for (index, regionString) in regionData.cities.enumerated() {
                if region == regionString {
                    return regionData.countryKeys[index]
                }
            }
        }
        return nil
        
        
    }
    
}
