//
//  ParseConstants.swift
//  On the Map
//
//  Created by Wojtek Materka on 22/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    
    struct Constants {
        
        // MARK: API and App ID and HTTPHeaders
        static let ParseAppID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAppIDHTTPHeader: String = "X-Parse-Application-Id"
        
        static let ParseRESTAPIKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseRESTAPIKeyHTTPHeader: String = "X-Parse-REST-API-Key"
        
        // MARK: URLs
        static let BaseURLSecure : String = "https://api.parse.com/1/"

        // MARK: Timouts
        static let RequestTimeout : Double = 15
        static let ResourceTimeout : Double = 15
    }
    
    // MARK: Methods
    
    struct Methods {
        
        // MARK: Student Location
        static let StudentLocation = "classes/StudentLocation"
        static let UpdateStudentLocation = "classes/StudentLocation/{objectId}"
    }
    
    struct HttpMethods {
        static let PostNewUser = "POST"
        static let UpdateExistingUser = "PUT"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        // MARK: UniqueKey
        static let UniqueKey = "objectId"
    }
    
    // MARK: Parameter key
    struct ParameterKeys {
        static let ArrayQuery = "where"
    }
    
    // MARK: JSON Response Keys
    
    struct JSONResponseKeys {
        
        // MARK: Student Location
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let ObjectID = "objectId"
        
        static let Results = "results"
        
        // MARK: PUT/POST Method Response
        static let POSTResponse = "createdAt"
        static let PUTResponse = "updatedAt"
    }
    
    // MARK: Student Location Keys
    
    /* for convenience */
//    enum Keys : Int {
//        case KeyObjectId, KeyUniqueKey, KeyFirstName, KeyLastName, KeyMapString, KeyMediaURL, KeyLatitude, KeyLongitude
//        func toKey() -> String! {
//            switch self {
//            case .KeyObjectId:
//                return "objectId"
//            case .KeyUniqueKey:
//                return "uniqueKey"
//            case .KeyFirstName:
//                return "firstName"
//            case .KeyLastName:
//                return "lastName"
//            case .KeyMapString:
//                return "mapString"
//            case .KeyMediaURL:
//                return "mediaURL"
//            case .KeyLatitude:
//                return "latitude"
//            case .KeyLongitude:
//                return "longitude"
//            }
//        }
//    }
    
}
