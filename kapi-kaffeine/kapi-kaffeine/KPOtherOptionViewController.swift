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
                                                           contentViewSetupFunction: { return KPSegmentedControl(["有", "無"]) })
    
    let timeLimitEditor = KPTitleEditorView<KPSegmentedControl>("有無限時",
                                                                contentViewSetupFunction: { return KPSegmentedControl(["限時", "不限時", "看狀況"]) })
    
    let socketEditor = KPTitleEditorView<KPSegmentedControl>("插座數量",
                                                             contentViewSetupFunction: { return KPSegmentedControl(["無", "很多", "部份座位有"]) })
    
    let standingDeskEditor = KPTitleEditorView<KPSegmentedControl>("是否有站立桌",
                                                                   contentViewSetupFunction: { return KPSegmentedControl(["有", "無"]) })
    
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
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.title = "提供設備"
        
        let submitButton = UIButton(type: .custom)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("設定完成", for: .normal)
        submitButton.clipsToBounds = true
        submitButton.setTitleColor(KPColorPalette.KPMainColor_v2.grayColor_level4,
                                   for: .disabled)
        submitButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                   for: .normal)
        submitButton.layer.cornerRadius = 4.0
        submitButton.layer.cornerRadius = 4.0
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
        wifiEditor.contentView.selectedSegmentIndex = uploadData?.wifi ?? true ? 0 : 1
        timeLimitEditor.contentView.selectedSegmentIndex = uploadData?.limitedTime ?? 0
        socketEditor.contentView.selectedSegmentIndex = uploadData?.socket ?? 0
        standingDeskEditor.contentView.selectedSegmentIndex = uploadData?.standingDesk ?? true ? 0 : 1
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
        
        guard let `uploadData` = uploadData else {
            return
        }
        
        // TODO: Set data
        uploadData.wifi = wifiEditor.contentView.selectedSegmentIndex == 0
        uploadData.limitedTime = timeLimitEditor.contentView.selectedSegmentIndex
        uploadData.socket = socketEditor.contentView.selectedSegmentIndex
        uploadData.standingDesk = standingDeskEditor.contentView.selectedSegmentIndex == 0
        
        navigationController?.popViewController(animated: true)
    }

}