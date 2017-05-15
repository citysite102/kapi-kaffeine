//
//  KPRatingView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/3.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPRatingView: UIView {

    
    enum RateType: String, RawRepresentable {
        case button = "Button"
        case star = "Star"
    }
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    var rateType: RateType = .button
    
    var currentRate: Int = 1 {
        didSet {
            switch rateType {
            case .button:
                rateScoreLabel.text = "\(currentRate)"
                minusButton.isEnabled = !(currentRate == 1)
                addButton.isEnabled = !(currentRate == 5)
            case .star:
                print("Not Implement")
            }
        }
    }
    
    var currentStarIndex: Int = 4
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var rateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor
        return label
    }()
    
    //----------------------------
    // MARK: - Type Properties
    //----------------------------
    
    lazy var minusButton: KPBounceButton = {
        let button = KPBounceButton.init()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.dampingRatio = 0.8
        button.bounceDuration = 0.5
        button.setBackgroundImage(UIImage.init(color: KPColorPalette.KPBackgroundColor.scoreButtonColor!),
                                  for: UIControlState.normal)
        button.setBackgroundImage(UIImage.init(color: KPColorPalette.KPBackgroundColor.disabledScoreButtonColor!),
                                  for: UIControlState.disabled)
        button.setImage(R.image.icon_minus()?.withRenderingMode(.alwaysTemplate),
                        for: UIControlState.normal)
        button.imageView?.tintColor = UIColor.white
        button.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        return button
    }()
    
    lazy var addButton: KPBounceButton = {
        let button = KPBounceButton.init()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.dampingRatio = 0.8
        button.bounceDuration = 0.5
        button.setBackgroundImage(UIImage.init(color: KPColorPalette.KPBackgroundColor.scoreButtonColor!),
                                  for: UIControlState.normal)
        button.setBackgroundImage(UIImage.init(color: KPColorPalette.KPBackgroundColor.disabledScoreButtonColor!),
                                  for: UIControlState.disabled)
        button.setImage(R.image.icon_add()?.withRenderingMode(.alwaysTemplate),
                        for: UIControlState.normal)
        button.imageView?.tintColor = UIColor.white
        button.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        return button
    }()
    
    lazy var rateScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.textAlignment = .center
        return label
    }()
    
    // Star Type
    var starViews:[KPBounceView] = [KPBounceView]()
    var panGesture: UIPanGestureRecognizer!
    var tapGesture: UITapGestureRecognizer!
    
    
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ type: RateType = RateType.button,
                     _ icon: UIImage,
                     _ title: String) {
        self.init(frame: .zero)
        
        rateType = type
        rateTitleLabel.text = title
        iconImageView.image = icon
        
        addSubview(iconImageView)
        addSubview(rateTitleLabel)
        makeUI()
    }
    
    func makeUI() {
        switch rateType {
        case .button:
            iconImageView.addConstraints(fromStringArray: ["H:|[$self]"])
            iconImageView.addConstraintForCenterAligningToSuperview(in: .vertical)
            rateTitleLabel.addConstraints(fromStringArray: ["H:[$view0]-16-[$self]"],
                                          views: [iconImageView])
            rateTitleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
            
            addSubview(minusButton)
            addSubview(rateScoreLabel)
            addSubview(addButton)
            
            addButton.addConstraints(fromStringArray: ["V:|[$self(24)]|",
                                                       "H:[$self(24)]|"])
            rateScoreLabel.addConstraints(fromStringArray: ["H:[$self]-16-[$view0]"],
                                          views: [addButton])
            rateScoreLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
            minusButton.addConstraints(fromStringArray: ["H:[$self(24)]-16-[$view0]",
                                                         "V:|[$self(24)]|"],
                                       views: [rateScoreLabel])
            
            addButton.addTarget(self, action: #selector(handleAddButtonOnTapped),
                                for: .touchUpInside)
            minusButton.addTarget(self, action: #selector(handleMinusButtonOnTapped),
                                  for: .touchUpInside)
            
            currentRate = 1
        case .star:
            
            panGesture = UIPanGestureRecognizer.init(target: self,
                                                     action: #selector(handlePanGesture(panGesture:)))
            tapGesture = UITapGestureRecognizer.init(target: self,
                                                     action: #selector(handleTapGesture(tapGesture:)))
            
            addGestureRecognizer(panGesture)
            
            iconImageView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                           "H:|[$self]"])
            rateTitleLabel.addConstraints(fromStringArray: ["H:[$view0]-16-[$self]"],
                                          views: [iconImageView])
            rateTitleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
            for index in 0..<5 {
                let starView = KPBounceView.init(R.image.icon_star()!)
                starViews.append(starView)
                addSubview(starView)
                if index == 0 {
                    starView.addConstraints(fromStringArray: ["H:[$self(24)]|",
                                                              "V:|-2-[$self(24)]-2-|"])
                } else {
                    starView.addConstraints(fromStringArray: ["H:[$self(24)]-4-[$view0]",
                                                              "V:|-2-[$self(24)]-2-|"],
                                            views:[starViews[index-1]])
                }
            }
            
        }
    }
    
    
    
    // MARK:Button Type UI Event
    
    func handleAddButtonOnTapped() {
        if currentRate < 5 {
            currentRate += 1
        }
    }
    
    func handleMinusButtonOnTapped() {
        if currentRate > 0 {
            currentRate -= 1
        }
    }
    
    // MARK:Star Type UI Event
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        
        switch panGesture.state {
        case .began:
            break
        case .changed:
            let touchPoint = panGesture.location(in: self)
            for (index, starView) in starViews.enumerated() {
                if starView.frame.contains(touchPoint) {
                    currentStarIndex = index
                    break
                }
            }

            for (index, starView) in starViews.enumerated() {
                starView.selected = index >= currentStarIndex ? true : false
            }
            
            break
        case .ended, .cancelled:
            break
        case .failed, .possible:
            break
        }
        
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        let touchPoint = tapGesture.location(in: self)
        for (index, starView) in starViews.enumerated() {
            if starView.frame.contains(touchPoint) {
                currentStarIndex = index
                break
            }
        }
        
        for (index, starView) in starViews.enumerated() {
            starView.selected = index >= currentStarIndex ? true : false
        }
    }
    
}
