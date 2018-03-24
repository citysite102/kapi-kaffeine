//
//  KPOtherOptionViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 17/03/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPOtherOptionViewController: KPNewStoreBasicController {
    
    
//    let wifiSegment = KPSegmentedControl(["有", "無"])
//    let timeLimitSegment = KPSegmentedControl(["限時", "不限時", "看狀況"])
//    let socketSegment = KPSegmentedControl(["無", "很多", "部份座位有"])
//    let standingDeskSegment = KPSegmentedControl(["有", "無"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = nil
        
        let submitButton = UIButton(type: .custom)
        submitButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.greenColor!), for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("確認新增", for: .normal)
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 3
        buttonContainer.addSubview(submitButton)
        submitButton.addConstraints(fromStringArray: ["H:[$self]-16-|", "V:|-10-[$self]-10-|"])
        submitButton.addTarget(self, action: #selector(KPNewStoreDetailInfoViewController.handleSubmitButtonOnTap(_:)), for: .touchUpInside)
        
        let backButton = UIButton(type: .custom)
        backButton.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_description!, for: .normal)
        backButton.setTitle("上一步", for: .normal)
        buttonContainer.addSubview(backButton)
        backButton.addConstraints(fromStringArray: ["H:|-16-[$self]-[$view0]", "V:|-10-[$self]-10-|"],
                                  views: [submitButton])
        backButton.addConstraintForHavingSameWidth(with: submitButton)
        backButton.addTarget(self, action: #selector(KPNewStoreDetailInfoViewController.handleBackButtonOnTap(_:)), for: .touchUpInside)
        
        
        let wifiEditor = KPTitleEditorView<KPSegmentedControl>("是否提供WIFI",
                                                               contentViewSetupFunction: { return KPSegmentedControl(["有", "無"]) })
        scrollContainer.addSubview(wifiEditor)
        wifiEditor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wifiEditor.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: 20),
            wifiEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            wifiEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            
            wifiEditor.contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        let timeLimitEditor = KPTitleEditorView<KPSegmentedControl>("有無限時",
                                                                    contentViewSetupFunction: { return KPSegmentedControl(["限時", "不限時", "看狀況"]) })
        scrollContainer.addSubview(timeLimitEditor)
        timeLimitEditor.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLimitEditor.topAnchor.constraint(equalTo: wifiEditor.bottomAnchor, constant: 20),
            timeLimitEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            timeLimitEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            
            timeLimitEditor.contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let socketEditor = KPTitleEditorView<KPSegmentedControl>("插座數量",
                                                                 contentViewSetupFunction: { return KPSegmentedControl(["無", "很多", "部份座位有"]) })
        scrollContainer.addSubview(socketEditor)
        socketEditor.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            socketEditor.topAnchor.constraint(equalTo: timeLimitEditor.bottomAnchor, constant: 20),
            socketEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            socketEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            
            socketEditor.contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        let standingDeskEditor = KPTitleEditorView<KPSegmentedControl>("是否有站立桌",
                                                                       contentViewSetupFunction: { return KPSegmentedControl(["有", "無"]) })
        
        scrollContainer.addSubview(standingDeskEditor)
        standingDeskEditor.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            standingDeskEditor.topAnchor.constraint(equalTo: socketEditor.bottomAnchor, constant: 20),
            standingDeskEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            standingDeskEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            standingDeskEditor.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: -20),
            standingDeskEditor.contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    func titleLabel(withTitle title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        titleLabel.font = UIFont.systemFont(ofSize: 20,
                                            weight: UIFont.Weight.light)
        return titleLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UI Events
    
    @objc func handleBackButtonOnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSubmitButtonOnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
