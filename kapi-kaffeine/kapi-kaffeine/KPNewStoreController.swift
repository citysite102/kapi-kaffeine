//
//  KPNewStoreController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit


struct KPNewStoreControllerConstants {
    static let leftPadding = 168
}

class KPNewStoreController: KPViewController {

    var dismissButton: KPBounceButton!
    var sendButton: UIButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    var tapGesture: UITapGestureRecognizer!
    
    var sectionOneContainer: UIView!
    var sectionTwoContainer: UIView!
    
    var sectionOneHeaderLabel: UILabel!
    var sectionTwoHeaderLabel: UILabel!
    
    var timeLimitLabel: UILabel!
    var timeRadioBoxOne: KPCheckView!
    var timeRadioBoxTwo: KPCheckView!
    var timeRadioBoxThree: KPCheckView!
    
    var socketLabel: UILabel!
    var socketRadioBoxOne: KPCheckView!
    var socketRadioBoxTwo: KPCheckView!
    var socketRadioBoxThree: KPCheckView!
    
    var nameSubTitleView: KPSubTitleEditView!
    var citySubTitleView: KPSubTitleEditView!
    var featureSubTitleView: KPSubTitleEditView!
    var sizingCell: KPFeatureTagCell!
    
    var addressSubTitleView: KPSubTitleEditView!
    var phoneSubTitleView: KPSubTitleEditView!
    var facebookSubTitleView: KPSubTitleEditView!
    
    let tags = ["工業風", "藝術", "文青", "老屋", "美式風",
                "服務佳", "有寵物", "開很晚", "手沖單品", "好停車",
                "很多書", "適合工作", "適合讀書", "聚會佳", "可預約", "可包場"]
    
    var featureCollectionView: UICollectionView!
    var rateCheckedView: KPItemCheckedView!
    var businessHourCheckedView: KPItemCheckedView!
    
    
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
        
        dismissButton = KPBounceButton.init(frame: CGRect.init(x: 0,
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
        
        sendButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 24));
        sendButton.setTitle("新增", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendButton.tintColor = KPColorPalette.KPTextColor.mainColor;
        sendButton.addTarget(self,
                             action: #selector(KPNewCommentController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        
        let rightbarItem = UIBarButtonItem.init(customView: self.sendButton);
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightbarItem]
        
        
        
        dismissButton.addTarget(self,
                                action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level7
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
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
                                                             "V:[$view0]-8-[$self]"],
                                           views: [sectionOneHeaderLabel])
     
        nameSubTitleView = KPSubTitleEditView.init(.Bottom,
                                                   .Edited,
                                                   "店家名稱")
        nameSubTitleView.placeHolderContent = "請輸入店家名稱"
        sectionOneContainer.addSubview(nameSubTitleView)
        nameSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                          "V:|[$self(72)]"])
        
        citySubTitleView = KPSubTitleEditView.init(.Bottom,
                                                   .Fixed,
                                                   "所在城市")
        citySubTitleView.placeHolderContent = "請選擇城市"
        citySubTitleView.customInputAction = {
            () -> Void in
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets.init(top: UIDevice().isCompact ? 48 : 56,
                                                     left: 0,
                                                     bottom: 0,
                                                     right: 0);
            controller.cornerRadius = [.topRight, .topLeft]
            let countryController = KPCountrySelectController()
            controller.contentController = countryController;
            controller.presentModalView();
        }
        sectionOneContainer.addSubview(citySubTitleView)
        citySubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                          "V:[$view0][$self(72)]"],
                                        views:[nameSubTitleView])
        
        featureSubTitleView = KPSubTitleEditView.init(.Bottom,
                                                      .Custom,
                                                      "選擇店家特色標籤")
        sectionOneContainer.addSubview(featureSubTitleView)
        featureSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0][$self(200)]"],
                                        views:[citySubTitleView])
        
        sizingCell = KPFeatureTagCell()
        
        
        let flowLayout = KPFeatureTagLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        
        featureCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: flowLayout)
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        featureCollectionView.backgroundColor = UIColor.clear
        featureCollectionView.allowsMultipleSelection = true
        featureCollectionView.register(KPFeatureTagCell.self,
                                       forCellWithReuseIdentifier: "cell")
        
        featureSubTitleView.customInfoView = featureCollectionView
    
        rateCheckedView = KPItemCheckedView.init("幫店家評分",
                                                 "未評分",
                                                 "已評分(3.0)",
                                                 .Bottom)
        
        sectionOneContainer.addSubview(rateCheckedView)
        rateCheckedView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:[$view0][$self(64)]"],
                                           views:[featureSubTitleView])
        
        businessHourCheckedView = KPItemCheckedView.init("填寫營業時間",
                                                         "未填寫",
                                                         "已填寫",
                                                         .Bottom)
        
        sectionOneContainer.addSubview(businessHourCheckedView)
        businessHourCheckedView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                 "V:[$view0][$self(64)]|"],
                                               views:[rateCheckedView])
        
        
        
        sectionTwoHeaderLabel = headerLabel("其他選項")
        containerView.addSubview(sectionTwoHeaderLabel)
        sectionTwoHeaderLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                               "V:[$view0]-16-[$self]"],
                                             views:[sectionOneContainer])
        
        sectionTwoContainer = UIView()
        sectionTwoContainer.backgroundColor = UIColor.white
        containerView.addSubview(sectionTwoContainer)
        sectionTwoContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-8-[$self]-8-|"],
                                           views: [sectionTwoHeaderLabel])
        
        timeLimitLabel = headerLabel("有無時間限制")
        sectionTwoContainer.addSubview(timeLimitLabel)
        timeLimitLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                        "V:|-16-[$self]"])
        timeRadioBoxOne = KPCheckView.init(.radio, "不設定")
        sectionTwoContainer.addSubview(timeRadioBoxOne)
        timeRadioBoxOne.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                         "V:[$view0]-16-[$self]"],
                                       views: [timeLimitLabel])
        timeRadioBoxTwo = KPCheckView.init(.radio, "客滿/人多限時")
        sectionTwoContainer.addSubview(timeRadioBoxTwo)
        timeRadioBoxTwo.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                         "V:[$view0]-16-[$self]"],
                                       views: [timeRadioBoxOne])
        timeRadioBoxThree = KPCheckView.init(.radio, "不限時")
        sectionTwoContainer.addSubview(timeRadioBoxThree)
        timeRadioBoxThree.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                         views: [timeRadioBoxTwo])
        
        socketLabel = headerLabel("插座數量")
        sectionTwoContainer.addSubview(socketLabel)
        socketLabel.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                     "V:|-16-[$self]"],
                                   metrics:[KPNewStoreControllerConstants.leftPadding])
        
        socketRadioBoxOne = KPCheckView.init(.radio, "不設定")
        sectionTwoContainer.addSubview(socketRadioBoxOne)
        socketRadioBoxOne.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                         metrics:[KPNewStoreControllerConstants.leftPadding],
                                         views: [socketLabel])
        socketRadioBoxTwo = KPCheckView.init(.radio, "部分座位有")
        sectionTwoContainer.addSubview(socketRadioBoxTwo)
        socketRadioBoxTwo.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                         metrics:[KPNewStoreControllerConstants.leftPadding],
                                         views: [socketRadioBoxOne])
        socketRadioBoxThree = KPCheckView.init(.radio, "很多插座")
        sectionTwoContainer.addSubview(socketRadioBoxThree)
        socketRadioBoxThree.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                             "V:[$view0]-16-[$self]"],
                                           metrics:[KPNewStoreControllerConstants.leftPadding],
                                           views: [socketRadioBoxTwo])
        
        
        addressSubTitleView = KPSubTitleEditView.init(.Both,
                                                      .Edited,
                                                      "店家地址")
        addressSubTitleView.placeHolderContent = "請輸入店家地址"
        sectionTwoContainer.addSubview(addressSubTitleView)
        addressSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-16-[$self(72)]"],
                                           views: [socketRadioBoxThree])
        
        phoneSubTitleView = KPSubTitleEditView.init(.Bottom,
                                                    .Edited,
                                                    "店家電話")
        phoneSubTitleView.placeHolderContent = "請輸入店家電話"
        phoneSubTitleView.inputKeyboardType = .phonePad
        sectionTwoContainer.addSubview(phoneSubTitleView)
        phoneSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                           "V:[$view0][$self(72)]"],
                                           views: [addressSubTitleView])
        
        facebookSubTitleView = KPSubTitleEditView.init(.Bottom,
                                                       .Edited,
                                                       "Facebook 連結")
        facebookSubTitleView.placeHolderContent = "請輸入店家 Facebook 連結"
        sectionTwoContainer.addSubview(facebookSubTitleView)
        facebookSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$view0][$self(72)]|"],
                                         views: [phoneSubTitleView])
        
        
        tapGesture = UITapGestureRecognizer.init(target: self,
                                                 action: #selector(handleTapGesture(tapGesture:)))
        tapGesture.cancelsTouchesInView = false
        containerView.addGestureRecognizer(tapGesture)
        
        
    }

    func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration();
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension KPNewStoreController: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell",
                                                          for: indexPath) as! KPFeatureTagCell;
            cell.featureLabel.text = self.tags[indexPath.row]
            return cell;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizingCell.featureLabel.text = self.tags[indexPath.row]
        return CGSize(width: sizingCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize).width,
                      height: 30)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
