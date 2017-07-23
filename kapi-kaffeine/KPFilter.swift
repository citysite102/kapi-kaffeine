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
    var searchTags: [searchTagType] = []
    
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
        
        for searchTag in searchTags {
            switch searchTag {
            case .standDesk:
                currentCafeDatas = currentCafeDatas.filter {
                    return $0.standingDesk?.intValue ?? 0 >= 3
                }
            case .socket:
                currentCafeDatas = currentCafeDatas.filter {
                    return $0.socket?.intValue ?? 0 >= 3
                }
            case .limitTime:
                currentCafeDatas = currentCafeDatas.filter {
                    return $0.limitedTime?.intValue ?? 0 >= 3
                }
            case .opening:
                currentCafeDatas = currentCafeDatas.filter {
                    return ($0.businessHour?.shopStatus.isOpening ?? false) == true
                }
            case .highRate:
                currentCafeDatas = currentCafeDatas.filter {
                    return $0.averageRate?.doubleValue ?? 0.0 > 4.0
                }
            }
        }
        
//        if let searchStart = startSearchTime, let searchEnd = endSearchTime {
//            let todayDate = Date()
//            if let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) {
//                let day = KPDataBusinessHourModel.getDayOfWeek()
////                let currentHour = calendar.component(.hour, from: todayDate)
////                let currentMinute = calendar.component(.minute, from: todayDate)
////                let currentTime = timeFormatter.date(from: String(format: "%2d:%2d", currentHour, currentMinute))
//                currentCafeDatas = currentCafeDatas.filter({ (dataModel) -> Bool in
//                    
////                    if let openTime = dataModel.businessHour?.businessTime[]
//                    
//                    if currentTime!.timeIntervalSince1970 > (timeFormatter.date(from: open)?.timeIntervalSince1970)! &&
//                        currentTime!.timeIntervalSince1970 < (timeFormatter.date(from: close)?.timeIntervalSince1970)! {
//                        return true
//                    }
//                    return false
//                })
//            }
//        }
        
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
