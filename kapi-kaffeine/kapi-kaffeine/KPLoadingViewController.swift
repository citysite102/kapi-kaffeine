//
//  KPLoadingViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPLoadingViewController: UIViewController {

    enum loadingState: String, RawRepresentable {
        case loading = "loading"
        case successed = "successed"
        case failed = "failed"
    }
    
    private var container: UIView!
    private var indicator: UIActivityIndicatorView!
    
    
    var successContent: String! = "留言成功"
    var successView: UIImageView!
    
    var failContent: String! = "留言失敗"
    var failedView: UIImageView!
    
    var state: loadingState = .loading {
        didSet {
            switch state {
            case .successed:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self.performStateAnimation(.successed)
                }
            case .failed:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self.performStateAnimation(.failed)
                }
            default:
                print("Still Nothing")
            }
        }
    }
    
    lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        container = UIView()
        container.backgroundColor = KPColorPalette.KPMainColor.grayColor_level3
        container.layer.cornerRadius = 8.0
        container.layer.masksToBounds = true
        view.addSubview(container)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.2) {
            self.state = .successed
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performStateAnimation(_ state: loadingState) {
        
        let fadeTransition = CATransition()
        fadeTransition.duration = 0.3
        
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
            UIView.animate(withDuration: 0.3,
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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.appModalController()?.dismissController(duration: 0.5)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
