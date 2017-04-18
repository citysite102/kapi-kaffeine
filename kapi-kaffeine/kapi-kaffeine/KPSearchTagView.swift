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
    var preferenceHintIcon: UIImageView!
    var preferenceHintLabel: UILabel!
    var demoHeaderTagContents = ["Wifi穩", "插座多插座", "公館町", "時", "師大",
                                 "信義區", "內湖", "火星", "北極", "黑洞"];
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        
        self.preferenceHintView = UIView();
        self.preferenceHintView.backgroundColor = KPColorPalette.KPMainColor.buttonColor;
        self.preferenceHintView.layer.cornerRadius = 3.0;
        self.addSubview(self.preferenceHintView);
        self.preferenceHintView.addConstraints(fromStringArray: ["V:|-4-[$self]-4-|",
                                                                 "H:|-8-[$self(96)]"]);
        
        self.preferenceHintIcon = UIImageView.init(image: UIImage.init(named: "icon_clock")?.withRenderingMode(.alwaysTemplate));
        self.preferenceHintIcon.tintColor = UIColor.white;
        self.preferenceHintView.addSubview(self.preferenceHintIcon);
        self.preferenceHintIcon.addConstraints(fromStringArray: ["H:|-4-[$self]"]);
        self.preferenceHintIcon.addConstraintForCenterAligningToSuperview(in: .vertical);
        
        self.preferenceHintLabel = UILabel();
        self.preferenceHintLabel.font = UIFont.systemFont(ofSize: 13.0);
        self.preferenceHintLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        self.preferenceHintLabel.text = "偏好篩選";
        self.preferenceHintView.addSubview(self.preferenceHintLabel);
        self.preferenceHintLabel.addConstraints(fromStringArray: ["H:[$self]-8-|"],
                                     views: [self.preferenceHintIcon]);
        self.preferenceHintLabel.addConstraintForCenterAligningToSuperview(in: .vertical);
        
        //Collection view
        self.collectionLayout = UICollectionViewFlowLayout();
        self.collectionLayout.scrollDirection = .horizontal;
        self.collectionLayout.minimumLineSpacing = 4.0;
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout);
        self.collectionView.backgroundColor = UIColor.clear;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = false;
        self.collectionView.showsVerticalScrollIndicator = false;
        self.collectionView.delaysContentTouches = true;
        self.collectionView.allowsMultipleSelection = true;
        self.collectionView.register(KPSearchTagCell.self,
                                     forCellWithReuseIdentifier: KPSearchTagView.KPSearchTagViewCellReuseIdentifier)
        
        self.addSubview(self.collectionView);
        self.collectionView.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]|", "V:|[$self]|"],
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
        cell.tagIcon.image = UIImage.init(named: "icon_clock");
        cell.layer.cornerRadius = 2.0;
        cell.layer.masksToBounds = true;
        cell.alpha = cell.isSelected ? 1.0 : 0.4;
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath);
        cell?.alpha = 1.0;
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath);
        cell?.alpha = 0.4;
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentSize = NSString.init(string: self.demoHeaderTagContents[indexPath.row]).boundingRect(with: CGSize.init(width: Double.greatestFiniteMagnitude, height: 32),
                                                                                                        options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)],
                                                                                                        context: nil).size;

        
        return CGSize.init(width: contentSize.width + 42, height: 32);
    }
    
}
