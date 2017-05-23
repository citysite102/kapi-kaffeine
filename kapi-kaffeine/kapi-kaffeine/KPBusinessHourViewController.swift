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
    
    var heightConstraints = [NSLayoutConstraint]()
    
    lazy var timePicker: KPTimePicker = {
        let picker = KPTimePicker()
        picker.delegate = self
        return picker
    }()
    
    var currentTimePickerIndex: Int = -1
    
    var attrs = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 19.0),
        NSForegroundColorAttributeName : KPColorPalette.KPTextColor.grayColor_level3!,
        NSUnderlineStyleAttributeName : 1] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isScrollEnabled = true
        
        titleLabel.text = "請勾選/調整店家的營業時間"
        
        let days = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]
        
        for (index, title) in days.enumerated() {
            let checkView = KPCheckView.init(.checkmark, title)
            containerView.addSubview(checkView)
            checkBoxViews.append(checkView)
            containerView.addConstraint(forHeight: 500)
            if index == 0 {
                checkView.addConstraints(fromStringArray: ["H:|-16-[$self]", "V:|-24-[$self]"])
            } else {
//                checkView.addConstraints(fromStringArray: ["H:|-16-[$self]", "V:[$view0]-32-[$self]"],
//                                         views: [checkBoxViews[index-1]])
                checkView.addConstraint(from: "H:|-16-[$self]")
                heightConstraints.append(NSLayoutConstraint.init(item: checkView,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: checkBoxViews[index-1],
                                                                 attribute: .bottom,
                                                                 multiplier: 1,
                                                                 constant: 32))
                containerView.addConstraint(heightConstraints.last!)
            }
            
            let startTimeButton = UIButton()
            let attrstr = NSAttributedString.init(string: "08:00", attributes: attrs)
            startTimeButton.setAttributedTitle(attrstr, for: .normal)
            containerView.addSubview(startTimeButton)
            startTimeButton.addConstraintForCenterAligning(to: checkView, in: .vertical)
            startTimeButton.addTarget(self, action: #selector(startTimeSelectButtonOnTap(button:)), for: .touchUpInside)
            startTimeButton.tag = index
            
            let endTimeButton = UIButton()
            let attrstr1 = NSAttributedString.init(string: "20:00", attributes: attrs)
            endTimeButton.setAttributedTitle(attrstr1, for: .normal)
            containerView.addSubview(endTimeButton)
            endTimeButton.addConstraintForCenterAligning(to: checkView, in: .vertical)
            endTimeButton.addTarget(self, action: #selector(endTimeSelectButtonOnTap(button:)), for: .touchUpInside)
            endTimeButton.tag = index
            
            let label = UILabel()
            label.text = "至"
            label.textAlignment = .center
            label.textColor = KPColorPalette.KPMainColor.mainColor
            containerView.addSubview(label)
            label.addConstraintForCenterAligning(to: checkView, in: .vertical)
            
            startTimeButton.addConstraints(fromStringArray: ["H:[$view0]-(>=0)-[$self]-[$view1]-[$view2]-16-|"],
                                           views: [checkView, label, endTimeButton])
            
        }
        
//        heightConstraints.append(checkBoxViews.last!.addConstraint(from: "V:[$self]-16-|").first as! NSLayoutConstraint)
        
        
        sendButton.addTarget(self, action: #selector(closeTimePicker), for: .touchUpInside)
        
    }
    
    func closeTimePicker() {
        showTimePickerAtIndex(index: -1)
    }
    
    func startTimeSelectButtonOnTap(button: UIButton) {
        showTimePickerAtIndex(index: button.tag)
    }
    
    func endTimeSelectButtonOnTap(button: UIButton) {
        showTimePickerAtIndex(index: button.tag)
    }
    
    func showTimePickerAtIndex(index: Int) {
        if currentTimePickerIndex != -1 {
            // hide the current time picker
            heightConstraints[currentTimePickerIndex].constant = 32
            if timePicker.superview != nil {
                timePicker.removeFromSuperview()
            }
        }
        
//        UIView.animate(withDuration: 0.5, animations: { 
//            self.containerView.layoutIfNeeded()
//        }) { (complete) in
            if index != -1 {
                // show time picker at index
                self.containerView.addSubview(self.timePicker)
                self.timePicker.addConstraint(from: "V:[$view0][$self]", views:[self.checkBoxViews[index]])
                self.timePicker.addConstraintForCenterAligningToSuperview(in: .horizontal)
                self.heightConstraints[index].constant = 32 + self.timePicker.pickerRowHeight*3.5
                
            }
            
            self.currentTimePickerIndex = index
            
            UIView.animate(withDuration: 0.5) {
                self.containerView.layoutIfNeeded()
            }
//        }
        
        
        
    }
    
    func valueUpdate(value: String) {
        for view in containerView.subviews {
            if view.tag == currentTimePickerIndex, let button = view as? UIButton {
                let attrstr = NSAttributedString.init(string: value, attributes: attrs)
                button.setAttributedTitle(attrstr, for: .normal)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
