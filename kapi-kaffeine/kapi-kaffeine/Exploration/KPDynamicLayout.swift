//
//  KPDynamicLayout.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/2/3.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPDynamicLayout: UICollectionViewFlowLayout {
    
    var animator: UIDynamicAnimator?
    
    override init() {
        super.init()
        animator = UIDynamicAnimator(collectionViewLayout: self)
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 12
        self.minimumInteritemSpacing = 12
        self.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20)
        self.itemSize = CGSize(width: 130, height: 168)
    }
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        return animator?.items(in: rect) as? [UICollectionViewLayoutAttributes]
//    }
//    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return animator?.layoutAttributesForCell(at:indexPath)
//    }
//    
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        let scrollView = collectionView
//        let delta = newBounds.origin.x - (scrollView?.bounds.origin.x)!
//        let touchLocation = collectionView?.panGestureRecognizer.location(in: collectionView)
//
//        for behavior in (animator?.behaviors)! {
//            if let attBehavior = behavior as? UIAttachmentBehavior {
//                let yDistanceFromTouch = fabsf(Float(touchLocation!.y - attBehavior.anchorPoint.y));
//                let xDistanceFromTouch = fabsf(Float(touchLocation!.x - attBehavior.anchorPoint.x));
//                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 2000.0;
//
//                let item = attBehavior.items.first
//                var center = item?.center
//                if delta < 0 {
//                    center?.x += max(delta,
//                                    delta*CGFloat(scrollResistance))
//                } else {
//                    center?.x += min(delta, delta*CGFloat(scrollResistance))
//                }
//                item?.center = center!
//                animator?.updateItem(usingCurrentState: item!)
//            }
//        }
//        return false
//    }
//    
//    override func prepare() {
//        super.prepare()
//        let contentSize = collectionView?.contentSize
//        let items = super.layoutAttributesForElements(in: CGRect(x: 0, y: 0,
//                                                                 width: (contentSize?.width)!,
//                                                                 height: (contentSize?.height)!))
//        
//        if self.animator?.behaviors.count == 0 {
//            for (_, item) in (items?.enumerated())! {
//                let behavior = UIAttachmentBehavior(item: item,
//                                                    attachedToAnchor: item.center)
//                behavior.length = 0.0
//                behavior.damping = 0.8
//                behavior.frequency = 0.8
//                self.animator?.addBehavior(behavior)
//            }
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
