//
//  KKMapMarkerInfoWindow.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 06/04/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KKMapMarkerInfoWindow: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init(data: NSDictionary) {
        
        let textRect = NSString(string: data.object(forKey: "name") as! NSString).boundingRect(with: CGSize(width: 300, height: 40),
                                                                                               options: .usesLineFragmentOrigin,
                                                                                               attributes: [:],
                                                                                               context: nil)
        
        super.init(frame: CGRect(x: 0, y: 0, width: textRect.width + 60 , height: 30))
        
        self.backgroundColor = UIColor.white
        
        let imageView = UIImageView(image: UIImage(named: "icon_house"))
        imageView.contentMode = .scaleAspectFit
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.text = data.object(forKey: "name") as? String
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        imageView.addConstraints(fromStringArray: ["H:|-[$self]-[$view0]-|", "V:|-2-[$self]-2-|", "V:|-[$view0]-|"], views: [titleLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
