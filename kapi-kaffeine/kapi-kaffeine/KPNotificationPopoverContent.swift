//
//  KPNotificationPopoverContent.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/13.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPNotificationPopoverContent: UIView, PopoverProtocol {

    var popoverView: KPPopoverView!
    var confirmAction: ((_ content: KPNotificationPopoverContent) -> Swift.Void)?
    var confirmButton: UIButton!
    var customHeight: CGFloat?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: KPFontSize.header)
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPMainColor_v2.mainColor
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        return label
    }()
    
    lazy private  var seperator: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    private var buttonContainer: UIView!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 280, height: customHeight ?? 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = KPLayoutConstant.corner_radius
        
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
        buttonContainer.addConstraint(from: "H:|[$self]|")
        
        addSubview(seperator)
        seperator.addConstraints(fromStringArray: ["V:[$self(1)]",
                                                   "H:|[$self]|"])
        seperator.addConstraintForAligning(to: .top, of: buttonContainer)
        
        confirmButton = UIButton(type: .custom)
        confirmButton.setTitle("確認", for: .normal)
        confirmButton.layer.cornerRadius = KPLayoutConstant.corner_radius
        confirmButton.layer.masksToBounds = true
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        confirmButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.mainColor_light!),
                                         for: .normal)
        confirmButton.addTarget(self,
                                action: #selector(KPNotificationPopoverContent.handleConfirmButtonOnTapped),
                                for: .touchUpInside);
        buttonContainer.addSubview(confirmButton)
        confirmButton.addConstraints(fromStringArray:
            ["V:|-8-[$self(36)]-8-|",
             "H:|-10-[$self]-10-|"])
    }
    
    
    @objc func handleConfirmButtonOnTapped() {
        if confirmAction != nil {
            confirmAction!(self)
        } else {
            popoverView.dismiss()
        }
    }

}
