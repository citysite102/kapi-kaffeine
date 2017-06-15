//
//  KPForthIntroView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPForthIntroView: KPSharedIntroView {

    var container: UIView!
    var firstPopImageView: UIImageView!
    var secondPopImageView: UIImageView!
    var thirdPopImageView: UIImageView!
    var starImageViewOne: UIImageView!
    var starImageViewTwo: UIImageView!
    var starImageViewThree: UIImageView!
    var starImageViewFour: UIImageView!
    var starImageViewFive: UIImageView!
    
    
    var animateSpeekBox: UIView!
    var animateSpeekBoxTwo: UIView!
    var animateSpeekBoxThree: UIView!
    
    var animateStarView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        container = UIView()
        addSubview(container)
        container.addConstraints(fromStringArray: ["V:|-80-[$self]",
                                                   "H:[$self(260)]"])
        container.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        firstPopImageView = UIImageView(image: R.image.image_onbroading_41())
        container.addSubview(firstPopImageView)
        firstPopImageView.addConstraints(fromStringArray: ["V:|[$self]",
                                                           "H:|-5-[$self]"])
        
        secondPopImageView = UIImageView(image: R.image.image_onbroading_42())
        container.addSubview(secondPopImageView)
        secondPopImageView.addConstraints(fromStringArray: ["V:|[$self]",
                                                            "H:[$self]-4-|"])
        animateSpeekBox = UIView()
        animateSpeekBox.backgroundColor = UIColor(rgbaHexValue: 0xD4D4D4FF)
        animateSpeekBox.layer.cornerRadius = 2.0
        animateSpeekBox.layer.masksToBounds = true
        secondPopImageView.addSubview(animateSpeekBox)
        animateSpeekBox.addConstraints(fromStringArray: ["V:|-14-[$self(7)]",
                                                         "H:|-16-[$self(120)]"])
        
        animateSpeekBoxTwo = UIView()
        animateSpeekBoxTwo.backgroundColor = UIColor(rgbaHexValue: 0xD4D4D4FF)
        animateSpeekBoxTwo.layer.cornerRadius = 2.0
        animateSpeekBoxTwo.layer.masksToBounds = true
        secondPopImageView.addSubview(animateSpeekBoxTwo)
        animateSpeekBoxTwo.addConstraints(fromStringArray: ["V:|-27-[$self(7)]",
                                                            "H:|-16-[$self(120)]"],
                                       views:[animateSpeekBox])
        
        animateSpeekBoxThree = UIView()
        animateSpeekBoxThree.backgroundColor = UIColor(rgbaHexValue: 0xD4D4D4FF)
        animateSpeekBoxThree.layer.cornerRadius = 2.0
        animateSpeekBoxThree.layer.masksToBounds = true
        secondPopImageView.addSubview(animateSpeekBoxThree)
        animateSpeekBoxThree.addConstraints(fromStringArray: ["V:|-40-[$self(7)]",
                                                              "H:|-16-[$self(70)]"],
                                       views:[animateSpeekBoxTwo])
        
        
        thirdPopImageView = UIImageView(image: R.image.image_onbroading_43())
        container.addSubview(thirdPopImageView)
        thirdPopImageView.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]",
                                                           "H:|[$self]|"],
                                         views: [secondPopImageView])
        
        animateStarView =  UIImageView(image: R.image.image_onbroading_star_animate()?.withRenderingMode(.alwaysTemplate))
        animateStarView.tintColor = KPColorPalette.KPMainColor.grayColor_level5
        thirdPopImageView.addSubview(animateStarView)
        animateStarView.addConstraints(fromStringArray: ["V:|-16-[$self]",
                                                         "H:|-87-[$self]"])
        
        
        starImageViewOne = UIImageView(image: R.image.image_onbroading_star_1())
        container.addSubview(starImageViewOne)
        starImageViewOne.addConstraints(fromStringArray: ["V:[$view0]-50-[$self]-16-|",
                                                          "H:|-16-[$self]"],
                                         views: [thirdPopImageView])
        
        starImageViewTwo = UIImageView(image: R.image.image_onbroading_star_2())
        container.addSubview(starImageViewTwo)
        starImageViewTwo.addConstraints(fromStringArray: ["V:[$view0]-32-[$self]",
                                                          "H:[$view1]-12-[$self]"],
                                        views: [thirdPopImageView, starImageViewOne])
        
        starImageViewThree = UIImageView(image: R.image.image_onbroading_star_3())
        container.addSubview(starImageViewThree)
        starImageViewThree.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]"],
                                          views: [thirdPopImageView])
        starImageViewThree.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        starImageViewFive = UIImageView(image: R.image.image_onbroading_star_1())
        container.addSubview(starImageViewFive)
        starImageViewFive.addConstraints(fromStringArray: ["V:[$view0]-50-[$self]",
                                                           "H:[$self]-16-|"],
                                         views: [thirdPopImageView])
        
        starImageViewFour = UIImageView(image: R.image.image_onbroading_star_2())
        container.addSubview(starImageViewFour)
        starImageViewFour.addConstraints(fromStringArray: ["V:[$view0]-32-[$self]",
                                                            "H:[$self]-12-[$view1]"],
                                          views: [thirdPopImageView, starImageViewFive])
        
        introTitleLabel.text = "留下你的足跡"
        introDescriptionLabel.textAlignment = .center
        introDescriptionLabel.setText(text: "為店家評分，留言，上傳照片，讓特別的時光留下美好回憶",
                                      lineSpacing: KPFactorConstant.KPSpacing.introSpacing)
        
        
        animateSpeekBox.isHidden = true
        animateSpeekBoxTwo.isHidden = true
        animateSpeekBoxThree.isHidden = true

        starImageViewOne.isHidden = true
        starImageViewTwo.isHidden = true
        starImageViewThree.isHidden = true
        starImageViewFour.isHidden = true
        starImageViewFive.isHidden = true
    
    }
    
    func showPopContents() {
        
        
        animateSpeekBox.isHidden = false
        animateSpeekBoxTwo.isHidden = false
        animateSpeekBoxThree.isHidden = false
        
        starImageViewOne.isHidden = false
        starImageViewTwo.isHidden = false
        starImageViewThree.isHidden = false
        starImageViewFour.isHidden = false
        starImageViewFive.isHidden = false
        
        let oldBoxOneFrame = animateSpeekBox.frame
        let oldBoxTwoFrame = animateSpeekBoxTwo.frame
        let oldBoxThreeFrame = animateSpeekBoxThree.frame
        
        animateSpeekBox.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        animateSpeekBox.frame = oldBoxOneFrame
        animateSpeekBox.transform = CGAffineTransform(scaleX: 0, y: 1)
        animateSpeekBoxTwo.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        animateSpeekBoxTwo.frame = oldBoxTwoFrame
        animateSpeekBoxTwo.transform = CGAffineTransform(scaleX: 0, y: 1)
        animateSpeekBoxThree.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        animateSpeekBoxThree.frame = oldBoxThreeFrame
        animateSpeekBoxThree.transform = CGAffineTransform(scaleX: 0, y: 1)
        
        starImageViewOne.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        starImageViewTwo.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        starImageViewThree.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        starImageViewFour.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        starImageViewFive.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.animateSpeekBox.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.animateSpeekBoxTwo.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.2,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.animateSpeekBoxThree.transform = CGAffineTransform.identity
        }) { (_) in
            
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseOut,
                           animations: {
                            self.animateStarView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }) { (_) in
                UIView.animate(withDuration: 0.3,
                               delay: 0.0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.8,
                               options: .curveEaseOut,
                               animations: {
                                self.animateStarView.tintColor = UIColor(rgbaHexValue: 0xF9C816FF)
                                self.animateStarView.transform = CGAffineTransform.identity
                }) { (_) in
                    self.performStarAnimation(0.1)
                }
            }
            
        }
    }
    
    func performStarAnimation(_ delay: TimeInterval) {
        
        UIView.animate(withDuration: 0.6,
                       delay: delay+0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.starImageViewOne.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.6,
                       delay: delay+0.1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.starImageViewTwo.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.6,
                       delay: delay+0.2,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.starImageViewThree.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.6,
                       delay: delay+0.3,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.starImageViewFour.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.6,
                       delay: delay+0.4,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.starImageViewFive.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
