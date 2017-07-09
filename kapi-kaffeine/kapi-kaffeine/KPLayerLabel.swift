//
//  KPLayerLabel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/29.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPLayerLabel: UILabel {

    
    override var text: String? {
        didSet {
            super.text = text
            self.textLayer().string = text
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            super.textColor = textColor
            self.textLayer().foregroundColor = textColor.cgColor
        }
    }
    
    
    override var font: UIFont! {
        didSet {
            super.font = font
            let fontName = font?.fontName
            let fontRef = CGFont(fontName! as CFString)
            self.textLayer().font = fontRef
            self.textLayer().fontSize = (font?.pointSize)!
        }
    }
    
    override class var layerClass: AnyClass {
        return CATextLayer.self
    }
    
    func textLayer() -> CATextLayer {
        return layer as! CATextLayer
    }
    
    func setUp() {
        textLayer().alignmentMode = kCAAlignmentLeft
        textLayer().truncationMode = kCATruncationEnd
        textLayer().isWrapped = true
        textLayer().display()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 0, 0, 0)));
    }
    
    
    
}
