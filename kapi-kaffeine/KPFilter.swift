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
            return $0.averageRate?.doubleValue ?? 0 >= averageRate &&
            $0.rates?.wifiAverage?.doubleValue ?? 0 >= wifiRate &&
            $0.rates?.quietAverage?.doubleValue ?? 0 >= quietRate &&
            $0.rates?.cheapAverage?.doubleValue ?? 0 >= cheapRate &&
            $0.rates?.seatAverage?.doubleValue ?? 0 >= seatRate &&
            $0.rates?.tastyAverage?.doubleValue ?? 0 >= tastyRate &&
            $0.rates?.foodAverage?.doubleValue ?? 0 >= foodRate &&
            $0.rates?.musicAverage?.doubleValue ?? 0 >= musicRate
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
