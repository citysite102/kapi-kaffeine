//
//  KPBusinessTimeViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/7.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPBusinessTimeViewController: UIViewController {

    
    var dismissButton: KPBounceButton!
    var containerView: UIView!
    var tapGesture: UITapGestureRecognizer!
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "快跟我們回報錯誤"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        return label
    }()
    
    lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.text = "*營業資訊以店家官網最新公佈為準"
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level4
        return label
    }()
    
    var businessTime: KPDataBusinessHourModel?
    
    private var shopStatusHint: UIView!
    private var shopStatusLabel: UILabel!
    private var dayInfoViews: [KPBusinessTimeInfoView] = [KPBusinessTimeInfoView]()
    var dayContents = ["星期一", "星期二",
                       "星期三", "星期四",
                       "星期五", "星期六",
                       "星期日"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(KPBusinessTimeViewController.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 4.0
        containerView.layer.masksToBounds = true
        view.addSubview(containerView)
        containerView.addConstraintForCenterAligningToSuperview(in: .vertical)
        containerView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        containerView.addConstraint(forWidth: 276)
        
        containerView.addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["V:|-24-[$self]",
                                                    "H:|-22-[$self]-24-|"])
        
        shopStatusHint = UIView()
        shopStatusHint.backgroundColor = KPColorPalette.KPShopStatusColor.opened
        shopStatusHint.layer.cornerRadius = 3.0
        shopStatusHint.isOpaque = true
        containerView.addSubview(shopStatusHint)
        shopStatusHint.addConstraints(fromStringArray: ["H:|-24-[$self(6)]",
                                                        "V:[$view0]-12-[$self(6)]"],
                                      views: [titleLabel])
        
        shopStatusLabel = KPLayerLabel()
        shopStatusLabel.font = UIFont.systemFont(ofSize: 12.0)
        shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor
        shopStatusLabel.text = "營業時間 未知"
        shopStatusLabel.isOpaque = true
        shopStatusLabel.layer.masksToBounds = true
        containerView.addSubview(shopStatusLabel)
        shopStatusLabel.addConstraints(fromStringArray: ["H:[$view0]-6-[$self($metric0)]"],
                                       metrics: [UIScreen.main.bounds.size.width/2],
                                       views: [shopStatusHint])
        shopStatusLabel.addConstraintForCenterAligning(to: shopStatusHint,
                                                       in: .vertical,
                                                       constant: -2)
        
        if businessTime != nil {
            let shopStatus = businessTime!.shopStatus
            shopStatusLabel.text = "\(shopStatus.status)"
            shopStatusHint.backgroundColor = shopStatus.isOpening ?
                KPColorPalette.KPShopStatusColor.opened :
                KPColorPalette.KPShopStatusColor.closed
        } else {
            shopStatusHint.backgroundColor = KPColorPalette.KPTextColor.grayColor_level5
            shopStatusLabel.text = "營業時間 未知"
        }
        
        
        for (index, content) in dayContents.enumerated() {
            let dayInfoView = KPBusinessTimeInfoView(content, businessTime==nil ?
                "尚無資料" : businessTime!.getTimeString(withDay: content))
            containerView.addSubview(dayInfoView)
            dayInfoViews.append(dayInfoView)
            if index == 0 {
                dayInfoView.addConstraints(fromStringArray: ["V:[$view0]-24-[$self]",
                                                             "H:|-24-[$self]-24-|"],
                                           views: [shopStatusLabel])
            } else {
                dayInfoView.addConstraints(fromStringArray: ["V:[$view0]-20-[$self]",
                                                             "H:|-24-[$self]-24-|"],
                                           views: [dayInfoViews[index-1]])
            }
        }
        
        containerView.addSubview(noteLabel)
        noteLabel.addConstraints(fromStringArray: ["H:|-24-[$self]-24-|",
                                                   "V:[$view0]-24-[$self]-24-|"],
                                 views: [dayInfoViews.last! as KPBusinessTimeInfoView])
        
    }

    func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
