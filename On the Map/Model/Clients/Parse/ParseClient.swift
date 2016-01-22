//
//  ParseClient.swift
//  On the Map
//
//  Created by Wojtek Materka on 21/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: Properties

    /* Shared session */
    var session: NSURLSession
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: getStudentLocations
    
    func getStudentLocations() {
        
        taskForGETMethod(Methods.StudentLocation) { JSONResult, error in
            print("JSONResult : \(JSONResult)")
        }
        
    }
    
    // MARK: Convenience functions
    
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Build the URL */
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        /* 2. Configure the request */
        
        // Setup the HTTPHeaders
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: Constants.ParseAppIDHTTPHeader)
        request.addValue(Constants.ParseRESTAPIKey, forHTTPHeaderField: Constants.ParseRESTAPIKeyHTTPHeader)
        
        // Set the session interval timeout
        let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlconfig.timeoutIntervalForRequest = Constants.RequestTimeout
        urlconfig.timeoutIntervalForResource = Constants.ResourceTimeout
        self.session = NSURLSession(configuration: urlconfig, delegate: nil, delegateQueue: nil)
        
        
        
        /* 3. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD was there an error? */
            guard (error == nil) else {
                print("[Parse GET Method: \(method)] There was an error: \(error)")
                if error?.code == NSURLErrorTimedOut {
                    completionHandler(result: nil, error: error)
                }
                return
            }
            
            /* GUARD was there any data returned? */
            guard let data = data else {
                print("[Parse GET Method: \(method)] No data returned by request")
                return
            }
            
            /* 4. Parse the data */
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            
        }
        
        task.resume()
        
        return task
    }
    
    
    // MARK: SharedInstance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
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