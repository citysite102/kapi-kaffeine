//
//  KPDataBusinessHourModel.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 19/06/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import Foundation


enum KPDay: String {
    case Monday    = "mon"
    case Tuesday   = "tue"
    case Wednesday = "wed"
    case Thursday  = "thu"
    case Friday    = "fri"
    case Saturday  = "sat"
    case Sunday    = "sun"
}

class KPDataBusinessHourModel: NSObject {
    
    var businessTime: [KPDay: [(startHour: String, endHour: String)]] = [KPDay.Monday: [],
                                                                         KPDay.Tuesday: [],
                                                                         KPDay.Wednesday: [],
                                                                         KPDay.Thursday: [],
                                                                         KPDay.Friday: [],
                                                                         KPDay.Saturday: [],
                                                                         KPDay.Sunday: []]
    lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    convenience init(value: [String: String]) {
        self.init()
        
        for (key, time) in value {
            let components = key.components(separatedBy: "_")
            let day = KPDay(rawValue: components.first!)!
            let timeIndex = Int(components[1])!
            
            while businessTime[day]!.count < timeIndex {
                businessTime[day]!.append(("", ""))
            }
            
            if components[2] == "open" {
                businessTime[day]?[timeIndex-1].startHour = time
            } else if components[2] == "close" {
                businessTime[day]?[timeIndex-1].endHour = time
            }
            
        }
    }
    
    var shopStatus: (isOpening: Bool, status: String)  {
        get {
            let todayDate = Date()
            if let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) {
                let currentHour = calendar.component(.hour, from: todayDate)
                let currentMinute = calendar.component(.minute, from: todayDate)
                let currentTime = timeFormatter.date(from: String(format: "%2d:%2d", currentHour, currentMinute))
                
                for (startHour, endHour) in businessTime[getDayOfWeek()]! {
                    if currentTime!.timeIntervalSince1970 > (timeFormatter.date(from: startHour)?.timeIntervalSince1970)! &&
                        currentTime!.timeIntervalSince1970 < (timeFormatter.date(from: endHour)?.timeIntervalSince1970)! {
                        return (true, "營業中: \(startHour)~\(endHour)")
                    }
                }
                return (false, "休息中")
            } else {
                // Calendar create failed
                // ???????
                return (false, "")
            }
        }
    }
    
    func getDayOfWeek() -> KPDay {
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let myComponents = myCalendar?.component(.weekday, from: todayDate as Date)
        if myComponents == 1 {
            return KPDay.Sunday
        } else if myComponents == 2 {
            return KPDay.Monday
        } else if myComponents == 3 {
            return KPDay.Tuesday
        } else if myComponents == 4 {
            return KPDay.Wednesday
        } else if myComponents == 5 {
            return KPDay.Thursday
        } else if myComponents == 6 {
            return KPDay.Friday
        } else if myComponents == 7 {
            return KPDay.Saturday
        } else {
            fatalError()
        }
    }
    
    override var description: String {
        var result = ""
        for (key, value) in businessTime {
            result += "\(key.rawValue): "
            for (start, end) in value {
                result += "\(start)~\(end)\t"
            }
            result += "\n"
        }
        return result
    }
    
    func getTimeString(withDay day: String) -> String {
        var timeArray: [(startHour: String, endHour: String)]
        switch day {
        case "星期一":
            timeArray = businessTime[KPDay.Monday]!
            break
        case "星期二":
            timeArray = businessTime[KPDay.Tuesday]!
            break
        case "星期三":
            timeArray = businessTime[KPDay.Wednesday]!
            break
        case "星期四":
            timeArray = businessTime[KPDay.Thursday]!
            break
        case "星期五":
            timeArray = businessTime[KPDay.Friday]!
            break
        case "星期六":
            timeArray = businessTime[KPDay.Saturday]!
            break
        case "星期日":
            timeArray = businessTime[KPDay.Sunday]!
            break
        default:
            fatalError()
            break
        }
        
        var result = ""
        for (start, end) in timeArray {
            result += "\(start)~\(end)\t"
        }
        return result == "" ? "休息" : result
    }
    
}
