//
//  KPListArticleCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/3/9.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPListArticleCell: UITableViewCell {

    var articleImageView: UIImageView!
    var articleTitleLabel: UILabel!
    var articleSubtitleLabel: KPLayerLabel!
    var separator: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        articleImageView = UIImageView(image: drawImage(image: R.image.demo_6()!,
                                                        rectSize: CGSize(width: 72,
                                                                         height: 72),
                                                        roundedRadius: 3))
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        contentView.addSubview(articleImageView)
        
        articleImageView.addConstraints(fromStringArray: ["H:|-16-[$self(76)]",
                                                          "V:|-18-[$self(76)]-18-|"])
        
        articleTitleLabel = UILabel()
        articleTitleLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        articleTitleLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        articleTitleLabel.setText(text: "倫敦，一個咖啡香滿溢的城市。令人心曠神怡。",
                                  lineSpacing: 4)
        articleTitleLabel.isOpaque = true
        articleTitleLabel.layer.masksToBounds = true
        articleTitleLabel.numberOfLines = 0
        contentView.addSubview(articleTitleLabel)
        
        articleTitleLabel.addConstraints(fromStringArray: ["H:[$view0]-12-[$self]-($metric0)-|",
                                                           "V:|-16-[$self]"],
                                     metrics: [KPLayoutConstant.information_horizontal_offset],
                                     views: [articleImageView])
        
        articleSubtitleLabel = KPLayerLabel()
        articleSubtitleLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        articleSubtitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        articleSubtitleLabel.text = "倫敦最棒的10間精選咖啡廳！"
        articleSubtitleLabel.isOpaque = true
        articleSubtitleLabel.layer.masksToBounds = true
        contentView.addSubview(articleSubtitleLabel)
        
        articleSubtitleLabel.addConstraints(fromStringArray: ["H:[$view0]-12-[$self]-($metric0)-|",
                                                              "V:[$view1]-10-[$self]"],
                                            metrics: [KPLayoutConstant.information_horizontal_offset],
                                            views: [articleImageView, articleTitleLabel])
        
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        contentView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|-8-[$self]-8-|"])
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
