//
//  KPLoadingView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPLoadingView: UIView {

    enum loadingState: String, RawRepresentable {
        case loading = "loading"
        case successed = "successed"
        case failed = "failed"
        case exp = "exp"
    }
    
    private var container: UIView!
    private var indicator: UIActivityIndicatorView!
    private var successContent: String! = "留言成功"
    private var failContent: String! = "留言失敗"
    
    var loadingContents: (loading: String,
        success: String,
        failed: String)? {
        didSet {
            self.displayLabel.text = loadingContents?.loading
            self.successContent = loadingContents?.success
            self.failContent = loadingContents?.failed
        }
    }
    
    var exp: NSNumber! {
        didSet {
            self.displayLabel.text = ""
        }
    }
    
    var iconView: UIImageView!
    
    var state: loadingState = .loading {
        didSet {
            switch state {
            case .successed:
                iconView.image = R.image.notification_success()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self.performStateAnimation(.successed)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.dismiss()
                }
            case .failed:
                iconView.image = R.image.notification_fail()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self.performStateAnimation(.failed)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.dismiss()
                }
            case .exp:
                iconView.image = R.image.notification_exp()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self.performStateAnimation(.exp)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.dismiss()
                }
            default:
                self.container.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.iconView.alpha = 0
                self.indicator.alpha = 1.0
                self.indicator.transform = .identity
                self.displayLabel.text = loadingContents != nil ? loadingContents?.loading : "載入中..."
                self.indicator.startAnimating()
            }
        }
    }
    
    lazy var displayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        container = UIView()
        container.backgroundColor = KPColorPalette.KPMainColor.grayColor_level3
        container.layer.cornerRadius = 8.0
        container.layer.masksToBounds = true
        addSubview(container)
        container.addConstraints(fromStringArray: ["V:[$self(96)]",
                                                   "H:[$self(96)]"])
        container.addConstraintForCenterAligningToSuperview(in: .vertical)
        container.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        container.addSubview(indicator)
        indicator.addConstraints(fromStringArray: ["V:|-16-[$self]"])
        indicator.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        container.addSubview(displayLabel)
        displayLabel.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]"],
                                    views: [indicator])
        displayLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        iconView = UIImageView(image: R.image.notification_success()!)
        iconView.tintColor = UIColor.white
        container.addSubview(iconView)
        iconView.addConstraints(fromStringArray: ["V:|-16-[$self(36)]",
                                                     "H:[$self(36)]"])
        iconView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        iconView.transform = CGAffineTransform(translationX: 0, y: 20)
        iconView.alpha = 0

    }
    
    func performStateAnimation(_ state: loadingState) {
        
        let fadeTransition = CATransition()
        
        if state == .exp {
            
            fadeTransition.duration = 0.2
            indicator.isHidden = true
            iconView.transform = CGAffineTransform(translationX: 0, y: 12)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: .curveEaseOut,
                           animations: {
                            self.iconView.alpha = 1.0
                            self.iconView.transform = CGAffineTransform.identity
            }) { (_) in
                
            }
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                switch state {
                case .exp:
                    self.displayLabel.text = String(format: "經驗值+%d", self.exp.intValue)
                default:
                    self.displayLabel.text = "Default"
                }
                self.displayLabel.layer.add(fadeTransition, forKey: nil)
            })
            displayLabel.text = ""
            displayLabel.layer.add(fadeTransition, forKey: nil)
            CATransaction.commit()
            
        } else {
            
            fadeTransition.duration = 0.2
        
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                            self.indicator.alpha = 0
                            self.indicator.transform = CGAffineTransform(translationX: 0, y: -24)
            }) { (_) in
                
            }
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.1,
                           options: .curveEaseOut,
                           animations: {
                            self.iconView.alpha = 1.0
                            self.iconView.transform = CGAffineTransform.identity
            }) { (_) in
                
            }
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                switch state {
                case .exp:
                    self.displayLabel.text = String(format: "經驗值+%d", self.exp.intValue)
                case .failed:
                    self.displayLabel.text = self.failContent
                case .successed:
                    self.displayLabel.text = self.successContent
                default:
                    self.displayLabel.text = "Default"
                }
                self.displayLabel.layer.add(fadeTransition, forKey: nil)
            })
            displayLabel.text = ""
            displayLabel.layer.add(fadeTransition, forKey: nil)
            CATransaction.commit()
        }
    }
    
    
    func dismiss() {
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: { 
                        self.container.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
