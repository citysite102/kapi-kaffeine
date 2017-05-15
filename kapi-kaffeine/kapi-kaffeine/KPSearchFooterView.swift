//
//  KPSearchFooterView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchFooterView: UIView {

    static let KPSearchFooterViewCellReuseIdentifier = "cell";
    
    var collectionView:UICollectionView!;
    var collectionLayout:UICollectionViewFlowLayout!;
    var demoFooterTagContents = ["全部", "西門町", "公館町", "東區", "師大",
                                 "信義區", "內湖", "火星", "北極", "黑洞"];
    
    var hotSpotView: UIView!;
    var hotSpotContainer: UIView!;
    var hotSpotLabel:UILabel!;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        
        //Collection view
        self.collectionLayout = UICollectionViewFlowLayout();
        self.collectionLayout.scrollDirection = .horizontal;
        self.collectionLayout.itemSize = CGSize.init(width: 56, height: 24);
        self.collectionLayout.minimumLineSpacing = 4.0;
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout);
        self.collectionView.backgroundColor = UIColor.clear;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = false;
        self.collectionView.showsVerticalScrollIndicator = false;
        self.collectionView.delaysContentTouches = true;
        self.collectionView.register(KPSearchFooterCell.self,
                                     forCellWithReuseIdentifier: KPSearchFooterView.KPSearchFooterViewCellReuseIdentifier)
        
        self.addSubview(self.collectionView);
        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"]);
        
        self.hotSpotView = UIView();
        self.hotSpotView.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        self.hotSpotView.layer.shadowColor = UIColor.black.cgColor;
        self.hotSpotView.layer.shadowOpacity = 0.2;
        self.hotSpotView.layer.shadowOffset = CGSize.init(width: 1.0, height: 0);
        
        self.addSubview(self.hotSpotView);
        self.hotSpotView.addConstraints(fromStringArray: ["H:|[$self(56)]", "V:|[$self]|"]);
        
        self.hotSpotContainer = UIView();
        self.hotSpotContainer.layer.cornerRadius = 2.0;
        self.hotSpotContainer.layer.masksToBounds = true;
        self.hotSpotContainer.layer.borderWidth = 1.0;
        self.hotSpotContainer.layer.borderColor = KPColorPalette.KPMainColor.mainColor_light?.cgColor;
        self.hotSpotView.addSubview(self.hotSpotContainer);
        self.hotSpotContainer.addConstraintForCenterAligningToSuperview(in: .horizontal);
        self.hotSpotContainer.addConstraintForCenterAligningToSuperview(in: .vertical);
        
        self.hotSpotLabel = UILabel();
        self.hotSpotLabel.font = UIFont.systemFont(ofSize: 12.0);
        self.hotSpotLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        self.hotSpotLabel.text = "熱門";
        self.hotSpotContainer.addSubview(self.hotSpotLabel);
        
        self.hotSpotLabel.addConstraints(fromStringArray: ["H:|-8-[$self]-8-|", "V:|-4-[$self]-4-|"]);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KPSearchFooterView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.demoFooterTagContents.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPSearchFooterView.KPSearchFooterViewCellReuseIdentifier,
                                                      for: indexPath) as! KPSearchFooterCell;
        cell.locationLabel.text = self.demoFooterTagContents[indexPath.row];
        cell.layer.cornerRadius = 2.0;
        cell.layer.masksToBounds = true;
        return cell;
    }
    
}

