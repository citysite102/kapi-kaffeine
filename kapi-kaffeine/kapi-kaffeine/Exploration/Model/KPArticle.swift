//
//  KPArticle.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 04/03/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper

class KPArticleItem: NSObject, Mappable {
    
    var articleID: String!
    var title: String?
    var peopleRead: Int = 0

    required init?(map: Map) {
        if map.JSON["article_id"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        articleID       <-  map["article_id"]
        title           <-  map["title"]
        peopleRead      <-  map["people_read"]
    }
    
}

class KPArticle: NSObject, Mappable {
    
    var title: KPArticleElement!
    var contents: [KPArticleElement] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title       <-  map["title"]
        contents    <-  map["contents"]
    }

}

class KPArticleElement: NSObject, Mappable {
    
    enum ElementType {
        case Text
        case Image
        case Br
        case Quote
        case Line
        case MultipleStyleText
        case Cafe
        
        case Unknown
    }
    
    
    var type: ElementType = .Unknown
    var fontSize: CGFloat = 16
    var bold: Bool = false
    var value: String = ""
    var underline: Bool = false
    var color: UIColor = UIColor.black
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        value       <-  map["value"]
        bold        <-  map["bold"]
        fontSize    <-  (map["style"], elementStyleTransform)
        type        <-  (map["format"], elementTypeTransform)
    }
    
    
    let elementStyleTransform = TransformOf<CGFloat, String>(fromJSON: { (value: String?) -> CGFloat in
        
        guard let value = value else {
            return 16
        }
        
        switch value {
        case "p":    return 16
        case "h1":   return 32
        case "h2":   return 24
        case "h3":   return 18
        default:     return 16
            
        }
        
    }, toJSON: { (value: CGFloat?) -> String? in
        return "p"
    })
    
    let elementTypeTransform = TransformOf<ElementType, String>(fromJSON: { (value: String?) -> ElementType in
        
        guard let value = value else {
            return .Unknown
        }
        
        switch value {
        case "text":    return .Text
        case "image":   return .Image
        case "br":      return .Br
        case "quote":   return .Quote
        case "line":    return .Line
        case "multiple_style_text": return .MultipleStyleText
        case "cafe":    return .Cafe
        default:        return .Unknown
        
        }
        
    }, toJSON: { (value: ElementType?) -> String? in
        
        guard let type = value else { return nil }
        
        switch type {
        
        case .Text:     return "text"
        case .Image:    return "image"
        case .Br:       return "br"
        case .Quote:    return "quote"
        case .Line:     return "line"
        case .MultipleStyleText:     return "multiple_style_text"
        case .Cafe:     return "cafe"
        case .Unknown:  return nil
            
        }
        
    })
    
}

