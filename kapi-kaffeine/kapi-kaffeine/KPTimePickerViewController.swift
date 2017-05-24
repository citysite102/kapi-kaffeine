//
//  KPTimePickerViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 16/05/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPTimePickerViewController: UIViewController, KPTimePickerDelegate {
    
    var timePicker: KPTimePicker!
    
    weak var businessHourController: KPBusinessHourViewController!
    var timeValue: String! {
        didSet {
            if timePicker != nil {
                timePicker.timeValue = timeValue
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        timePicker = KPTimePicker()
        view.addSubview(timePicker)
        if timeValue != nil {
            timePicker.timeValue = timeValue
        }
        timePicker.addConstraint(from: "V:|-[$self]")
        timePicker.addConstraintForCenterAligningToSuperview(in: .horizontal)
        timePicker.delegate = self
        
        let seporator = UIView()
        seporator.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        view.addSubview(seporator)
        seporator.addConstraints(fromStringArray: ["H:|-8-[$self]-8-|", "V:[$view0]-16-[$self(1)]"],
                                 views:[timePicker])
        
        let doneButton = UIButton()
        doneButton.setTitle("完成", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.setBackgroundImage(UIImage.init(color: KPColorPalette.KPMainColor.mainColor!),
                                        for: .normal)
        doneButton.layer.cornerRadius = 4.0
        doneButton.layer.masksToBounds = true
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        view.addSubview(doneButton)
        doneButton.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|", "V:[$view0]-16-[$self(40)]-16-|"], views: [seporator])
        doneButton.addTarget(self, action: #selector(handleDoneButtonOnTap(sender:)), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func valueUpdate(timePicker: KPTimePicker, value: String) {
        timeValue = value
    }
    
    func handleDoneButtonOnTap(sender: UIButton) {
        self.businessHourController.valueUpdate(timePicker: timePicker, value: timeValue)
        self.appModalController()?.dismissControllerWithDefaultDuration()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
