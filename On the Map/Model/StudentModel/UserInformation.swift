//
//  UserInformation.swift
//  On the Map
//
//  Created by Wojtek Materka on 29/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

struct UserInformation {
    var udacityKey : String
    var firstName : String
    var lastName : String
    var hasLocation: Bool? = nil
    var lat: Float? = nil
    var long: Float? = nil
    
    init(udacityKey: String, firstName: String, lastName: String) {
        self.udacityKey = udacityKey
        self.firstName = firstName
        self.lastName = lastName
    }
    
    static func UserInformationFromUserData(userData: [String:AnyObject]) -> UserInformation {
        
        let user = UserInformation(
            udacityKey: userData[UClient.JSONResponseKeys.UserKey] as! String,
            firstName: userData[UClient.JSONResponseKeys.FirstName] as! String,
            lastName: userData[UClient.JSONResponseKeys.LastName] as! String)
        
        return user
    }
    
}

