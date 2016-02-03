//
//  UserInformation.swift
//  On the Map
//
//  Created by Wojtek Materka on 29/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

struct UserInformation {
    static var udacityKey : String? {
        willSet(userUdacityKey) {
            print("setting user udacity Key tp \(userUdacityKey)")
        }
        didSet {
            if udacityKey != oldValue {
                print("Changed user Udacity key from \(oldValue) to \(udacityKey)")
            }
        }
    }
    static var firstName : String?
    static var lastName : String?
    static var mapString : String?
    static var mediaURL : String?
    static var lat: Double? = nil
    static var long: Double? = nil
    static var objectID: String?
    
    init(udacityKey: String, firstName: String, lastName: String) {
        UserInformation.udacityKey = udacityKey
        UserInformation.firstName = firstName
        UserInformation.lastName = lastName
    }
    
    /* Convert JSON result from UClient login to UserInformation */
    static func UserInformationFromUserData(userData: [String:AnyObject]) -> UserInformation {
        
        let user = UserInformation(
            udacityKey: userData[UClient.JSONResponseKeys.UserKey] as! String,
            firstName: userData[UClient.JSONResponseKeys.FirstName] as! String,
            lastName: userData[UClient.JSONResponseKeys.LastName] as! String)
        
        return user
    }
    
    static func updateUserInformationFromDictionary(userData: [String:AnyObject]) {

        UserInformation.mapString = userData[ParseClient.JSONResponseKeys.MapString] as? String
        UserInformation.mediaURL = userData[ParseClient.JSONResponseKeys.MediaURL] as? String
        UserInformation.lat = userData[ParseClient.JSONResponseKeys.Latitude] as? Double
        UserInformation.long = userData[ParseClient.JSONResponseKeys.Longitude] as? Double
        UserInformation.objectID = userData[ParseClient.JSONResponseKeys.ObjectID] as? String

    }
    
    static func clearUserInformation() {
        UserInformation.udacityKey = nil
        UserInformation.firstName = nil
        UserInformation.lastName = nil
        UserInformation.mapString = nil
        UserInformation.mediaURL = nil
        UserInformation.lat = nil
        UserInformation.long = nil
        UserInformation.objectID = nil
    }
    
    
}

