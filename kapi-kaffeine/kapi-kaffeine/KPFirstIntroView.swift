//
//  KPFirstIntroView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import pop

class KPFirstIntroView: UIView {

    
    var bottomImageView: UIImageView!
    var firstPopImageView: UIImageView!
    var secondPopImageView: UIImageView!
    var thirdPopImageView: UIImageView!
    
    
    var descriptionStyle: NSMutableParagraphStyle!
    
    
//    var titleContents = ["超實用咖啡地圖", "上千家咖啡館任你選", "快速找到目的地", "留下你的足跡", "最挺你的社群"]
//    var descriptionContents =  ["不管是想要工作，聚會，讀書，你總是能找到最適合你的地方",
//                                "收錄全台超過1000家咖啡館資訊，隨時更新，動態一手掌握",
//                                "關鍵字搜尋，偏好篩選，附近店家，方法不只一個，但絕對快速簡單",
//                                "為店家評分，留言，上傳照片，讓特別的時光留下美好回憶",
//                                "全台網友協力貢獻店家資料，找咖啡不再是件麻煩事"]
    
    lazy var introTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    lazy var introDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.alpha = 0.8
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.isUserInteractionEnabled = false
        
        bottomImageView = UIImageView(image: R.image.image_onbroading_1())
        bottomImageView.contentMode = .scaleAspectFit
        addSubview(bottomImageView)
        bottomImageView.addConstraints(fromStringArray: ["V:|-72-[$self(230)]",
                                                         "H:[$self]"])
        bottomImageView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        firstPopImageView = UIImageView(image: R.image.image_onbroading_11())
        addSubview(firstPopImageView)
        firstPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 24)
        firstPopImageView.addConstraintForAligning(to: .left, of: bottomImageView, constant: 8)
        
        secondPopImageView = UIImageView(image: R.image.image_onbroading_12())
        addSubview(secondPopImageView)
        secondPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 88)
        secondPopImageView.addConstraintForAligning(to: .right, of: bottomImageView, constant: 0)
        
        thirdPopImageView = UIImageView(image: R.image.image_onbroading_13())
        addSubview(thirdPopImageView)
        thirdPopImageView.addConstraintForAligning(to: .top, of: bottomImageView, constant: 104)
        thirdPopImageView.addConstraintForAligning(to: .left, of: bottomImageView, constant: 16)
        
        firstPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        secondPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        thirdPopImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        
        
        descriptionStyle = NSMutableParagraphStyle()
        descriptionStyle.alignment = .center
        descriptionStyle.lineSpacing = 2.4
        
        let attrS = NSMutableAttributedString.init(string: "不管是想要工作，聚會，讀書，你總是能找到最適合你的地方")
        attrS.addAttributes([NSParagraphStyleAttributeName: descriptionStyle],
                            range: NSRange.init(location: 0, length: attrS.length))
        
        
        introTitleLabel.text = "超實用咖啡地圖"
        introDescriptionLabel.attributedText = attrS
        
        addSubview(introTitleLabel)
        addSubview(introDescriptionLabel)
        
        introTitleLabel.addConstraints(fromStringArray: ["V:[$self]-168-|",
                                                         "H:|-32-[$self]-32-|"])
        
        introDescriptionLabel.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]",
                                                               "H:|-32-[$self]-32-|"],
                                             views:[introTitleLabel])
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.showPopContents()
        }
        
    }
    
    func showPopContents() {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: { 
                        self.firstPopImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.secondPopImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.thirdPopImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
