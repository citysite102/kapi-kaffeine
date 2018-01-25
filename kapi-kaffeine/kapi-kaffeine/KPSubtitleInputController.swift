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
    
    var searchController: UISearchController!
    
    weak open var delegate: KPSubtitleInputDelegate?
    var dismissButton: UIButton!
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
        title = "輸入店家名稱"
        
        // Cancel button
        let barLeftItem = UIBarButtonItem(title: "取消",
                                          style: .plain,
                                          target: self,
                                          action: #selector(KPSubtitleInputController.handleCancelButtonOnTap))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        navigationItem.leftBarButtonItem = barLeftItem
        
        configureSearchController()
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        view.addSubview(self.tableView)
        tableView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:|[$self]|"])
        tableView.register(KPInputRecommendCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
        
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "搜尋咖啡店名稱..."
//        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    
    @objc func handleCancelButtonOnTap() {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
//    @objc func handleSendButtonOnTapped() {
//        appModalController()?.dismissControllerWithDefaultDuration()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension KPSubtitleInputController: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField,
//                   shouldChangeCharactersIn range: NSRange,
//                   replacementString string: String) -> Bool {
//        let returnKey = (string as NSString).range(of: "\n").location == NSNotFound
//
//        if !returnKey {
//            textField.resignFirstResponder()
//            return false
//        }
//        if !(textField.text?.isEmpty)! {
//            let oString = textField.text! as NSString
//            let nString = oString.replacingCharacters(in: range, with: string)
//            placeAutoComplete(nString)
//        }
//        return true
//    }
    
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
//        outputValue = apiContents[indexPath.row]
//        editTextField.text = apiContents[indexPath.row].name
//        tableView.deselectRow(at: tableView.indexPathForSelectedRow!,
//                              animated: false)
//        delegate?.outputValueSet(self)
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 56
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiContents.count
    }
    
}

