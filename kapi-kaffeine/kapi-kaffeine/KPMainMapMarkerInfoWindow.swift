//
//  KPMainMapMarkerInfoWindow.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 11/04/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPMainMapMarkerInfoWindow: UIView {
    
    var contentView: UIView!

    init(dataModel: KPDataModel) {
        
        let textRect = NSString(string: dataModel.name).boundingRect(with: CGSize(width: 300, height: 30),
                                                                     options: .usesFontLeading,
                                                                     attributes: [:],
                                                                     context: nil)
        
        super.init(frame: CGRect(x: 0, y: 0, width: 40 + textRect.width  + 50 , height: 30))
        
        self.contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 5))
        self.contentView.backgroundColor = UIColor.white
        
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOffset = CGSize.init(width: 1.0, height: 2.0);
        
        self.addSubview(self.contentView)
        
        self.contentView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]"])
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.size.width/2 - 5, y: self.frame.size.height - 5))
        path.addLine(to: CGPoint(x: self.frame.size.width/2 + 5, y: self.frame.size.height - 5))
        path.addLine(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width/2 - 5, y: self.frame.size.height - 5))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        let imageView = UIImageView(image: UIImage(named: "icon_house"))
        imageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.text = dataModel.name
        
        let starImageView = UIImageView(image: UIImage(named: "icon_mapMarker"))
        starImageView.contentMode = .scaleAspectFit

        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 12)
        scoreLabel.text = "4.3"
        scoreLabel.textColor = UIColor(hexString: "784d1f")
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(starImageView)
        self.contentView.addSubview(scoreLabel)
        
        imageView.addConstraints(fromStringArray: ["H:|-[$self(19)]-4-[$view0]-4-[$view1(16)]-4-[$view2]-|",
                                                   "V:|-3-[$self(19)]-3-|",
                                                   "V:|[$view0]|",
                                                   "V:|-4-[$view1]-4-|",
                                                   "V:|[$view2]|"],
                                 views: [titleLabel, starImageView, scoreLabel])
        
        scoreLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
