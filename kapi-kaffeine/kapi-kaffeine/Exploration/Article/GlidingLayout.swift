//
// GlidingCollection.swift
// GlidingCollection
//
// Created by Abdurahim Jauzee on 06/03/2017.
// Copyright (c) 2017 Ramotion Inc. All rights reserved.
//


import UIKit

/// :nodoc:
protocol GlidingLayoutDelegate {
  func collectionViewDidScroll()
}

final class GlidingLayout: UICollectionViewFlowLayout {
  
  var delegate: GlidingLayoutDelegate?
  
    
//    override func targetContentOffset(forProposedContentOffset
//        proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        
//        
//        if (proposedContentOffset.x < CGFloat((4-2)*255) + 100) {
//            let currentOffset = proposedContentOffset.x
//            var index = floor(currentOffset/255)
//            if currentOffset - 180 > 255*index || currentOffset + 75 > 255 * (index+1) {
//                index = index+1
//            }
//            
//            print("Velocity:\(velocity.x)")
//            print("Pointee:\(proposedContentOffset.x)")
//            if velocity.x == 0 {
////                targetContentOffset.pointee.x = index*255
//                return CGPoint(x: index*255,
//                               y: 0)
//            } else {
//                self .setContentOffset(CGPoint(x: index*255, y: 0),
//                                            animated: true)
//                targetContentOffset.pointee.x = index*255
//            }
//        } else {
//            return proposedContentOffset
//        }
//        
//    }
    
//  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//
//    guard let collectionView = self.collectionView else {
//      return proposedContentOffset
//    }
//
//    let pageWidth = itemSize.width + minimumLineSpacing
//
//    let rawPageValue = collectionView.contentOffset.x / pageWidth
//    let currentPage = velocity.x > 0 ? floor(rawPageValue) : ceil(rawPageValue)
//    let nextPage = velocity.x > 0 ? ceil(rawPageValue) : floor(rawPageValue)
//    let pannedLessThanPage = abs(1 + currentPage - rawPageValue) > 0.3
//    let flicked = abs(velocity.x) > 0.3
//
//    var offset = proposedContentOffset
//    if pannedLessThanPage && flicked {
//      offset.x = nextPage * pageWidth
//    } else {
//      offset.x = round(rawPageValue) * pageWidth
//    }
//
//    return offset
//  }
 
//  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//    delegate?.collectionViewDidScroll()
//    return true
//  }
//
//  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//    guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
//    let transformed = attributes.map { transformLayoutAttributes($0) }
//    return transformed
//  }
//  
//  private func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//    
//    guard let collectionView = self.collectionView else { return attributes }
//    
//    let startOffset = (attributes.frame.origin.x - collectionView.contentOffset.x - sectionInset.left) / attributes.frame.width
//    let maxScale: CGFloat = 1.03
//    let minScale: CGFloat = 1.0
//    let minLeftOffset: CGFloat = 0
//    let maxLeftOffset: CGFloat = 20
//    
//    let divided = abs(startOffset) / 10
////    let scale = max(minScale, min(maxScale, 1.0 + divided))
//    let scale = max(minScale, maxScale - divided)
//    let offset = max(minLeftOffset, maxLeftOffset*startOffset)
//    
//    if let contentView = collectionView.cellForItem(at: attributes.indexPath)?.contentView, let parallaxView = contentView.viewWithTag(99) {
//        var transform = CGAffineTransform.identity
//        transform = transform.scaledBy(x: scale, y: scale)
//        transform = transform.translatedBy(x: offset,
//                                           y: 0)
//        parallaxView.transform = transform
//        
//    }
//  
//    return attributes
//  }
  
}
