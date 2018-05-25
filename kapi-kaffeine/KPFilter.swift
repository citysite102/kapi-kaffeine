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

    enum TimeFilter {
        case None
//        case Opening
        case Open(from: String, to: String)
    }
    
    static let sharedFilter = KPFilter()
    
    var sortedby: Sortedby = .distance
    
    var selectedTag: Set<searchTagType> = []
    
    var priceIndex: Int = 2
    
    var currentOpening: Bool = false
    var searchTime: String?
    var timeFilter: TimeFilter = .None
    
    lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    let calendar = Calendar.current
    
    public func currentFilterCafeDatas() -> [KPDataModel] {
        var currentCafeDatas: [KPDataModel] = KPServiceHandler.sharedHandler.currentCafeDatas!
        
        
        
        for tagType in selectedTag {
            switch tagType {
            case .wifi:
                currentCafeDatas = currentCafeDatas.filter { (dataModel) -> Bool in
                    dataModel.wifiAverage != 0
                }
                break
            case .socket:
                currentCafeDatas = currentCafeDatas.filter { (dataModel) -> Bool in
                    dataModel.socket != 5
                }
                break
            case .limitTime:
                currentCafeDatas = currentCafeDatas.filter { (dataModel) -> Bool in
                    dataModel.limitedTime != 2
                }
                break
            case .opening:
                currentCafeDatas = currentCafeDatas.filter { (dataModel) -> Bool in
                    dataModel.businessHour?.isOpening ?? false
                }
                break
            case .standingDesk:
                currentCafeDatas = currentCafeDatas.filter { (dataModel) -> Bool in
                    dataModel.standingDesk != 2
                }
                break
            case .highRate:
                currentCafeDatas = currentCafeDatas.filter { (dataModel) -> Bool in
                    dataModel.averageRate?.doubleValue ?? 0 >= 4
                }
                break
            }
        }
        
        if !selectedTag.contains(.opening) {
            switch timeFilter {
            case .None:
                break
            case .Open(from: let from, to: let to):
                
                guard let fromTime = timeFormatter.date(from: from)?.timeIntervalSince1970,
                    let toTime = timeFormatter.date(from: to)?.timeIntervalSince1970 else {
                        break
                }
                
                currentCafeDatas = currentCafeDatas.filter({ (dataModel) -> Bool in
                    guard let businessTime = dataModel.businessHour?.businessTime else { return false }
                    
                    guard let timeList = businessTime[getWeekdayOf(Date())] else { return false }
                    
                    var minTimeInterval: Double = Double.greatestFiniteMagnitude
                    var maxTimeInterval: Double = 0
                    for timeInfo in timeList {
                        
                        if timeInfo.startTimeInterval < minTimeInterval {
                            minTimeInterval = timeInfo.startTimeInterval
                        }
                        
                        if timeInfo.endTimeInterval > maxTimeInterval {
                            maxTimeInterval = timeInfo.endTimeInterval
                        }
                        
                    }
                    
                    if fromTime > minTimeInterval && toTime < maxTimeInterval {
                        return true
                    }
                    
                    return false
                })
                
                break
            }
        }
        
        
        if priceIndex == 0 {
            currentCafeDatas = currentCafeDatas.filter( { $0.priceAverage?.intValue == 0 } )
        } else if priceIndex == 1 {
            currentCafeDatas = currentCafeDatas.filter( { $0.priceAverage?.intValue == 0 || $0.priceAverage?.intValue == 1 } )
        }
        
        currentCafeDatas.sort { (model1, model2) -> Bool in
            if sortedby == .distance {
                return model1.distanceInMeter ?? Double.greatestFiniteMagnitude < model2.distanceInMeter ?? Double.greatestFiniteMagnitude
            } else {
                return model1.averageRate?.doubleValue ?? 0 > model2.averageRate?.doubleValue ?? 0
            }
        }
        
        return currentCafeDatas
    }
    
    func getWeekdayOf(_ date: Date) -> KPDay {
        let component = calendar.component(Calendar.Component.weekday, from: date)
        switch component {
        case 0:
            return .Sunday
        case 1:
            return .Monday
        case 2:
            return .Tuesday
        case 3:
            return .Wednesday
        case 4:
            return .Thursday
        case 5:
            return .Friday
        case 6:
            return .Saturday
        default:
            return .Monday
        }
    }
    
    
    func restoreDefaultSettings() {
        sortedby = .distance
        
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
