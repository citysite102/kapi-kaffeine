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
    var scrollViewContainer: UIView!
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
        
        scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(self.scrollView)
        scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                    "H:|[$self]|"])
        
        
        scrollViewContainer = UIView()
        scrollView.addSubview(self.scrollViewContainer)
        scrollViewContainer.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        scrollViewContainer.addConstraintForHavingSameWidth(with: self.view)
        
        dismissButton = UIButton.init()
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                               for: .normal)
        dismissButton.tintColor = KPColorPalette.KPMainColor.mainColor
        dismissButton.addTarget(self,
                                action: #selector(KPRatingViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        scrollViewContainer.addSubview(dismissButton)
        dismissButton.addConstraints(fromStringArray: ["H:|-16-[$self(24)]",
                                                       "V:|-16-[$self(24)]"])
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        
        
        scrollViewContainer.addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["V:[$view0]-24-[$self]",
                                                    "H:|-16-[$self]"],
                                  views:[dismissButton])
        
        scrollViewContainer.addSubview(seperator_one)
        seperator_one.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$view0]-16-[$self(1)]"],
                                     views: [titleLabel])
        
        containerView = UIView()
        scrollViewContainer.addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]"],
                                     views: [seperator_one])
        
        scrollViewContainer.addSubview(seperator_two)
        seperator_two.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$view0][$self(1)]"],
                                     views: [containerView])
        
        sendButton = UIButton.init(type: .custom)
        sendButton.setTitle("送出評分", for: .normal)
        sendButton.setTitleColor(KPColorPalette.KPTextColor.mainColor,
                                 for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        scrollViewContainer.addSubview(sendButton)
        sendButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(30)]-16-|"],
                                  views: [seperator_two])
        sendButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
    }
    
    
    
    func handleDismissButtonOnTapped() {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
