//
//  KPSearchBar.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchBar: UISearchBar {

    
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!

    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        searchBarStyle = .prominent
        isTranslucent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {

        if let index = indexOfSearchFieldInSubviews() {
            
            let startPoint = CGPoint.init(x: 0.0, y: frame.size.height)
            let endPoint = CGPoint.init(x: frame.size.width, y: frame.size.height)
            let path = UIBezierPath()
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = preferredTextColor.cgColor
            shapeLayer.lineWidth = 1.0
            
            layer.addSublayer(shapeLayer)
            
            let searchField: UITextField = subviews[0].subviews[index] as! UITextField
            searchField.frame = CGRect.init(x:5.0,
                                            y:5.0,
                                            width:frame.size.width - 10.0,
                                            height:frame.size.height - 10.0)
            
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            searchField.backgroundColor = barTintColor
        }
        super.draw(rect)
    }
    
    
    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0]
        
        for i in 0 ..< searchBarView.subviews.count {
            if searchBarView.subviews[i] is UITextField {
                index = i
                break
            }
        }
        return index
    }
    
}
