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

class KPNewStoreController: KPViewController, UITextFieldDelegate, KPKeyboardProtocol {
    
    var _scrollContainerView: UIView {
        get {
            return containerView
        }
    }
    
    var _activeTextField: UIView? {
        get {
            return activeTextField
        }
    }
    
    var _scrollView: UIScrollView {
        get {
            return scrollView
        }
    }
    
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
    var priceSubTitleView: KPSubTitleEditView!
    var featureSubTitleView: KPSubTitleEditView!
    var sizingCell: KPFeatureTagCell!
    
    var activeTextField: UITextField?
    
    var addressSubTitleView: KPSubTitleEditView!
    var phoneSubTitleView: KPSubTitleEditView!
    var facebookSubTitleView: KPSubTitleEditView!
    
    
    var ratingController: KPRatingViewController!
    var countrySelectController: KPCountrySelectController!
    var priceSelectController: KPPriceSelectController!
    var businessHourController: KPBusinessHourViewController!
    
    let tags = ["工業風", "藝術", "文青", "老屋", "美式風",
                "服務佳", "有寵物", "開很晚", "手沖單品", "好停車",
                "很多書", "適合工作", "適合讀書", "聚會佳", "可預約", "可包場"]
    
    var featureCollectionView: UICollectionView!
    var rateCheckedView: KPItemCheckedView!
    var businessHourCheckedView: KPItemCheckedView!
    
    
    func headerLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = title
        return label
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "新增店家"
        
        dismissButton = KPBounceButton(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 24,
                                                     height: 24),
                                       image:R.image.icon_close()!)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPNewStoreController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        let barItem = UIBarButtonItem(customView: dismissButton)
        
        sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        sendButton.setTitle("新增", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendButton.tintColor = KPColorPalette.KPTextColor.mainColor
        sendButton.addTarget(self,
                             action: #selector(KPNewStoreController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        
        let rightbarItem = UIBarButtonItem(customView: sendButton)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        
        rightbarItem.isEnabled = false
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightbarItem]
        
        
        
        dismissButton.addTarget(self,
                                action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
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
     
        nameSubTitleView = KPSubTitleEditView(.Bottom,
                                              .Edited,
                                              "店家名稱")
        nameSubTitleView.placeHolderContent = "請輸入店家名稱"
        sectionOneContainer.addSubview(nameSubTitleView)
        nameSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                          "V:|[$self(72)]"])
        
        citySubTitleView = KPSubTitleEditView(.Bottom,
                                              .Fixed,
                                              "所在城市")
        citySubTitleView.placeHolderContent = "請選擇城市"
        citySubTitleView.customInputAction = {
            [unowned self] () -> Void in
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: UIDevice().isCompact ? 48 : 56,
                                                     left: 0,
                                                     bottom: 0,
                                                     right: 0)
            controller.cornerRadius = [.topRight, .topLeft]
            if self.countrySelectController == nil {
                self.countrySelectController = KPCountrySelectController()
                self.countrySelectController.identifiedKey = "country"
                self.countrySelectController.delegate = self
            }
            controller.contentController = self.countrySelectController
            controller.presentModalView()
        }
        sectionOneContainer.addSubview(citySubTitleView)
        citySubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                          "V:[$view0][$self(72)]"],
                                        views:[nameSubTitleView])
        
        priceSubTitleView = KPSubTitleEditView(.Bottom,
                                               .Fixed,
                                               "價格區間")
        priceSubTitleView.placeHolderContent = "請選擇價格區間"
        priceSubTitleView.customInputAction = {
            [unowned self] () -> Void in
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: UIDevice().isCompact ? 48 : 56,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            controller.cornerRadius = [.topRight, .topLeft]
            if self.priceSelectController == nil {
                self.priceSelectController = KPPriceSelectController()
                self.priceSelectController.identifiedKey = "price"
                self.priceSelectController.delegate = self
            }
            controller.contentController = self.priceSelectController
            controller.presentModalView()
        }
        sectionOneContainer.addSubview(priceSubTitleView)
        priceSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                           "V:[$view0][$self(72)]"],
                                         views:[citySubTitleView])
        
        
        featureSubTitleView = KPSubTitleEditView(.Bottom,
                                                 .Custom,
                                                 "選擇店家特色標籤")
        sectionOneContainer.addSubview(featureSubTitleView)
        featureSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0][$self(200)]"],
                                        views:[priceSubTitleView])
        
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
    
        rateCheckedView = KPItemCheckedView("幫店家評分",
                                            "未評分",
                                            "已評分(3.0)",
                                            .Bottom)
        sectionOneContainer.addSubview(rateCheckedView)
        rateCheckedView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:[$view0][$self(64)]"],
                                           views:[featureSubTitleView])
        rateCheckedView.customInputAction = {
            [unowned self] () -> Void in
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: UIDevice().isCompact ? 32 : 40,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            controller.cornerRadius = [.topRight, .topLeft, .bottomLeft, .bottomRight]
            if self.ratingController == nil {
                self.ratingController = KPRatingViewController()
                self.ratingController.identifiedKey = "rate"
                self.ratingController.isRemote = false
                self.ratingController.delegate = self
            }
            controller.contentController = self.ratingController
            controller.presentModalView()
        }
        
        businessHourCheckedView = KPItemCheckedView("填寫營業時間",
                                                    "未填寫",
                                                    "已填寫",
                                                    .Bottom)
        sectionOneContainer.addSubview(businessHourCheckedView)
        businessHourCheckedView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                 "V:[$view0][$self(64)]|"],
                                               views:[rateCheckedView])
        businessHourCheckedView.customInputAction = {
            [unowned self] () -> Void in
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 32,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            if self.businessHourController == nil {
                self.businessHourController = KPBusinessHourViewController()
                self.businessHourController.identifiedKey = "time"
                self.businessHourController.delegate = self
            }
            controller.contentController = self.businessHourController
            controller.cornerRadius = [.topRight, .topLeft]
            controller.presentModalView()
        }
        
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
        timeRadioBoxOne = KPCheckView(.radio, "不設定")
        timeRadioBoxOne.checkBox.checkState = .checked
        sectionTwoContainer.addSubview(timeRadioBoxOne)
        timeRadioBoxOne.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                         "V:[$view0]-16-[$self]"],
                                       views: [timeLimitLabel])
        timeRadioBoxTwo = KPCheckView(.radio, "客滿/人多限時")
        sectionTwoContainer.addSubview(timeRadioBoxTwo)
        timeRadioBoxTwo.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                         "V:[$view0]-16-[$self]"],
                                       views: [timeRadioBoxOne])
        timeRadioBoxThree = KPCheckView(.radio, "不限時")
        sectionTwoContainer.addSubview(timeRadioBoxThree)
        timeRadioBoxThree.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                         views: [timeRadioBoxTwo])
        
        timeRadioBoxOne.checkBox.deselectCheckBoxs = [timeRadioBoxTwo.checkBox,
                                                      timeRadioBoxThree.checkBox]
        timeRadioBoxTwo.checkBox.deselectCheckBoxs = [timeRadioBoxOne.checkBox,
                                                      timeRadioBoxThree.checkBox]
        timeRadioBoxThree.checkBox.deselectCheckBoxs = [timeRadioBoxTwo.checkBox,
                                                        timeRadioBoxOne.checkBox]
        
        socketLabel = headerLabel("插座數量")
        sectionTwoContainer.addSubview(socketLabel)
        socketLabel.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                     "V:|-16-[$self]"],
                                   metrics:[KPNewStoreControllerConstants.leftPadding])
        
        socketRadioBoxOne = KPCheckView(.radio, "不設定")
        socketRadioBoxOne.checkBox.checkState = .checked
        sectionTwoContainer.addSubview(socketRadioBoxOne)
        socketRadioBoxOne.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                         metrics:[KPNewStoreControllerConstants.leftPadding],
                                         views: [socketLabel])
        socketRadioBoxTwo = KPCheckView(.radio, "部分座位有")
        sectionTwoContainer.addSubview(socketRadioBoxTwo)
        socketRadioBoxTwo.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                         metrics:[KPNewStoreControllerConstants.leftPadding],
                                         views: [socketRadioBoxOne])
        socketRadioBoxThree = KPCheckView(.radio, "很多插座")
        sectionTwoContainer.addSubview(socketRadioBoxThree)
        socketRadioBoxThree.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                             "V:[$view0]-16-[$self]"],
                                           metrics:[KPNewStoreControllerConstants.leftPadding],
                                           views: [socketRadioBoxTwo])
        
        socketRadioBoxOne.checkBox.deselectCheckBoxs = [socketRadioBoxTwo.checkBox,
                                                        socketRadioBoxThree.checkBox]
        socketRadioBoxTwo.checkBox.deselectCheckBoxs = [socketRadioBoxOne.checkBox,
                                                        socketRadioBoxThree.checkBox]
        socketRadioBoxThree.checkBox.deselectCheckBoxs = [socketRadioBoxOne.checkBox,
                                                          socketRadioBoxTwo.checkBox]
        
        addressSubTitleView = KPSubTitleEditView(.Both,
                                                 .Edited,
                                                 "店家地址")
        addressSubTitleView.placeHolderContent = "請輸入店家地址"
        addressSubTitleView.editTextField.delegate = self
        sectionTwoContainer.addSubview(addressSubTitleView)
        addressSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-16-[$self(72)]"],
                                           views: [socketRadioBoxThree])
        
        phoneSubTitleView = KPSubTitleEditView(.Bottom,
                                               .Edited,
                                               "店家電話")
        phoneSubTitleView.placeHolderContent = "請輸入店家電話"
        phoneSubTitleView.inputKeyboardType = .phonePad
        phoneSubTitleView.editTextField.delegate = self
        sectionTwoContainer.addSubview(phoneSubTitleView)
        phoneSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                           "V:[$view0][$self(72)]"],
                                           views: [addressSubTitleView])
        
        facebookSubTitleView = KPSubTitleEditView(.Bottom,
                                                  .Edited,
                                                  "Facebook 連結")
        facebookSubTitleView.placeHolderContent = "請輸入店家 Facebook 連結"
        facebookSubTitleView.editTextField.delegate = self
        sectionTwoContainer.addSubview(facebookSubTitleView)
        facebookSubTitleView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$view0][$self(72)]-16-|"],
                                         views: [phoneSubTitleView])
        
        
        tapGesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(handleTapGesture(tapGesture:)))
        tapGesture.cancelsTouchesInView = false
        containerView.addGestureRecognizer(tapGesture)
        
        
        registerForNotification()
    }

    func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func handleSendButtonOnTapped() {
        
        KPServiceHandler.sharedHandler.addNewShop(nameSubTitleView.editTextField.text ?? "",
                                                  addressSubTitleView.editTextField.text ?? "",
                                                  citySubTitleView.editTextField.text ?? "",
                                                  facebookSubTitleView.editTextField.text ?? "",
                                                  "1",
                                                  "1",
                                                  phoneSubTitleView.editTextField.text ?? "",
                                                  (businessHourController.setValue as? [String: String]) ?? [:]) { (success) in
                                                    if success == true {
                                                        KPPopoverView.popoverNotification("新增成功",
                                                                                          "感謝您提交資訊，我們將儘速進行審查:D 這將會需要1-3天的審核時間確認店家的資訊是否無誤，給我好好的等。",
                                                                                          nil)
                                                    }
                                                    
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension KPNewStoreController: KPSharedSettingDelegate {
    
    func sendButtonTapped(_ controller: KPSharedSettingViewController) {
        if controller.identifiedKey == "country" {
            self.citySubTitleView.content = controller.setValue as! String
        } else if controller.identifiedKey == "price" {
            self.priceSubTitleView.content = controller.setValue as! String
        } else if controller.identifiedKey == "rate" {
            self.rateCheckedView.checkContent = String(format: "已評分(%.1f)",
                                                       controller.setValue as! CGFloat)
            self.rateCheckedView.checked = true
        } else if controller.identifiedKey == "time" {
            self.businessHourCheckedView.checked = true
        }
    }
}

extension KPNewStoreController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell",
                                                          for: indexPath) as! KPFeatureTagCell
            cell.featureLabel.text = self.tags[indexPath.row]
            return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizingCell.featureLabel.text = self.tags[indexPath.row]
        return CGSize(width: sizingCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize).width,
                      height: 30)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        featureSubTitleView.layer.shouldRasterize = true
//        featureSubTitleView.layer.rasterizationScale = UIScreen.main.scale
//    }
//    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        featureSubTitleView.layer.shouldRasterize = true
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
