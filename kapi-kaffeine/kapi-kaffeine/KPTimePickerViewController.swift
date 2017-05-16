//
//  KPTimePickerViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 16/05/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPTimePickerViewController: KPSharedSettingViewController {
    
    var timePicker: KPTimePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "選時間了喔"
        
        timePicker = KPTimePicker()
        containerView.addSubview(timePicker)
//        timePicker.addConstraint(forHeight: 300)
//        timePicker.addConstraintForCenterAligningToSuperview(in: .vertical)
        timePicker.addConstraint(from: "V:|[$self(300)]|")
        timePicker.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
