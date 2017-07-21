//
//  KPHelper+Foundation.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation


extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
    
    var cgFloatValue: CGFloat {
        return NSDecimalNumber(decimal:self).cgFloatValue
    }
}
