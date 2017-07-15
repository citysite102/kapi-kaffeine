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

class KPServiceHandler {

    
    static let sharedHandler = KPServiceHandler()
    
    private var kapiDataRequest: KPCafeRequest!
    private var kapiDetailedInfoRequest: KPCafeDetailedInfoRequest!
    
    // 目前儲存所有的咖啡店
    var currentCafeDatas: [KPDataModel]!
    var currentDisplayModel: KPDataModel?
    
    // MARK: Initialization
    
    private init() {
        kapiDataRequest = KPCafeRequest()
        kapiDetailedInfoRequest = KPCafeDetailedInfoRequest()
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
                                    var cafeDatas = [KPDataModel]()
                                    if result["data"].arrayObject != nil {
                                        for data in (result["data"].arrayObject)! {
                                            if let cafeData = KPDataModel(JSON: (data as! [String: Any])) {
                                                cafeDatas.append(cafeData)
                                            }
                                        }
                                        if KPLocationManager.sharedInstance().currentLocation != nil {
                                            cafeDatas.sort(by: { (model1, model2) -> Bool in
                                                model1.distanceInMeter! < model2.distanceInMeter!
                                            })
                                        }
                                        self.currentCafeDatas = cafeDatas
                                        completion?(cafeDatas, nil)
                                    } else {
                                        completion?(nil, NetworkRequestError.resultUnavailable)
                                    }
        }.catch { error in
            completion?(nil, (error as! NetworkRequestError))
        }
    }
    
    func fetchStoreInformation(_ cafeID: String!,
                               _ completion:((_ result: KPDataModel?) -> Void)!) {
        kapiDetailedInfoRequest.perform(cafeID).then {result -> Void in
            if let data = result["data"].dictionaryObject {
                if let cafeData = KPDataModel(JSON: data) {
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
                    _ fb_url:String,
                    _ limited_time: String,
                    _ socket: String,
                    _ phone: String,
                    _ business_hour: [String: String],
                    _ completion: ((_ successed: Bool) -> Swift.Void)?) {
        
        
        let newShopRequest = KPAddNewCafeRequest()
        
        let loadingView = KPLoadingView(("新增中..", "新增成功", "新增失敗"))
        UIApplication.shared.topViewController.view.addSubview(loadingView)
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        
        newShopRequest.perform(name,
                               address,
                               city,
                               fb_url,
                               limited_time,
                               socket,
                               phone,
                               business_hour).then { result -> Void in
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                          execute: {
                                            loadingView.removeFromSuperview()
            })
            completion?(false)
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
                                    completion?(commentResult)
                                    guard let _ = KPUserManager.sharedManager.currentUser?.reviews?.first(where: {$0.identifier == self.currentDisplayModel?.identifier}) else {
                                        KPUserManager.sharedManager.currentUser?.reviews?.append(self.currentDisplayModel!)
                                        KPUserManager.sharedManager.storeUserInformation()
                                        return
                                    }
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
                completion?(true, nil)
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
                              music).then { result -> Void in
                                if let commentResult = result["result"].bool {
                                    loadingView.state = commentResult ? .successed : .failed
                                    completion?(commentResult)
                                    guard let _ = KPUserManager.sharedManager.currentUser?.rates?.first(where: {$0.identifier == self.currentDisplayModel?.identifier}) else {
                                        KPUserManager.sharedManager.currentUser?.rates?.append(self.currentDisplayModel!)
                                        KPUserManager.sharedManager.storeUserInformation()
                                        return
                                    }
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
                completion?(true, KPRateDataModel(JSON: ratingResult))
            }
            completion?(false, nil)
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
                                      music)).then { (response1, response2) -> Void in
                                        loadingView.state = .successed
                                        completion?(true)
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
    
    
    // MARK: Report
    
    func sendReport(_ content: String,
                    _ completion: ((Bool) -> Swift.Void)? = nil) {
        let loadingView = KPLoadingView(("回報中...", "回報成功", "回報失敗"))
        UIApplication.shared.topViewController.view.addSubview(loadingView)
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            loadingView.state = .successed
            completion?(true)
        }
    }
}
