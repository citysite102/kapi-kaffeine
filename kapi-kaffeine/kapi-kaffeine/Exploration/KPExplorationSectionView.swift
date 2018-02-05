//
//  KPExplorationSectionView.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 22/11/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPExplorationSectionView: UITableViewCell {

    var sectionTitleLabel: UILabel!
    var sectionDescriptionLabel: UILabel!
    var collectionView: UICollectionView!
    var separatar: UIView!
    var shouldShowSeparatar: Bool = true {
        didSet {
            self.separatar.isHidden = !shouldShowSeparatar
        }
    }
    
    let demoImages = [R.image.demo_1(),
                      R.image.demo_2(),
                      R.image.demo_3(),
                      R.image.demo_4(),
                      R.image.demo_5(),
                      R.image.demo_6()]
    var shops: [KPExplorationShop] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        
        sectionTitleLabel = UILabel()
        sectionTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        sectionTitleLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        contentView.addSubview(sectionTitleLabel)
        sectionTitleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                           "V:|-16-[$self]"])
        sectionTitleLabel.text = "IG 人氣打卡店家"
        
        sectionDescriptionLabel = UILabel()
        sectionDescriptionLabel.numberOfLines = 0
        sectionDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        sectionDescriptionLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        contentView.addSubview(sectionDescriptionLabel)
        sectionDescriptionLabel.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                                 "V:[$view0]-6-[$self]"],
                                               views: [sectionTitleLabel])
        sectionDescriptionLabel.text = "由知名部落客們聯手推薦的知名店家。"
        
        let collectionViewLayout = KPDynamicLayout()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(KPExplorationSectionCell.self, forCellWithReuseIdentifier: "ExplorationSectionCell")
        contentView.addSubview(collectionView)
        collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                        "V:[$view0]-2-[$self(190)]"],
                                      views: [sectionDescriptionLabel])
        
        
        separatar = UIView()
        separatar.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        contentView.addSubview(separatar)
        separatar.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                   "V:[$view0]-24-[$self(1)]-16-|"],
                                 views:[collectionView])
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
        cell.imageView.image = demoImages[Int(arc4random())%6]
        cell.nameLabel.text = shops[indexPath.row].name
        cell.regionLabel.text = shops[indexPath.row].place
        cell.imageView.af_setImage(withURL: URL(string: shops[indexPath.row].imageURL)!)
        return cell
    }    
}
