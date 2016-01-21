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
    
    // MARK: Authenticate
    
    func authenticateWithUserCredentials(email: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        if email.isEmpty {
            completionHandler(success: false, errorString: "Email is Empty")
        } else if password.isEmpty {
            completionHandler(success: false, errorString: "Password is Empty")
        } else {
            getSessionID(email, password: password) { (success, sessionID, errorString) in
                if success {
                    /* Success we have sessionID */
                    self.sessionID = sessionID
                    completionHandler(success: success, errorString: errorString)
                } else {
                    completionHandler(success: success, errorString: errorString)
                }
            }
        }
    }
    
    
    func getSessionID(email: String, password: String, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        /* 1. Specify HTTP Body */
        let jsonBody : [String:AnyObject] = [
            "udacity": [
                UClient.JSONBodyKeys.Username: email as String,
                UClient.JSONBodyKeys.Password: password as String
            ]
        ]
        
        /* 2. Make the request */
        taskForPOSTMethod(UClient.Methods.UdacitySession, jsonBody: jsonBody) { JSONResult, error in
            
            print("JSONResult : \(JSONResult)")
            
            /* 3. Send the desired value to completion handler */
            /* check for errors and return info to user */
            if let error = error {
                print(error)
                
                /* catching the timeout error */
                if error.code == NSURLErrorTimedOut {
                    completionHandler(success: false, sessionID: nil, errorString: "Cannot connect to Udacity server. Please check your connection.")
                } else {
                    completionHandler(success: false, sessionID: nil, errorString: "There was an error establishing a session with Udacity server. Please try again later.")
                }
                
            /* what if 403 ie invalid credentials? */
            } else if let error = JSONResult[UClient.JSONResponseKeys.ErrorMessage] as? String {
                print("\(error)")
                if JSONResult[UClient.JSONResponseKeys.Status] as? Int == 403 {
                    completionHandler(success: false, sessionID: nil, errorString: "Invalid username or password. Try again.")
                } else {
                    completionHandler(success: false, sessionID: nil, errorString: error)
                }
                
            /* do we have session? */
            } else if let sessionID = JSONResult.valueForKeyPath(UClient.JSONResponseKeys.SessionID)! as? String {
                print("found session ID: \(sessionID)")
                completionHandler(success: true, sessionID: sessionID, errorString: nil)
            } else {
                print("Could not find \(UClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                completionHandler(success: false, sessionID: nil, errorString: "There was an error establishing a session with Udacity server. Please try again later.")
            }
            
        }
    }
    
    // MARK: Convenience functions
    
    func taskForPOSTMethod(method: String, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Build the URL */
        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        /* 2. Configure the request */
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        /* 3. Make the request */
        
        // Set the session interval timeout
        let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlconfig.timeoutIntervalForRequest = 15
        urlconfig.timeoutIntervalForResource = 15
        self.session = NSURLSession(configuration: urlconfig, delegate: nil, delegateQueue: nil)
        
        // request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: was there an error? */
            guard (error == nil) else {
                print("There was an error: \(error) while calling method: \(method)")
                if error?.code == NSURLErrorTimedOut {
                    completionHandler(result: nil, error: error)
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("[StartUdacitySession] No data was returned by request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            /* 4. Parse the data and use the data in completion handler */
            UClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        /* 5. Start the request */
        task.resume()

        return task
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
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
}

    
