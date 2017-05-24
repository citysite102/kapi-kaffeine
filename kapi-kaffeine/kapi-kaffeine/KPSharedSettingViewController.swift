//
//  KPSharedSettingViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 16/05/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSharedSettingViewController: KPViewController {

    var dismissButton:UIButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    var sendButton: UIButton!

    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        return label
    }()
    
    lazy var seperator_one: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        return view
    }()
    
    lazy var seperator_two: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        dismissButton = UIButton.init()
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                               for: .normal)
        dismissButton.tintColor = KPColorPalette.KPMainColor.mainColor
        dismissButton.addTarget(self,
                                action: #selector(KPRatingViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        view.addSubview(dismissButton)
        dismissButton.addConstraints(fromStringArray: ["H:|-16-[$self(30)]",
                                                       "V:|-16-[$self(30)]"])
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
        
        
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
        containerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        containerView.addConstraintForHavingSameWidth(with: scrollView)
        
        
        view.addSubview(seperator_two)
        seperator_two.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$view0][$self(1)]"],
                                     views: [scrollView])
        
        sendButton = UIButton.init(type: .custom)
        sendButton.setTitle("送出評分", for: .normal)
        sendButton.setTitleColor(KPColorPalette.KPTextColor.mainColor,
                                 for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(sendButton)

        sendButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(30)]-16-|"],
                                  views: [seperator_two])
        sendButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        view.addSubview(seperator_two)
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
