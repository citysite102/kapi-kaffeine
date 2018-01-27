
//
//  KPArticleQuoteView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/1/26.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPArticleQuoteView: UIView {

    
    var quoteContent: String! {
        didSet {
            quoteTextView.setText(text: quoteContent,
                                  lineSpacing: 5.0)
            setNeedsLayout()
        }
    }
    
    var sideHintColor: UIColor = KPColorPalette.KPMainColor_v2.redColor! {
        didSet {
            sideHintView.backgroundColor = sideHintColor
        }
    }
    
    private var sideHintView: UIView!
    private var quoteTextView: UITextView!
    private var sideHintHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sideHintView = UIView()
        sideHintView.backgroundColor = KPColorPalette.KPMainColor_v2.redColor!
        addSubview(sideHintView)
        sideHintView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                      "H:|[$self(4)]"])
        sideHintHeightConstraint = sideHintView.addConstraint(forHeight: 0)
        
        quoteTextView = UITextView()
        quoteTextView.font = UIFont.boldSystemFont(ofSize: 22)
        quoteTextView.textColor = KPColorPalette.KPMainColor_v2.redColor
        quoteTextView.backgroundColor = UIColor.clear
        quoteTextView.isScrollEnabled = false
        addSubview(quoteTextView)
        quoteTextView.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]|"],
                                     views:[sideHintView])
        quoteTextView.addConstraintForCenterAligningToSuperview(in: .vertical)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = quoteTextView.sizeThatFits(CGSize(width: quoteTextView.frame.width,
                                                     height: CGFloat(MAXFLOAT)))
        sideHintHeightConstraint.constant = size.height - 10
    }
    

}
