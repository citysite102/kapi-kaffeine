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
    var separator: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.frame = CGRect(x: 0, y: 0, width: 375, height: 96)
        
        shimmerView = FBShimmeringView()
        contentView.addSubview(shimmerView)
        shimmerView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                     "V:|[$self(96@999)]|"])
        
        
        loadingImageView = UIImageView(image: R.image.loading_cell())
        addSubview(loadingImageView)
        shimmerView.contentView = loadingImageView
    
        shimmerView.shimmeringOpacity = 0.2
        shimmerView.shimmeringPauseDuration = 0.3
        shimmerView.isShimmering = true
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        contentView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|[$self]|"])
        
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
