//
//  KPSubtitleInputController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GooglePlaces

protocol KPSubtitleInputDelegate: NSObjectProtocol {
    func outputValueSet(_ controller: KPSubtitleInputController)
}

class KPSubtitleInputController: KPViewController {

    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "店家名稱"
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        return label
    }()
    
    lazy var editTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = KPColorPalette.KPTextColor.grayColor_level2
        textField.placeholder = "請輸入店家名稱"
        textField.delegate = self
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    weak open var delegate: KPSubtitleInputDelegate?
    var dismissButton: KPBounceButton!
    var sendButton: UIButton!
    var tableView: UITableView!
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    var apiContents: [GMSPlace] = [GMSPlace]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var identifiedKey: String?
    var outputValue: Any!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubview(subTitleLabel)
        
        dismissButton = KPBounceButton()
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                               for: .normal)
        dismissButton.tintColor = KPColorPalette.KPMainColor.mainColor
        dismissButton.addTarget(self,
                                action: #selector(KPSubtitleInputController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        view.addSubview(dismissButton)
        dismissButton.addConstraints(fromStringArray: ["H:|-12-[$self(30)]",
                                                       "V:|-24-[$self(30)]"])
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        
        
        subTitleLabel.addConstraints(fromStringArray: ["V:[$view0]-24-[$self]",
                                                       "H:|-16-[$self]-16-|"],
                                     views: [dismissButton])
        
        view.addSubview(editTextField)
        editTextField.addConstraints(fromStringArray: ["V:[$view0]-12-[$self]",
                                                       "H:|-16-[$self]-16-|"],
                                     views: [subTitleLabel])
        
        let bottomBorderView = UIView()
        bottomBorderView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        view.addSubview(bottomBorderView)
        bottomBorderView.addConstraints(fromStringArray: ["H:|-16-[$self]|",
                                                          "V:[$view0]-12-[$self(1)]"],
                                        views:[editTextField])
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        view.addSubview(self.tableView)
        tableView.addConstraints(fromStringArray: ["V:[$view0]-12-[$self]|",
                                                   "H:|[$self]|"],
                                 views: [bottomBorderView])
        tableView.register(KPInputRecommendCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
        
        
        sendButton = UIButton.init(type: .custom)
        sendButton.setTitle("確認名稱", for: .normal)
        sendButton.setTitleColor(KPColorPalette.KPTextColor.mainColor,
                                 for: .normal)
        sendButton.addTarget(self,
                             action: #selector(KPSubtitleInputController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(sendButton)
        view.addSubview(separator)
        
        sendButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(30)]-16-|"],
                                  views: [separator])
        sendButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        separator.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                   "V:[$self(1)]-16-[$view0]"],
                                 views: [sendButton])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        editTextField.becomeFirstResponder()
    }
    
    func handleDismissButtonOnTapped() {
        dismiss(animated: true, completion: nil);
    }
    
    func handleSendButtonOnTapped() {
        outputValue = editTextField.text
        delegate?.outputValueSet(self)
        appModalController()?.dismissControllerWithDefaultDuration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension KPSubtitleInputController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let returnKey = (string as NSString).range(of: "\n").location == NSNotFound
        
        if !returnKey {
            textField.resignFirstResponder()
            return false
        }
        if !(textField.text?.isEmpty)! {
            let oString = textField.text! as NSString
            let nString = oString.replacingCharacters(in: range, with: string)
            placeAutoComplete(nString)
        }
        return true
    }
    
    func placeAutoComplete(_ placeName: String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        print("搜尋:\(placeName)")
        GMSPlacesClient().autocompleteQuery(placeName,
                                            bounds: nil,
                                            filter: filter,
                                            callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
                                                
            if let results = results {
                
                var places = [GMSPlace]()
                for result in results {
                    if let placeID = result.placeID {
                        GMSPlacesClient().lookUpPlaceID(placeID,
                                                        callback: { (place, error) in
                                                            if let error = error {
                                                                print("lookup place id query error: \(error.localizedDescription)")
                                                                return
                                                            }
                                                            
                                                            guard let place = place else {
                                                                print("No place details for \(placeID)")
                                                                return
                                                            }
                                                            
                                                            if place.types.contains("cafe") {
                                                                places.append(place)
                                                                self.apiContents = places
                                                            }
                                                            
                                                            print("Name:\(place.name)")
                        })
                    }
                }
            }
        })
    }
}

extension KPSubtitleInputController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell",
                                                 for: indexPath) as! KPInputRecommendCell
        cell.titleLabel.text = apiContents[indexPath.row].name
        cell.addressLabel.text = apiContents[indexPath.row].formattedAddress
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        outputValue = apiContents[indexPath.row]
        editTextField.text = apiContents[indexPath.row].name
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!,
                              animated: false)
        delegate?.outputValueSet(self)
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiContents.count
    }
    
}

