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

    weak var delegate: KPSearchConditionViewControllerDelegate?
    
    var dismissButton: UIButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    
    var conditionTitles = ["有 Wifi",
                           "有插座",
                           "無時間限制",
                           "站立工作"]
    
    var ratingViews = [KPRatingView]()
    var conditions = [KPItemCheckedView]()
    
    var sortTitleLabel: UILabel!
    var priceSettingTitleLabel: UILabel!
    var priceSettingDescriptionLabel: UILabel!
    var conditionTitleLabel: UILabel!
    var businessHourTitleLabel: UILabel!
    var businessHourResultLabel: UILabel!
    
    
    var sortSegmentedControl: KPSegmentedControl!
    var priceSegmentedControl: KPSegmentedControl!
    
    
    lazy var seperator_one: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    lazy var seperator_two: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    var selectAllButton: UIButton!
    
    var startSearchTime: String?
    var endSearchTime: String?
    
    var businessCheckBox: KPCheckView!
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
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
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
        sortTitleLabel = titleLabel("排序方式")
        containerView.addSubview(sortTitleLabel)
        sortTitleLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                        "V:|-24-[$self]"])
        
        sortSegmentedControl = KPSegmentedControl.init(["距離最近",
                                                        "評分最高"])
        sortSegmentedControl.selectedSegmentIndex = KPFilter.sharedFilter.sortedby == .distance ? 0 : 1
        containerView.addSubview(sortSegmentedControl)
        sortSegmentedControl.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                              "V:[$view0]-12-[$self(40)]"],
                                            views: [sortTitleLabel])
        
        priceSettingTitleLabel = titleLabel("價格區間")
        containerView.addSubview(priceSettingTitleLabel)
        priceSettingTitleLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:[$view0]-40-[$self]"],
                                         views: [sortSegmentedControl])
        
        priceSettingDescriptionLabel = UILabel()
        priceSettingDescriptionLabel.font = UIFont.systemFont(ofSize: 12.0)
        priceSettingDescriptionLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        priceSettingDescriptionLabel.text = "$=低於99元 / $$=100-199元 / $$$=高於200元"
        containerView.addSubview(priceSettingDescriptionLabel)
        priceSettingDescriptionLabel.addConstraints(fromStringArray: ["H:|-17-[$self]-16-|",
                                                                      "V:[$view0]-8-[$self]"],
                                             views: [priceSettingTitleLabel])
        
        
        priceSegmentedControl = KPSegmentedControl.init(["$ (3間)",
                                                         "$$ (25間)",
                                                         "$$$ (12間)"])
        priceSegmentedControl.selectedSegmentIndex = 0
        containerView.addSubview(priceSegmentedControl)
        priceSegmentedControl.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                               "V:[$view0]-8-[$self(40)]"],
                                            views: [priceSettingDescriptionLabel])
        
       
        containerView.addSubview(seperator_one)
        seperator_one.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:[$view0]-24-[$self(1)]"],
                                          views: [priceSegmentedControl])
        
        // Section 2
        conditionTitleLabel = titleLabel("特殊需求")
        containerView.addSubview(conditionTitleLabel)
        conditionTitleLabel.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                             "V:[$view0]-24-[$self]"],
                                                views: [seperator_one])
        
        
        selectAllButton = UIButton()
        selectAllButton?.setTitle("全選",
                                  for: .normal)
        selectAllButton?.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_description,
                                       for: .normal)
        selectAllButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        selectAllButton.addTarget(self,
                                  action: #selector(handleSelectAllButtonOnTapped), for: .touchUpInside)
        containerView.addSubview(selectAllButton)
        let _ = selectAllButton?.addConstraintForCenterAligning(to: conditionTitleLabel,
                                                        in: .vertical)
        let _ = selectAllButton?.addConstraints(fromStringArray: ["H:[$self]-16-|"])
        
        for (index, title) in conditionTitles.enumerated() {
            
            let condition = KPItemCheckedView(title)
            conditions.append(condition)
            containerView.addSubview(condition)
            
            if index == 0 {
                condition.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                           "V:[$view0]-12-[$self]"],
                                          views: [conditionTitleLabel])
            } else {
                condition.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                           "V:[$view0]-12-[$self]"],
                                          views: [conditions[index-1]])
            }
        }
        
        containerView.addSubview(seperator_two)
        seperator_two.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:[$view0]-24-[$self(1)]"],
                                          views: [conditions.last!])
        
        businessHourTitleLabel = titleLabel("營業時間")
        containerView.addSubview(businessHourTitleLabel)
        businessHourTitleLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:[$view0]-24-[$self]"],
                                                views: [seperator_two])
        
        businessHourResultLabel = UILabel()
        businessHourResultLabel.font = UIFont.systemFont(ofSize: 16.0)
        businessHourResultLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        businessHourResultLabel.text = "從 8:00 營業至 19:00"
        containerView.addSubview(businessHourResultLabel)
        businessHourResultLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:[$view0]-8-[$self]-136-|"],
                                              views: [businessHourTitleLabel])
        

        businessCheckBox = KPCheckView(.checkmark, "目前營業中")
        containerView.addSubview(businessCheckBox)
        businessCheckBox.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                          "V:[$view0]-16-[$self]"],
                                        views: [businessHourResultLabel])

        searchButtonContainer = UIView()
        searchButtonContainer.backgroundColor = UIColor.white
        view.addSubview(searchButtonContainer)
        searchButtonContainer.addConstraints(fromStringArray: ["V:[$self]|",
                                                               "H:|[$self]|"])
        searchButtonContainer.addSubview(seperator_three)
        seperator_three.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self(1)]"])
        
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
    
    @objc func handleSelectAllButtonOnTapped() {
        for condition in conditions {
            condition.checkBox.checkState = .checked
        }
    }
    
    @objc func handleRestoreButtonOnTapped() {
        sortSegmentedControl.selectedSegmentIndex = 0
        priceSegmentedControl.selectedSegmentIndex = 0
        for condition in conditions {
            condition.checkBox.checkState = .unchecked
        }
        businessCheckBox.checkBox.checkState = .unchecked
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
