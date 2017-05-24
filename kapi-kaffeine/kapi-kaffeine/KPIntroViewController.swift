//
//  KPIntroViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/22.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import BenzeneFoundation

class KPIntroViewController: KPViewController {

    var statusBarShouldBeHidden = false
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    var skipButton: UIButton!
//    
    var firstIntroView: KPFirstIntroView!
    var secondIntroView: KPSecondIntroView!
    var thirdIntroView: KPThirdIntroView!
    var forthIntroView: KPForthIntroView!
    var fifthIntroView: KPFifthIntroView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let layer = CAGradientLayer()
        layer.colors = [KPColorPalette.KPMainColor.mainColor_light!.cgColor,
                        KPColorPalette.KPMainColor.mainColor!.cgColor]
        layer.locations = [0.0, 1.0]
        layer.frame = UIScreen.main.bounds
        view.layer.addSublayer(layer)
        
        
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        
        skipButton = UIButton()
        skipButton.setTitle("略過", for: .normal)
        skipButton.setBackgroundImage(UIImage.init(color: UIColor.clear),
                                      for: .normal)
        skipButton.setBackgroundImage(UIImage.init(color: UIColor.white),
                                      for: .highlighted)
        skipButton.setTitleColor(UIColor.white, for: .normal)
        skipButton.setTitleColor(KPColorPalette.KPMainColor.mainColor,
                                 for: .highlighted)
        skipButton.layer.borderColor = UIColor.white.cgColor
        skipButton.layer.borderWidth = 1.0
        skipButton.layer.cornerRadius = 2.0
        skipButton.layer.masksToBounds = true
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        skipButton.addTarget(self, action: #selector(skipButtonOnTapped(_:)),
                             for: UIControlEvents.touchUpInside)
        
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        
        skipButton.addConstraints(fromStringArray: ["V:|-24-[$self(32)]",
                                                    "H:[$self(48)]-16-|"])
        
        pageControl.addConstraintForCenterAligningToSuperview(in: .horizontal)
        pageControl.addConstraint(from: "V:[$self(40)]-32-|")
        
        scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                    "H:|[$self]|"])
        
        firstIntroView = KPFirstIntroView()
        secondIntroView = KPSecondIntroView()
        thirdIntroView = KPThirdIntroView()
        forthIntroView = KPForthIntroView()
        fifthIntroView = KPFifthIntroView()
        
        
        scrollView.addSubview(firstIntroView)
        scrollView.addSubview(secondIntroView)
        scrollView.addSubview(thirdIntroView)
        scrollView.addSubview(forthIntroView)
        scrollView.addSubview(fifthIntroView)
        
        firstIntroView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                        "H:|[$self]"])
        firstIntroView.addConstraintForHavingSameHeight(with: self.view)
        firstIntroView.addConstraintForHavingSameWidth(with: self.view)
        
        secondIntroView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                        "H:[$view0][$self]"],
                                      views:[firstIntroView])
        secondIntroView.addConstraintForHavingSameHeight(with: self.view)
        secondIntroView.addConstraintForHavingSameWidth(with: self.view)
        
        thirdIntroView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                        "H:[$view0][$self]"],
                                      views:[secondIntroView])
        thirdIntroView.addConstraintForHavingSameHeight(with: self.view)
        thirdIntroView.addConstraintForHavingSameWidth(with: self.view)
        
        forthIntroView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                        "H:[$view0][$self]"],
                                      views:[thirdIntroView])
        forthIntroView.addConstraintForHavingSameHeight(with: self.view)
        forthIntroView.addConstraintForHavingSameWidth(with: self.view)
        
        fifthIntroView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                        "H:[$view0][$self]|"],
                                      views:[forthIntroView])
        fifthIntroView.addConstraintForHavingSameHeight(with: self.view)
        fifthIntroView.addConstraintForHavingSameWidth(with: self.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width*5,
                                        height: UIScreen.main.bounds.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    // MARK: UI Event
    
    func skipButtonOnTapped(_ sender: UIButton) {
        
        if self.appModalController() != nil {
            self.appModalController()?.dismissControllerWithDefaultDuration()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension KPIntroViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let current = scrollView.contentOffset.x/UIScreen.main.bounds.size.width
        pageControl.currentPage = Int(current)
        
        if pageControl.currentPage == 1 {
            self.secondIntroView.showPopContents()
        } else if pageControl.currentPage == 2 {
            self.thirdIntroView.showPopContents()
        } else if pageControl.currentPage == 3 {
            self.forthIntroView.showPopContents()
        } else if pageControl.currentPage == 4 {
            self.fifthIntroView.showPopContents()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let current = scrollView.contentOffset.x/UIScreen.main.bounds.size.width
        let currentProgress = CGFloat(Int(scrollView.contentOffset.x) - Int(current)*Int(UIScreen.main.bounds.size.width)) /
            UIScreen.main.bounds.size.width
        print("Current:\(current), Offset:\(currentProgress)")
        

        let scale = 1.0 - fabs(currentProgress)*0.2
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/1200.0
        transform = CATransform3DRotate(transform, BFAngleFromDegree(max(-90, min(90, -currentProgress * 2 * 90))),
                                        1,
                                        0,
                                        0)
        transform = CATransform3DScale(transform, scale, scale, 1)
        
        if current > 1 && current < 2 {
            self.thirdIntroView.updateLayoutWithProgress(currentProgress)
        } else if current > 3 && current < 4 {
            self.fifthIntroView.updateLayoutWithProgress(currentProgress)
        }
    }
}
