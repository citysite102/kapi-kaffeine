//
//  KPOtherOptionViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 17/03/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPOtherOptionViewController: KPViewController {

    
    var scrollContainer: UIView!
    var scrollView: UIScrollView!
    var buttonContainer: UIView!
    
    
    let wifiSegment = KPSegmentedControl(["有", "無"])
    let timeLimitSegment = KPSegmentedControl(["限時", "不限時", "看狀況"])
    let socketSegment = KPSegmentedControl(["無", "很多", "部份座位有"])
    let standingDeskSegment = KPSegmentedControl(["有", "無"])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = nil

        scrollView = UIScrollView()
        scrollView.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        scrollView.addConstraint(from: "H:|[$self]|")
        
        scrollContainer = UIView()
        scrollContainer.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
        scrollView.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        scrollContainer.addConstraintForHavingSameWidth(with: view)
        
        buttonContainer = UIView()
        buttonContainer.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
        view.addSubview(buttonContainer)
        buttonContainer.layer.borderColor = KPColorPalette.KPBackgroundColor.grayColor_level6?.cgColor
        buttonContainer.layer.borderWidth = 1
        
        buttonContainer.addConstraints(fromStringArray: ["H:|-(-1)-[$self]-(-1)-|", "V:[$view0][$self(60)]"],
                                       views: [scrollView])
        buttonContainer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
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
        
        
        let wifiLabel = titleLabel(withTitle: "是否提供WIFI")
        scrollContainer.addSubview(wifiLabel)
        scrollContainer.addSubview(wifiSegment)
        wifiLabel.translatesAutoresizingMaskIntoConstraints = false
        wifiSegment.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wifiLabel.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: 20),
            wifiLabel.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            wifiLabel.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            
            wifiSegment.topAnchor.constraint(equalTo: wifiLabel.bottomAnchor, constant: 10),
            wifiSegment.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            wifiSegment.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            wifiSegment.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        let timeLimitLabel = titleLabel(withTitle: "有無限時")
        scrollContainer.addSubview(timeLimitLabel)
        scrollContainer.addSubview(timeLimitSegment)
        timeLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLimitSegment.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLimitLabel.topAnchor.constraint(equalTo: wifiSegment.bottomAnchor, constant: 20),
            timeLimitLabel.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            timeLimitLabel.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            
            timeLimitSegment.topAnchor.constraint(equalTo: timeLimitLabel.bottomAnchor, constant: 10),
            timeLimitSegment.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            timeLimitSegment.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            timeLimitSegment.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let socketLabel = titleLabel(withTitle: "插座數量")
        scrollContainer.addSubview(socketLabel)
        scrollContainer.addSubview(socketSegment)
        socketLabel.translatesAutoresizingMaskIntoConstraints = false
        socketSegment.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            socketLabel.topAnchor.constraint(equalTo: timeLimitSegment.bottomAnchor, constant: 20),
            socketLabel.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            socketLabel.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            
            socketSegment.topAnchor.constraint(equalTo: socketLabel.bottomAnchor, constant: 10),
            socketSegment.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            socketSegment.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            socketSegment.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let standingDeskLabel = titleLabel(withTitle: "是否有站立桌")
        scrollContainer.addSubview(standingDeskLabel)
        scrollContainer.addSubview(standingDeskSegment)
        standingDeskLabel.translatesAutoresizingMaskIntoConstraints = false
        standingDeskSegment.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            standingDeskLabel.topAnchor.constraint(equalTo: socketSegment.bottomAnchor, constant: 20),
            standingDeskLabel.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            standingDeskLabel.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            
            standingDeskSegment.topAnchor.constraint(equalTo: standingDeskLabel.bottomAnchor, constant: 10),
            standingDeskSegment.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            standingDeskSegment.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            standingDeskSegment.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: -20),
            standingDeskSegment.heightAnchor.constraint(equalToConstant: 40)
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
