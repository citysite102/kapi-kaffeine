//
//  KPRatingView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/3.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit


protocol KPRatingViewDelegate: NSObjectProtocol {
    func rateValueDidChanged(_ ratingView: KPRatingView)
}

class KPRatingView: UIView {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    weak open var delegate: KPRatingViewDelegate?
    var enable: Bool = true {
        didSet {
            self.isUserInteractionEnabled = enable
            for starView in self.starViews {
                starView.alpha = enable ? 1.0 : 0.5
            }
        }
    }
    var currentRate: Int = 0 {
        didSet {
            let animatedIndex = 5 - currentRate
            for (index, starView) in starViews.enumerated() {
                starView.selected = index >= animatedIndex ? true : false
            }
            delegate?.rateValueDidChanged(self)
        }
    }

    private var starViews:[KPBounceView] = [KPBounceView]()
    private var panGesture: UIPanGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()

    }
    
    func makeUI() {
        
        
        panGesture = UIPanGestureRecognizer(target: self,
                                            action: #selector(handlePanGesture(panGesture:)))
        panGesture.delegate = self
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTapGesture(tapGesture:)))
        
        addGestureRecognizer(panGesture)
        addGestureRecognizer(tapGesture)
        
        for index in 0..<5 {
            let starView = KPBounceView(R.image.icon_star_filled()!)
            starView.iconSize = CGSize(width: 44, height: 44)
            starViews.append(starView)
            addSubview(starView)
            if index == 0 {
                starView.addConstraints(fromStringArray: ["H:[$self(44)]-(>=0)-|",
                                                          "V:|[$self(44)]|"])
            } else if index == 4 {
                starView.addConstraints(fromStringArray: ["H:|[$self(44)]-8-[$view0]",
                                                          "V:|[$self(44)]|"],
                                        views:[starViews[index-1]])
            } else {
                starView.addConstraints(fromStringArray: ["H:[$self(44)]-8-[$view0]",
                                                          "V:|[$self(44)]|"],
                                        views:[starViews[index-1]])
            }
        }
        
    }
    
    
    
    // MARK:Button Type UI Event
    
    @objc func handleAddButtonOnTapped() {
        if currentRate < 5 {
            currentRate += 1
        }
    }
    
    @objc func handleMinusButtonOnTapped() {
        if currentRate > 0 {
            currentRate -= 1
        }
    }
    
    // MARK:Star Type UI Event
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            break
        case .changed:
            let touchPoint = panGesture.location(in: self)
            for (index, starView) in starViews.enumerated() {
                if starView.frame.contains(touchPoint) {
                    currentRate = 5 - index
                    break
                }
            }
            break
        case .ended, .cancelled:
            break
        case .failed, .possible:
            break
        }
        
    }
    
    @objc func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        let touchPoint = tapGesture.location(in: self)
        for (index, starView) in starViews.enumerated() {
            if starView.frame.contains(touchPoint) {
                currentRate = 5 - index
                break
            }
        }
    }
    
    //MARK: Segmented Type UI Event
    @objc func handleSegmentedValueChanged(_ sender: KPSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentRate = 0
        } else if sender.selectedSegmentIndex == 1 {
            currentRate = 3
        } else if sender.selectedSegmentIndex == 2 {
            currentRate = 4
        }
    }
    
}

extension KPRatingView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
