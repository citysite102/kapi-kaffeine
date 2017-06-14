//
//  KPLoginViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/14.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class KPLoginViewController: KPViewController {

    
    var iconImage: UIImageView!
    var titleImage: UIImageView!
    var descriptionLabel: UILabel!
    var facebookLoginButton: UIButton!
    var skipLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(patternImage: R.image.image_background()!)
        
        
        
        iconImage = UIImageView(image: R.image.image_icon_login())
        view.addSubview(iconImage)
        iconImage.addConstraintForCenterAligningToSuperview(in: .horizontal)
        iconImage.addConstraintForCenterAligningToSuperview(in: .vertical,
                                                            constant: -112)
        
        titleImage = UIImageView(image: R.image.image_title_login())
        view.addSubview(titleImage)
        titleImage.addConstraintForCenterAligningToSuperview(in: .horizontal)
        titleImage.addConstraint(from: "V:[$view0]-8-[$self]",
                                 views: [iconImage])
        
        descriptionLabel = UILabel();
        descriptionLabel.font = UIFont.systemFont(ofSize: 15.0);
        descriptionLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        descriptionLabel.text = " - 輕鬆找到最適合的咖啡店 -";
        view.addSubview(descriptionLabel);
        descriptionLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        descriptionLabel.addConstraints(fromStringArray: ["V:[$self]-16-|"])
        
        facebookLoginButton = UIButton()
        facebookLoginButton.setImage(R.image.facebook_login_s(), for: .normal)
        view.addSubview(facebookLoginButton)
        facebookLoginButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        facebookLoginButton.addConstraintForCenterAligningToSuperview(in: .vertical,
                                                                      constant: 48)
        facebookLoginButton.addConstraints(fromStringArray: ["V:[$self(64)]",
                                                             "H:[$self(276)]"])
        facebookLoginButton.addTarget(self, action: #selector(facebookLoginButtonOnTapped(_:)),
                                      for: UIControlEvents.touchUpInside)
        
        
        skipLoginButton = UIButton()
        skipLoginButton.setImage(R.image.skip_login(), for: .normal)
        view.addSubview(skipLoginButton)
        skipLoginButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        skipLoginButton.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(49)]",
                                                         "H:[$self(202)]"],
                                       views:[facebookLoginButton])
        skipLoginButton.addTarget(self, action: #selector(skipButtonOnTapped(_:)),
                             for: UIControlEvents.touchUpInside)
    
    }

    func facebookLoginButtonOnTapped(_ sender: UIButton) {
        KPUserManager.sharedManager.logIn(self)
    }
    
    func skipButtonOnTapped(_ sender: UIButton) {
        
        if appModalController() != nil {
            appModalController()?.dismissControllerWithDefaultDuration()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
