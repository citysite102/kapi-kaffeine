//
//  KPDefaultLoadingTableCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/21.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import Shimmer

class KPDefaultLoadingTableCell: UITableViewCell {

    
    var shimmerView: FBShimmeringView!
    
    var loadingImageView: UIImageView!
    
    var container: UIView!
    var defaultImagePlace: UIView!
    var defaultTitlePlace: UIView!
    var defaultDescriptionPlace: UIView!
    var defaultDistancePlace: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.frame = CGRect(x: 0, y: 0, width: 320, height: 80)
        
        shimmerView = FBShimmeringView()
        contentView.addSubview(shimmerView)
        shimmerView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                     "V:|[$self(80@999)]|"])
        
        
        loadingImageView = UIImageView(image: R.image.loading_cell())
        addSubview(loadingImageView)
        shimmerView.contentView = loadingImageView
    
        shimmerView.shimmeringOpacity = 0.2
        shimmerView.shimmeringPauseDuration = 0.3
        shimmerView.isShimmering = true
        
//        defaultTitlePlace = UIView()
//        defaultTitlePlace.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
//        addSubview(defaultTitlePlace)
//        defaultTitlePlace.addConstraints(fromStringArray: ["H:[$view0]-8-[$self($metric0)]",
//                                                           "V:|-12-[$self(20)]"],
//                                        metrics: [UIScreen.main.bounds.size.width/2],
//                                        views: [defaultImagePlace]);
//        
//        defaultDescriptionPlace = UIView()
//        defaultDescriptionPlace.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
//        addSubview(defaultDescriptionPlace)
//        defaultDescriptionPlace.addConstraints(fromStringArray: ["H:[$view0]-8-[$self($metric0)]",
//                                                                 "V:[$view1]-6-[$self(14)]"],
//                                         metrics: [UIScreen.main.bounds.size.width/2],
//                                         views: [defaultImagePlace, defaultTitlePlace]);
//        
//        defaultDistancePlace = UIView()
//        defaultDistancePlace.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
//        addSubview(defaultDistancePlace)
//        defaultTitlePlace.addConstraints(fromStringArray: ["H:[$view0]-8-[$self($metric0)]",
//                                                           "V:[$view1]-6-[$self(14)]"],
//                                         metrics: [UIScreen.main.bounds.size.width/2],
//                                         views: [defaultImagePlace, defaultDescriptionPlace]);
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
