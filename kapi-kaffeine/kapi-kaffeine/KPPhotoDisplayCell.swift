//
//  KPPhotoDisplayCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol KPPhotoDisplayCellDelegate: NSObjectProtocol {
    func cellPhotoDidMoving(_ location: CGPoint)
    func cellPhotoEndMoving(_ location: CGPoint)
}

class KPPhotoDisplayCell: UICollectionViewCell {
    
    
    weak open var delegate: KPPhotoDisplayCellDelegate?
    
    var shopPhoto: UIImageView!
    var longPressGesture: UILongPressGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    
    var draggable: Bool = false
    var startAnchorPoint: CGPoint!
    var lastMovePoint: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        backgroundColor = UIColor.black;
        
        shopPhoto = UIImageView();
        shopPhoto.layer.cornerRadius = 2.0;
        shopPhoto.layer.masksToBounds = true;
        shopPhoto.contentMode = .scaleAspectFit;
        shopPhoto.isUserInteractionEnabled = true
        addSubview(shopPhoto);
        shopPhoto.addConstraintForCenterAligningToSuperview(in:.vertical)
        shopPhoto.addConstraintForCenterAligningToSuperview(in:.horizontal)
        shopPhoto.addConstraint(from: "H:|[$self]|")
        
        longPressGesture = UILongPressGestureRecognizer(target: self,
                                                        action: #selector(handlePhotoLongPressed(_:)))
        longPressGesture.minimumPressDuration = 0.2
        shopPhoto.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handlePhotoLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            startAnchorPoint = sender.location(in: self)
        case .changed:
            let touchPoint = sender.location(in: self)
            print("Touch Point: \(touchPoint)")
            if lastMovePoint != nil {
                shopPhoto.transform = CGAffineTransform(translationX:touchPoint.x - lastMovePoint!.x,
                                                        y: touchPoint.y - lastMovePoint!.y)
            } else {
                shopPhoto.transform = CGAffineTransform(translationX: touchPoint.x - startAnchorPoint.x,
                                                        y: touchPoint.y - startAnchorPoint.y)
            }
            
        case .ended:
            lastMovePoint = nil
            UIView.animate(withDuration: 0.7,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.8,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: {
                            self.shopPhoto.transform = .identity
            }) { (_) in
                
            }
            
        case .cancelled:
            print("Cancelled")
        default:
            print("Default")
        }
    }
    
}
