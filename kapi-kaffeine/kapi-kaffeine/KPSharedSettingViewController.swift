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
        sendButton.setTitle("送出評分", for: .normal)
        sendButton.setTitleColor(KPColorPalette.KPTextColor.mainColor,
                                 for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return sendButton
    }()
    
    var identifiedKey: String?
    var returnValue: Any!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
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
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                               for: .normal)
        dismissButton.tintColor = KPColorPalette.KPMainColor.mainColor
        dismissButton.addTarget(self,
                                action: #selector(KPSharedSettingViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        view.addSubview(dismissButton)
        dismissButton.addConstraints(fromStringArray: ["H:|-12-[$self(30)]",
                                                       "V:|-16-[$self(30)]"])
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        
        
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

        sendButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(30)]-16-|"],
                                  views: [seperator_two])
        sendButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        seperator_two.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$self(1)]-16-[$view0]"],
                                     views: [sendButton])
        
    }
    
    func handleDismissButtonOnTapped() {
        self.dismiss(animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
