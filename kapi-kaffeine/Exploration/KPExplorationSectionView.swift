//
//  KPExplorationSectionView.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 22/11/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPExplorationSectionView: UITableViewCell {

    var collectionView: UICollectionView!
    
    var sectionTitleLabel: UILabel!
    var sectionDescriptionLabel: UILabel!
    
    var shops: [KPExplorationShop] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        
        sectionTitleLabel = UILabel()
        sectionTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        sectionTitleLabel.textColor = UIColor(hexString: "585858")
        contentView.addSubview(sectionTitleLabel)
        sectionTitleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:|-12-[$self]"])
        sectionTitleLabel.text = "IG 人氣打卡店家"
        
        sectionDescriptionLabel = UILabel()
        sectionDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        sectionDescriptionLabel.textColor = UIColor(hexString: "979797")
        contentView.addSubview(sectionDescriptionLabel)
        sectionDescriptionLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-[$self]"], views: [sectionTitleLabel])
        sectionDescriptionLabel.text = "由知名部落客們聯手推薦的知名店家。"
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(KPExplorationSectionCell.self, forCellWithReuseIdentifier: "ExplorationSectionCell")
        contentView.addSubview(collectionView)
        collectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-4-[$self(210)]|"], views: [sectionDescriptionLabel])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension KPExplorationSectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExplorationSectionCell", for: indexPath) as! KPExplorationSectionCell
        cell.nameLabel.text = shops[indexPath.row].name
        cell.regionLabel.text = shops[indexPath.row].address
        cell.imageView.af_setImage(withURL: URL(string: shops[indexPath.row].imageURL)!)
//        cell.imageView.image = R.image.demo_6()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 190)
    }
    
}
