//
//  KPMainListCellFeatureView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/11.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPMainListCellFeatureContainer: UIView {

    var container:UIView!;
    var tagViews:[UIView] = [];
    
    var featureContents:Array<String>! {
        didSet {
            
            for subView in self.container.subviews as [UIView] {
                subView.removeAllRelatedConstraintsInSuperView();
                subView.removeFromSuperview();
            }
            
            for (index, content) in featureContents.enumerated() {
                
                let addedTagView = UIView();
                let addedTagLabel = UILabel();
                
                self.container.addSubview(addedTagView);
                
                addedTagView.layer.cornerRadius = 10.0;
                addedTagView.layer.borderWidth = 1.0;
                addedTagView.layer.borderColor = KPColorPalette.KPMainColor.mainColor?.cgColor;
                
                if index == 0 {
                    addedTagView.addConstraints(fromStringArray:
                        ["V:|[$self(20)]|", "H:|[$self]"]);
                } else if index == featureContents.count-1 {
                    addedTagView.addConstraints(fromStringArray:
                        ["V:|[$self(20)]|", "H:[$view0]-4-[$self]|"],
                                                  views: [self.tagViews[index-1]]);
                } else {
                    addedTagView.addConstraints(fromStringArray:
                        ["V:|[$self(20)]|", "H:[$view0]-4-[$self]"],
                                                views: [self.tagViews[index-1]]);
                }
                
                addedTagLabel.font = UIFont.systemFont(ofSize: 10.0);
                addedTagLabel.textColor = KPColorPalette.KPMainColor.mainColor;
                addedTagLabel.text = content;
                addedTagView.addSubview(addedTagLabel);
                addedTagLabel.addConstraintForCenterAligningToSuperview(in: .vertical);
                addedTagLabel.addConstraints(fromStringArray:
                    ["H:|-4-[$self]-4-|"]);
                
                self.tagViews.append(addedTagView);
            }
        }
    };
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.container = UIView();
        self.addSubview(self.container);
        self.container.addConstraints(fromStringArray: ["V:|[$self]|",
                                                        "H:|[$self]|"]);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}