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
    
    var shops: [KPDataModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        
        sectionTitleLabel = UILabel()
        sectionTitleLabel.font = UIFont.systemFont(ofSize: KPFontSize.header,
                                                   weight: UIFont.Weight.medium)
        sectionTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        contentView.addSubview(sectionTitleLabel)
        sectionTitleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                           "V:|-16-[$self]"])
        sectionTitleLabel.text = "IG 人氣打卡店家"
        
        sectionDescriptionLabel = UILabel()
        sectionDescriptionLabel.numberOfLines = 0
        sectionDescriptionLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent,
                                                         weight: UIFont.Weight.light)

        sectionDescriptionLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
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
        collectionView.delaysContentTouches = false
        collectionView.canCancelContentTouches = true
        collectionView.register(KPExplorationSectionCell.self, forCellWithReuseIdentifier: "ExplorationSectionCell")
        contentView.addSubview(collectionView)
        collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                        "V:[$view0]-4-[$self(192)]"],
                                      views: [sectionDescriptionLabel])
        
        
        separatar = UIView()
        separatar.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        contentView.addSubview(separatar)
        separatar.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                   "V:[$view0]-16-[$self(1)]-8-|"],
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
     
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        let informationController = KPInformationViewController()
        informationController.informationDataModel = shops[indexPath.row]
        let navigationController = UINavigationController(rootViewController: informationController)
        controller.contentController = navigationController
        controller.presentModalView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExplorationSectionCell",
                                                      for: indexPath) as! KPExplorationSectionCell
        cell.nameLabel.text = shops[indexPath.row].name
        cell.regionLabel.text = shops[indexPath.row].place
        cell.rateLabel.text = String(format: "%.1f",
                                      (shops[indexPath.row].averageRate?.doubleValue) ?? 0)
        cell.collectButton.tag = indexPath.row
        cell.collectButton.isSelected = KPUserManager.sharedManager.currentUser?.hasFavorited(shops[indexPath.row].identifier) ?? false
        cell.collectButton.addTarget(self,
                                     action: #selector(handleShopFavorited(sender:)),
                                     for: UIControlEvents.primaryActionTriggered)
        if let url = shops[indexPath.row].imageURL_l ?? shops[indexPath.row].imageURL_s {
            cell.imageView.af_setImage(withURL: url,
                                       placeholderImage: nil,
                                       filter: nil,
                                       progress: nil,
                                       progressQueue: DispatchQueue.global(),
                                       imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                       runImageTransitionIfCached: true,
                                       completion: nil)
        } else if let url = shops[indexPath.row].googleURL_l ?? shops[indexPath.row].googleURL_s {
            cell.imageView.af_setImage(withURL: url,
                                       placeholderImage: nil,
                                       filter: nil,
                                       progress: nil,
                                       progressQueue: DispatchQueue.global(),
                                       imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                       runImageTransitionIfCached: true,
                                       completion: nil)
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "demo_3")
        }
        return cell
    }
    
    @objc func handleShopFavorited(sender: KPBounceButton) {
        if sender.isSelected {
            KPServiceHandler.sharedHandler.removeFavoriteCafe(shops[sender.tag])
        } else {
            KPServiceHandler.sharedHandler.addFavoriteCafe(shops[sender.tag])
        }
    }
}
