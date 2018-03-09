//
//  KPLoadingViewController_v1.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPLoadingViewController_v1: KPViewController {

//    enum loadingState: String, RawRepresentable {
//        case loading = "loading"
//        case successed = "successed"
//        case failed = "failed"
//    }
    
    var container: UIView!
    var outerShape: CAShapeLayer!
    var loadingShape: CAShapeLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        container = UIView()
        container.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level3
        container.layer.cornerRadius = 4.0
        container.layer.masksToBounds = true
        view.addSubview(container)
        container.addConstraints(fromStringArray: ["V:[$self(88)]",
                                                   "H:[$self(88)]"])
        container.addConstraintForCenterAligningToSuperview(in: .vertical)
        container.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        outerShape = CAShapeLayer();
        outerShape.strokeColor = UIColor.white.cgColor
        outerShape.lineWidth   = 2.0;
        outerShape.fillColor   = UIColor.clear.cgColor
        outerShape.lineCap     = kCALineCapRound;
        container.layer.addSublayer(outerShape);
        
        outerShape.path        = UIBezierPath(ovalIn: CGRect(x: 20,
                                                             y: 20,
                                                             width: 48,
                                                             height: 48)).cgPath
        outerShape.frame       = CGRect(x: 0, y: 0, width: 88, height: 88)
        
        loadingShape = CAShapeLayer();
        loadingShape.strokeColor = UIColor.white.cgColor
        loadingShape.lineWidth   = 2.0;
        loadingShape.fillColor   = UIColor.clear.cgColor
        loadingShape.lineCap     = kCALineCapRound;
        loadingShape.strokeEnd   = 0.8;
        loadingShape.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        container.layer.addSublayer(loadingShape);
        
        loadingShape.path        = UIBezierPath(ovalIn: CGRect(x: 32,
                                                               y: 32,
                                                               width: 24,
                                                               height: 24)).cgPath
        loadingShape.frame       = CGRect(x: 0, y: 0, width: 88, height: 88)
        
        self.performLoadingAnimation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performLoadingAnimation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.2) {
            self.loadingShape.isHidden = false
            let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
            spinAnimation.fromValue = 0
            spinAnimation.toValue = CGFloat.pi*2
            spinAnimation.duration = 0.8
            spinAnimation.repeatCount = Float(CGFloat.infinity)
            self.loadingShape.add(spinAnimation, forKey: nil)
        }
    }

}
