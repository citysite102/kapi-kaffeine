//
//  KPSearchTagView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchTagView: UIView {
    
    static let KPSearchTagViewCellReuseIdentifier = "cell";

    var collectionView:UICollectionView!;
    var collectionLayout:UICollectionViewFlowLayout!;
    
    var preferenceHintView: UIView!
    var demoHeaderTagContents = ["Wifi穩", "插座多", "公館町", "不限時", "師大",
                                 "信義區", "內湖", "火星", "北極", "黑洞"];
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        
        self.preferenceHintView = UIView();
        self.preferenceHintView.backgroundColor = KPColorPalette.KPMainColor.buttonColor;
        self.preferenceHintView.layer.cornerRadius = 3.0;
        self.addSubview(self.preferenceHintView);
        self.preferenceHintView.addConstraints(fromStringArray: ["V:|-4-[$self]-4-|",
                                                                 "H:|-8-[$self(86)]"]);
        
        //Collection view
        self.collectionLayout = UICollectionViewFlowLayout();
        self.collectionLayout.scrollDirection = .horizontal;
//        self.collectionLayout.itemSize = CGSize.init(width: 72, height: 32);
        self.collectionLayout.minimumLineSpacing = 4.0;
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout);
        self.collectionView.backgroundColor = UIColor.clear;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = false;
        self.collectionView.showsVerticalScrollIndicator = false;
        self.collectionView.delaysContentTouches = true;
        self.collectionView.register(KPSearchTagCell.self,
                                     forCellWithReuseIdentifier: KPSearchTagView.KPSearchTagViewCellReuseIdentifier)
        
        self.addSubview(self.collectionView);
        self.collectionView.addConstraints(fromStringArray: ["H:[$view0]-4-[$self]|", "V:|[$self]|"],
                                           views: [self.preferenceHintView]);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension KPSearchTagView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.demoHeaderTagContents.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPSearchTagView.KPSearchTagViewCellReuseIdentifier,
                                                      for: indexPath) as! KPSearchTagCell;
        cell.tagTitle.text = self.demoHeaderTagContents[indexPath.row];
        cell.tagIcon.image = UIImage.init(named: "icon_close");
        cell.layer.cornerRadius = 2.0;
        cell.layer.masksToBounds = true;
        
        return cell;
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cell = collectionView.cellForItem(at: indexPath) as! KPSearchTagCell;
//        cell.layoutIfNeeded();
//        return CGSize.init(width: cell.frameSize.width, height: 32);
//    }
    
}
