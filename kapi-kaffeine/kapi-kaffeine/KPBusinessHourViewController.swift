//
//  KPBusinessHourViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 16/05/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPBusinessHourViewController: KPSharedSettingViewController, KPTimePickerDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        scrollView.isScrollEnabled = true
        
        titleLabel.text = "請勾選/調整店家的營業時間"
        
        let days = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]
        
        for (index, title) in days.enumerated() {
            let container = UIView()
            container.backgroundColor = UIColor.clear
            containerView.addSubview(container)
            subContainers.append(container)
            
            let checkView = KPCheckView(.checkmark, title)
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
                             action: #selector(KPCountrySelectController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        
    }
    
    func startTimeSelectButtonOnTap(button: UIButton) {
        currentSelectedButton = button
        showTimePicker()
    }
    
    func endTimeSelectButtonOnTap(button: UIButton) {
        currentSelectedButton = button
        showTimePicker()
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
    
    func showTimePicker() {
        
        let controller = KPModalViewController()
        controller.presentationStyle = .popout
        controller.contentSize = CGSize(width: 300, height: 300)
        controller.presentationStyle = .popout
        let timePickerController = KPTimePickerViewController()
        if let timeValue = currentSelectedButton?.titleLabel?.attributedText?.string {
            timePickerController.timeValue = timeValue
        }
        timePickerController.businessHourController = self
        controller.contentController = timePickerController;
        controller.presentModalView()
        
    }
    
    func valueUpdate(timePicker: KPTimePicker, value: String) {
        if currentSelectedButton != nil {
            currentSelectedButton!.setAttributedTitle(NSAttributedString(string: value, attributes: editAttrs),
                                                      for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSendButtonOnTapped() {
        delegate?.sendButtonTapped(self)
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    

}
