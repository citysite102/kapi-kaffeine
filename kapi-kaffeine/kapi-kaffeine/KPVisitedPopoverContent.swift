//
//  KPVisitedPopoverContent.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/14.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPVisitedPopoverContent: UIView, PopoverProtocol {

    var popoverView: KPPopoverView!
    var confirmAction: ((_ content: KPVisitedPopoverContent) -> Swift.Void)?
    var confirmButton: UIButton!
    
    static let KPShopPhotoInfoViewCellReuseIdentifier = "cell"
    
    var collectionView:UICollectionView!
    var collectionLayout:UICollectionViewFlowLayout!
    var shownCellIndex: [Int] = [Int]()
    var photos: [String] = [String]() {
        didSet {
            self.peopleLabel.text = "共有\(photos.count)人來過"
            self.invalidateIntrinsicContentSize()
        }
    }
    var animated: Bool = true
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = "有誰來過這間咖啡?"
        return label
    }()
    
    lazy var peopleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor.grayColor_level4
        return label
    }()
    
    lazy private  var seperator: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    private var buttonContainer: UIView!
    private var cancelButton: UIButton!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 280, height: (photos.count/5+1)*80+110)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = KPLayoutConstant.corner_radius
        
        addSubview(titleLabel)
        titleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        titleLabel.addConstraints(fromStringArray: ["V:|-16-[$self]",
                                                    "H:|-16-[$self]-16-|"])
        
        addSubview(peopleLabel)
        peopleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        peopleLabel.addConstraints(fromStringArray: ["V:[$view0]-6-[$self]",
                                                     "H:|-16-[$self]-16-|"],
                                   views: [titleLabel])
        
        buttonContainer = UIView()
        addSubview(buttonContainer)
        buttonContainer.addConstraintForCenterAligningToSuperview(in: .horizontal)
        buttonContainer.addConstraint(from: "V:[$self]|")

        //Collection view
        self.collectionLayout = UICollectionViewFlowLayout()
        self.collectionLayout.scrollDirection = .vertical
        self.collectionLayout.sectionInset = UIEdgeInsetsMake(8, 18, 8, 18)
        self.collectionLayout.minimumLineSpacing = 6.0
        self.collectionLayout.minimumInteritemSpacing = 4.0
        self.collectionLayout.itemSize = CGSize(width: 42, height: 42)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = true
        self.collectionView.delaysContentTouches = true
        self.collectionView.register(KPShopPhotoCell.self,
                                     forCellWithReuseIdentifier: KPShopPhotoInfoView.KPShopPhotoInfoViewCellReuseIdentifier)
        
        self.addSubview(self.collectionView)
        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:[$view0]-8-[$self][$view1]"],
                                           views:[peopleLabel,
                                                  buttonContainer])
        
        addSubview(seperator)
        seperator.addConstraints(fromStringArray: ["V:[$self(1)]",
                                                   "H:|[$self]|"])
        seperator.addConstraintForAligning(to: .top, of: buttonContainer)
        
        cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.layer.cornerRadius = KPLayoutConstant.corner_radius
        cancelButton.layer.masksToBounds = true
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: UIDevice().isSuperCompact ? 13.0 : 15.0)
        cancelButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level4!),
                                        for: .normal)
        cancelButton.addTarget(self,
                               action: #selector(KPVisitedPopoverContent.handleCancelButtonOnTapped),
                               for: .touchUpInside)
        buttonContainer.addSubview(cancelButton)
        cancelButton.addConstraints(fromStringArray:
            ["V:|-8-[$self(36)]-8-|",
             "H:|-10-[$self($metric0)]"], metrics: [125])
        
        confirmButton = UIButton(type: .custom)
        confirmButton.setTitle("打卡", for: .normal)
        confirmButton.layer.cornerRadius = KPLayoutConstant.corner_radius
        confirmButton.layer.masksToBounds = true
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        confirmButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor_light!),
                                         for: .normal)
        confirmButton.addTarget(self,
                                action: #selector(KPVisitedPopoverContent.handleConfirmButtonOnTapped),
                                for: .touchUpInside)
        buttonContainer.addSubview(confirmButton)
        confirmButton.addConstraints(fromStringArray:
            ["V:|-8-[$self(36)]-8-|",
             "H:[$view0]-10-[$self($metric0)]-10-|"],
                                     metrics: [125],
                                     views:[cancelButton])
    }
    
    @objc func handleCancelButtonOnTapped() {
        popoverView.dismiss()
    }
    
    @objc func handleConfirmButtonOnTapped() {
        if confirmAction != nil {
            confirmAction!(self)
        }
    }
}

extension KPVisitedPopoverContent: UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let displayCell = cell as! KPShopPhotoCell
        
        if !shownCellIndex.contains(indexPath.row) && animated {
            displayCell.shopPhoto.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).rotated(by: -CGFloat.pi/3)
            UIView.animate(withDuration: 0.7,
                           delay: 0.1+Double(indexPath.row)*0.02,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseOut,
                           animations: {
                            displayCell.shopPhoto.transform = CGAffineTransform.identity
            }) { (_) in
                self.shownCellIndex.append(indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPShopPhotoInfoView.KPShopPhotoInfoViewCellReuseIdentifier,
                                                      for: indexPath) as! KPShopPhotoCell
        cell.shopPhoto.af_setImage(withURL: URL(string: photos[indexPath.row])!,
                                   placeholderImage: UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level6!),
                                   filter: nil,
                                   progress: nil,
                                   progressQueue: DispatchQueue.global(),
                                   imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                   runImageTransitionIfCached: true,
                                   completion: { response in
                                    if let responseImage = response.result.value {
                                        cell.shopPhoto.image = responseImage
                                    }
        })
        
        cell.shopPhoto.layer.cornerRadius = 21
        return cell
    }
}
