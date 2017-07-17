//
//  KPHelper.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import BenzeneFoundation
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

    public class func kpImageWithColor(color: UIColor, size: CGSize) -> UIImage? {
    
        UIGraphicsBeginImageContextWithOptions(size,
                                               false,
                                               UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext()
        if context == nil {
            return nil;
        }
        color.set()
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image;
    }
    
    public class func verticalImage(imagesArray: NSArray) -> UIImage {
        let unifiedImage: UIImage
        let totalImageSize = self.verticalAppendedTotalImageSize(imagesArray: imagesArray)
        UIGraphicsBeginImageContextWithOptions(totalImageSize, false, UIScreen.main.scale);
        
        var imageOffsetFactor: CGFloat = 0.0;
        
        for case let img as UIImage in imagesArray {
            img.draw(at: CGPoint(x: 0, y: imageOffsetFactor))
            imageOffsetFactor += img.size.height
        }
        
        unifiedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return unifiedImage;
    }
    
    private class func verticalAppendedTotalImageSize(imagesArray: NSArray) -> CGSize {
        var totalSize = CGSize.zero
        for case let img as UIImage in imagesArray {
            let imSize = img.size
            totalSize.height += imSize.height
            totalSize.width = max(totalSize.width, imSize.width)
        }
        return totalSize;
    }
}

public extension UIView {
    
    public func screenshot() -> UIImage? {
        return self.screenshot(croppingRect: self.bounds)
    }
    
    public func screenshot(croppingRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(croppingRect.size,
                                               false,
                                               UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext();
        if context == nil {
            return nil
        }
        
        context!.translateBy(x: -croppingRect.origin.x,
                             y: -croppingRect.origin.y)
        self.layoutIfNeeded()
        self.layer.render(in: context!)
        
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage!
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
                                       range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}

public extension UIApplication {
    
    public func KPTopViewController() -> UIViewController! {
        return self.KPTopViewControllerFromController(currentViewController: UIApplication.shared.rootViewController)
    }
    
    public func KPTopViewControllerFromController(currentViewController: UIViewController) -> UIViewController! {
        if currentViewController.presentedViewController == nil {
            return currentViewController
        } else if currentViewController is UINavigationController {
            if (currentViewController as! UINavigationController).topViewController?.presentedViewController != nil {
                return self.KPTopViewControllerFromController(currentViewController:(currentViewController as! UINavigationController).topViewController!)
            } else {
                return (currentViewController as! UINavigationController).topViewController
            }
        } else {
            return self.KPTopViewControllerFromController(currentViewController:currentViewController.presentedViewController!)
        }
    }
}

public extension UITableView {
    
    public override func screenshot() -> UIImage {
        
        let screenshots = NSMutableArray()
        
        for _ in 0..<self.numberOfSections {
            
            // 只畫出顯示出來的 Cell 整體的狀況
            for indexPath in self.indexPathsForVisibleRows! {
                if let cellScreenshot = self.screenshotOfCell(indexPath as NSIndexPath)  {
                    screenshots.add(cellScreenshot)
                }
            }
            
            // 想要畫出整個 Table View 的狀況
//            for row in 0..<self.numberOfRows(inSection: section) {
//                let cellIndexPath = NSIndexPath(row: row,
//                                                section: section)
//                if let cellScreenshot = self.screenShotOfCell(cellIndexPath)  {
//                    screenshots.add(cellScreenshot)
//                }
//            }
        }
        return UIImage.verticalImage(imagesArray: screenshots)
    }
    
    public func screenshotOfCell(_ indexPath: NSIndexPath) -> UIImage? {
        var cellScreenshot: UIImage
        
        let currTableViewOffset = self.contentOffset
        
        self.scrollToRow(at: indexPath as IndexPath,
                         at: .top,
                         animated: false)
        
        cellScreenshot = (self.cellForRow(at: indexPath as IndexPath)?.screenshot())!
        
        self.setContentOffset(currTableViewOffset, animated: false)
        return cellScreenshot
    }
    
    public func screenshotForVisible() -> UIImage? {
        let visibleRect = CGRect(x: 0, y: self.contentOffset.y,
                                 width: self.bounds.width,
                                 height: self.bounds.height)
        return self.screenshot(croppingRect: visibleRect)
    }
}


// MARK: Drawing

// 繪製圓角
func drawImage(image originImage: UIImage,
               rectSize: CGSize,
               roundedRadius radius: CGFloat) -> UIImage? {
    
    let rect = CGRect(x: 0, y: 0, width: rectSize.width, height: rectSize.height)
    let ratio = max(originImage.size.width/rectSize.width, originImage.size.height/rectSize.height)
    
    UIGraphicsBeginImageContextWithOptions(rect.size,
                                           false,
                                           0)
    
    let currentContext = UIGraphicsGetCurrentContext()
    
    var cropImage: UIImage
    if originImage.size.width > originImage.size.height {
        let imageRef = originImage.cgImage!.cropping(to: CGRect(x: (originImage.size.width-(rect.width)*ratio)/2,
                                                                y: 0,
                                                                width: rect.width*ratio,
                                                                height: rect.height*ratio))
        cropImage = UIImage(cgImage: imageRef!)
    } else if originImage.size.width < originImage.size.height {
        let imageRef = originImage.cgImage!.cropping(to: CGRect(x: 0,
                                                                y: (originImage.size.height-(rect.height)*ratio)/2,
                                                                width: rect.width*ratio,
                                                                height: rect.height*ratio))
        cropImage = UIImage(cgImage: imageRef!)
    } else {
        cropImage = originImage
    }
    
    currentContext?.addPath(UIBezierPath(roundedRect: rect,
                                         cornerRadius: radius).cgPath)
        
    currentContext?.clip()
    cropImage.draw(in: rect)
    currentContext?.drawPath(using: .fillStroke)
    
    let rounderCornerImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return rounderCornerImage
}


