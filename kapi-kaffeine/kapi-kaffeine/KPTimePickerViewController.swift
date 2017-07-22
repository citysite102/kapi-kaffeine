//
//  KPTimePickerViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 16/05/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol KPTimePickerViewControllerDelegate: class {
    func timePickerButtonDidTap(_ timePickerController: KPTimePickerViewController, selectedIndex index: Int)
}

class KPTimePickerViewController: UIViewController, KPTimePickerDelegate, KPTabViewDelegate, UIScrollViewDelegate {
    
    var tabView: KPTabView!
    
    private var scrollView: UIScrollView!
    private var containerView: UIView!
    
    weak var delegate: KPTimePickerViewControllerDelegate?
        
    var startTimePicker: KPTimePicker!
    var startTimeValue: String! {
        didSet {
            if startTimePicker != nil {
                startTimePicker.timeValue = startTimeValue
            }
        }
    }
    
    var endTimePicker: KPTimePicker!
    var endTimeValue: String! {
        didSet {
            if endTimePicker != nil {
                endTimePicker.timeValue = endTimeValue
            }
        }
    }
    
    var isAnimating: Bool = false {
        didSet {
            self.scrollView.isUserInteractionEnabled = !isAnimating
        }
    }
    
    private lazy var buttonContainer: UIView = {
        return UIView()
    }()
    
    var buttons: [UIButton] = []
    
    func setButtonTitles(_ titles:[String]) {
        for subview in buttonContainer.subviews {
            subview.removeFromSuperview()
        }
        buttons = []
        
        for (index, title) in titles.enumerated() {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor!),
                                          for: .normal)
            button.layer.cornerRadius = 4.0
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            buttonContainer.addSubview(button)
            button.addConstraint(from: "V:|-8-[$self(36)]-8-|")
            button.tag = index
            
            if index == 0 {
                button.addConstraint(from: "H:|-12-[$self]")
            } else {
                button.addConstraint(from: "H:[$view0]-[$self]",
                                     views: [buttons.last!])
                button.addConstraintForHavingSameWidth(with: buttons.last!)
            }
            
            buttons.append(button)
            
            button.addTarget(self, action: #selector(handleButtonOnTap(sender:)), for: .touchUpInside)
        }
        
        if let lastButton = buttons.last {
            lastButton.addConstraint(from: "H:[$self]-12-|")
        }
        
        view.layoutIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles = ["營業時間", "打祥時間"]
        
        view.backgroundColor = UIColor.white
        
        tabView = KPTabView(titles: titles)
        tabView.font = UIFont.boldSystemFont(ofSize: 16)
        tabView.delegate = self
        view.addSubview(tabView)
        tabView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self(60)]"])
        
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-[$self]"], views: [tabView])
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        containerView.addConstraintForHavingSameHeight(with: scrollView)
        
        
        startTimePicker = KPTimePicker()
        containerView.addSubview(startTimePicker)
        if startTimeValue != nil {
            startTimePicker.timeValue = startTimeValue
        }
        startTimePicker.addConstraints(fromStringArray: ["H:|[$self]", "V:|[$self]|"])
        startTimePicker.addConstraintForHavingSameWidth(with: scrollView)
        startTimePicker.delegate = self
        
        
        endTimePicker = KPTimePicker()
        containerView.addSubview(endTimePicker)
        if endTimeValue != nil {
            endTimePicker.timeValue = endTimeValue
        }
        endTimePicker.delegate = self
        endTimePicker.addConstraints(fromStringArray: ["H:[$view0][$self]|", "V:|[$self]|"],
                                     views: [startTimePicker])
        endTimePicker.addConstraintForHavingSameWidth(with: scrollView)
        endTimePicker.delegate = self
        
        let seporator = UIView()
        seporator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        view.addSubview(seporator)
        seporator.addConstraints(fromStringArray: ["H:|-8-[$self]-8-|",
                                                   "V:[$view0]-16-[$self(1)]"],
                                 views:[scrollView])
        
        view.addSubview(buttonContainer)
        buttonContainer.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]|"], views: [seporator])
        
//        let doneButton = UIButton()
//        doneButton.setTitle("完成", for: .normal)
//        doneButton.setTitleColor(UIColor.white, for: .normal)
//        doneButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor!),
//                                        for: .normal)
//        doneButton.layer.cornerRadius = 4.0
//        doneButton.layer.masksToBounds = true
//        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
//        view.addSubview(doneButton)
//        doneButton.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
//                                                    "V:[$view0]-16-[$self(40)]-16-|"],
//                                  views: [seporator])
//        doneButton.addTarget(self, action: #selector(handleDoneButtonOnTap(sender:)), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func valueUpdate(timePicker: KPTimePicker, value: String) {
        if timePicker == startTimePicker {
            startTimeValue = value
        } else if timePicker == endTimePicker {
            endTimeValue = value
        }
    }
    
    func tabView(_: KPTabView, didSelectIndex index: Int) {
        isAnimating = true
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frameSize.width*CGFloat(index), y: 0)
        }) { (complete) in
            self.isAnimating = false
        }
    }
    
    func handleButtonOnTap(sender: UIButton) {
        if delegate != nil {
            delegate!.timePickerButtonDidTap(self, selectedIndex: sender.tag)
        }
        self.appModalController()?.dismissControllerWithDefaultDuration()        
    }
    
    
    // MARK: UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isAnimating {
            return
        }
        let screenWidth = UIScreen.main.bounds.width
        tabView.currentIndex = Int((scrollView.contentOffset.x+screenWidth/2)/screenWidth)
    }
    
}
