//
//  KPBusinessHoursEditor.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 11/02/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

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
    
    let dayButtons = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        titleLabel.text = "營業時段"
        titleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        titleLabel.font = UIFont.systemFont(ofSize: 20,
                                            weight: UIFont.Weight.light)
        addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:|-20-[$self]"])
        
        let mondayButton = dayButtonWithTitle(Day.Monday.rawValue)
        addSubview(mondayButton)
        mondayButton.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-16-[$self]"],
                                    views: [titleLabel])
        
        let tuesdayButton = dayButtonWithTitle(Day.Tuesday.rawValue)
        addSubview(tuesdayButton)
        tuesdayButton.addConstraints(fromStringArray: ["H:[$view0]-[$self]"],
                                     views: [mondayButton])
        tuesdayButton.addConstraintForCenterAligning(to: mondayButton, in: .vertical)
        
        let wednesdayButton = dayButtonWithTitle(Day.Wednesday.rawValue)
        addSubview(wednesdayButton)
        wednesdayButton.addConstraints(fromStringArray: ["H:[$view0]-[$self]"],
                                       views: [tuesdayButton])
        wednesdayButton.addConstraintForCenterAligning(to: mondayButton, in: .vertical)
        
        let thursdayButton = dayButtonWithTitle(Day.Thursday.rawValue)
        addSubview(thursdayButton)
        thursdayButton.addConstraints(fromStringArray: ["H:[$view0]-[$self]-20-|"],
                                      views: [wednesdayButton])
        thursdayButton.addConstraintForCenterAligning(to: mondayButton, in: .vertical)
        
        let fridayButton = dayButtonWithTitle(Day.Friday.rawValue)
        addSubview(fridayButton)
        fridayButton.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-[$self]"],
                                    views: [mondayButton])
        
        let saturdayButton = dayButtonWithTitle(Day.Saturday.rawValue)
        addSubview(saturdayButton)
        saturdayButton.addConstraints(fromStringArray: ["H:[$view0]-[$self]"],
                                      views: [fridayButton])
        saturdayButton.addConstraintForCenterAligning(to: fridayButton, in: .vertical)
        
        let sundayButton = dayButtonWithTitle(Day.Sunday.rawValue)
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
        timeTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        timeTitleLabel.font = UIFont.systemFont(ofSize: 20,
                                                weight: UIFont.Weight.light)
        addSubview(timeTitleLabel)
        timeTitleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-30-[$self]"],
                                      views: [sundayButton])
        
        
        let timeLabel = UILabel()
        timeLabel.text = "從 8:00 營業至 19:00"
        timeLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        timeLabel.font = UIFont.systemFont(ofSize: 16,
                                           weight: UIFont.Weight.light)
        addSubview(timeLabel)
        timeLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-10-[$self]"],
                                 views: [timeTitleLabel])
        
        let time1Label = UILabel()
        time1Label.text = "00:00"
        time1Label.textColor = KPColorPalette.KPTextColor_v2.mainColor_hint
        addSubview(time1Label)
        time1Label.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-20-[$self]"],
                                  views: [timeLabel])
        
        let time2Label = UILabel()
        time2Label.text = "24:00"
        time2Label.textColor = KPColorPalette.KPTextColor_v2.mainColor_hint
        addSubview(time2Label)
        time2Label.addConstraints(fromStringArray: ["H:[$self]-20-|"])
        time2Label.addConstraintForCenterAligning(to: time1Label, in: .vertical)

        
        let rangeSlider = RangeSlider()
        addSubview(rangeSlider)
        rangeSlider.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-4-[$self(40)]-20-|"],
                                   views: [time1Label])
        

    }
    
    func dayButtonWithTitle(_ title: String) -> UIButton {
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
    
    @objc func dayButtonOnTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
