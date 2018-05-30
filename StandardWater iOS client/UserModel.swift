//
//  UserModel.swift
//  StandardWater iOS client
//
//  Created by Grant Broadwater on 5/16/18.
//  Copyright © 2018 StandardWater. All rights reserved.
//

import Foundation
import GoogleSignIn

class UserModel {
    
    // Member Constants
    let googleID: String
    let displayName: String
    let accessToken: String
    
    // Member Variables
    var authenticated = false
    var admin = false
    
    // Initializer
    init(_ user: GIDGoogleUser) {
        self.googleID = user.userID
        self.displayName = user.profile.name
        self.accessToken = user.authentication.idToken
    }
    
    // Authenticate current model with server
    func authenticateAsStandardWaterUser(onComplete callback: ((Bool, UserModel?, String?)->Void)? = nil) {
        
        // Authenticate
        AuthenticationModel.authenticate(token: self.accessToken) { isValidSWUser, isAdmin, message in
            
            // Set authenticated flag
            self.authenticated = isValidSWUser;
            
            if isAdmin ?? false {
                self.admin = true
            }
            
            // Call callback if availible
            if let callback = callback {
                if self.authenticated {
                    callback(true, self, message)
                } else {
                    callback(false, nil, message)
                }
            }
        }
    }
}
