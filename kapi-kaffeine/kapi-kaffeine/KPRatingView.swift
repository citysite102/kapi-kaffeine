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
    enum RateType: String, RawRepresentable {
        case button = "Button"
        case star = "Star"
        case segmented = "Segmented"
    }
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    weak open var delegate: KPRatingViewDelegate?
    var enable: Bool = true {
        didSet {
            self.isUserInteractionEnabled = enable
            self.addButton.alpha = enable ? 1.0 : 0.5
            self.minusButton.alpha = enable ? 1.0 : 0.5
            self.rateScoreLabel.alpha = enable ? 1.0: 0.4
            self.rateTitleLabel.alpha = enable ? 1.0 : 0.4
            self.iconImageView.alpha = enable ? 1.0 : 0.4
            for starView in self.starViews {
                starView.alpha = enable ? 1.0 : 0.5
            }
        }
    }
    var rateType: RateType = .button
    var currentRate: Int = 0 {
        didSet {
            switch rateType {
            case .button:
                rateScoreLabel.text = "\(currentRate)"
                minusButton.isEnabled = !(currentRate == 1)
                addButton.isEnabled = !(currentRate == 5)
            case .star:
                let animatedIndex = 5 - currentRate
                for (index, starView) in starViews.enumerated() {
                    starView.selected = index >= animatedIndex ? true : false
                }
            case .segmented:
                if currentRate < 3 {
                    segmentedControl.selectedSegmentIndex = 0
                } else if currentRate >= 4 {
                    segmentedControl.selectedSegmentIndex = 2
                } else {
                    segmentedControl.selectedSegmentIndex = 1
                }
            }
            
            delegate?.rateValueDidChanged(self)
        }
    }

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = KPColorPalette.KPMainColor.mainColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var rateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level1
        return label
    }()
    
    //----------------------------
    // MARK: - Type Properties
    //----------------------------
    
    lazy var minusButton: KPBounceButton = {
        let button = KPBounceButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.dampingRatio = 0.8
        button.bounceDuration = 0.5
        button.setImage(R.image.button_minus()!,
                        for: UIControlState.normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        return button
    }()
    
    lazy var addButton: KPBounceButton = {
        let button = KPBounceButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.dampingRatio = 0.8
        button.bounceDuration = 0.5
        button.setImage(R.image.button_add()!,
                        for: UIControlState.normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        button.imageView?.contentMode = .scaleAspectFit
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
    private var starViews:[KPBounceView] = [KPBounceView]()
    private var panGesture: UIPanGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    
    
    // Segmented
    private var segmentedControl: KPSegmentedControl!
    
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
        
        iconImageView.addConstraints(fromStringArray: ["V:[$self(24)]",
                                                       "H:|[$self(24)]"])
        iconImageView.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        switch rateType {
        case .button:
            rateTitleLabel.addConstraints(fromStringArray: ["H:[$view0]-16-[$self]"],
                                          views: [iconImageView])
            rateTitleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
            
            let scoreLabelContainer = UIView()
            addSubview(scoreLabelContainer)
            addSubview(minusButton)
            scoreLabelContainer.addSubview(rateScoreLabel)
            addSubview(addButton)
            
            addButton.addConstraints(fromStringArray: ["V:|[$self(40)]|",
                                                       "H:[$self(32)]|"])
            
            scoreLabelContainer.addConstraints(fromStringArray: ["H:[$self(32)]-(-2)-[$view0]",
                                                                 "V:|[$self(40)]|"],
                                               views: [addButton])
            rateScoreLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
            rateScoreLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
            minusButton.addConstraints(fromStringArray: ["H:[$self(32)]-(-2)-[$view0]",
                                                         "V:|[$self(40)]|"],
                                       views: [scoreLabelContainer])
            
            addButton.addTarget(self, action: #selector(handleAddButtonOnTapped),
                                for: .touchUpInside)
            minusButton.addTarget(self, action: #selector(handleMinusButtonOnTapped),
                                  for: .touchUpInside)
            
            currentRate = 1
        case .star:
            
            panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handlePanGesture(panGesture:)))
            panGesture.delegate = self
            tapGesture = UITapGestureRecognizer(target: self,
      action: #selector(handleTapGesture(tapGesture:)))
            
            addGestureRecognizer(panGesture)
            addGestureRecognizer(tapGesture)
            rateTitleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
            rateTitleLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                          views: [iconImageView])
            for index in 0..<5 {
                let starView = KPBounceView(R.image.icon_star()!)
                starView.iconSize = CGSize(width: 24, height: 24)
                starViews.append(starView)
                addSubview(starView)
                if index == 0 {
                    starView.addConstraints(fromStringArray: ["H:[$self(28)]|",
                                                              "V:|[$self(40)]|"])
                } else {
                    starView.addConstraints(fromStringArray: ["H:[$self(28)]-0-[$view0]",
                                                              "V:|[$self(40)]|"],
                                            views:[starViews[index-1]])
                }
            }
        case .segmented:
            
            rateTitleLabel.addConstraints(fromStringArray: ["H:[$view0]-16-[$self]"],
                                          views: [iconImageView])
            rateTitleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
            
            segmentedControl = KPSegmentedControl.init(["不限", "尚可", "優秀"],
                                                       [KPColorPalette.KPMainColor.mainColor_light!,
                                                        KPColorPalette.KPMainColor.starColor!,
                                                        KPColorPalette.KPMainColor.mainColor_sub!],
                                                       [KPColorPalette.KPTextColor.whiteColor!,
                                                        KPColorPalette.KPTextColor.mainColor!,
                                                        KPColorPalette.KPTextColor.whiteColor!])
            
            segmentedControl.addTarget(self, action: #selector(handleSegmentedValueChanged(_:)), for: .valueChanged)
            
            addSubview(segmentedControl)
            segmentedControl.addConstraints(fromStringArray: ["H:|-(\(KPSearchConditionViewControllerConstants.leftPadding-16))-[$self]-8-|",
                                                              "V:|-5-[$self(30)]-5-|"],
                                            views: [rateTitleLabel])
            
            
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
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        let touchPoint = tapGesture.location(in: self)
        for (index, starView) in starViews.enumerated() {
            if starView.frame.contains(touchPoint) {
                currentRate = 5 - index
                break
            }
        }
    }
    
    //MARK: Segmented Type UI Event
    func handleSegmentedValueChanged(_ sender: KPSegmentedControl) {
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
