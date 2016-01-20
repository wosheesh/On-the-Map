//
//  UClient.swift
//  On the Map
//
//  Created by Wojtek Materka on 20/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

// MARK: UClient: NSObject

class UClient: NSObject {
    
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID: String? = nil
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: Get Session ID
    
//    TODO: get session id
    /* get sessionid to login */
    func getSession(email: String, password: String, completionHandler: (result: String?, error: String?) -> Void) {
        if email.isEmpty {
            completionHandler(result: nil, error: "Email is Empty")
        } else if password.isEmpty {
            completionHandler(result: nil, error: "Password is Empty")
        } else {
            completionHandler(result: "success", error: nil)
        }
    }
    
    

    // MARK: Shared Instance
    
    /* used to call on type functions directly without the need to instantiate ? */
    
    class func sharedInstance() -> UClient {
        struct Singleton {
            static var sharedInstance = UClient()
        }
        
        return Singleton.sharedInstance
    }
    
    
    
    
// MARK: Helpers
    
    /* Helper function: Given a dictionary of parameters, convert to a string for an url */
//    class func escapedParameters(parameters: [String : AnyObject]) -> String {
//        
//        var urlVars = [String]()
//        
//        for (key, value) in parameters {
//            
//            /* Make sure it's a string value */
//            let stringValue = "\(value)"
//            
//            /* Escape it */
//            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
//            
//            /* Append it */
//            urlVars += [key + ":" + "\(escapedValue)"]
//            
//        }
//        
//        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
//    }
    
}