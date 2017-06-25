//
//  KPFifthIntroView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class KPFifthIntroView: KPSharedIntroView {

    var bottomImageView: UIImageView!
    var firstPopImageView: UIImageView!
    var secondPopImageView: UIImageView!
    var thirdPopImageView: UIImageView!
    
    var facebookLoginButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        isUserInteractionEnabled = true
        
        bottomImageView = UIImageView(image: R.image.image_onbroading_5())
        bottomImageView.contentMode = .scaleAspectFit
        addSubview(bottomImageView)
        bottomImageView.addConstraints(fromStringArray: ["V:[$self]",
                                                         "H:[$self]"])
        bottomImageView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        bottomImageView.addConstraintForCenterAligningToSuperview(in: .vertical, constant: -80)
        
        firstPopImageView = UIImageView(image: R.image.image_onbroading_51())
        addSubview(firstPopImageView)
        firstPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 32)
        firstPopImageView.addConstraintForAligning(to: .left, of: bottomImageView, constant: 8)
        
        secondPopImageView = UIImageView(image: R.image.image_onbroading_52())
        addSubview(secondPopImageView)
        secondPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 16)
        secondPopImageView.addConstraintForAligning(to: .right, of: bottomImageView, constant: 0)
        
        thirdPopImageView = UIImageView(image: R.image.image_onbroading_53())
        addSubview(thirdPopImageView)
        thirdPopImageView.addConstraintForAligning(to: .bottom, of: bottomImageView, constant: 16)
        thirdPopImageView.addConstraintForAligning(to: .left, of: bottomImageView, constant: 32)
        
        introTitleLabel.text = "最挺你的社群"
        introDescriptionLabel.textAlignment = .center
        introDescriptionLabel.setText(text: "全台網友協力貢獻店家資料，找咖啡不再是件麻煩事",
                                      lineSpacing: KPFactorConstant.KPSpacing.introSpacing)
        
        facebookLoginButton = UIButton()
        facebookLoginButton.setImage(R.image.facebook_login(), for: .normal)
        addSubview(facebookLoginButton)
        facebookLoginButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        facebookLoginButton.addConstraints(fromStringArray: ["V:[$self(64)]-32-|",
                                                             "H:[$self(276)]"])
        
    }
    
    
    func showPopContents() {
        
        UIView.animateKeyframes(withDuration: 3.0,
                                delay: 0,
                                options: [.repeat],
                                animations: { 
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25,
                                                       animations: { 
                                                self.firstPopImageView.alpha = 0.0
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.firstPopImageView.alpha = 1.0
                                    })
        }) { (_) in
            
        }
        
        UIView.animateKeyframes(withDuration: 3.0,
                                delay: 1.0,
                                options: [.repeat],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.secondPopImageView.alpha = 0.0
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.secondPopImageView.alpha = 1.0
                                    })
        }) { (_) in
            
        }
        
        UIView.animateKeyframes(withDuration: 3.0,
                                delay: 2.0,
                                options: [.repeat],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.thirdPopImageView.alpha = 0.0
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.thirdPopImageView.alpha = 1.0
                                    })
        }) { (_) in
            
        }
        
    }
    
    func updateLayoutWithProgress(_ progress: CGFloat) {
        print("Progress:\(320-320*progress)")
        firstPopImageView.transform = CGAffineTransform(translationX: progress == 0 ? 0 : 140-140*progress,
                                                        y: 0)
        secondPopImageView.transform = CGAffineTransform(translationX: progress == 0 ? 0 : 200-200*progress,
                                                         y: 0)
        thirdPopImageView.transform = CGAffineTransform(translationX: progress == 0 ? 0 : 260-260*progress,
                                                        y: 0)
        facebookLoginButton.transform = CGAffineTransform(translationX: progress == 0 ? 0 : 320-320*progress,
                                                        y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

