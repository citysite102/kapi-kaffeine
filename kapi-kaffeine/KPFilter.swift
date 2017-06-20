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
