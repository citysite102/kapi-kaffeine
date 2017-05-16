//
//  KPNewCommentController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/16.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPNewCommentController: UIViewController {

    
    var dismissButton: KPBounceButton!
    var sendButton: UIButton!
    var containerView: UIView!
    var textFieldContainerView: UIView!
    lazy var textFieldHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = "請留下你的評價"
        return label
    }()
    
    var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = "新增評價"
        navigationItem.hidesBackButton = true
        
        dismissButton = KPBounceButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                            for: .normal);
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        dismissButton.addTarget(self,
                             action: #selector(KPNewCommentController.handleDismissButtonOnTapped),
                             for: .touchUpInside)
        let barItem = UIBarButtonItem.init(customView: self.dismissButton);
        
        sendButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 24));
        sendButton.setTitle("發佈", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendButton.tintColor = KPColorPalette.KPTextColor.mainColor;
        sendButton.addTarget(self,
                             action: #selector(KPNewCommentController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        
        let rightbarItem = UIBarButtonItem.init(customView: self.sendButton);
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightbarItem]
        
        containerView = UIView()
        containerView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level7
        view.addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                       "H:|[$self]|"])
        
        textFieldContainerView = UIView()
        textFieldContainerView.backgroundColor = UIColor.white
        containerView.addSubview(textFieldContainerView)
        textFieldContainerView.addConstraints(fromStringArray: ["V:|[$self(240)]",
                                                                "H:|[$self]|"])
        
        textFieldContainerView.addSubview(textFieldHeaderLabel)
        textFieldHeaderLabel.addConstraints(fromStringArray: ["V:|-16-[$self]",
                                                              "H:|-16-[$self]"])
        
        inputTextField = UITextField()
        inputTextField.delegate = self
        inputTextField.placeholder = "Ex:東西很好吃，環境也很舒適..."
        textFieldContainerView.addSubview(inputTextField)
        inputTextField.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]",
                                                        "H:|-16-[$self]-16-|"],
                                      views: [textFieldHeaderLabel])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleDismissButtonOnTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func handleSendButtonOnTapped() {
        
    }
}

extension KPNewCommentController: UITextFieldDelegate {
    
}
