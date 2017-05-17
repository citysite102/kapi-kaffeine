//
//  KPNewStoreController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPNewStoreController: KPViewController {

    var dismissButton:UIButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    
    var sectionOneContainer: UIView!
    var sectionTwoContainer: UIView!
    
    var sectionOneHeaderLabel: UILabel!
    var sectionTwoHeaderLabel: UILabel!
    
    var nameSubTitleView: KPSubTitleEditView!
    var citySubTitleView: KPSubTitleEditView!
    var featureSubTitleView: KPSubTitleEditView!
    
    let tags = ["工業風", "藝術", "文青", "老屋", "美式風",
                "服務佳", "有寵物", "開很晚", "手沖單品", "好停車",
                "很多書", "適合工作", "適合讀書", "聚會佳", "可預約", "可包場"]
    
    var featureCollectionView: UICollectionView!
    
    func headerLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPMainColor.mainColor
        label.text = title
        return label
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "新增店家"
        
        dismissButton = UIButton.init(frame: CGRect.init(x: 0,
                                                         y: 0,
                                                         width: 24,
                                                         height: 24))
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                                    for: .normal)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPNewStoreController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        let barItem = UIBarButtonItem.init(customView: dismissButton)
        navigationItem.leftBarButtonItem = barItem
        
        dismissButton.addTarget(self,
                                action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level7
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                    "H:|[$self]|"])
        scrollView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:|[$self]|"])
        containerView.addConstraintForHavingSameWidth(with: view)
        
        sectionOneHeaderLabel = headerLabel("請協助填寫店家相關資訊")
        containerView.addSubview(sectionOneHeaderLabel)
        sectionOneHeaderLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                               "V:|-16-[$self]"])
        
        sectionOneContainer = UIView()
        sectionOneContainer.backgroundColor = UIColor.white
        containerView.addSubview(sectionOneContainer)
        sectionOneContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-8-[$self(300)]"],
                                           views: [sectionOneHeaderLabel])
     
        nameSubTitleView = KPSubTitleEditView.init(.Bottom,
                                                   .Edited,
                                                   "店家名稱")
        nameSubTitleView.placeHolderContent = "請輸入店家名稱"
        sectionOneContainer.addSubview(nameSubTitleView)
        nameSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                          "V:|[$self(72)]"])
        
        citySubTitleView = KPSubTitleEditView.init(.Bottom,
                                                   .Edited,
                                                   "所在城市")
        citySubTitleView.placeHolderContent = "請選擇城市"
        sectionOneContainer.addSubview(citySubTitleView)
        citySubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                          "V:[$view0][$self(72)]"],
                                        views:[nameSubTitleView])
        
        featureSubTitleView = KPSubTitleEditView.init(.Bottom,
                                                      .Custom,
                                                      "選擇店家特色標籤")
        sectionOneContainer.addSubview(featureSubTitleView)
        featureSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0][$self(150)]"],
                                        views:[citySubTitleView])
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 30, height: 20)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 15
        
        featureCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: flowLayout)
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        featureCollectionView.backgroundColor = UIColor.clear
        featureCollectionView.register(KPFeatureTagCell.self,
                                       forCellWithReuseIdentifier: "cell")
        
        
        featureSubTitleView.customInfoView = featureCollectionView
    }

    func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension KPNewStoreController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell",
                                                          for: indexPath) as! KPFeatureTagCell;
            cell.featureLabel.text = self.tags[indexPath.row]
            return cell;
    }
}
