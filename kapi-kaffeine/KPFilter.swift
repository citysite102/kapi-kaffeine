//
//  KPFilter.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/20.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import BenzeneFoundation

enum Sortedby {
    case distance
    case rates
}

class KPFilter {

    static let sharedFilter = KPFilter()
    
    
    var sortedby: Sortedby! = .distance
    
    var city: String?
    
    var wifiRate: Double = 0
    var quietRate: Double = 0
    var cheapRate: Double = 0
    var seatRate: Double = 0
    var tastyRate: Double = 0
    var foodRate: Double = 0
    var musicRate: Double = 0
    
    var averageRate: Double = 0
    
    var limited_time: Int = 4
    var socket: Int = 4
    var standingDesk: Bool = false
    
    var currentOpening: Bool = false
    var searchTime: String?
    
    lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    public func currentFilterCafeDatas() -> [KPDataModel] {
        var currentCafeDatas: [KPDataModel]!
        if city != nil {
            currentCafeDatas = KPFilter.filterData(source: KPServiceHandler.sharedHandler.currentCafeDatas!, withCity: city!)
        } else {
            currentCafeDatas = KPServiceHandler.sharedHandler.currentCafeDatas
        }
        
        if standingDesk == true {
            currentCafeDatas = currentCafeDatas.filter({
                return $0.standingDesk?.intValue ?? 0 == 1
            })
        }
        
        if limited_time != 4 {
            currentCafeDatas = currentCafeDatas.filter({
                
                if limited_time == 3 {
                    return $0.limitedTime?.intValue == 1 || $0.limitedTime?.intValue == 3
                }
                
                if limited_time == 1 {
                    return $0.limitedTime?.intValue == 1
                }
                
                return true
            })
        }
        
        if socket != 4 {
            currentCafeDatas = currentCafeDatas.filter({
                
                if socket == 3 || socket == 2 {
                    return $0.socket?.intValue == 3 || $0.socket?.intValue == 2 || $0.socket?.intValue == 1
                }
                
                if socket == 1 {
                    return $0.socket?.intValue == 1
                }
                
                return true
            })
        }
        
        currentCafeDatas = currentCafeDatas.filter({
            return $0.averageRate?.doubleValue ?? 5 >= averageRate &&
            $0.wifiAverage?.doubleValue ?? 5 >= wifiRate &&
            $0.quietAverage?.doubleValue ?? 5 >= quietRate &&
            $0.cheapAverage?.doubleValue ?? 5 >= cheapRate
        })
        
        currentCafeDatas = currentCafeDatas.filter({
            return $0.seatAverage?.doubleValue ?? 5 >= seatRate &&
                   $0.tastyAverage?.doubleValue ?? 5 >= tastyRate &&
                   $0.foodAverage?.doubleValue ?? 5 >= foodRate &&
                   $0.musicAverage?.doubleValue ?? 5 >= musicRate
        })
        
        
        if currentOpening == true {
            currentCafeDatas = currentCafeDatas.filter({
                return $0.businessHour?.isOpening ?? false
            })
        } else if let searchTime = searchTime {
            let components = searchTime.components(separatedBy: "~")
            if components.count == 2,
                let startSearchTime = timeFormatter.date(from: components.first!)?.timeIntervalSince1970,
                let endSearchTime = timeFormatter.date(from: components.last!)?.timeIntervalSince1970 {
                
                currentCafeDatas = currentCafeDatas.filter({
                    if let businessHours = $0.businessHour?.businessTime[KPDataBusinessHourModel.getDayOfWeek()] {
                        for businessHour in businessHours {
                            if startSearchTime > businessHour.startTimeInterval &&
                                endSearchTime < businessHour.endTimeInterval {
                                return true
                            }
                        }
                    }
                    return false
                })
            }
        }
        
        if sortedby == .distance {
            currentCafeDatas.sort { (data1, data2) -> Bool in
                data1.distanceInMeter ?? Double.greatestFiniteMagnitude < data2.distanceInMeter ?? Double.greatestFiniteMagnitude
            }
        } else if sortedby == .rates {
            currentCafeDatas.sort { (data1, data2) -> Bool in
                if data1.averageRate?.doubleValue ?? 0 > data2.averageRate?.doubleValue ?? 0 {
                    return true
                } else if data1.averageRate?.doubleValue ?? 0 < data2.averageRate?.doubleValue ?? 0 {
                    return false
                } else {
                    return data1.distanceInMeter ?? Double.greatestFiniteMagnitude < data2.distanceInMeter ?? Double.greatestFiniteMagnitude
                }
                
            }
        }
        
        
        
        return currentCafeDatas
    }
    
    
    func restoreDefaultSettings() {
        sortedby = .distance
        
        wifiRate = 0
        quietRate = 0
        cheapRate = 0
        seatRate = 0
        tastyRate = 0
        foodRate = 0
        musicRate = 0
        
        averageRate = 0
        
        limited_time = 4
        socket = 4
        standingDesk = false
        
        currentOpening = false
        searchTime = nil
    }
    
    
    public class func filterData(source: [KPDataModel], withMRT
                                 mrt: String) -> [KPDataModel] {
        
        let filterContent = source.filter {
            return $0.mrt == mrt
        }
        return filterContent
    }
    
    public class func filterData(source: [KPDataModel], withCity
                                 city: String) -> [KPDataModel] {
        
        let filterContent = source.filter {
            return $0.city == city
        }
        return filterContent
    }
    
}
