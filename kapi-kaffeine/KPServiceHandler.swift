//
//  KPServiceHandler.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit
import Crashlytics

class KPServiceHandler {

    
    static let sharedHandler = KPServiceHandler()
    
    private var kapiDataRequest: KPCafeRequest!
    private var kapiDetailedInfoRequest: KPCafeDetailedInfoRequest!
    
    // 目前儲存所有的咖啡店
    var currentCafeDatas: [KPDataModel]!
    var currentDisplayModel: KPDataModel? {
        didSet {
            CLSLogv("Information Controller with cafe id: %@", getVaList([currentDisplayModel?.identifier ?? ""]))
        }
    }
    var currentCity: String?
    var relatedDisplayModel: [KPDataModel]? {
        if currentDisplayModel != nil {
            let filteredLocationModel = KPFilter.filterData(source: self.currentCafeDatas,
                                                            withCity: self.currentDisplayModel?.city ?? "taipei")
            var relativeArray: [(cafeModel: KPDataModel, weight: CGFloat)] =
                [(cafeModel: KPDataModel, weight: CGFloat)]()
            for dataModel in filteredLocationModel {
                if dataModel.identifier != currentDisplayModel?.identifier {
                    relativeArray.append((cafeModel: dataModel,
                                          weight: relativeWeight(currentDisplayModel!, dataModel)))
                }
            }
            
            relativeArray.sort(by: { (model1, model2) -> Bool in
                model1.weight < model2.weight
            })
            
            if relativeArray.count >= 5 {
                return [relativeArray[0].cafeModel,
                        relativeArray[1].cafeModel,
                        relativeArray[2].cafeModel,
                        relativeArray[3].cafeModel,
                        relativeArray[4].cafeModel]
            } else {
                var responseResult: [KPDataModel] = [KPDataModel]()
                for relativeModel in relativeArray {
                    responseResult.append(relativeModel.cafeModel)
                }
                return responseResult
            }
        }
        return nil
    }
    
    
    //
    var featureTags: [KPDataTagModel] = []
    
    // Region
//    var regionData: [String : [(name: String, key: String, coordinate: CLLocationCoordinate2D)]] =
//        ["北部": [("台北 Taipei", "taipei", CLLocationCoordinate2D(latitude: 25.0470462, longitude: 121.5156119)),
//                 ("基隆 Keelung", "keelung", CLLocationCoordinate2D(latitude: 25.131736, longitude: 121.738372)),
//                 ("桃園 Taoyuan", "taoyuan", CLLocationCoordinate2D(latitude: 24.989206, longitude: 121.311351)),
//                 ("新竹 Hsinchu", "hsinchu", CLLocationCoordinate2D(latitude: 24.8015771, longitude: 120.969366))],
//         
//         "中部": [("苗栗 miaoli", "miaoli", CLLocationCoordinate2D(latitude: 24.57002, longitude: 120.820149)),
//                 ("台中 taichung", "taichung", CLLocationCoordinate2D(latitude: 24.1375758, longitude: 120.6844115)),
//                 ("南投 nantou", "nantou", CLLocationCoordinate2D(latitude: 23.8295543, longitude: 120.7904003)),
//                 ("彰化 changhua", "changhua", CLLocationCoordinate2D(latitude: 24.0816314, longitude: 120.5362503)),
//                 ("雲林 yunlin", "yunlin", CLLocationCoordinate2D(latitude: 23.7289229, longitude: 120.4206707))],
//         
//         "南部": [("嘉義 chiayi", "chiayi", CLLocationCoordinate2D(latitude: 23.4791187, longitude: 120.4389442)),
//                 ("台南 tainan", "tainan", CLLocationCoordinate2D(latitude: 22.9719654, longitude: 120.2140395)),
//                 ("高雄 kaohsiung", "kaohsiung", CLLocationCoordinate2D(latitude: 22.6397615, longitude: 120.299913)),
//                 ("屏東 pingtung", "pingtung", CLLocationCoordinate2D(latitude: 22.668857, longitude: 120.4837693))],
//         
//         "東部": [("宜蘭 Yilan", "yilan", CLLocationCoordinate2D(latitude: 24.7543117, longitude: 121.756184)),
//                 ("花蓮 Hualien", "hualien", CLLocationCoordinate2D(latitude: 23.9929463, longitude: 121.5989202)),
//                 ("台東 Taitung", "taitung", CLLocationCoordinate2D(latitude: 22.791625, longitude: 121.1233145)),
//                 ("澎湖 Penghu", "penghu", CLLocationCoordinate2D(latitude: 23.6294021, longitude: 119.526859))]]
    
    
    // MARK: Initialization
    
    private init() {
        kapiDataRequest = KPCafeRequest()
        kapiDetailedInfoRequest = KPCafeDetailedInfoRequest()
    }
    
    
    func relativeWeight(_ model1: KPDataModel,
                        _ model2: KPDataModel) -> CGFloat {
        var totalWeight: CGFloat = 0
        totalWeight = totalWeight + pow(Decimal((model1.standingDesk?.intValue)! - (model2.standingDesk?.intValue)!), 2).cgFloatValue
        totalWeight = totalWeight + pow(Decimal((model1.socket?.intValue)! - (model2.socket?.intValue)!), 2).cgFloatValue
        totalWeight = totalWeight + pow(Decimal((model1.limitedTime?.intValue)! - (model2.limitedTime?.intValue)!), 2).cgFloatValue
        totalWeight = totalWeight + pow(Decimal((model1.averageRate?.intValue)! - (model2.averageRate?.intValue)!), 2).cgFloatValue
        return totalWeight
    }
    
    
    // MARK: Global API
    
    func fetchRemoteData(_ limitedTime: NSNumber? = nil,
                         _ socket: NSNumber? = nil,
                         _ standingDesk: NSNumber? = nil,
                         _ mrt: String? = nil,
                         _ city: String? = nil,
                         _ completion:((_ result: [KPDataModel]?, _ error: NetworkRequestError?) -> Void)!) {
        kapiDataRequest.perform(limitedTime,
                                socket,
                                standingDesk,
                                mrt,
                                city).then { result -> Void in
                                    DispatchQueue.global().async {
                                        var cafeDatas = [KPDataModel]()
                                        if result["data"].arrayObject != nil {
                                            for data in (result["data"].arrayObject)! {
                                                if let cafeData = KPDataModel(JSON: (data as! [String: Any])) {
                                                    cafeDatas.append(cafeData)
                                                }
                                            }
                                            self.currentCafeDatas = cafeDatas
                                            completion?(cafeDatas, nil)
                                        } else {
                                            completion?(nil, NetworkRequestError.resultUnavailable)
                                        }
                                    }
        }.catch { error in
            DispatchQueue.global().async {
                completion?(nil, (error as! NetworkRequestError))
            }
        }
    }
    
    func fetchStoreInformation(_ cafeID: String!,
                               _ completion:((_ result: KPDetailedDataModel?) -> Void)!) {
        kapiDetailedInfoRequest.perform(cafeID).then {result -> Void in
            if let data = result["data"].dictionaryObject {
                if let cafeData = KPDetailedDataModel(JSON: data) {
                    completion(cafeData)
                }
            }
        }.catch { error in
            completion(nil)
        }
    }
    
    func addNewShop(_ name:String,
                    _ address:String,
                    _ city:String,
                    _ latitude: Double,
                    _ longitude: Double,
                    _ fb_url:String,
                    _ limited_time: Int,
                    _ standingDesk: Int,
                    _ socket: Int,
                    _ wifi: Int,
                    _ quiet: Int,
                    _ cheap: Int,
                    _ seat: Int,
                    _ tasty: Int,
                    _ food: Int,
                    _ music: Int,
                    _ phone: String,
                    _ tags: [KPDataTagModel],
                    _ business_hour: [String: String],
                    _ price_average: Int,
                    _ completion: ((_ successed: Bool) -> Swift.Void)?) {
        
        
        let newShopRequest = KPAddNewCafeRequest()
        
        let loadingView = KPLoadingView(("新增中..", "新增成功", "新增失敗"))
        UIApplication.shared.topViewController.view.addSubview(loadingView)
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        
        newShopRequest.perform(name,
                               address,
                               city,
                               latitude,
                               longitude,
                               fb_url,
                               limited_time,
                               standingDesk,
                               socket,
                               wifi,
                               quiet,
                               cheap,
                               seat,
                               tasty,
                               food,
                               music,
                               phone,
                               tags,
                               business_hour,
                               price_average).then { result -> Void in
                                if let addResult = result["result"].bool {
                                    loadingView.state = addResult ? .successed : .failed
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5,
                                                                  execute: {
                                                                    loadingView.removeFromSuperview()
                                    })
                                    completion?(addResult)
                                } else {
                                    loadingView.state = .failed
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                                                  execute: {
                                                                    loadingView.removeFromSuperview()
                                    })
                                    completion?(false)
                                }
            }.catch { (error) in
                loadingView.state = .failed
                print(error)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                              execute: {
                                                loadingView.removeFromSuperview()
                })
                completion?(false)
                
        }
        
    }
    
    // MARK: Rating API
    
    func reportStoreClosed(_ completion: ((_ successed: Bool) -> Swift.Void)?) {
        
        let loadingView = KPLoadingView(("回報中..", "回報成功", "回報失敗"))
        UIApplication.shared.KPTopViewController().view.addSubview(loadingView)
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) { 
            loadingView.state = .successed
            completion?(true)
        }
    }
    
    
    // MARK: Comment API
    
    func addComment(_ comment: String? = "",
                    _ completion: ((_ successed: Bool) -> Swift.Void)?) {
        
        let loadingView = KPLoadingView(("新增中..", "新增成功", "新增失敗"))
        UIApplication.shared.KPTopViewController().view.addSubview(loadingView)
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        
        let commentRequest = KPNewCommentRequest()
        commentRequest.perform((currentDisplayModel?.identifier)!,
                               comment!).then { result -> Void in
                                if let commentResult = result["result"].bool {
                                    loadingView.state = commentResult ? .successed : .failed
                                    
                                    if commentResult {
                                        let notification = Notification.Name(KPNotification.information.commentInformation)
                                        NotificationCenter.default.post(name: notification, object: nil)
                                    }
                                    
                                    completion?(commentResult)
                                    guard let _ = KPUserManager.sharedManager.currentUser?.reviews?.first(where: {$0.identifier == self.currentDisplayModel?.identifier}) else {
                                        KPUserManager.sharedManager.currentUser?.reviews?.append(self.currentDisplayModel!)
                                        KPUserManager.sharedManager.storeUserInformation()
                                        return
                                    }
                                } else {
                                    completion?(false)
                                }
        }.catch { (error) in
            completion?(false)
        }
    }
    
    func getComments(_ completion: ((_ successed: Bool,
                                     _ comments: [KPCommentModel]?) -> Swift.Void)?) {
        
        let commentRequest = KPGetCommentRequest()
        commentRequest.perform((currentDisplayModel?.identifier)!).then { result -> Void in
            var resultComments = [KPCommentModel]()
            if result["result"].boolValue {
                if let commentDatas = result["data"]["comments"].arrayObject {
                    for case let commentDataModel as Dictionary<String, Any> in commentDatas {
                        if let commentModel = KPCommentModel(JSON: commentDataModel) {
                            resultComments.append(commentModel)
                        }
                    }
                }
                
                let sortedComments = resultComments.sorted(by: { (comment1, comment2) -> Bool in
                    return comment1.createdTime.intValue > comment2.createdTime.intValue
                })
                
                completion?(true, sortedComments)
            } else {
                completion?(false, nil)
            }
        }.catch { (error) in
            completion?(false, nil)
        }
    }
    
    // MARK: Rating API

    func addRating(_ wifi: NSNumber? = 0,
                   _ seat: NSNumber? = 0,
                   _ food: NSNumber? = 0,
                   _ quiet: NSNumber? = 0,
                   _ tasty: NSNumber? = 0,
                   _ cheap: NSNumber? = 0,
                   _ music: NSNumber? = 0,
                   _ completion: ((_ successed: Bool) -> Swift.Void)?) {
        
        let loadingView = KPLoadingView(("新增中..", "新增成功", "新增失敗"))
        UIApplication.shared.KPTopViewController().view.addSubview(loadingView)
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        let ratingRequest = KPNewRatingRequest()
        ratingRequest.perform((currentDisplayModel?.identifier)!,
                              wifi,
                              seat,
                              food,
                              quiet,
                              tasty,
                              cheap,
                              music,
                              .add).then { result -> Void in
                                if let commentResult = result["result"].bool {
                                    loadingView.state = commentResult ? .successed : .failed
                                    
                                    if commentResult {
                                        let notification = Notification.Name(KPNotification.information.rateInformation)
                                        NotificationCenter.default.post(name: notification, object: nil)
                                    }
                                    
                                    completion?(commentResult)
                                    guard let _ = KPUserManager.sharedManager.currentUser?.rates?.first(where: {$0.identifier == self.currentDisplayModel?.identifier}) else {
                                        KPUserManager.sharedManager.currentUser?.rates?.append(self.currentDisplayModel!)
                                        KPUserManager.sharedManager.storeUserInformation()
                                        return
                                    }
                                } else {
                                    completion?(false)
                                }
            }.catch { (error) in
                loadingView.state = .failed
                completion?(false)
            }
    }
    
    func updateRating(_ wifi: NSNumber? = 0,
                      _ seat: NSNumber? = 0,
                      _ food: NSNumber? = 0,
                      _ quiet: NSNumber? = 0,
                      _ tasty: NSNumber? = 0,
                      _ cheap: NSNumber? = 0,
                      _ music: NSNumber? = 0,
                      _ completion: ((_ successed: Bool) -> Swift.Void)?) {
        
        let loadingView = KPLoadingView(("修改中..", "修改成功", "修改失敗"))
        UIApplication.shared.KPTopViewController().view.addSubview(loadingView)
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        let ratingRequest = KPNewRatingRequest()
        ratingRequest.perform((currentDisplayModel?.identifier)!,
                              wifi,
                              seat,
                              food,
                              quiet,
                              tasty,
                              cheap,
                              music,
                              .put).then { result -> Void in
                                if let commentResult = result["result"].bool {
                                    loadingView.state = commentResult ? .successed : .failed
                                    
                                    if commentResult {
                                        let notification = Notification.Name(KPNotification.information.rateInformation)
                                        NotificationCenter.default.post(name: notification, object: nil)
                                    }
                                    
                                    completion?(commentResult)
                                    guard let _ = KPUserManager.sharedManager.currentUser?.rates?.first(where: {$0.identifier == self.currentDisplayModel?.identifier}) else {
                                        KPUserManager.sharedManager.currentUser?.rates?.append(self.currentDisplayModel!)
                                        KPUserManager.sharedManager.storeUserInformation()
                                        return
                                    }
                                } else {
                                    completion?(false)
                                }
            }.catch { (error) in
                loadingView.state = .failed
                completion?(false)
        }
    }
    
    
    func getRatings(_ completion: ((_ successed: Bool,
        _ rating: KPRateDataModel?) -> Swift.Void)?) {
        
        let getRatingRequest = KPGetRatingRequest()
        getRatingRequest.perform((currentDisplayModel?.identifier)!).then { result -> Void in
            if let ratingResult = result["data"].dictionaryObject {
                print("Get Photo Result:\(ratingResult)")
                completion?(true, KPRateDataModel(JSON: ratingResult))
            } else {
                completion?(false, nil)
            }
        }.catch { (error) in
            completion?(false, nil)
        }
    }
    
    // MARK: Mix
    
    func addCommentAndRatings(_ comment: String? = "",
                              _ wifi: NSNumber? = 0,
                              _ seat: NSNumber? = 0,
                              _ food: NSNumber? = 0,
                              _ quiet: NSNumber? = 0,
                              _ tasty: NSNumber? = 0,
                              _ cheap: NSNumber? = 0,
                              _ music: NSNumber? = 0,
                              _ completion: ((_ successed: Bool) -> Swift.Void)?) {
        
        
        let loadingView = KPLoadingView(("新增中..", "新增成功", "新增失敗"))
        UIApplication.shared.KPTopViewController().view.addSubview(loadingView)
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        
        let commentRequest = KPNewCommentRequest()
        let ratingRequest = KPNewRatingRequest()
        
        when(fulfilled:
                commentRequest.perform((currentDisplayModel?.identifier)!, comment!),
                ratingRequest.perform((currentDisplayModel?.identifier)!,
                                      wifi,
                                      seat,
                                      food,
                                      quiet,
                                      tasty,
                                      cheap,
                                      music,
                                      .add)).then { (response1, response2) -> Void in
                                        
                                        var notification = Notification.Name(KPNotification.information.rateInformation)
                                        NotificationCenter.default.post(name: notification, object: nil)
                                        
                                        notification = Notification.Name(KPNotification.information.commentInformation)
                                        NotificationCenter.default.post(name: notification, object: nil)
                                        
                                        loadingView.state = .successed
                                        completion?(true)
                                        
                                        guard let _ = KPUserManager.sharedManager.currentUser?.reviews?.first(where: {$0.identifier == self.currentDisplayModel?.identifier}) else {
                                            KPUserManager.sharedManager.currentUser?.reviews?.append(self.currentDisplayModel!)
                                            KPUserManager.sharedManager.storeUserInformation()
                                            
                                            guard let _ = KPUserManager.sharedManager.currentUser?.rates?.first(where: {$0.identifier == self.currentDisplayModel?.identifier}) else {
                                                KPUserManager.sharedManager.currentUser?.rates?.append(self.currentDisplayModel!)
                                                KPUserManager.sharedManager.storeUserInformation()
                                                return
                                            }   
                                            return
                                        }
                                        
                                        
        }.catch { (error) in
            loadingView.state = .failed
            completion?(false)
        }
    }
    
    // MARK: Photo API
    
    func getPhotos(_ completion: ((_ successed: Bool,
        _ photos: [String]?) -> Swift.Void)?) {
        
        let getPhotoRequest = KPGetPhotoRequest()
        getPhotoRequest.perform((currentDisplayModel?.identifier)!).then { result -> Void in
            print("Get Photo Result:\(result)")
            completion?(true, result["data"].arrayObject as? [String])
        }.catch { (error) in
            completion?(false, nil)
        }
    }
    
    
    // MARK: Favorite / Visit
    
    func addFavoriteCafe(_ completion: ((Bool) -> Swift.Void)? = nil) {
        
        let addRequest = KPFavoriteRequest()
        addRequest.perform((currentDisplayModel?.identifier)!,
                           KPFavoriteRequest.requestType.add).then { result -> Void in
                            
                            guard let _ = KPUserManager.sharedManager.currentUser?.favorites?.first(where: {$0.identifier == self.currentDisplayModel?.identifier}) else {
                                KPUserManager.sharedManager.currentUser?.favorites?.append(self.currentDisplayModel!)
                                KPUserManager.sharedManager.storeUserInformation()
                                return
                            }
                            completion?(true)
            }.catch { error in
                print("Add Favorite Cafe error\(error)")
                completion?(false)
        }
    }
    
    // MARK: User API
    
    func modifyRemoteUserData(_ user: KPUser, _ completion:((_ successed: Bool) -> Void)?) {
        
        let loadingView = KPLoadingView(("修改中...", "修改成功", "修改失敗"))
        UIApplication.shared.KPTopViewController().view.addSubview(loadingView)
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])

        let request = KPUserInformationRequest()
        request.perform(user.displayName,
                        user.photoURL,
                        user.defaultLocation,
                        user.intro,
                        user.email,
                        .put).then { result -> Void in
                            print(result)
                            KPUserManager.sharedManager.storeUserInformation()
                            loadingView.state = result["result"].boolValue ? .successed : .failed
                            completion?(result["result"].boolValue)
            }.catch { error in
                print(error)
                loadingView.state = .failed
                completion?(false)
        }
    }
    
    func removeFavoriteCafe(_ cafeID: String,
                            _ completion: ((Bool) -> Swift.Void)? = nil) {
        
        let removeRequest = KPFavoriteRequest()
        removeRequest.perform(cafeID,
                              KPFavoriteRequest.requestType.delete).then { result -> Void in
                                //                                if let found = self.currentUser?.favorites?.first(where: {$0.identifier == cafeID}) {
                                if let foundOffset = KPUserManager.sharedManager.currentUser?.favorites?.index(where: {$0.identifier == cafeID}) {
                                    KPUserManager.sharedManager.currentUser?.favorites?.remove(at: foundOffset)
                                }
                                KPUserManager.sharedManager.storeUserInformation()
                                completion?(true)
                                print("Result\(result)")
            }.catch { (error) in
                print("error\(error)")
                completion?(false)
        }
    }
    
    func addVisitedCafe(_ completion: ((Bool) -> Swift.Void)? = nil) {
        let addRequest = KPVisitedRequest()
        addRequest.perform((currentDisplayModel?.identifier)!,
                           KPVisitedRequest.requestType.add).then { result -> Void in
                            
                            guard let _ = KPUserManager.sharedManager.currentUser?.visits?.first(where: {$0.identifier == self.currentDisplayModel?.identifier}) else {
                                KPUserManager.sharedManager.currentUser?.visits?.append(self.currentDisplayModel!)
                                KPUserManager.sharedManager.storeUserInformation()
                                return
                            }
                            completion?(true)
                            print("Result\(result)")
            }.catch { (error) in
                print("Remove Visited Cafe error\(error)")
                completion?(false)
        }
    }
    
    func removeVisitedCafe(_ cafeID: String,
                           _ completion: ((Bool) -> Swift.Void)? = nil) {
        let removeRequest = KPVisitedRequest()
        removeRequest.perform(cafeID,
                              KPVisitedRequest.requestType.delete).then { result -> Void in
                                if let foundOffset = KPUserManager.sharedManager.currentUser?.visits?.index(where: {$0.identifier == cafeID}) {
                                    KPUserManager.sharedManager.currentUser?.visits?.remove(at: foundOffset)
                                }
                                KPUserManager.sharedManager.storeUserInformation()
                                completion?(true)
                                print("Result\(result)")
            }.catch { (error) in
                print("Remove Visited Error \(error)")
                completion?(false)
        }
    }
    
    // MARK: Comment Voting
    
    func updateCommentVoteStatus(_ cafeID: String?,
                                 _ commentID: String,
                                 _ type: voteType,
                                 _ completion: ((Bool) -> Swift.Void)? = nil) {
        let commentVoteRequest = KPCommentVoteRequest()
        commentVoteRequest.perform(cafeID ?? (self.currentDisplayModel?.identifier)!,
                                   type,
                                   commentID).then { result -> Void in
                                    
                                    if let voteResult = result["result"].bool {
                                        if voteResult {
                                            let notification = Notification.Name(KPNotification.information.commentInformation)
                                            NotificationCenter.default.post(name: notification, object: nil)
                                        }
                                        completion?(voteResult)
                                    }
                                    
                                    completion?(true)
                                    print("Result\(result)")
            }.catch { (error) in
                print("Like Comment Error \(error)")
                completion?(false)
        }
    }
    
    // MARK: Report
    
    func sendReport(_ content: String,
                    _ completion: ((Bool) -> Swift.Void)? = nil) {
        let loadingView = KPLoadingView(("回報中...", "回報成功", "回報失敗"))
        UIApplication.shared.KPTopViewController().view.addSubview(loadingView)
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            loadingView.state = .successed
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                completion?(true)
            }
        }
    }
    
    // MARK: Tag
    func fetchTagList() {
        let tagListRequest = KPFeatureTagRequest()
        tagListRequest.perform().then {[unowned self] result -> Void in
            if let tagResult = result["result"].bool, tagResult == true {
                var tagList = [KPDataTagModel]()
                for data in (result["data"].arrayObject)! {
                    if let tagData = KPDataTagModel(JSON: (data as! [String: Any])) {
                        tagList.append(tagData)
                    }
                }
                if tagList.count > 0 {
                    self.featureTags = tagList
                }
            }
        }.catch { (error) in
            print(error)
        }
    }
    
    // MARK: Photo Upload
    func uploadPhoto(_ cafeID: String?,
                     _ photoData: Data!) {
        let photoUploadRequest = KPPhotoUploadRequest()
        photoUploadRequest.perform(cafeID ?? (currentDisplayModel?.identifier)!,
                                   nil,
                                   photoData).then {[unowned self] result -> Void in
                                    
                                print("Result:\(result)")
            }.catch { (error) in
                print("Error:\(error)")
        }
    }
}
