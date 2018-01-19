//
//  KPSearchConditionViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol KPSearchConditionViewControllerDelegate: class {
    func searchConditionControllerDidSearch(_ searchConditionController: KPPreferenceSearchViewController)
}

struct KPSearchConditionViewControllerConstants {
    static let leftPadding = 168
}

class KPPreferenceSearchViewController: KPViewController {

    var dismissButton: UIButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    
    var ratingTitles = ["Wifi穩定", "安靜程度",
                        "價格實惠", "座位數量",
                        "咖啡品質", "餐點美味", "環境舒適"]
    
    var ratingImages = [R.image.icon_wifi(), R.image.icon_sleep(),
                        R.image.icon_money(), R.image.icon_seat(),
                        R.image.icon_cup(), R.image.icon_cutlery(),
                        R.image.icon_pic()]
    
    var ratingViews = [KPRatingView]()
    
    weak var delegate: KPSearchConditionViewControllerDelegate?
    
    var sortLabel: UILabel!
    var sortSegmentedControl: KPSegmentedControl!
    var priceSegmentedControl: KPSegmentedControl!
    
    
    var priceSettingLabel: UILabel!
    var priceSettingDescriptionLabel: UILabel!
    
    
    lazy var seperator_one: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    // Section 2
    var adjustPointLabel: UILabel!
    
    lazy var seperator_two: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    // Section 3
    
    var startSearchTime: String?
    var endSearchTime: String?
    
    var businessHourLabel: UILabel!
    var businessCheckBoxOne: KPCheckView!
    var businessCheckBoxTwo: KPCheckView!
    var businessCheckBoxThree: KPCheckView!
    var timeSupplementView: KPSpecificTimeSupplementView!
    
    lazy var seperator_three: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    var searchButtonContainer: UIView!
    var searchButton: UIButton!
    
    func buttonWithTitle(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(KPColorPalette.KPTextColor.mainColor!,
                             for: .normal)
        button.setTitleColor(UIColor.white,
                             for: .selected)
        button.setBackgroundImage(UIImage(color: UIColor.white),
                                  for: .normal)
        button.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.mainColor!),
                                  for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 18.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = KPColorPalette.KPMainColor_v2.mainColor?.cgColor
        button.layer.masksToBounds = true
        return button
    }
    
    func titleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor_subtitle
        label.text = title
        return label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "篩選偏好設定"
        navigationController?.navigationBar.shadowImage = UIImage()
        
    
        let barRightItem = UIBarButtonItem(title: "清除",
                                           style: .plain,
                                           target: self,
                                           action: #selector(handleRestoreButtonOnTapped))
        barRightItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        
        let barLeftItem = UIBarButtonItem(title: "取消",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleDismissButtonOnTapped))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        
        navigationItem.rightBarButtonItem = barRightItem
        navigationItem.leftBarButtonItem = barLeftItem
        
        scrollView = UIScrollView()
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
        
        
        // Section 1
        sortLabel = titleLabel("排序方式")
        containerView.addSubview(sortLabel)
        sortLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                   "V:|-24-[$self]"])
        
        sortSegmentedControl = KPSegmentedControl.init(["距離最近",
                                                        "評分最高"])
        sortSegmentedControl.selectedSegmentIndex = KPFilter.sharedFilter.sortedby == .distance ? 0 : 1
        containerView.addSubview(sortSegmentedControl)
        sortSegmentedControl.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                              "V:[$view0]-12-[$self(36)]"],
                                            views: [sortLabel])
        
        priceSettingLabel = titleLabel("價格區間")
        containerView.addSubview(priceSettingLabel)
        priceSettingLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                           "V:[$view0]-40-[$self]"],
                                         views: [sortSegmentedControl])
        
        priceSettingDescriptionLabel = UILabel()
        priceSettingDescriptionLabel.font = UIFont.systemFont(ofSize: 14.0)
        priceSettingDescriptionLabel.textColor = KPColorPalette.KPTextColor.mainColor_description
        priceSettingDescriptionLabel.text = "$=低於99元 / $$=100-199元 / $$$=高於200元"
        containerView.addSubview(priceSettingDescriptionLabel)
        priceSettingDescriptionLabel.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                                      "V:[$view0]-8-[$self]"],
                                             views: [priceSettingLabel])
        
        
        priceSegmentedControl = KPSegmentedControl.init(["$ (3間)",
                                                         "$$ (25間)",
                                                         "$$$ (12間)"])
        priceSegmentedControl.selectedSegmentIndex = 0
        containerView.addSubview(priceSegmentedControl)
        priceSegmentedControl.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                               "V:[$view0]-8-[$self(36)]"],
                                            views: [priceSettingDescriptionLabel])
        
       
        containerView.addSubview(seperator_one)
        seperator_one.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:[$view0]-24-[$self(1)]"],
                                          views: [priceSegmentedControl])
        
        // Section 2
        adjustPointLabel = titleLabel("特殊需求")
        containerView.addSubview(adjustPointLabel)
        adjustPointLabel.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                          "V:[$view0]-16-[$self]"],
                                             views: [seperator_one])
        
        for (index, title) in ratingTitles.enumerated() {
            let ratingView = KPRatingView(.segmented,
                                               ratingImages[index]!,
                                               title)
            ratingViews.append(ratingView)
            containerView.addSubview(ratingView)
            
            if index == 0 {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-12-[$self]"],
                                          views: [adjustPointLabel])
            } else {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-12-[$self]"],
                                          views: [ratingViews[index-1]])
            }
            
            
            switch index {
            case 0:
                ratingView.currentRate = Int(KPFilter.sharedFilter.wifiRate)
            case 1:
                ratingView.currentRate = Int(KPFilter.sharedFilter.quietRate)
            case 2:
                ratingView.currentRate = Int(KPFilter.sharedFilter.cheapRate)
            case 3:
                ratingView.currentRate = Int(KPFilter.sharedFilter.seatRate)
            case 4:
                ratingView.currentRate = Int(KPFilter.sharedFilter.tastyRate)
            case 5:
                ratingView.currentRate = Int(KPFilter.sharedFilter.foodRate)
            case 6:
                ratingView.currentRate = Int(KPFilter.sharedFilter.musicRate)
            default:
                fatalError()
            }
            
        }
        
        containerView.addSubview(seperator_two)
        seperator_two.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:[$view0]-16-[$self(1)]"],
                                          views: [ratingViews.last!])
        
        businessHourLabel = titleLabel("營業時間")
        containerView.addSubview(businessHourLabel)
        businessHourLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                              views: [seperator_two])
        
        businessCheckBoxOne = KPCheckView(.radio, "不設定")
        businessCheckBoxOne.checkBox.checkState = .checked
        containerView.addSubview(businessCheckBoxOne)
        businessCheckBoxOne.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                             "V:[$view0]-16-[$self]"],
                                                views: [businessHourLabel])
        
        businessCheckBoxTwo = KPCheckView(.radio, "目前營業中")
        containerView.addSubview(businessCheckBoxTwo)
        businessCheckBoxTwo.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                             "V:[$view0]-16-[$self]"],
                                                views: [businessCheckBoxOne])

        
        businessCheckBoxThree = KPCheckView(.radio, "特定營業時段")
        containerView.addSubview(businessCheckBoxThree)
        businessCheckBoxThree.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                               "V:[$view0]-16-[$self]-88-|"],
                                           views: [businessCheckBoxTwo])
        businessCheckBoxThree.checkBox.addTarget(self,
                                                 action: #selector(handleBusinessCheckBoxTwoOnTap(_:)),
                                                 for: .valueChanged)
        
        businessCheckBoxOne.deselectCheckViews = [businessCheckBoxTwo, businessCheckBoxThree]
        businessCheckBoxTwo.deselectCheckViews = [businessCheckBoxOne, businessCheckBoxThree]
        businessCheckBoxThree.deselectCheckViews = [businessCheckBoxOne, businessCheckBoxTwo]
        
        
        if KPFilter.sharedFilter.currentOpening == true {
            businessCheckBoxTwo.checkBox.checkState = .checked
        } else if KPFilter.sharedFilter.searchTime != nil {
            businessCheckBoxThree.checkBox.checkState = .checked
        } else {
            businessCheckBoxOne.checkBox.checkState = .checked
        }
        
        
        timeSupplementView = KPSpecificTimeSupplementView()
        businessCheckBoxThree.supplementInfoView = timeSupplementView
        timeSupplementView.addConstraint(forWidth: 90)
        
        searchButtonContainer = UIView()
        searchButtonContainer.backgroundColor = UIColor.white
        view.addSubview(searchButtonContainer)
        searchButtonContainer.addConstraints(fromStringArray: ["V:[$self]|",
                                                               "H:|[$self]|"])
        searchButtonContainer.addSubview(seperator_three)
        seperator_three.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self(1)]"],
                                       views: [businessCheckBoxThree])
        
        searchButton = UIButton()
        searchButton.setTitle("開始搜尋", for: .normal)
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.greenColor!),
                                                for: .normal)
        searchButton.layer.cornerRadius = 4.0
        searchButton.layer.masksToBounds = true
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        searchButtonContainer.addSubview(searchButton)
        searchButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(40)]-16-|",
                                                      "H:|-16-[$self]-16-|"],
                                         views: [seperator_three])
        searchButton.addTarget(self, action: #selector(handleSearchButtonOnTap(_:)), for: .touchUpInside)
    }
    
    @objc func handleSearchButtonOnTap(_ sender: UIButton) {
        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.condition_search_button)
        delegate?.searchConditionControllerDidSearch(self)
        appModalController()?.dismissControllerWithDefaultDuration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    @objc func handleRestoreButtonOnTapped() {
        sortSegmentedControl.selectedSegmentIndex = 0
        
        ratingViews[0].currentRate = 0
        ratingViews[1].currentRate = 0
        ratingViews[2].currentRate = 0
        ratingViews[3].currentRate = 0
        ratingViews[4].currentRate = 0
        ratingViews[5].currentRate = 0
        ratingViews[6].currentRate = 0
        
        businessCheckBoxOne.checkBox.checkState = .checked
    }
    
//    @objc func handleQuickSettingButtonOnTap(_ sender: UIButton) {
//        if sender == quickSettingButtonOne {
//            quickSettingButtonOne.isSelected = true
//            quickSettingButtonTwo.isSelected = false
//            quickSettingButtonThree.isSelected = false
//            ratingViews[0].currentRate = 4
//            ratingViews[1].currentRate = 3
//            ratingViews[2].currentRate = 3
//            ratingViews[3].currentRate = 4
//            ratingViews[4].currentRate = 3
//            ratingViews[5].currentRate = 3
//            ratingViews[6].currentRate = 4
//        } else if sender == quickSettingButtonTwo {
//            quickSettingButtonOne.isSelected = false
//            quickSettingButtonTwo.isSelected = true
//            quickSettingButtonThree.isSelected = false
//            ratingViews[0].currentRate = 3
//            ratingViews[1].currentRate = 3
//            ratingViews[2].currentRate = 4
//            ratingViews[3].currentRate = 3
//            ratingViews[4].currentRate = 4
//            ratingViews[5].currentRate = 3
//            ratingViews[6].currentRate = 4
//        } else if sender == quickSettingButtonThree {
//            quickSettingButtonOne.isSelected = false
//            quickSettingButtonTwo.isSelected = false
//            quickSettingButtonThree.isSelected = true
//            ratingViews[0].currentRate = 4
//            ratingViews[1].currentRate = 4
//            ratingViews[2].currentRate = 4
//            ratingViews[3].currentRate = 4
//            ratingViews[4].currentRate = 4
//            ratingViews[5].currentRate = 4
//            ratingViews[6].currentRate = 4
//        }
//    }
    
    @objc func handleBusinessCheckBoxTwoOnTap(_ sender: KPCheckBox) {
        if sender.checkState == .checked {
            let controller = KPModalViewController()
            controller.dismissWhenTouchingOnBackground = false
            controller.presentationStyle = .popout
            controller.contentSize = CGSize(width: 300, height: 350)
            controller.presentationStyle = .popout
            let timePickerController = KPTimePickerViewController()
            timePickerController.startTimeValue = (timeSupplementView.startTime != nil) ? timeSupplementView.startTime! : "10:30"
            timePickerController.endTimeValue = (timeSupplementView.endTime != nil) ? timeSupplementView.endTime! : "10:30"
            timePickerController.delegate = self
            timePickerController.setButtonTitles(["完成"])
            controller.contentController = timePickerController
            controller.presentModalView()
        }
    }
}


class KPSpecificTimeSupplementView: UIView {
    
    var startTime: String?
    var endTime: String?
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = "請選擇時段"
        return label
    }()
    
    lazy var baseline: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timeLabel)
        timeLabel.addConstraints(fromStringArray: ["V:|[$self]",
                                                   "H:|[$self]|"])
        
        addSubview(baseline)
        baseline.addConstraints(fromStringArray: ["V:[$view0]-4-[$self(1)]|",
                                                  "H:|[$self]|"],
                                views: [timeLabel])
    }
}


extension KPPreferenceSearchViewController: KPTimePickerViewControllerDelegate {
    func timePickerButtonDidTap(_ timePickerController: KPTimePickerViewController, selectedIndex index: Int) {
        timeSupplementView.startTime = timePickerController.startTimeValue
        timeSupplementView.endTime = timePickerController.endTimeValue
        timeSupplementView.timeLabel.text = "\(timePickerController.startTimeValue!)~\(timePickerController.endTimeValue!)"
    }
}
