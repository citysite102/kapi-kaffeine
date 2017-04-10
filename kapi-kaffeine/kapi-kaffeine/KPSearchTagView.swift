//
//  KPSearchTagView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchTagView: UIView {

    var collectionView:UICollectionView!;
    var collectionLayout:UICollectionViewFlowLayout!;
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = KPColorPalette.KPTestHintColor.redHintColor;
        
        
        
        //Collection view
//        _collectionLayout = [[TCPromotionCollectionLayout alloc] init];
//        [self.collectionLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//        [self.collectionLayout setItemSize:CGSizeMake(TCPromotionControllerNormalCellWidth,
//            TCPromotionControllerNormalCellHeight)];
//        [self.collectionLayout setSectionInset:UIEdgeInsetsMake(0, [[UIScreen mainScreen] bounds].size.width/2 -
//            TCPromotionControllerNormalCellWidth/2, 0,
//            ([[UIScreen mainScreen] bounds].size.width/2 -
//            TCPromotionControllerNormalCellWidth/2))];
//        [self.collectionLayout setMinimumInteritemSpacing:-20.0f];
//        [self.collectionLayout setMinimumLineSpacing:-20.0f];
//        [self.collectionLayout setDelegate:self];
//        
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionLayout];
//        [self.collectionView setUserInteractionEnabled:YES];
//        [self.collectionView setBackgroundColor:[UIColor clearColor]];
//        [self.collectionView setDataSource:self];
//        [self.collectionView setDelegate:self];
//        [self.collectionView setShowsHorizontalScrollIndicator:NO];
//        [self.collectionView setShowsVerticalScrollIndicator:NO];
//        [self.collectionView setDelaysContentTouches:NO];
        
        
//        self.collectionLayout = UICollectionViewFlowLayout();
//        self.collectionLayout.scrollDirection = .horizontal;
//        
//        self.collectionView = UICollectionView();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
