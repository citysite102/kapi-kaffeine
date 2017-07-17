//
//  KPSearchTagView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

enum searchTagType: String {
//    case wifi       = "Wifi穩"
    case socket     = "插座多"
    case limitTime  = "不限時"
    case opening    = "營業中"
    case highRate   = "評分高"
    case standDesk  = "有站桌"
}

protocol KPSearchTagViewDelegate: NSObjectProtocol {
    func searchTagDidSelect(_ searchTags: [searchTagType])
}

class KPSearchTagView: UIView {
    
    static let KPSearchTagViewCellReuseIdentifier = "cell"

    weak open var delegate: KPSearchTagViewDelegate?
    
    var collectionView:UICollectionView!
    var collectionLayout:UICollectionViewFlowLayout!
    
    
    var preferenceHintButton: UIButton!
    
    var preferenceHintView: UIView!
    var preferenceHintIcon: UIImageView!
    var preferenceHintLabel: UILabel!
    var currentSelectTags: [searchTagType]! = [searchTagType]()
    var headerTagContents = [searchTagType.standDesk,
                             searchTagType.socket,
                             searchTagType.limitTime,
                             searchTagType.opening,
                             searchTagType.highRate]
    var headerTagImages = [R.image.icon_wifi(), R.image.icon_socket(),
                           R.image.icon_clock(), R.image.icon_door(),
                           R.image.icon_star()]

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor_light
        
        
        self.preferenceHintButton = UIButton()
        self.preferenceHintButton.setImage(R.image.icon_filter(),
                                           for: .normal)
        self.preferenceHintButton.imageEdgeInsets = UIEdgeInsetsMake(4, 2, 4, 2)
        self.preferenceHintButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4)
        self.preferenceHintButton.imageView?.contentMode = .scaleAspectFit
        self.preferenceHintButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        self.preferenceHintButton.setTitle("偏好篩選", for: .normal)
        self.preferenceHintButton.setTitleColor(UIColor.white, for: .normal)
        self.preferenceHintButton.setTitleColor(UIColor(hexString: "#888888"), for: .highlighted)
        self.preferenceHintButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor!),
                                                     for: .normal)
        self.preferenceHintButton.imageView?.tintColor = UIColor.white
        self.preferenceHintButton.layer.cornerRadius = 3.0
        self.preferenceHintButton.layer.masksToBounds = true
        self.preferenceHintButton.addTarget(self,
                                            action: #selector(handlePreferenceButtonOnTapped),
                                            for: .touchUpInside)
        self.addSubview(self.preferenceHintButton)
        self.preferenceHintButton.addConstraints(fromStringArray: ["V:|-4-[$self]-4-|",
                                                                   "H:|-8-[$self(96)]"])
        
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
                                           views: [self.preferenceHintButton])
        
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
        cell.tagTitle.text = self.headerTagContents[indexPath.row].rawValue
        cell.tagIcon.image = self.headerTagImages[indexPath.row]
        cell.layer.cornerRadius = 2.0
        cell.layer.masksToBounds = true
        cell.alpha = cell.isSelected ? 1.0 : 0.4
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        currentSelectTags.append(headerTagContents[indexPath.row])
        delegate?.searchTagDidSelect(currentSelectTags)
        cell?.alpha = 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        currentSelectTags.remove(at: currentSelectTags.index(of: headerTagContents[indexPath.row])!)
        delegate?.searchTagDidSelect(currentSelectTags)
        cell?.alpha = 0.4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentSize = NSString.init(string: self.headerTagContents[indexPath.row].rawValue).boundingRect(with: CGSize.init(width: Double.greatestFiniteMagnitude, height: 32),
                                                                                                             options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)],
                                                                                                             context: nil).size

        
        return CGSize.init(width: contentSize.width + 42, height: 32)
    }
    
}
