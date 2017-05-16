//
//  KPTimePicker.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPTimePicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerRowHeight: CGFloat = 60
    
    var pickerView: UIPickerView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        pickerView = UIPickerView()
        self.addSubview(pickerView)
        
        pickerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self(\(pickerRowHeight*3.5))]|"])
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = KPColorPalette.KPMainColor.mainColor
        pickerView.addSubview(separatorLine)
        pickerView.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .centerY, relatedBy: .equal, toItem: separatorLine, attribute: .centerY, multiplier: 1, constant: pickerRowHeight/2))
        separatorLine.addConstraintForCenterAligningToSuperview(in: .horizontal)
        separatorLine.addConstraint(forWidth: 50)
        separatorLine.addConstraint(forHeight: 2)
        
        let separatorLine1 = UIView()
        separatorLine1.backgroundColor = KPColorPalette.KPMainColor.mainColor
        pickerView.addSubview(separatorLine1)
        pickerView.addConstraint(NSLayoutConstraint(item: separatorLine1, attribute: .centerY, relatedBy: .equal, toItem: pickerView, attribute: .centerY, multiplier: 1, constant: pickerRowHeight/2))
        separatorLine1.addConstraintForCenterAligningToSuperview(in: .horizontal)
        separatorLine1.addConstraint(forWidth: 50)
        separatorLine1.addConstraint(forHeight: 2)
        
        let separatorLine2 = UIView()
        separatorLine2.backgroundColor = KPColorPalette.KPMainColor.mainColor
        pickerView.addSubview(separatorLine2)
        pickerView.addConstraint(NSLayoutConstraint(item: separatorLine2, attribute: .centerY, relatedBy: .equal, toItem: pickerView, attribute: .centerY, multiplier: 1, constant: pickerRowHeight/2))
        separatorLine2.addConstraint(from: "H:|-(\(6.66+25))-[$self]")
        separatorLine2.addConstraint(forWidth: 50)
        separatorLine2.addConstraint(forHeight: 2)
        
        let separatorLine3 = UIView()
        separatorLine3.backgroundColor = KPColorPalette.KPMainColor.mainColor
        pickerView.addSubview(separatorLine3)
        pickerView.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .centerY, relatedBy: .equal, toItem: separatorLine3, attribute: .centerY, multiplier: 1, constant: pickerRowHeight/2))
        separatorLine3.addConstraint(from: "H:|-(\(6.66+25))-[$self]")
        separatorLine3.addConstraint(forWidth: 50)
        separatorLine3.addConstraint(forHeight: 2)
        
        
        let separatorLine3_top = UIView()
        separatorLine3_top.backgroundColor = KPColorPalette.KPMainColor.mainColor
        pickerView.addSubview(separatorLine3_top)
        pickerView.addConstraint(NSLayoutConstraint(item: separatorLine3_top, attribute: .centerY, relatedBy: .equal, toItem: pickerView, attribute: .centerY, multiplier: 1, constant: pickerRowHeight/2))
        separatorLine3_top.addConstraint(from: "H:[$self]-(\(6.66+25))-|")
        separatorLine3_top.addConstraint(forWidth: 50)
        separatorLine3_top.addConstraint(forHeight: 2)
        
        let separatorLine3_bottom = UIView()
        separatorLine3_bottom.backgroundColor = KPColorPalette.KPMainColor.mainColor
        pickerView.addSubview(separatorLine3_bottom)
        pickerView.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .centerY, relatedBy: .equal, toItem: separatorLine3_bottom, attribute: .centerY, multiplier: 1, constant: pickerRowHeight/2))
        separatorLine3_bottom.addConstraint(from: "H:[$self]-(\(6.66+25))-|")
        separatorLine3_bottom.addConstraint(forWidth: 50)
        separatorLine3_bottom.addConstraint(forHeight: 2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 12
        case 1:
            return 4
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    // MARK: UIPickerViewDelegate
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch component {
//        case 0:
//            return "\(row+1)"
//        case 1:
//            if row == 0 {
//                return "\(0)"
//            } else if row == 1 {
//                return "\(15)"
//            } else if row == 2 {
//                return "\(30)"
//            } else if row == 3 {
//                return "\(45)"
//            }
//        case 2:
//            if row == 0 {
//                return "AM"
//            } else {
//                return "PM"
//            }
//        default:
//            return ""
//        }
//        return ""
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        
//        let test = UIView()
//        label.addSubview(test)
//        test.backgroundColor = KPColorPalette.KPMainColor.mainColor
//        test.addConstraints(fromStringArray: ["H:[$self(50)]", "V:[$self(2)]|"])
//        test.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        switch component {
        case 0:
            label.text = "\(row+1)"
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
        case 2:
            if row == 0 {
                label.text = "AM"
            } else {
                label.text = "PM"
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
            return 100
        case 1:
            return 100
        case 2:
            return 100
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

}
