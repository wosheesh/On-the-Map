//
//  UConstants.swift
//  On the Map
//
//  Created by Wojtek Materka on 20/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

extension UClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let BaseURL: String = "https://www.udacity.com/api/"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Authentication
        static let UdacitySession = "session"
        
        // MARK: User Data
        static let UdacityUserData = "users/{id}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserId = "id"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let Username = "username"
        static let Password = "password"
        static let FBAccessToken = "access_token"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status"
        static let ErrorMessage = "error"
        
        // MARK: Authorization
        static let UserID = "key"
        static let SessionID = "id"
        
        // MARK: Public User Data
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
    }
}
