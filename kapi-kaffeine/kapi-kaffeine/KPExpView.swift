//
//  KPExpView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/5.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import M13ProgressSuite

class KPExpView: UIView {

    
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        label.text = "LV1"
        return label
    }()
    
    lazy var expLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        label.text = "80/100"
        return label
    }()
    
    var progressView: M13ProgressViewBar!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(levelLabel)
        levelLabel.addConstraints(fromStringArray: ["V:|[$self]",
                                                    "H:|[$self]"])
        
        addSubview(expLabel)
        expLabel.addConstraints(fromStringArray: ["V:|[$self]",
                                                  "H:[$self]|"])
        
        progressView = M13ProgressViewBar(frame: .zero)
        progressView.showPercentage = false
        progressView.progressBarThickness = 4
        progressView.progressBarCornerRadius = 2
        progressView.secondaryColor = KPColorPalette.KPBackgroundColor.exp_background
        progressView.primaryColor = KPColorPalette.KPTextColor.whiteColor
        
        addSubview(progressView)
        progressView.addConstraints(fromStringArray: ["V:[$self(10)]|",
                                                      "H:|[$self]|"])
        progressView.setProgress(0.2, animated: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
