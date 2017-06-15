//
//  KPSecondIntroView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSecondIntroView: KPSharedIntroView {

    var bottomImageView: UIImageView!
    var firstPopImageView: UIImageView!
    var secondPopImageView: UIImageView!
    var thirdPopImageView: UIImageView!
    var forthPopImageView: UIImageView!
    var fifthPopImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        bottomImageView = UIImageView(image: R.image.image_onbroading_2())
        bottomImageView.contentMode = .scaleAspectFit
        addSubview(bottomImageView)
        bottomImageView.addConstraints(fromStringArray: ["V:|-80-[$self(240)]",
                                                         "H:[$self]"])
        bottomImageView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        firstPopImageView = UIImageView(image: R.image.image_onbroading_21())
        addSubview(firstPopImageView)
        firstPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 0)
        firstPopImageView.addConstraintForAligning(to: .left, of: bottomImageView, constant: 40)
        
        secondPopImageView = UIImageView(image: R.image.image_onbroading_22())
        addSubview(secondPopImageView)
        secondPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 56)
        secondPopImageView.addConstraintForAligning(to: .left, of: bottomImageView, constant: 0)
        
        thirdPopImageView = UIImageView(image: R.image.image_onbroading_23())
        addSubview(thirdPopImageView)
        thirdPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 120)
        thirdPopImageView.addConstraintForAligning(to: .left, of: bottomImageView, constant: -16)
        
        forthPopImageView = UIImageView(image: R.image.image_onbroading_24())
        addSubview(forthPopImageView)
        forthPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 24)
        forthPopImageView.addConstraintForAligning(to: .right, of: bottomImageView, constant: 16)
        
        fifthPopImageView = UIImageView(image: R.image.image_onbroading_25())
        addSubview(fifthPopImageView)
        fifthPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 112)
        fifthPopImageView.addConstraintForAligning(to: .right, of: bottomImageView, constant: 16)
        
        firstPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        secondPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        thirdPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        forthPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        fifthPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        introTitleLabel.text = "上千家咖啡館任你選"
        introDescriptionLabel.textAlignment = .center
        introDescriptionLabel.setText(text: "收錄全台超過1000家咖啡館資訊，隨時更新，動態一手掌握",
                                      lineSpacing: KPFactorConstant.KPSpacing.introSpacing)
        
    }
    
    func showPopContents() {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.firstPopImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.secondPopImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.thirdPopImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.forthPopImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.4,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.fifthPopImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
