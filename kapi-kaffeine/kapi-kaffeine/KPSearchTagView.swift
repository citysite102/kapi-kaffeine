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
    var collectionLayout:UICollectionViewLayout!;
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = KPColorPalette.KPTestHintColor.redHintColor;
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
