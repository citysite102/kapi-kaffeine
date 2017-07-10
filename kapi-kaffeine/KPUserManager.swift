//
//  KPUserManager.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/25.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import FacebookCore
import ObjectMapper

public class KPUserManager {
    
    
    // MARK: Singleton
    
    static let sharedManager = KPUserManager()
    
    // MARK: Initialization
    
    private init() {
        
        // 讀取資料
        KPUserDefaults.loadUserInformation()

        // 介面
        loadingView = KPLoadingView()
        loadingView.loadingContents = ("登入中...", "登入成功", "登入失敗")
        
        // 屬性
        loginManager = LoginManager()
     
        // 建立Current User
        if KPUserDefaults.accessToken != nil {
            var currentUserInfo: [String: Any] = ["access_token": KPUserDefaults.accessToken!]
            if let userInformation = KPUserDefaults.userInformation {
                currentUserInfo.merge(dict: userInformation)
                self.currentUser = Mapper<KPUser>().map(JSONObject: currentUserInfo)
            }
        }
    }
    
    
    // MARK: Properties
    
    var currentUser: KPUser?
    var loginManager: LoginManager!
    var loadingView: KPLoadingView!
    
    // MARK: API
    
    func logIn(_ viewController: UIViewController,
               completion: ((Bool) -> Swift.Void)? = nil) {
        
        loginManager.loginBehavior = LoginBehavior.native;
        loginManager.logIn([.publicProfile],
                           viewController: viewController) { (loginResult) in
                            
                            viewController.view.addSubview(self.loadingView)
                            self.loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                                              "H:|[$self]|"])
                            
                            switch loginResult {
                            case .failed(_):
                                self.loadingView.state = .failed
                                completion?(false)
                            case .cancelled:
                                self.loadingView.state = .failed
                                completion?(false)
                            case .success( _, _, let accessToken):
                                
                                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                                Auth.auth().signIn(with: credential,
                                                   completion: { (user, error) in
                                                        
                                                        if let error = error {
                                                            print("Login error: \(error.localizedDescription)")
                                                            let alertController = UIAlertController(title: "Login Error",
                                                                                                    message: error.localizedDescription,
                                                                                                    preferredStyle: .alert)
                                                            let okayAction = UIAlertAction(title: "OK",
                                                                                           style: .cancel,
                                                                                           handler: nil)
                                                            alertController.addAction(okayAction)
                                                            viewController.present(alertController,
                                                                                   animated: true,
                                                                                   completion: nil)
                                                            self.loadingView.state = .failed
                                                            completion?(false)
                                                            return
                                                        }
                                                        
                                                        
                                                        let loginRequest = KPLoginRequest()
                                                        loginRequest.perform(user?.uid,
                                                                             user?.displayName,
                                                                             user?.photoURL?.absoluteString,
                                                                             user?.email ?? "unknown").then { result -> Void in
                                                                                
                                                                                // 建立 Current User
                                                                                self.currentUser =
                                                                                    Mapper<KPUser>().map(JSONObject: result["data"].dictionaryObject)
                                                                                self.currentUser?.accessToken = result["token"].string
                                                                                KPUserDefaults.accessToken = result["token"].string
                                                                                self.storeUserInformation()
                                                                                
                                                                                self.loadingView.state = .successed
                                                                                completion?(true)
                                                                                
                                                                                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                                                                                    viewController.dismiss(animated: true, completion: {
                                                                                        print("Successfully Logged In")
                                                                                    })
                                                                                }
                                                                            
                                                            }.catch { error in
                                                                print("Error")
                                                            }
                                })
                            }
        }
    }
    
    
    func logOut() {
        loginManager.logOut()
        KPUserDefaults.clearUserInformation()
    }
    
    func updateUserInformation() {
        let userRequest = KPUserInformationRequest()
        userRequest.perform(nil, nil, nil, nil, nil, .get).then {
            result -> Void in
            print("取得更新後的使用者資料")
        }.catch { error in
                
        }
    }
    
    func storeUserInformation() {
        let userInformationString = currentUser?.toJSONString()
        if let jsonData = userInformationString?.data(using: .utf8) {
            do {
                let userInformation = try? JSONSerialization.jsonObject(with: jsonData,
                                                                        options: [])
                
                if userInformation != nil {
                    KPUserDefaults.userInformation = userInformation as? Dictionary<String, Any>
                }
            }
        }
    }
    
    // MARK: User Action
    
}
