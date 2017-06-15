//
//  KPHelper.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    public convenience init?(color: UIColor,
                             size: CGSize = CGSize(width: 1, height: 1)) {
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

}


public extension UILabel {
    public func setText(text: String,
                        lineSpacing: CGFloat = 1.0) {
        if lineSpacing < 0.01 || text.characters.count == 0 {
            self.text = text
            return
        }
        
        let descriptionStyle = NSMutableParagraphStyle()
        
        descriptionStyle.lineBreakMode = self.lineBreakMode
        descriptionStyle.alignment = self.textAlignment
        descriptionStyle.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([NSParagraphStyleAttributeName: descriptionStyle],
                                       range: NSRange.init(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}
