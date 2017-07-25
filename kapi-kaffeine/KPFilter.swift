//
//  KPFilter.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/20.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import BenzeneFoundation

class KPFilter {

    static let sharedFilter = KPFilter()
    
    var city: String?
    
    var wifiRate: Double = 0
    var quietRate: Double = 0
    var cheapRate: Double = 0
    var seatRate: Double = 0
    var tastyRate: Double = 0
    var foodRate: Double = 0
    var musicRate: Double = 0
    
    var averageRate: Double = 0
    
    var limited_time: Int?
    var socket: Int?
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
            currentCafeDatas = KPFilter.filterData(source: KPServiceHandler.sharedHandler.currentCafeDatas, withCity: city!)
        } else {
            currentCafeDatas = KPServiceHandler.sharedHandler.currentCafeDatas
        }
        
        if standingDesk == true {
            currentCafeDatas = currentCafeDatas.filter({
                return $0.standingDesk?.intValue ?? 0 == 1
            })
        }
        
        if let limited_time = limited_time {
            currentCafeDatas = currentCafeDatas.filter({
                return $0.limitedTime?.intValue ?? 10 <= limited_time
            })
        }
        
        if let socket = socket {
            currentCafeDatas = currentCafeDatas.filter({
                return $0.socket?.intValue ?? 10 <= socket
            })
        }
        
        currentCafeDatas = currentCafeDatas.filter({
            return $0.averageRate?.doubleValue ?? 5 >= averageRate &&
            $0.wifiAverage?.doubleValue ?? 5 >= wifiRate &&
            $0.quietAverage?.doubleValue ?? 5 >= quietRate &&
            $0.cheapAverage?.doubleValue ?? 5 >= cheapRate &&
            $0.seatAverage?.doubleValue ?? 5 >= seatRate &&
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
        
        return currentCafeDatas
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
