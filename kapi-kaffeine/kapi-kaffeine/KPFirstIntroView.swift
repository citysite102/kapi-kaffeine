//
//  KPFirstIntroView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import pop

class KPFirstIntroView: KPSharedIntroView {

    
    var bottomImageView: UIImageView!
    var firstPopImageView: UIImageView!
    var secondPopImageView: UIImageView!
    var thirdPopImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.isUserInteractionEnabled = false
        
        bottomImageView = UIImageView(image: R.image.image_onbroading_1())
        bottomImageView.contentMode = .scaleAspectFit
        addSubview(bottomImageView)
        bottomImageView.addConstraints(fromStringArray: ["V:|-72-[$self(230)]",
                                                         "H:[$self]"])
        bottomImageView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        firstPopImageView = UIImageView(image: R.image.image_onbroading_11())
        addSubview(firstPopImageView)
        firstPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 24)
        firstPopImageView.addConstraintForAligning(to: .left, of: bottomImageView, constant: 8)
        
        secondPopImageView = UIImageView(image: R.image.image_onbroading_12())
        addSubview(secondPopImageView)
        secondPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 88)
        secondPopImageView.addConstraintForAligning(to: .right, of: bottomImageView, constant: 0)
        
        thirdPopImageView = UIImageView(image: R.image.image_onbroading_13())
        addSubview(thirdPopImageView)
        thirdPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 104)
        thirdPopImageView.addConstraintForAligning(to: .left, of: bottomImageView, constant: 16)
        
        firstPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        secondPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        thirdPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        
        let attrS = NSMutableAttributedString.init(string: "不管是想要工作，聚會，讀書，你總是能找到最適合你的地方")
        attrS.addAttributes([NSParagraphStyleAttributeName: descriptionStyle],
                            range: NSRange.init(location: 0, length: attrS.length))
        
        
        introTitleLabel.text = "超實用咖啡地圖"
        introDescriptionLabel.attributedText = attrS
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
