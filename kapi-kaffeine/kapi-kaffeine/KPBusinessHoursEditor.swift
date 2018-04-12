//
//  KPBusinessHoursEditor.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 11/02/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol KPBusinessHoursEditorDelegate: class {
    func deleteHoursEditor(_ editor: KPBusinessHoursEditor)
}

class KPBusinessHoursEditor: UIView {
    
    enum Day: String {
        case Monday = "星期一"
        case Tuesday = "星期二"
        case Wednesday = "星期三"
        case Thursday = "星期四"
        case Friday = "星期五"
        case Saturday = "星期六"
        case Sunday = "星期日"
        
        static let allValues = [KPBusinessHoursEditor.Day.Monday,
                                KPBusinessHoursEditor.Day.Tuesday,
                                KPBusinessHoursEditor.Day.Wednesday,
                                KPBusinessHoursEditor.Day.Thursday,
                                KPBusinessHoursEditor.Day.Friday,
                                KPBusinessHoursEditor.Day.Saturday,
                                KPBusinessHoursEditor.Day.Sunday]
    }
    
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    let time1Label = UILabel()
    let time2Label = UILabel()
    
    let mondayButton = dayButtonWithTitle(Day.Monday.rawValue)
    let tuesdayButton = dayButtonWithTitle(Day.Tuesday.rawValue)
    let wednesdayButton = dayButtonWithTitle(Day.Wednesday.rawValue)
    let thursdayButton = dayButtonWithTitle(Day.Thursday.rawValue)
    let fridayButton = dayButtonWithTitle(Day.Friday.rawValue)
    let saturdayButton = dayButtonWithTitle(Day.Saturday.rawValue)
    let sundayButton = dayButtonWithTitle(Day.Sunday.rawValue)
    let rangeSlider = RangeSlider()

    let deleteButton = UIButton()
    
    var delegate: KPBusinessHoursEditorDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundColor = UIColor.white
        
        titleLabel.text = "營業時段"
        titleLabel.font = UIFont.systemFont(ofSize: KPFontSize.sub_header,
                                            weight: UIFont.Weight.regular)
        titleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        
        addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:|-20-[$self]"])
        
        addSubview(mondayButton)
        mondayButton.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-16-[$self]"],
                                    views: [titleLabel])
        
        tuesdayButton.isSelected = true
        addSubview(tuesdayButton)
        tuesdayButton.addConstraints(fromStringArray: ["H:[$view0]-[$self]"],
                                     views: [mondayButton])
        tuesdayButton.addConstraintForCenterAligning(to: mondayButton, in: .vertical)
        
        wednesdayButton.isSelected = true
        addSubview(wednesdayButton)
        wednesdayButton.addConstraints(fromStringArray: ["H:[$view0]-[$self]"],
                                       views: [tuesdayButton])
        wednesdayButton.addConstraintForCenterAligning(to: mondayButton, in: .vertical)
        
        thursdayButton.isSelected = true
        addSubview(thursdayButton)
        thursdayButton.addConstraints(fromStringArray: ["H:[$view0]-[$self]-20-|"],
                                      views: [wednesdayButton])
        thursdayButton.addConstraintForCenterAligning(to: mondayButton, in: .vertical)
        
        fridayButton.isSelected = true
        addSubview(fridayButton)
        fridayButton.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-[$self]"],
                                    views: [mondayButton])
        
        saturdayButton.isSelected = true
        addSubview(saturdayButton)
        saturdayButton.addConstraints(fromStringArray: ["H:[$view0]-[$self]"],
                                      views: [fridayButton])
        saturdayButton.addConstraintForCenterAligning(to: fridayButton, in: .vertical)
        
        sundayButton.isSelected = true
        addSubview(sundayButton)
        sundayButton.addConstraints(fromStringArray: ["H:[$view0]-[$self]"],
                                    views: [saturdayButton])
        sundayButton.addConstraintForCenterAligning(to: fridayButton, in: .vertical)
        
        mondayButton.addConstraintForHavingSameWidth(with: tuesdayButton)
        mondayButton.addConstraintForHavingSameWidth(with: wednesdayButton)
        mondayButton.addConstraintForHavingSameWidth(with: thursdayButton)
        mondayButton.addConstraintForHavingSameWidth(with: fridayButton)
        mondayButton.addConstraintForHavingSameWidth(with: saturdayButton)
        mondayButton.addConstraintForHavingSameWidth(with: sundayButton)
        
        
        let timeTitleLabel = UILabel()
        timeTitleLabel.text = "選擇營業時段"
        
        timeTitleLabel.font = UIFont.systemFont(ofSize: KPFontSize.sub_header,
                                            weight: UIFont.Weight.regular)
        timeTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        
        addSubview(timeTitleLabel)
        timeTitleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-30-[$self]"],
                                      views: [sundayButton])
        
        
        
        timeLabel.text = "從 8:00 營業至 19:00"
        timeLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        timeLabel.font = UIFont.systemFont(ofSize: 16,
                                           weight: UIFont.Weight.light)
        addSubview(timeLabel)
        timeLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-10-[$self]"],
                                 views: [timeTitleLabel])
        
        time1Label.text = "00:00"
        time1Label.textColor = KPColorPalette.KPTextColor_v2.mainColor_hint
        addSubview(time1Label)
        time1Label.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-20-[$self]"],
                                  views: [timeLabel])
        
        time2Label.text = "24:00"
        time2Label.textColor = KPColorPalette.KPTextColor_v2.mainColor_hint
        addSubview(time2Label)
        time2Label.addConstraints(fromStringArray: ["H:[$self]-20-|"])
        time2Label.addConstraintForCenterAligning(to: time1Label, in: .vertical)

        
        rangeSlider.maximumValue = 144
        rangeSlider.minimumValue = 0
        rangeSlider.upperValue = 114
        rangeSlider.lowerValue = 48
        rangeSlider.trackHighlightTintColor = KPColorPalette.KPMainColor_v2.mainColor_light!
        addSubview(rangeSlider)
        rangeSlider.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-4-[$self(32)]"],
                                   views: [time1Label])
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)),
                              for: .valueChanged)
        
        
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: rangeSlider.bottomAnchor, constant: 10),
            deleteButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        deleteButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = 3
        deleteButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.redColor!), for: .normal)
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.setTitle("刪除此營業時段", for: .normal)
        deleteButton.addTarget(self, action: #selector(handleDeleteButtonOnTap(_:)), for: .touchUpInside)
    }
    
    static func dayButtonWithTitle(_ title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.grayColor_level7!),
                                  for: .normal)
        button.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.mainColor_light!),
                                  for: .selected)
        button.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_hint_light,
                             for: .normal)
        button.setTitleColor(KPColorPalette.KPTextColor_v2.whiteColor,
                             for: .selected)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addConstraint(forHeight: 40)
        button.addTarget(self, action: #selector(dayButtonOnTap(_:)), for: .touchUpInside)
        return button
    }
    
    func outputValue(with index: Int) -> [String: String] {
        
        var output: [String: String] = [:]
        
        let open  = "\(Int(floor(rangeSlider.lowerValue/6))):\(Int(rangeSlider.lowerValue) % 6)0"
        let close = "\(Int(floor(rangeSlider.upperValue/6))):\(Int(rangeSlider.upperValue) % 6)0"
        
        if mondayButton.isSelected {
            output["mon_\(index)_open"]  = open
            output["mon_\(index)_close"] = close
        }
        
        if tuesdayButton.isSelected {
            output["tue_\(index)_open"]  = open
            output["tue_\(index)_close"] = close
        }
        
        if wednesdayButton.isSelected {
            output["wed_\(index)_open"]  = open
            output["wed_\(index)_close"] = close
        }
        
        if thursdayButton.isSelected {
            output["thu_\(index)_open"]  = open
            output["thu_\(index)_close"] = close
        }
        
        if fridayButton.isSelected {
            output["fri_\(index)_open"]  = open
            output["fri_\(index)_close"] = close
        }
        
        if saturdayButton.isSelected {
            output["sat_\(index)_open"]  = open
            output["sat_\(index)_close"] = close
        }
        
        if sundayButton.isSelected {
            output["sun_\(index)_open"]  = open
            output["sun_\(index)_close"] = close
        }
        
        return output
    }
    
    @objc func rangeSliderValueChanged(_ sender: RangeSlider) {
        timeLabel.text = "從 \(Int(floor(sender.lowerValue/6))):\(Int(sender.lowerValue) % 6)0 營業至 \(Int(floor(sender.upperValue/6))):\(Int(sender.upperValue) % 6)0"
    }
    
    @objc static func dayButtonOnTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func handleDeleteButtonOnTap(_ sender: UIButton) {
        delegate?.deleteHoursEditor(self)
    }
    
}
