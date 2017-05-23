//
//  KPThirdIntroView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPThirdIntroView: UIView {

    var bottomImageView: UIImageView!
    var firstPopImageView: UIImageView!
    var secondPopImageView: UIImageView!
    var thirdPopImageView: UIImageView!
    var forthPopImageView: UIImageView!
    var fifthPopImageView: UIImageView!
    
    
    var descriptionStyle: NSMutableParagraphStyle!
    
    lazy var introTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    lazy var introDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.alpha = 0.8
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.isUserInteractionEnabled = false
        
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
        
        descriptionStyle = NSMutableParagraphStyle()
        descriptionStyle.alignment = .center
        descriptionStyle.lineSpacing = 2.4
        
        let attrS = NSMutableAttributedString.init(string: "關鍵字搜尋，偏好篩選，附近店家，方法不只一個，但絕對快速簡單")
        attrS.addAttributes([NSParagraphStyleAttributeName: descriptionStyle],
                            range: NSRange.init(location: 0, length: attrS.length))
        
        
        introTitleLabel.text = "快速找到目的地"
        introDescriptionLabel.attributedText = attrS
        
        addSubview(introTitleLabel)
        addSubview(introDescriptionLabel)
        
        introTitleLabel.addConstraints(fromStringArray: ["V:[$self]-168-|",
                                                         "H:|-32-[$self]-32-|"])
        
        introDescriptionLabel.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]",
                                                               "H:|-32-[$self]-32-|"],
                                             views:[introTitleLabel])
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.showPopContents()
        }
        
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
                       delay: 0.2,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.forthPopImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
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
