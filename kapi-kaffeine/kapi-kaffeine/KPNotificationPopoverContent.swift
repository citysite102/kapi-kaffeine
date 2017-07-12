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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPMainColor.mainColor
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
        view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        return view
    }()
    
    private var buttonContainer: UIView!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 280, height: 200)
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
        buttonContainer.addConstraint(from: "H:|[$self]|")
        
        addSubview(seperator)
        seperator.addConstraints(fromStringArray: ["V:[$self(1)]",
                                                   "H:|[$self]|"])
        seperator.addConstraintForAligning(to: .top, of: buttonContainer)
        
        confirmButton = UIButton(type: .custom)
        confirmButton.setTitle("確認", for: .normal)
        confirmButton.layer.cornerRadius = 2.0
        confirmButton.layer.masksToBounds = true
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        confirmButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor_light!),
                                         for: .normal)
        confirmButton.addTarget(self,
                                action: #selector(KPNotificationPopoverContent.handleConfirmButtonOnTapped),
                                for: .touchUpInside);
        buttonContainer.addSubview(confirmButton)
        confirmButton.addConstraints(fromStringArray:
            ["V:|-8-[$self(36)]-8-|",
             "H:|-10-[$self]-10-|"])
    }
    
    
    func handleConfirmButtonOnTapped() {
        if confirmAction != nil {
            confirmAction!(self)
        } else {
            popoverView.dismiss()
        }
    }

}
