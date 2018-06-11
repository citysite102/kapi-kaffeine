//
//  KPOtherOptionViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 17/03/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPOtherOptionViewController: KPNewStoreBasicController {
    
    let wifiEditor = KPTitleEditorView<KPSegmentedControl>("是否提供WIFI",
                                                           contentViewSetupFunction: { return KPSegmentedControl(["沒有", "有"]) })
    
    let timeLimitEditor = KPTitleEditorView<KPSegmentedControl>("有無限時",
                                                                contentViewSetupFunction: { return KPSegmentedControl(["沒有", "有"]) })
    
    let socketEditor = KPTitleEditorView<KPSegmentedControl>("插座數量",
                                                             contentViewSetupFunction: { return KPSegmentedControl(["沒有", "有"]) })
    
    let standingDeskEditor = KPTitleEditorView<KPSegmentedControl>("是否有站立桌",
                                                                   contentViewSetupFunction: { return KPSegmentedControl(["沒有", "有"]) })
    
    weak var uploadData: KPUploadDataModel?
    
    init(_ data: KPUploadDataModel) {
        uploadData = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let submitButton = UIButton(type: .custom)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("設定完成", for: .normal)
        submitButton.clipsToBounds = true
        submitButton.setTitleColor(KPColorPalette.KPMainColor_v2.grayColor_level4,
                                   for: .disabled)
        submitButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                   for: .normal)
        submitButton.layer.cornerRadius = KPLayoutConstant.corner_radius
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level3?.cgColor
        buttonContainer.addSubview(submitButton)
        submitButton.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                      "V:|-12-[$self(40)]-12-|"])
        submitButton.addTarget(self, action: #selector(KPNewStoreDetailInfoViewController.handleSubmitButtonOnTap(_:)), for: .touchUpInside)
        
        
        scrollContainer.addSubview(wifiEditor)
        wifiEditor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wifiEditor.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: 20),
            wifiEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            wifiEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            
            wifiEditor.contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        
        scrollContainer.addSubview(timeLimitEditor)
        timeLimitEditor.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLimitEditor.topAnchor.constraint(equalTo: wifiEditor.bottomAnchor, constant: 20),
            timeLimitEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            timeLimitEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            
            timeLimitEditor.contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        scrollContainer.addSubview(socketEditor)
        socketEditor.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            socketEditor.topAnchor.constraint(equalTo: timeLimitEditor.bottomAnchor, constant: 20),
            socketEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            socketEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            
            socketEditor.contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        scrollContainer.addSubview(standingDeskEditor)
        standingDeskEditor.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            standingDeskEditor.topAnchor.constraint(equalTo: socketEditor.bottomAnchor, constant: 20),
            standingDeskEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            standingDeskEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            standingDeskEditor.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: -20),
            standingDeskEditor.contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        // Setup default value
        if let wifi = uploadData?.wifi {
            wifiEditor.contentView.selectedSegmentIndex = wifi == 0 ? 0 : 1
        }
        if let limitTime = uploadData?.limitedTime {
            timeLimitEditor.contentView.selectedSegmentIndex = limitTime == 2 ? 0 : 1
        }
        if let socket = uploadData?.socket {
            socketEditor.contentView.selectedSegmentIndex = socket == 5 ? 0 : 1
        }
        if let standingDesk = uploadData?.standingDesk {
            standingDeskEditor.contentView.selectedSegmentIndex = standingDesk == 2 ? 0 : 1
        }
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

//    @objc func handleBackButtonOnTap(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
//    }
    
    @objc func handleSubmitButtonOnTap(_ sender: UIButton) {
        
        guard let `uploadData` = uploadData else {
            return
        }
        
        delegate?.infoViewControllerDidSubmit(self)
        
        // TODO: Set data
        if let index = wifiEditor.contentView.selectedSegmentIndex {
            uploadData.wifi = index  == 0 ? 0 : 5
        }
        if let index = timeLimitEditor.contentView.selectedSegmentIndex {
            uploadData.limitedTime = index == 0 ? 2 : 1
        }
        if let index = socketEditor.contentView.selectedSegmentIndex {
            uploadData.socket = index == 0 ? 5 : 1
        }
        if let index = standingDeskEditor.contentView.selectedSegmentIndex {
            uploadData.standingDesk = index == 0 ? 2 : 1
        }
        
        navigationController?.popViewController(animated: true)
    }

}
