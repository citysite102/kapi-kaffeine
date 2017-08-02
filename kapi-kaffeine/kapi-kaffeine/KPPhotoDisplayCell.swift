//
//  KPPhotoDisplayCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol KPPhotoDisplayCellDelegate: NSObjectProtocol {
    func scrollShouldLocked(_ cell: KPPhotoDisplayCell)
    func scrollShouldEnabled(_ cell: KPPhotoDisplayCell)
}

class KPPhotoDisplayCell: UICollectionViewCell {
    
    
    weak open var delegate: KPPhotoDisplayCellDelegate?
    var scrollContainer: UIScrollView!
    var shopPhoto: UIImageView!
    
    var longPressGesture: UILongPressGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    
    var draggable: Bool = false
    var startAnchorPoint: CGPoint!
    var lastMovePoint: CGPoint?
    var minScale: CGFloat!
    var originalHeight: CGFloat!
    var oldOffsetY: CGFloat!
    var heightConstraint: NSLayoutConstraint!
    
    
    var imageViewBottomConstraint: NSLayoutConstraint!
    var imageViewLeadingConstraint: NSLayoutConstraint!
    var imageViewTopConstraint: NSLayoutConstraint!
    var imageViewTrailingConstraint: NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        scrollContainer = UIScrollView()
        scrollContainer.minimumZoomScale = 1.0
        scrollContainer.maximumZoomScale = 3.0
        scrollContainer.delegate = self
        scrollContainer.alwaysBounceVertical = false
        scrollContainer.alwaysBounceHorizontal = false
        scrollContainer.decelerationRate = UIScrollViewDecelerationRateFast
        addSubview(scrollContainer)
//        scrollContainer.addConstraintForCenterAligningToSuperview(in:.vertical)
//        scrollContainer.addConstraintForCenterAligningToSuperview(in:.horizontal)
        scrollContainer.addConstraint(from: "H:|[$self]|")
        scrollContainer.addConstraint(from: "V:|[$self]|")
        
        shopPhoto = UIImageView()
        shopPhoto.layer.cornerRadius = 2.0
        shopPhoto.layer.masksToBounds = true
        shopPhoto.clipsToBounds = true
        shopPhoto.contentMode = .scaleAspectFit
        shopPhoto.isUserInteractionEnabled = true
        scrollContainer.addSubview(shopPhoto)
//        shopPhoto.addConstraintForCenterAligningToSuperview(in:.vertical)
//        shopPhoto.addConstraintForCenterAligningToSuperview(in:.horizontal)
        
        imageViewTopConstraint = shopPhoto.addConstraint(from: "V:|[$self]").first as! NSLayoutConstraint
        imageViewBottomConstraint = shopPhoto.addConstraint(from: "V:[$self]|").first as! NSLayoutConstraint
        imageViewLeadingConstraint = shopPhoto.addConstraint(from: "H:|[$self]").first as! NSLayoutConstraint
        imageViewTrailingConstraint = shopPhoto.addConstraint(from: "H:[$self]|").first as! NSLayoutConstraint
//        shopPhoto.addConstraint(from: "H:|[$self]|")
//        shopPhoto.addConstraint(from: "V:|[$self]|")
        
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomImage(_:)))
//        shopPhoto.addGestureRecognizer(pinchGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func zoomImage(_ sender: UIPinchGestureRecognizer) {
//        switch sender.state {
//        case .ended,
//             .changed:
//            let currentScale = frame.size.width/bounds.size.width
//            var newScale = currentScale*sender.scale
//            if newScale < 1 {
//                newScale = 1
//            }
//            if newScale > 3 {
//                newScale = 3
//            }
//            shopPhoto.transform = CGAffineTransform(scaleX: newScale, y: newScale)
//            scrollContainer.contentSize = CGSize(width: shopPhoto.frameSize.width*photoRatio,
//                                                 height: shopPhoto.frameSize.height*photoRatio)
//        default:
//            break
//        }
//    }
    
    override func layoutSubviews() {
//        photoRatio = UIScreen.main.bounds.size.width/(shopPhoto.image?.size.width)!
        updateMinZoomScaleForSize(self.bounds.size)
//        originalHeight = (shopPhoto.image?.size.height)!*photoRatio
//        
//        if heightConstraint == nil {
//            heightConstraint = shopPhoto.addConstraint(forHeight: (shopPhoto.image?.size.height)!*photoRatio)
//            shopPhoto.addConstraint(forWidth: UIScreen.main.bounds.size.width)
//        } else {
//            heightConstraint.constant = originalHeight*scrollContainer.zoomScale
//        }
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        
        print("----------\(shopPhoto.bounds)")
//        let widthScale = size.width / shopPhoto.bounds.width
//        let heightScale = size.height / shopPhoto.bounds.height
//        minScale = min(widthScale, heightScale)

        let widthRatio =  size.width/(shopPhoto.image?.size.width)!
        let heightRatio = size.height/(shopPhoto.image?.size.height)!
        minScale = min(widthRatio, heightRatio)
        
//        scrollContainer.minimumZoomScale = minScale
//        scrollContainer.zoomScale = minScale
    }
    
}

extension KPPhotoDisplayCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return shopPhoto
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("Zoom Scale:\(scrollView.zoomScale)")
        if scrollView.zoomScale > 1 {
            updateConstraintsForSize(self.bounds.size)
        }
    }

    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        
        if shopPhoto.frameSize.height == 0 {
            layoutIfNeeded()
        }
        
        
//        let yOffset = max(0, (size.height - shopPhoto.frame.height) / 2)
        let yOffset = max(0, (size.height - (shopPhoto.image?.size.height)!*minScale) / 4)
        print("YOffset:\(yOffset) Height:\(shopPhoto.frame.height) Scale:\(minScale)")
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - shopPhoto.frame.width) / 2)
        print("XOffset:\(xOffset) Width:\(shopPhoto.frame.width)")
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        layoutIfNeeded()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("End zooming at scale:\(scale)")
        if scale <= 1.1 {
            scrollContainer.setZoomScale(1.0, animated: true)
            delegate?.scrollShouldEnabled(self)
        } else {
            delegate?.scrollShouldLocked(self)
//            scrollView.setContentOffset(CGPoint(x: (self.shopPhoto.frameSize.width-self.frameSize.width)/2,
//                                                y: (self.shopPhoto.frameSize.height-self.frameSize.height)/2),
//                                        animated: true)
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("contentOffsetX:\(scrollView.contentOffset.x) Y:\(scrollView.contentOffset.y)")
//        print("Offset Value:\((self.shopPhoto.frameSize.width-self.frameSize.width)/2)")
//        if !scrollView.isZooming && (shopPhoto.image?.size.height)!*photoRatio < UIScreen.main.bounds.size.height {
//            
//        }
//    }
}
