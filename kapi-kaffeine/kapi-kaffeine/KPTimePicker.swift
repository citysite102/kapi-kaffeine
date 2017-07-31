//
//  KPTimePicker.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol KPTimePickerDelegate: class {
    func valueUpdate(timePicker: KPTimePicker, value: String)
}

class KPTimePicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerRowHeight: CGFloat = 60
    
    var pickerView: UIPickerView!
    
    weak var delegate: KPTimePickerDelegate?
    
    var timeValue: String {
        get {
            return "\(String(format: "%02d", pickerView.selectedRow(inComponent: 0))):\(String(format: "%02d", pickerView.selectedRow(inComponent: 1)*15))"
        }
        set {
            let components = newValue.components(separatedBy: ":")
            if let hour = Int(components.first!) {
                pickerView.selectRow(hour < 24 ? hour: 0, inComponent: 0, animated: true)
            }
            
            if let minute = Int(components.last!) {
                pickerView.selectRow(minute/15, inComponent: 1, animated: true)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        pickerView = UIPickerView()
        self.addSubview(pickerView)
        
        pickerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        pickerView.dataSource = self
        pickerView.delegate = self
        
//        let separatorLine = UIView()
//        separatorLine.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
//        pickerView.addSubview(separatorLine)
//        pickerView.addConstraint(NSLayoutConstraint(item: separatorLine, attribute: .bottom, relatedBy: .equal, toItem: pickerView, attribute: .bottom, multiplier: 0.357, constant: 0))
//        separatorLine.addConstraintForCenterAligningToSuperview(in: .horizontal)
//        separatorLine.addConstraint(forWidth: 50)
//        separatorLine.addConstraint(forHeight: 2)
//        
//        let separatorLine1 = UIView()
//        separatorLine1.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
//        pickerView.addSubview(separatorLine1)
//        pickerView.addConstraint(NSLayoutConstraint(item: separatorLine1, attribute: .bottom, relatedBy: .equal, toItem: pickerView, attribute: .bottom, multiplier: 0.643, constant: 0))
//        separatorLine1.addConstraintForCenterAligningToSuperview(in: .horizontal)
//        separatorLine1.addConstraint(forWidth: 50)
//        separatorLine1.addConstraint(forHeight: 2)
        
        let separatorLine1_top = UIView()
        separatorLine1_top.backgroundColor = KPColorPalette.KPMainColor.mainColor
        pickerView.addSubview(separatorLine1_top)
        pickerView.addConstraint(NSLayoutConstraint(item: separatorLine1_top, attribute: .bottom, relatedBy: .equal, toItem: pickerView, attribute: .bottom, multiplier: 0.357, constant: 0))

        separatorLine1_top.addConstraint(from: "H:|-(77)-[$self]")
        separatorLine1_top.addConstraint(forWidth: 50)
        separatorLine1_top.addConstraint(forHeight: 2)
        
        let separatorLine1_bottom = UIView()
        separatorLine1_bottom.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
        pickerView.addSubview(separatorLine1_bottom)
        pickerView.addConstraint(NSLayoutConstraint(item: separatorLine1_bottom, attribute: .bottom, relatedBy: .equal, toItem: pickerView, attribute: .bottom, multiplier: 0.643, constant: 0))
        separatorLine1_bottom.addConstraint(from: "H:|-(77)-[$self]")
        separatorLine1_bottom.addConstraint(forWidth: 50)
        separatorLine1_bottom.addConstraint(forHeight: 2)
        
        
        let separatorLine3_top = UIView()
        separatorLine3_top.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
        pickerView.addSubview(separatorLine3_top)
        pickerView.addConstraint(NSLayoutConstraint(item: separatorLine3_top, attribute: .bottom, relatedBy: .equal, toItem: pickerView, attribute: .bottom, multiplier: 0.357, constant: 0))
        separatorLine3_top.addConstraint(from: "H:[$self]-(77)-|")
        separatorLine3_top.addConstraint(forWidth: 50)
        separatorLine3_top.addConstraint(forHeight: 2)
        
        let separatorLine3_bottom = UIView()
        separatorLine3_bottom.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
        pickerView.addSubview(separatorLine3_bottom)
        pickerView.addConstraint(NSLayoutConstraint(item: separatorLine3_bottom, attribute: .bottom, relatedBy: .equal, toItem: pickerView, attribute: .bottom, multiplier: 0.643, constant: 0))
        separatorLine3_bottom.addConstraint(from: "H:[$self]-(77)-|")
        separatorLine3_bottom.addConstraint(forWidth: 50)
        separatorLine3_bottom.addConstraint(forHeight: 2)
        
        timeValue = "10:30"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28)
        
        switch component {
        case 0:
            label.text = "\(row)"
        case 1:
            if row == 0 {
                label.text = "\(00)"
            } else if row == 1 {
                label.text = "\(15)"
            } else if row == 2 {
                label.text = "\(30)"
            } else if row == 3 {
                label.text = "\(45)"
            }
        default:
            label.text = ""
        }
        
        return label
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerRowHeight
    }
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 88
        case 1:
            return 88
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if delegate != nil {
            delegate?.valueUpdate(timePicker: self, value: timeValue)
        }
    }

}
