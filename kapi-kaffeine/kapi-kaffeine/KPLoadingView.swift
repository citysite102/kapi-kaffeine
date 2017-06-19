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
    }
    
    private var container: UIView!
    private var indicator: UIActivityIndicatorView!
    
    
    var loadingContents: (loading: String, success: String, failed: String)! {
        didSet {
            self.loadingLabel.text = loadingContents.loading
            self.successContent = loadingContents.success
            self.failContent = loadingContents.failed
        }
    }
    
    private var successContent: String! = "留言成功"
    private var successView: UIImageView!
    private var failContent: String! = "留言失敗"
    private var failedView: UIImageView!
    
    var state: loadingState = .loading {
        didSet {
            switch state {
            case .successed:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self.performStateAnimation(.successed)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.dismiss()
                }
            case .failed:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self.performStateAnimation(.failed)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.dismiss()
                }
            default:
                self.container.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.successView.alpha = 0
                self.failedView.alpha = 0
                self.indicator.alpha = 1.0
                self.indicator.transform = .identity
                self.indicator.startAnimating()
            }
        }
    }
    
    lazy var loadingLabel: UILabel = {
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
        
        indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        container.addSubview(indicator)
        indicator.addConstraints(fromStringArray: ["V:|-16-[$self]"])
        indicator.addConstraintForCenterAligningToSuperview(in: .horizontal)
        indicator.startAnimating()
        
        container.addSubview(loadingLabel)
        loadingLabel.text = "載入中..."
        loadingLabel.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]"],
                                    views: [indicator])
        loadingLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        successView = UIImageView.init(image: R.image.icon_loading_success()?.withRenderingMode(.alwaysTemplate))
        successView.tintColor = UIColor.white
        container.addSubview(successView)
        successView.addConstraints(fromStringArray: ["V:|-20-[$self]"])
        successView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        successView.transform = CGAffineTransform.init(translationX: 0, y: 24)
        successView.alpha = 0
        
        failedView = UIImageView.init(image: R.image.icon_loading_success()?.withRenderingMode(.alwaysTemplate))
        failedView.tintColor = UIColor.white
        container.addSubview(failedView)
        failedView.addConstraints(fromStringArray: ["V:|-20-[$self]"])
        failedView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        failedView.transform = CGAffineTransform.init(translationX: 0, y: 24)
        failedView.alpha = 0

    }
    
    func performStateAnimation(_ state: loadingState) {
        
        let fadeTransition = CATransition()
        fadeTransition.duration = 0.35
        
        switch state {
        case .successed:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                            self.indicator.alpha = 0
                            self.indicator.transform = CGAffineTransform.init(translationX: 0, y: -24)
            }) { (_) in
                
            }
            UIView.animate(withDuration: 0.35,
                           delay: 0.2,
                           options: .curveEaseOut,
                           animations: {
                            self.successView.alpha = 1.0
                            self.successView.transform = CGAffineTransform.identity
            }) { (_) in
                
            }
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.loadingLabel.text = self.successContent
                self.loadingLabel.layer.add(fadeTransition, forKey: nil)
            })
            loadingLabel.text = ""
            loadingLabel.layer.add(fadeTransition, forKey: nil)
            CATransaction.commit()
        case .failed:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                            self.indicator.alpha = 0
                            self.indicator.transform = CGAffineTransform.init(translationX: 0, y: -24)
            }) { (_) in
                
            }
            UIView.animate(withDuration: 0.3,
                           delay: 0.2,
                           options: .curveEaseOut,
                           animations: {
                            self.failedView.alpha = 1.0
                            self.failedView.transform = CGAffineTransform.identity
            }) { (_) in
                
            }
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.loadingLabel.text = self.failContent
                self.loadingLabel.layer.add(fadeTransition, forKey: nil)
            })
            loadingLabel.text = ""
            loadingLabel.layer.add(fadeTransition, forKey: nil)
            CATransaction.commit()
        default:
            break
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
