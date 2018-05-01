//
//  KPSearchTagView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

enum searchTagType: String {
    case wifi         = "有Wifi"
    case socket       = "有插座"
    case limitTime    = "無時間限制"
    case opening      = "營業中"
    case standingDesk = "站立工作"
    case highRate     = "評分高"
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
                                                        "V:|-2-[$self(40)]-8-|"])
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPSearchTagView.KPSearchTagViewButtonCellReuseIdentifier,
                                                      for: indexPath) as! KPSearchTagButtonCell
        cell.isSelected = KPFilter.sharedFilter.selectedTag.contains(headerTagContents[indexPath.row])
        if cell.isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition(rawValue: 0))
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        cell.tagTitle.text = self.headerTagContents[indexPath.row].rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.searchTagDidSelect(headerTagContents[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.searchTagDidDeselect(headerTagContents[indexPath.row])
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
