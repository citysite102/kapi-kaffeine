//
//  KPBusinessHourViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 16/05/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPBusinessHourViewController: KPSharedSettingViewController, KPTimePickerViewControllerDelegate {
    
    var checkBoxViews = [KPCheckView]()
    var startTimeButtons = [UIButton]()
    var endTimeButtons = [UIButton]()
    var subContainers = [UIView]()
    
    var currentSelectedButton: UIButton?
    
    var attrs = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 19.0),
        NSForegroundColorAttributeName : KPColorPalette.KPTextColor.grayColor_level3!,
        NSUnderlineStyleAttributeName : 1] as [String : Any]
    
    var editAttrs = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 19.0),
        NSForegroundColorAttributeName : KPColorPalette.KPTextColor.mainColor!,
        NSUnderlineStyleAttributeName : 1] as [String : Any]
    
    var defaultBusinessHour: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        scrollView.isScrollEnabled = true
        
        titleLabel.text = "勾選/調整店家的營業時間"
        
        let days = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]
        
        for (index, title) in days.enumerated() {
            let container = UIView()
            container.backgroundColor = UIColor.clear
            containerView.addSubview(container)
            subContainers.append(container)
            
            let checkView = KPCheckView(.checkmark, title)
            checkView.checkBox.checkState = .checked
            container.addSubview(checkView)
            checkBoxViews.append(checkView)
            checkView.checkBox.addTarget(self, action: #selector(handleCheckBoxOnTap(checkBox:)), for: .valueChanged)
            checkView.checkBox.tag = index

            if index == 0 {
                container.addConstraints(fromStringArray: ["H:|[$self]|", "V:|-24-[$self]"])
            } else {
                container.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-32-[$self]"],
                                         views: [subContainers[index-1]])
            }
            
            let startTimeButton = UIButton()
            let attrstr = NSAttributedString(string: "08:00", attributes: attrs)
            startTimeButton.setAttributedTitle(attrstr, for: .normal)
            container.addSubview(startTimeButton)
            startTimeButton.addConstraintForCenterAligning(to: checkView, in: .vertical)
            startTimeButton.addTarget(self, action: #selector(startTimeSelectButtonOnTap(button:)), for: .touchUpInside)
            startTimeButton.tag = index
            startTimeButtons.append(startTimeButton)
            
            let endTimeButton = UIButton()
            let attrstr1 = NSAttributedString(string: "20:00", attributes: attrs)
            endTimeButton.setAttributedTitle(attrstr1, for: .normal)
            container.addSubview(endTimeButton)
            endTimeButton.addConstraintForCenterAligning(to: checkView, in: .vertical)
            endTimeButton.addTarget(self, action: #selector(endTimeSelectButtonOnTap(button:)), for: .touchUpInside)
            endTimeButton.tag = index
            endTimeButtons.append(endTimeButton)
            
            let label = UILabel()
            label.text = "至"
            label.textAlignment = .center
            label.textColor = KPColorPalette.KPTextColor.mainColor
            container.addSubview(label)
            label.addConstraintForCenterAligning(to: checkView, in: .vertical)
            
            startTimeButton.addConstraints(fromStringArray: ["H:|-16-[$view0]-(>=0)-[$self]-[$view1]-[$view2]-16-|",
                                                             "V:|[$view0]|"],
                                           views: [checkView, label, endTimeButton])
            
        }
        

        subContainers.last!.addConstraint(from: "V:[$self]-16-|")
        
        sendButton.setTitle("確認送出", for: .normal)
        sendButton.addTarget(self,
                             action: #selector(handleSendButtonOnTapped),
                             for: .touchUpInside)
        
        if let businessHour = defaultBusinessHour {
            setBusinessHour(businessHour)
        }
        
    }
    
    func setBusinessHour(_ businessHour: [String: String]?) {
        
        if let businessHour = businessHour {
            
            if checkBoxViews.count == 0 {
                defaultBusinessHour = businessHour
                return
            }
            
            for checkBoxView in self.checkBoxViews {
                checkBoxView.checkBox.checkState = .unchecked
            }
            
            for subcontainer in self.subContainers {
                subcontainer.alpha = 0.6
            }
            
            for (key, time) in businessHour {
                let components = key.components(separatedBy: "_")
                let day = KPDay(rawValue: components.first!)!
                
                var dayNumber: Int!
                switch day {
                case .Monday:
                    dayNumber = 0
                case .Tuesday:
                    dayNumber = 1
                case .Wednesday:
                    dayNumber = 2
                case .Thursday:
                    dayNumber = 3
                case .Friday:
                    dayNumber = 4
                case .Saturday:
                    dayNumber = 5
                case .Sunday:
                    dayNumber = 6
                }
                
                self.checkBoxViews[dayNumber].checkBox.checkState = .checked
                self.subContainers[dayNumber].alpha = 1
                
                if components[2] == "open" {
                    self.startTimeButtons[dayNumber].setAttributedTitle(NSAttributedString(string: time, attributes: self.editAttrs),
                                                                                            for: .normal)
                } else if components[2] == "close" {
                    self.endTimeButtons[dayNumber].setAttributedTitle(NSAttributedString(string: time, attributes: self.editAttrs),
                                                                      for: .normal)
                }
                
            }
        }
    }
    
    override func handleDismissButtonOnTapped() {
        self.setBusinessHour(returnValue as? [String: String])
        super.handleDismissButtonOnTapped()
    }
    
    func startTimeSelectButtonOnTap(button: UIButton) {
        currentSelectedButton = button
        showTimePicker(0)
    }
    
    func endTimeSelectButtonOnTap(button: UIButton) {
        currentSelectedButton = button
        showTimePicker(1)
    }
    
    func handleCheckBoxOnTap(checkBox: KPCheckBox) {
        if checkBox.checkState == .checked {
            startTimeButtons[checkBox.tag].isEnabled = true
            endTimeButtons[checkBox.tag].isEnabled = true
            subContainers[checkBox.tag].alpha = 1
        } else {
            startTimeButtons[checkBox.tag].isEnabled = false
            endTimeButtons[checkBox.tag].isEnabled = false
            subContainers[checkBox.tag].alpha = 0.6
        }
    }
    
    func showTimePicker(_ index: Int) {
        
        let controller = KPModalViewController()
        controller.presentationStyle = .popout
        controller.contentSize = CGSize(width: 300, height: 350)
        controller.presentationStyle = .popout
        let timePickerController = KPTimePickerViewController()
        timePickerController.tabView.currentIndex = index
        timePickerController.setButtonTitles(["設定全部", "完成"])
        timePickerController.delegate = self
        timePickerController.startTimeValue = startTimeButtons[currentSelectedButton!.tag].titleLabel?.attributedText?.string
        timePickerController.endTimeValue = endTimeButtons[currentSelectedButton!.tag].titleLabel?.attributedText?.string
        controller.contentController = timePickerController
        controller.presentModalView()
        
    }
    
    func updateTimeValue(startTime startTimeValue: String, endTime endTimeValue: String) {
        if currentSelectedButton != nil {
            startTimeButtons[currentSelectedButton!.tag].setAttributedTitle(NSAttributedString(string: startTimeValue, attributes: editAttrs),
                                                                            for: .normal)
            endTimeButtons[currentSelectedButton!.tag].setAttributedTitle(NSAttributedString(string: endTimeValue, attributes: editAttrs),
                                                                          for: .normal)
        }
    }
    
    func updateAllTimeValue(startTime startTimeValue: String, endTime endTimeValue: String) {
        for (index, _) in checkBoxViews.enumerated() {
            startTimeButtons[index].setAttributedTitle(NSAttributedString(string: startTimeValue, attributes: editAttrs),
                                                       for: .normal)
            endTimeButtons[index].setAttributedTitle(NSAttributedString(string: endTimeValue, attributes: editAttrs),
                                                     for: .normal)
        }
    }
    
    func timePickerButtonDidTap(_ timePickerController: KPTimePickerViewController, selectedIndex index: Int) {
        if index == 1 {
            self.updateTimeValue(startTime: timePickerController.startTimeValue,
                                 endTime: timePickerController.endTimeValue)
        } else if index == 0 {
            self.updateAllTimeValue(startTime: timePickerController.startTimeValue,
                                    endTime: timePickerController.endTimeValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSendButtonOnTapped() {
        var value: [String: String] = [:]
        for (index, checkBoxView) in checkBoxViews.enumerated() {
            if checkBoxView.checkBox.checkState == .checked {
                let dayShortHands = KPDataBusinessHourModel.getShortHands(withDay: checkBoxView.titleLabel.text!).rawValue
                value["\(dayShortHands)_1_open"] = self.startTimeButtons[index].titleLabel?.text
                value["\(dayShortHands)_1_close"] = self.endTimeButtons[index].titleLabel?.text
            }
        }
        returnValue = value
        delegate?.returnValueSet(self)
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    

}
