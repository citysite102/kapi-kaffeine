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
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "覺旅咖啡-陽光店"
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
        
        self.view.backgroundColor = UIColor.white
        
//        dismissButton = KPBounceButton()
//        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
//                               for: .normal)
//        dismissButton.tintColor = KPColorPalette.KPMainColor.mainColor
//        dismissButton.addTarget(self,
//                                action: #selector(KPBusinessTimeViewController.handleDismissButtonOnTapped),
//                                for: .touchUpInside)
//        
//        view.addSubview(dismissButton)
//        dismissButton.addConstraints(fromStringArray: ["H:|-20-[$self(30)]",
//                                                       "V:|-16-[$self(30)]"])
//        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        
        
        view.addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["V:|-24-[$self]",
                                                    "H:|-24-[$self]"])
        
        shopStatusHint = UIView();
        shopStatusHint.backgroundColor = KPColorPalette.KPShopStatusColor.opened;
        shopStatusHint.layer.cornerRadius = 3.0;
        shopStatusHint.isOpaque = true
        view.addSubview(shopStatusHint);
        shopStatusHint.addConstraints(fromStringArray: ["H:|-24-[$self(6)]",
                                                        "V:[$view0]-16-[$self(6)]"],
                                      views: [titleLabel]);
        
        shopStatusLabel = KPLayerLabel();
        shopStatusLabel.font = UIFont.systemFont(ofSize: 12.0);
        shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor;
        shopStatusLabel.text = "營業時間 未知";
        shopStatusLabel.isOpaque = true
        shopStatusLabel.layer.masksToBounds = true
        view.addSubview(shopStatusLabel);
        shopStatusLabel.addConstraints(fromStringArray: ["H:[$view0]-5-[$self($metric0)]"],
                                       metrics: [UIScreen.main.bounds.size.width/2],
                                       views: [shopStatusHint]);
        shopStatusLabel.addConstraintForCenterAligning(to: shopStatusHint,
                                                       in: .vertical,
                                                       constant: -2)
        
        if businessTime != nil {
            let shopStatus = businessTime!.shopStatus
            shopStatusLabel.text = "營業時間 \(shopStatus.status)"
            shopStatusHint.backgroundColor = shopStatus.isOpening ?
                KPColorPalette.KPShopStatusColor.opened :
                KPColorPalette.KPShopStatusColor.closed
        } else {
            shopStatusHint.backgroundColor = KPColorPalette.KPTextColor.grayColor_level5
            shopStatusLabel.text = "營業時間 未知"
        }
        
        
        for (index, content) in dayContents.enumerated() {
            let dayInfoView = KPBusinessTimeInfoView(content, businessTime==nil ? "尚無資料" : businessTime!.getTimeString(withDay: content))
            view.addSubview(dayInfoView)
            dayInfoViews.append(dayInfoView)
            if index == 0 {
                dayInfoView.addConstraints(fromStringArray: ["V:[$view0]-20-[$self]",
                                                             "H:|-24-[$self]-24-|"],
                                           views: [shopStatusLabel])
            } else {
                dayInfoView.addConstraints(fromStringArray: ["V:[$view0]-20-[$self]",
                                                             "H:|-24-[$self]-24-|"],
                                           views: [dayInfoViews[index-1]])
            }
        }
        
        view.addSubview(noteLabel)
        noteLabel.addConstraints(fromStringArray: ["H:|-24-[$self]-24-|",
                                                   "V:[$self]-24-|"],
                                 views: [dayInfoViews.last! as KPBusinessTimeInfoView])
        
    }

    func handleDismissButtonOnTapped() {
        self.dismiss(animated: true, completion: nil);
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
