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
    var sessionID: String?
    var userID: String?
    var userData: [String:AnyObject]?
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: Authenticate
    /* Authenticate with emaill and password, and pull user data */
    func authenticateWithUserCredentials(email: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        if email.isEmpty {
            completionHandler(success: false, errorString: "Email is Empty")
        } else if password.isEmpty {
            completionHandler(success: false, errorString: "Password is Empty")
        } else {
            
            getSessionID(email, password: password, access_token: nil) { (success, sessionID, userID, errorString) in
                
                if success {
                    /* set sessionID and userID */
                    self.sessionID = sessionID
                    self.userID = userID
                    
                    /* get user data */
                    self.getUserDataWithUserID(self.userID!) { (success, userData, errorString) in
                        
                        if success {
                            
                            self.userData = userData
                            
                            completionHandler(success: success, errorString: errorString)
                        } else {
                            completionHandler(success: success, errorString: errorString)
                        }
                    }
                } else {
                    completionHandler(success: success, errorString: errorString)
                }
            }
        }
    }
    
    
    func getUserDataWithUserID(userID: String, completionHandler: (success: Bool, userData: [String:AnyObject]?, errorString: String?) -> Void) {
        
        if userID.isEmpty {
            completionHandler(success: false, userData: nil, errorString: "UserID not provided or empty")
        } else {
            
            /* 1. Specify methods (if has {key}) */
            var mutableMethod : String = Methods.UdacityUserData
            mutableMethod = UClient.subtituteKeyInMethod(mutableMethod, key: UClient.URLKeys.UserId, value: String(UClient.sharedInstance().userID!))!
            
            /* 2. Make the request */
            taskForGETMethod(mutableMethod) { JSONResult, error in
                
//                print("\(__FUNCTION__) JSONResult : \(JSONResult)")
                
                /* 3. send the results to completionHandler */
                
                if let error = error {
                    print(error)
                    /* catching the timeout error */
                    if error.code == NSURLErrorTimedOut {
                        completionHandler(success: false, userData: nil, errorString: "Cannot connect to Udacity server. Please check your connection.")
                    } else {
                        completionHandler(success: false, userData: nil, errorString: "There was an error establishing a session with Udacity server. Please try again later.")
                    }
                } else if let userData = JSONResult[UClient.JSONResponseKeys.UserResults] as? [String : AnyObject] {
                    completionHandler(success: true, userData: userData, errorString: nil)
                } else {
                    completionHandler(success: false, userData: nil, errorString: "Could not parse getUserDataWithUserID")
                }
            }
        }
    }

    
    func getSessionID(email: String?, password: String?, access_token: String?, completionHandler: (success: Bool, sessionID: String?, userID: String?, errorString: String?) -> Void) {
        
        var jsonBody : [String : AnyObject]?
        
        /* 1. Specify HTTP Body */
        if let email = email {
            if let password = password {
                jsonBody = [
                    "udacity": [
                        UClient.JSONBodyKeys.Username: email as String!,
                        UClient.JSONBodyKeys.Password: password as String!
                    ]
                ]
            }
        } else if let access_token = access_token {
            print(access_token)
            jsonBody = [
                "facebook_mobile" : [
                    "access_token": access_token as String!
                ]
            ]
        }
        
        
        print(jsonBody)
        
        /* 2. Make the request */
        taskForPOSTMethod(UClient.Methods.UdacitySession, jsonBody: jsonBody!) { JSONResult, error in
            
            print("\(__FUNCTION__) JSONResult : \(JSONResult)")
            
            /* 3. Send the desired value to completion handler */
            /* check for errors and return info to user */
            if let error = error {
                print(error)
                
                /* catching the timeout error */
                if error.code == NSURLErrorTimedOut {
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Cannot connect to Udacity server. Please check your connection.")
                } else {
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "There was an error establishing a session with Udacity server. Please try again later.")
                }
                
            /* what if 403 ie invalid credentials? */
            } else if let error = JSONResult[UClient.JSONResponseKeys.ErrorMessage] as? String {
                print("\(error)")
                if JSONResult[UClient.JSONResponseKeys.Status] as? Int == 403 {
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Invalid username or password. Try again.")
                } else {
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: error)
                }
                
            /* do we have session? */
            } else if let sessionID = JSONResult.valueForKeyPath(UClient.JSONResponseKeys.SessionID) as? String {
                
                /* do we have user ID? */
                if let userID = JSONResult.valueForKeyPath(UClient.JSONResponseKeys.UserID) as? String {
                
                    completionHandler(success: true, sessionID: sessionID, userID: userID, errorString: nil)
                }
            } else {
                print("Could not find \(UClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "There was an error establishing a session with Udacity server. Please try again later.")
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
        
        print("HTTPBODY: ", NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding))
        
        /* 3. Make the request */
        
        // Set the session interval timeout
        let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlconfig.timeoutIntervalForRequest = Constants.RequestTimeout
        urlconfig.timeoutIntervalForResource = Constants.ResourceTimeout
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
                print("\(__FUNCTION__) in \(__FILE__) returned no data")
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
    
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Build the URL */
        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        /* 2. Configure the request */
//        request.HTTPMethod = "GET"
        
        /* 3. Make the request */
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
                print("\(__FUNCTION__) in \(__FILE__) returned no data")
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
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
}

    
