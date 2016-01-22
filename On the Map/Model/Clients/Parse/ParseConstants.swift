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
    }
    
}
