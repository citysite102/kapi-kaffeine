//
//  KPPhotoBrowser.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/3/21.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class KPPhotoBrowser: SKPhotoBrowser {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateCloseButton(R.image.icon_close_white()!,
                               size: CGSize(width: 50, height: 50))
        // Do any additional setup after loading the view.
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
