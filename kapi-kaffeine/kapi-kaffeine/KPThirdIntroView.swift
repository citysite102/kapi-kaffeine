//
//  KPThirdIntroView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPThirdIntroView: KPSharedIntroView {

    var firstPopImageView: UIImageView!
    var secondPopImageView: UIImageView!
    var thirdPopImageView: UIImageView!
    var forthPopImageView: UIImageView!
    var fifthPopImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame);
        
        
        firstPopImageView = UIImageView(image: R.image.image_onbroading_31())
        firstPopImageView.contentMode = .scaleAspectFit
        addSubview(firstPopImageView)
        firstPopImageView.addConstraints(fromStringArray: ["V:[$self]",
                                                           "H:[$self]"])
        firstPopImageView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        firstPopImageView.addConstraintForCenterAligningToSuperview(in: .vertical, constant: -168)
        
        secondPopImageView = UIImageView(image: R.image.image_onbroading_32())
        addSubview(secondPopImageView)
        secondPopImageView.addConstraints(fromStringArray: ["V:[$view0]-4-[$self]",
                                                            "H:[$self]"],
                                          views:[firstPopImageView])
        secondPopImageView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        thirdPopImageView = UIImageView(image: R.image.image_onbroading_33())
        addSubview(thirdPopImageView)
        thirdPopImageView.addConstraints(fromStringArray: ["V:[$view0]-4-[$self]",
                                                            "H:[$self]"],
                                          views:[secondPopImageView])
        thirdPopImageView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        forthPopImageView = UIImageView(image: R.image.image_onbroading_34())
        addSubview(forthPopImageView)
        forthPopImageView.addConstraints(fromStringArray: ["V:[$view0]-24-[$self]",
                                                            "H:[$self]"],
                                         views:[thirdPopImageView])
        forthPopImageView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        fifthPopImageView = UIImageView(image: R.image.image_onbroading_35())
        addSubview(fifthPopImageView)
        fifthPopImageView.addConstraintForAligning(to: .top, of: forthPopImageView, constant: 0)
        fifthPopImageView.addConstraintForAligning(to: .right, of: forthPopImageView, constant: 56)
        
//        fifthPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        introTitleLabel.text = "快速找到目的地"
        introDescriptionLabel.textAlignment = .center
        introDescriptionLabel.setText(text: "關鍵字搜尋，偏好篩選，附近店家，方法不只一個，但絕對快速簡單",
                                      lineSpacing: KPFactorConstant.KPSpacing.introSpacing)
    }
    
    func showPopContents() {
        
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: 0.5,
//                       initialSpringVelocity: 0.8,
//                       options: .curveEaseOut,
//                       animations: {
//                        self.fifthPopImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        }) { (_) in
//            
//        }
    }
    
    
    func updateLayoutWithProgress(_ progress: CGFloat) {
        print("Progress:\(320-320*progress)")
        firstPopImageView.transform = CGAffineTransform(translationX: progress == 0 ? 0 : 140-140*progress,
                                                        y: 0)
        secondPopImageView.transform = CGAffineTransform(translationX: progress == 0 ? 0 : 200-200*progress,
                                                        y: 0)
        thirdPopImageView.transform = CGAffineTransform(translationX: progress == 0 ? 0 : 260-260*progress,
                                                        y: 0)
        forthPopImageView.transform = CGAffineTransform(translationX: progress == 0 ? 0 : 320-320*progress,
                                                        y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
