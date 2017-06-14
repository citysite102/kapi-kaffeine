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
    
    var loadingView: KPLoadingView!
    static let sharedManager = KPUserManager()
    
    
    // MARK: Initialization
    
    private init() {
        
        // 讀取資料
        KPUserDefaults.loadUserInformation()

        // 介面
        loadingView = KPLoadingView()
        loadingView.successContent = "登入成功"
        loadingView.failContent = "登入失敗"
     
        // 建立Current User
        if KPUserDefaults.accessToken != nil {
            let currentUserInfo = ["access_token": KPUserDefaults.accessToken]
            self.currentUser = Mapper<KPUser>().map(JSONObject: currentUserInfo)
        }
    }
    
    
    // MARK: Properties
    
    var currentUser: KPUser?
    
    // MARK: API
    
    func logIn(_ viewController: UIViewController,
               completion: ((Bool) -> Swift.Void)? = nil) {
        
        let loginManager = LoginManager()
        
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
                                
                                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                                FIRAuth.auth()?.signIn(with: credential,
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
                                                                                    Mapper<KPUser>().map(JSONObject: result["data"].dictionaryValue)
                                                                                self.currentUser?.accessToken = result["token"].stringValue
                                                                                KPUserDefaults.accessToken = self.currentUser?.accessToken
                                                            
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
    
}
