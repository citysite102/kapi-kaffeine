//
//  KPDefaultPopoverContent.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/4.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPDefaultPopoverContent: UIView, PopoverProtocol {
    
    var popoverView: KPPopoverView!
    var confirmAction: ((_ content: KPDefaultPopoverContent) -> Swift.Void)?
    var confirmButton: UIButton!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor.mainColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor.grayColor_level3
        return label
    }()
    
    lazy private  var seperator: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    private var buttonContainer: UIView!
    private var cancelButton: UIButton!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 280, height: 180)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 4
        
        addSubview(titleLabel)
        titleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        titleLabel.addConstraints(fromStringArray: ["V:|-16-[$self]",
                                                    "H:|-16-[$self]-16-|"])
        
        addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        descriptionLabel.addConstraints(fromStringArray: ["V:[$view0]-12-[$self]",
                                                          "H:[$self(240)]"],
                                        views: [titleLabel])
        
        
        
        buttonContainer = UIView()
        addSubview(buttonContainer)
        buttonContainer.addConstraintForCenterAligningToSuperview(in: .horizontal)
        buttonContainer.addConstraint(from: "V:[$self]|")
        
        
        addSubview(seperator)
        seperator.addConstraints(fromStringArray: ["V:[$self(1)]",
                                                   "H:|[$self]|"])
        seperator.addConstraintForAligning(to: .top, of: buttonContainer)
        
        cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.layer.cornerRadius = 2.0
        cancelButton.layer.masksToBounds = true
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: UIDevice().isSuperCompact ? 13.0 : 15.0)
        cancelButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level4!),
                                        for: .normal)
        cancelButton.addTarget(self,
                               action: #selector(KPDefaultPopoverContent.handleCancelButtonOnTapped),
                               for: .touchUpInside);
        buttonContainer.addSubview(cancelButton)
        cancelButton.addConstraints(fromStringArray:
            ["V:|-8-[$self(36)]-8-|",
             "H:|-10-[$self($metric0)]"], metrics: [125])
        
        confirmButton = UIButton(type: .custom)
        confirmButton.setTitle("確認", for: .normal)
        confirmButton.layer.cornerRadius = 2.0
        confirmButton.layer.masksToBounds = true
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        confirmButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor_light!),
                                        for: .normal)
        confirmButton.addTarget(self,
                                action: #selector(KPDefaultPopoverContent.handleConfirmButtonOnTapped),
                                for: .touchUpInside);
        buttonContainer.addSubview(confirmButton)
        confirmButton.addConstraints(fromStringArray:
            ["V:|-8-[$self(36)]-8-|",
             "H:[$view0]-10-[$self($metric0)]-10-|"],
                                     metrics: [125],
                                     views:[cancelButton])
    }

    @objc func handleCancelButtonOnTapped() {
        popoverView.dismiss()
    }
    
    @objc func handleConfirmButtonOnTapped() {
        if confirmAction != nil {
            confirmAction!(self)
        }
    }
}
