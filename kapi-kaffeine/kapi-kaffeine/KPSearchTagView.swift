//
//  KPSearchTagView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

enum searchTagType: String {
    case wifi       = "Wifi 穩定"
    case socket     = "插座多"
    case limitTime  = "不限時"
    case opening    = "目前營業中"
    case highRate   = "綜合評分高"
    case clear      = "清除設定"
}

protocol KPSearchTagViewDelegate: NSObjectProtocol {
    func searchTagDidSelect(_ searchTag: searchTagType)
    func searchTagDidDeselect(_ searchTag: searchTagType)
}

class KPSearchTagView: UIView {
    
    static let KPSearchTagViewCellReuseIdentifier = "cell"
    static let KPSearchTagViewButtonCellReuseIdentifier = "button_cell"

    weak open var delegate: (KPSearchTagViewDelegate & KPSearchConditionViewControllerDelegate)?
    
    var collectionView: UICollectionView!
    var collectionLayout: UICollectionViewFlowLayout!
    var preferenceHintButton: KPPreferenceHintButton!
    var preferenceHintView: UIView!
    var preferenceHintIcon: UIImageView!
    var preferenceHintLabel: UILabel!
    
    var headerTagContents = [searchTagType.wifi,
                             searchTagType.socket,
                             searchTagType.limitTime,
                             searchTagType.opening,
                             searchTagType.highRate]
    var headerTagImages = [R.image.icon_wifi(), R.image.icon_socket(),
                           R.image.icon_clock(), R.image.icon_door(),
                           R.image.icon_star()]

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        
        
//        preferenceHintButton = KPPreferenceHintButton()
//        preferenceHintButton.setImage(R.image.icon_filter(),
//                                           for: .normal)
//        preferenceHintButton.imageEdgeInsets = UIEdgeInsetsMake(4, 2, 4, 2)
//        preferenceHintButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4)
//        preferenceHintButton.imageView?.contentMode = .scaleAspectFit
//        preferenceHintButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
//        preferenceHintButton.setTitle("偏好篩選", for: .normal)
//        preferenceHintButton.setTitleColor(UIColor.white, for: .normal)
//        preferenceHintButton.setTitleColor(UIColor(hexString: "#888888"), for: .highlighted)
//        preferenceHintButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor!),
//                                                     for: .normal)
//        preferenceHintButton.imageView?.tintColor = UIColor.white
//        preferenceHintButton.layer.cornerRadius = 3.0
//        preferenceHintButton.layer.masksToBounds = true
//        addSubview(preferenceHintButton)
//        preferenceHintButton.addConstraints(fromStringArray: ["V:|-4-[$self]-4-|",
//                                                              "H:|-8-[$self(96)]"])
        
        //Collection view
        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 8.0
        collectionLayout.minimumInteritemSpacing = 8.0
        collectionLayout.estimatedItemSize = CGSize(width: 68, height: 32)
        
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = true
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = UIEdgeInsetsMake(0,
                                                       12,
                                                       0,
                                                       8);
        collectionView.register(KPSearchTagButtonCell.self,
                                forCellWithReuseIdentifier: KPSearchTagView.KPSearchTagViewButtonCellReuseIdentifier)
        collectionView.register(KPSearchTagCell.self,
                                forCellWithReuseIdentifier: KPSearchTagView.KPSearchTagViewCellReuseIdentifier)
        
        addSubview(collectionView)
        collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                        "V:|-12-[$self(40)]-12-|"])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deselectAllSearchTag() {
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        collectionView.reloadData()
    }

}

extension KPSearchTagView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerTagContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if indexPath.row == headerTagContents.count-1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPSearchTagView.KPSearchTagViewButtonCellReuseIdentifier,
                                                          for: indexPath) as! KPSearchTagButtonCell
            cell.tagTitle.text = self.headerTagContents[indexPath.row].rawValue
            return cell
            
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPSearchTagView.KPSearchTagViewCellReuseIdentifier,
//                                                          for: indexPath) as! KPSearchTagCell
//            cell.tagTitle.text = self.headerTagContents[indexPath.row].rawValue
//            cell.tagIcon.image = self.headerTagImages[indexPath.row]
//            cell.layer.cornerRadius = 2.0
//            cell.layer.masksToBounds = true
//            cell.alpha = cell.isSelected ? 1.0 : 0.4
//
//            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.headerTagContents[indexPath.row] == .clear {
            deselectAllSearchTag()
        }
//        let cell = collectionView.cellForItem(at: indexPath)
//        currentSelectTags.append(headerTagContents[indexPath.row])
//        delegate?.searchTagDidSelect(headerTagContents[indexPath.row])
//        cell?.alpha = 1.0
//        preferenceHintButton.hintCount = collectionView.indexPathsForSelectedItems?.count ?? 0
//        preferenceHintButton.hintCount = currentSelectTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        preferenceHintButton.hintCount = collectionView.indexPathsForSelectedItems?.count ?? 0
//        delegate?.searchTagDidDeselect(headerTagContents[indexPath.row])
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row == headerTagContents.count-1 {
//            return CGSize.init(width: 68, height: 32)
//        } else {
//            let contentSize = NSString.init(string: self.headerTagContents[indexPath.row].rawValue).boundingRect(with: CGSize.init(width: Double.greatestFiniteMagnitude, height: 32),
//                                                                                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)],
//                                                                                                                 context: nil).size
//
//
//            return CGSize.init(width: contentSize.width + 42, height: 32)
//        }
//    }
    
}
