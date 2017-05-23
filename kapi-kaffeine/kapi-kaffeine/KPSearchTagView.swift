//
//  KPSearchTagView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchTagView: UIView {
    
    static let KPSearchTagViewCellReuseIdentifier = "cell"

    var collectionView:UICollectionView!
    var collectionLayout:UICollectionViewFlowLayout!
    
    var preferenceHintView: UIView!
    var preferenceHintIcon: UIImageView!
    var preferenceHintLabel: UILabel!
    var headerTagContents = ["Wifi穩", "插座多", "不限時", "營業中", "評分高"]
    var headerTagImages = [R.image.icon_wifi(), R.image.icon_socket(),
                           R.image.icon_clock(), R.image.icon_door(),
                           R.image.icon_star()]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = KPColorPalette.KPMainColor.mainColor_light
        
        self.preferenceHintView = UIView()
        self.preferenceHintView.backgroundColor = KPColorPalette.KPMainColor.mainColor
        self.preferenceHintView.layer.cornerRadius = 3.0
        self.addSubview(self.preferenceHintView)
        self.preferenceHintView.addConstraints(fromStringArray: ["V:|-4-[$self]-4-|",
                                                                 "H:|-8-[$self(96)]"])
        
        self.preferenceHintIcon = UIImageView.init(image: R.image.icon_clock()?.withRenderingMode(.alwaysTemplate))
        self.preferenceHintIcon.tintColor = UIColor.white
        self.preferenceHintView.addSubview(self.preferenceHintIcon)
        self.preferenceHintIcon.addConstraints(fromStringArray: ["H:|-4-[$self]"])
        self.preferenceHintIcon.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        let preferenceTapGesture = UITapGestureRecognizer.init(target: self,
                                                               action: #selector(handlePreferenceButtonOnTapped))
        
        
        self.preferenceHintLabel = UILabel()
        self.preferenceHintLabel.isUserInteractionEnabled = true
        self.preferenceHintLabel.font = UIFont.systemFont(ofSize: 13.0)
        self.preferenceHintLabel.textColor = KPColorPalette.KPTextColor.whiteColor
        self.preferenceHintLabel.text = "偏好篩選"
        self.preferenceHintView.addSubview(self.preferenceHintLabel)
        self.preferenceHintLabel.addConstraints(fromStringArray: ["H:[$self]-8-|"],
                                     views: [self.preferenceHintIcon])
        self.preferenceHintLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        self.preferenceHintLabel.addGestureRecognizer(preferenceTapGesture)
        
        //Collection view
        self.collectionLayout = UICollectionViewFlowLayout()
        self.collectionLayout.scrollDirection = .horizontal
        self.collectionLayout.minimumLineSpacing = 4.0
        self.collectionLayout.minimumInteritemSpacing = 6.0
        
        self.collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: self.collectionLayout)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.delaysContentTouches = true
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.register(KPSearchTagCell.self,
                                     forCellWithReuseIdentifier: KPSearchTagView.KPSearchTagViewCellReuseIdentifier)
        
        self.addSubview(self.collectionView)
        self.collectionView.addConstraints(fromStringArray: ["H:[$view0]-6-[$self]|", "V:|[$self]|"],
                                           views: [self.preferenceHintView])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handlePreferenceButtonOnTapped() {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets.init(top: 0,
                                                 left: 0,
                                                 bottom: 0,
                                                 right: 0)
        let preferenceController = KPSearchConditionViewController()
        let navigationController = UINavigationController.init(rootViewController: preferenceController)
        controller.contentController = navigationController
        controller.presentModalView()
    }

}

extension KPSearchTagView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.headerTagContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPSearchTagView.KPSearchTagViewCellReuseIdentifier,
                                                      for: indexPath) as! KPSearchTagCell
        cell.tagTitle.text = self.headerTagContents[indexPath.row]
        cell.tagIcon.image = self.headerTagImages[indexPath.row]
        cell.layer.cornerRadius = 2.0
        cell.layer.masksToBounds = true
        cell.alpha = cell.isSelected ? 1.0 : 0.4
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0.4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentSize = NSString.init(string: self.headerTagContents[indexPath.row]).boundingRect(with: CGSize.init(width: Double.greatestFiniteMagnitude, height: 32),
                                                                                                        options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)],
                                                                                                        context: nil).size

        
        return CGSize.init(width: contentSize.width + 42, height: 32)
    }
    
}
