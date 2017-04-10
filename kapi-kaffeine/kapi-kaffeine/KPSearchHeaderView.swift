//
//  KPSearchHeaderView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchHeaderView: UIView {

    var searchTagView: KPSearchTagView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = KPColorPalette.KPMainColor.MainColor;
        
        self.searchTagView = KPSearchTagView();
        self.addSubview(self.searchTagView);
        self.searchTagView.addConstraints(fromStringArray: ["V:[$self(40)]|", "H:|[$self]|"]);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
