//
//  UFacebook.swift
//  On the Map
//
//  Created by Wojtek Materka on 01/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

let facebookReadPermissions = ["email"]

extension UClient {
    
    // MARK: authenticateWithFacebook
    func authenticateWithFacebook(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        // TODO: Should handle when user already logged in.
        
        /* use FB Login Manager to authenticate */
        FBSDKLoginManager().logInWithReadPermissions(facebookReadPermissions, fromViewController: nil, handler: { result, error in
            
            if error != nil {
                
                FBSDKLoginManager().logOut()
                completionHandler(success: false, error: error)
            } else if result.isCancelled {
                
                // handle cancellations
                FBSDKLoginManager().logOut()
                let userInfo = [NSLocalizedDescriptionKey : "Facebook Login cancelled"]
                completionHandler(success: false, error: NSError(domain: "authenticateWithFacebook - cancel", code: 0, userInfo: userInfo))
            } else {
                let access_token = FBSDKAccessToken.currentAccessToken().tokenString
                 print("Got a FB access_token: \(access_token)")
                
                /* if successful read user data from Udacity */
                self.getSessionID(nil, password: nil, access_token: access_token) { success, sessionID, userID, errorString in
                    
                    if success {
                        self.sessionID = sessionID
                        self.userID = userID
                        
                        self.getUserDataWithUserID(self.userID!) { success, userData, errorString in
                            
                            if success {
                                self.userData = userData
                                completionHandler(success: success, error: nil)
                            } else {
                                let userInfo = [NSLocalizedDescriptionKey : errorString as String!]
                                completionHandler(success: success, error: NSError(domain: "authenticateWithFacebook - getUserDataWithUserID", code: 0, userInfo: userInfo))
                            }
                        }
                        
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey : errorString as String!]
                        completionHandler(success: success, error: NSError(domain: "authenticateWithFacebook - getSessionID", code: 0, userInfo: userInfo))
                    }
                    
                }

            }
        })


    }
    
    
    func logoutFromFacebook() {
        
//        FBSDKAccessToken.currentAccessToken() = nil
        FBSDKLoginManager().logOut()
        
    }
    
}