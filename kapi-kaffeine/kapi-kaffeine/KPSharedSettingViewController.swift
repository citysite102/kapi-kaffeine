//
//  KPSharedSettingViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 16/05/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit


protocol KPSharedSettingDelegate: NSObjectProtocol {
    func returnValueSet(_ controller: KPSharedSettingViewController)
}

class KPSharedSettingViewController: KPViewController {

    weak open var delegate: KPSharedSettingDelegate?
    var dismissButton: KPBounceButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    lazy var sendButton: UIButton! = {
        let sendButton = UIButton.init(type: .custom)
//        sendButton.setTitle("送出評分", for: .normal)
//        sendButton.setTitleColor(KPColorPalette.KPTextColor.mainColor,
//                                 for: .normal)
//        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        
//        sendButton = UIButton.init(type: .custom)
        sendButton.setTitle("完成", for: .normal)
        
        sendButton.setTitleColor(KPColorPalette.KPMainColor_v2.grayColor_level4,
                                 for: .disabled)
        sendButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                 for: .normal)
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = KPLayoutConstant.corner_radius
        sendButton.layer.borderWidth = 1.0
        sendButton.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level3?.cgColor
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        
        return sendButton
    }()
    
    var identifiedKey: String?
    var returnValue: Any!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: KPFontSize.header,
                                       weight: UIFont.Weight.regular)
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        return label
    }()
    
    lazy var seperator_one: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    lazy var seperator_two: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        dismissButton = KPBounceButton()
        dismissButton.setImage(R.image.icon_close(),
                               for: .normal)
        dismissButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        dismissButton.addTarget(self,
                                action: #selector(KPSubtitleInputController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        view.addSubview(dismissButton)
        dismissButton.addConstraints(fromStringArray: ["H:|-12-[$self($metric0)]",
                                                       "V:|-36-[$self($metric0)]"], metrics:[KPLayoutConstant.dismissButton_size])
        
        
        view.addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["V:[$view0]-24-[$self]",
                                                    "H:|-16-[$self]"],
                                  views:[dismissButton])
        
        view.addSubview(seperator_one)
        seperator_one.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$view0]-16-[$self(1)]"],
                                     views: [titleLabel])
        
        scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(self.scrollView)
        scrollView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                    "H:|[$self]|"],
                                  views: [seperator_one])
        
        containerView = UIView()
        scrollView.addSubview(self.containerView)
        containerView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:|[$self]|"])
        containerView.addConstraintForHavingSameWidth(with: scrollView)
        
        
        view.addSubview(seperator_two)
        seperator_two.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$view0][$self(1)]"],
                                     views: [scrollView])
        
        view.addSubview(sendButton)
        view.addSubview(seperator_two)

        sendButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(40)]-16-|",
                                                    "H:|-12-[$self]-12-|"],
                                  views: [seperator_two])
        
//        sendButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(30)]-16-|"],
//                                  views: [seperator_two])
        sendButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        seperator_two.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$self(1)]-16-[$view0]"],
                                     views: [sendButton])
        
    }
    
    @objc func handleDismissButtonOnTapped() {
        self.dismiss(animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
