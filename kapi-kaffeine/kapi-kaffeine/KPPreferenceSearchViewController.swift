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
    
    var slider: RangeSlider!
    
    
    lazy var separator_one: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    lazy var separator_two: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    var selectAllButton: UIButton!
    
    var startSearchTime: String?
    var endSearchTime: String?
    
    var businessCheckBox: KPCheckView!
    var businessCheckBox_two: KPCheckView!
    var timeSupplementView: KPSpecificTimeSupplementView!
    
    lazy var separator_three: UIView = {
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        button.layer.cornerRadius = 18.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = KPColorPalette.KPMainColor_v2.mainColor?.cgColor
        button.layer.masksToBounds = true
        return button
    }
    
    func titleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: KPFontSize.header,
                                       weight: UIFont.Weight.regular)
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
        navigationController?.navigationBar.topItem?.title = "偏好篩選"
        
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: KPColorPalette.KPTextColor_v2.mainColor_title!,
//                                                                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32)]
//        } else {
//            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: KPColorPalette.KPTextColor_v2.mainColor_title!,
//                                                                       NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32)]
//        }
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
    
        let barRightItem = UIBarButtonItem(title: "清除",
                                           style: .plain,
                                           target: self,
                                           action: #selector(handleRestoreButtonOnTapped))
        barRightItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.mainContent)], for: .normal)
        
        let barLeftItem = UIBarButtonItem(title: "取消",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleDismissButtonOnTapped))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.mainContent), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        
        navigationItem.rightBarButtonItem = barRightItem
        navigationItem.leftBarButtonItem = barLeftItem
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                    "H:|[$self]|"])
        
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
                                                              "V:[$view0]-16-[$self(40)]"],
                                            views: [sortTitleLabel])
        
        priceSettingTitleLabel = titleLabel("價格區間")
        containerView.addSubview(priceSettingTitleLabel)
        priceSettingTitleLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:[$view0]-32-[$self]"],
                                         views: [sortSegmentedControl])
        
        priceSettingDescriptionLabel = UILabel()
        priceSettingDescriptionLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        priceSettingDescriptionLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        priceSettingDescriptionLabel.text = "$=低於99元 / $$=100-199元 / $$$=高於200元"
        containerView.addSubview(priceSettingDescriptionLabel)
        priceSettingDescriptionLabel.addConstraints(fromStringArray: ["H:|-18-[$self]-16-|",
                                                                      "V:[$view0]-10-[$self]"],
                                             views: [priceSettingTitleLabel])
        
        
        priceSegmentedControl = KPSegmentedControl.init(["$ (3間)",
                                                         "$$ (25間)",
                                                         "$$$ (12間)"])
        priceSegmentedControl.selectedSegmentIndex = 0
        containerView.addSubview(priceSegmentedControl)
        priceSegmentedControl.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                               "V:[$view0]-12-[$self(40)]"],
                                            views: [priceSettingDescriptionLabel])
        
       
        containerView.addSubview(separator_one)
        separator_one.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:[$view0]-24-[$self(1)]"],
                                          views: [priceSegmentedControl])
        
        // Section 2
        conditionTitleLabel = titleLabel("特殊需求")
        containerView.addSubview(conditionTitleLabel)
        conditionTitleLabel.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                             "V:[$view0]-24-[$self]"],
                                                views: [separator_one])
        
        
        selectAllButton = UIButton()
        selectAllButton?.setTitle("全選",
                                  for: .normal)
        selectAllButton?.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_description,
                                       for: .normal)
        selectAllButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: KPFontSize.subContent)
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
                condition.addConstraints(fromStringArray: ["H:|-17-[$self]-16-|",
                                                           "V:[$view0]-16-[$self]"],
                                          views: [conditionTitleLabel])
            } else {
                condition.addConstraints(fromStringArray: ["H:|-17-[$self]-16-|",
                                                           "V:[$view0]-12-[$self]"],
                                          views: [conditions[index-1]])
            }
        }
        
        containerView.addSubview(separator_two)
        separator_two.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:[$view0]-24-[$self(1)]"],
                                          views: [conditions.last!])
        
        businessHourTitleLabel = titleLabel("營業時間")
        containerView.addSubview(businessHourTitleLabel)
        businessHourTitleLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:[$view0]-24-[$self]"],
                                                views: [separator_two])
        
        
        
        businessCheckBox = KPCheckView(.checkmark, "目前營業中")
        containerView.addSubview(businessCheckBox)
        businessCheckBox.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                          "V:[$view0]-24-[$self(24)]"],
                                        views: [businessHourTitleLabel])
        
        businessCheckBox_two = KPCheckView(.checkmark, "特定時間")
        containerView.addSubview(businessCheckBox_two)
        businessCheckBox_two.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                              "V:[$view0]-16-[$self(24)]"],
                                            views: [businessCheckBox])
        
        businessCheckBox.deselectCheckViews = [businessCheckBox_two]
        businessCheckBox_two.deselectCheckViews = [businessCheckBox]
        businessCheckBox_two.checkBox.addTarget(self,
                                                action: #selector(handleSpecificCheckBoxOnChanged(_:)),
                                                for: .valueChanged)
        
        
        businessHourResultLabel = UILabel()
        businessHourResultLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        businessHourResultLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        businessHourResultLabel.text = "從 8:00 營業至 19:00"
        containerView.addSubview(businessHourResultLabel)
        businessHourResultLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:[$view0]-32-[$self]"],
                                              views: [businessCheckBox_two])
        
        slider = RangeSlider()
        slider.maximumValue = 144
        slider.minimumValue = 0
        slider.upperValue = 114
        slider.lowerValue = 48
        slider.trackHighlightTintColor = KPColorPalette.KPMainColor_v2.mainColor_light!
        containerView.addSubview(slider)
        slider.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                "V:[$view0]-12-[$self(32)]-100-|"],
                                   views: [businessHourResultLabel])
        slider.addTarget(self,
                         action: #selector(rangeSliderValueChanged(_:)),
                         for: .valueChanged)
        
        businessHourResultLabel.alpha = 0.5
        slider.alpha = 0.5
        slider.isUserInteractionEnabled = false

        searchButtonContainer = UIView()
        searchButtonContainer.backgroundColor = UIColor.white
        view.addSubview(searchButtonContainer)
        searchButtonContainer.addConstraints(fromStringArray: ["V:[$self]|",
                                                               "H:|[$self]|"])
        searchButtonContainer.addSubview(separator_three)
        separator_three.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self(1)]"])
        
        searchButton = UIButton()
        searchButton.setTitle("開始搜尋", for: .normal)
        searchButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor_light, for: .normal)
        searchButton.layer.cornerRadius = 4.0
        searchButton.layer.masksToBounds = true
        searchButton.layer.borderWidth = 1.0
        searchButton.layer.borderColor = KPColorPalette.KPMainColor_v2.mainColor?.cgColor
        searchButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                   for: .normal)
        searchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: KPFontSize.subContent)
        searchButtonContainer.addSubview(searchButton)
        searchButton.addConstraints(fromStringArray: ["V:[$view0]-12-[$self(40)]-12-|",
                                                      "H:|-16-[$self]-16-|"],
                                         views: [separator_three])
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
    
    @objc func handleSpecificCheckBoxOnChanged(_ sender: KPCheckBox) {
        if sender.checkState == .checked {
            businessHourResultLabel.alpha = 1.0
            slider.alpha = 1.0
            slider.isUserInteractionEnabled = true
        } else {
            businessHourResultLabel.alpha = 0.5
            slider.alpha = 0.5
            slider.isUserInteractionEnabled = false
        }
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
    
    @objc func rangeSliderValueChanged(_ sender: RangeSlider) {
        businessHourResultLabel.text = "從 \(Int(floor(sender.lowerValue/6))):\(Int(sender.lowerValue) % 6)0 營業至 \(Int(floor(sender.upperValue/6))):\(Int(sender.upperValue) % 6)0"
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
        label.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
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
