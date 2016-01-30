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
    var mapString : String?
    var mediaURL : String?
    var lat: Double? = nil
    var long: Double? = nil
    var objectID: String?
    
    init(udacityKey: String, firstName: String, lastName: String) {
        self.udacityKey = udacityKey
        self.firstName = firstName
        self.lastName = lastName
    }
    
    /* Convert JSON result from UClient login to UserInformation */
    static func UserInformationFromUserData(userData: [String:AnyObject]) -> UserInformation {
        
        let user = UserInformation(
            udacityKey: userData[UClient.JSONResponseKeys.UserKey] as! String,
            firstName: userData[UClient.JSONResponseKeys.FirstName] as! String,
            lastName: userData[UClient.JSONResponseKeys.LastName] as! String)
        
        return user
    }
    
    static func updateUserInformationFromDictionary(user: UserInformation, userData: [String:AnyObject]) -> UserInformation {
        var updatedUser = user
        
        updatedUser.mapString = userData[ParseClient.JSONResponseKeys.MapString] as? String
        updatedUser.mediaURL = userData[ParseClient.JSONResponseKeys.MediaURL] as? String
        updatedUser.lat = userData[ParseClient.JSONResponseKeys.Latitude] as? Double
        updatedUser.long = userData[ParseClient.JSONResponseKeys.Longitude] as? Double
        updatedUser.objectID = userData[ParseClient.JSONResponseKeys.ObjectID] as? String

        return updatedUser
    }
    
    
}

