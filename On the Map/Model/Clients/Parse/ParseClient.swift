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

    /* Array to hold studentInformation in a single place */
    var studentInformationArray: [StudentInformation] = [StudentInformation]()
    
    /* UdacityUser information */
    var user: UserInformation

    /* Shared session */
    var session: NSURLSession
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        
        /* instantiate 'user' for possible Parse updates */
        user = UserInformation.UserInformationFromUserData(UClient.sharedInstance().userData!)
        
        super.init()
        

    }
    
    // MARK: getStudentLocations
    
    func getStudentLocations(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        // TODO: Limit to last 100 entries
        
        /* Make the request */
        taskForGETMethod(Methods.StudentLocation, parameters: nil) { JSONResult, error in
            
            /* check for errors */
            if let error = error {
                print(error)
                completionHandler(success: false, error: error)
            } else {
                
                /* if JSON parse successful store the student informations as an array of ParseClient singleton */
                if let results = JSONResult[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    self.studentInformationArray = StudentInformation.StudentInformationFromResults(results)
                    completionHandler(success: true, error: nil)
                    
                } else {
                    completionHandler(success: false, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Student Data"]))
                }
            }
        }
    }
    
    // MARK: queryForStudentLocation
    
    func queryForStudentLocation(uniqueKey: String, completionHandler: (results: [[String:AnyObject]]?, error: NSError?) -> Void) {
        
        /* 1. Specify the parameters, method */
        
        /* declare the query for a specific userKey */
        let query = "{\"\(JSONResponseKeys.UniqueKey)\":\"\(user.udacityKey)\"}"
        /* declare the parameters for Parse API */
        let parameters = [ParameterKeys.ArrayQuery : query]
      
        /* 2. Make the request */
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { JSONResult, error in
            
            if let error = error {
                print("[Parse: \(__FUNCTION__)] There was an error: \(error)")
                completionHandler(results: nil, error: error)
            } else {
                if let results = JSONResult[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    completionHandler(results: results, error: nil)
                } else {
                    print(JSONResult)
                    completionHandler(results: nil, error: NSError(domain: "queryForStudentLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not resolve query"]))
                }
            }
        }
        
        // api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221217518784%22%7D
//                                                ?where=%7B%22uniqueKey%22%3A%221217518784%22%7D
        
//        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D"
//        let url = NSURL(string: urlString)
//        print(url)
//        let request = NSMutableURLRequest(URL: url!)
//        request.addValue(Constants.ParseAppID, forHTTPHeaderField: Constants.ParseAppIDHTTPHeader)
//        request.addValue(Constants.ParseRESTAPIKey, forHTTPHeaderField: Constants.ParseRESTAPIKeyHTTPHeader)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            if error != nil {
//                print("\(__FUNCTION__) Error: \(error)")
//                return
//            }
//            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//        }
//        task.resume()
        
        
    }
    
    
    // MARK: Convenience functions
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject]?,
        completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Build the URL */
        var urlString = String()
            
        if let mutableParameters = parameters {
            print("MutableParameters: \(mutableParameters)")
            urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(mutableParameters)
        } else {
            urlString = Constants.BaseURLSecure + method
        }
            
        print("urlString: \(urlString)")
        let url = NSURL(string: urlString)!
        print("\(__FUNCTION__) Url: \(url)")
        let request = NSMutableURLRequest(URL: url)
        
        /* 2. Configure the request */
        
        // Setup the HTTPHeaders
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: Constants.ParseAppIDHTTPHeader)
        request.addValue(Constants.ParseRESTAPIKey, forHTTPHeaderField: Constants.ParseRESTAPIKeyHTTPHeader)
        
        // Set the session interval timeout
        let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlconfig.timeoutIntervalForRequest = ParseClient.Constants.RequestTimeout
        urlconfig.timeoutIntervalForResource = ParseClient.Constants.ResourceTimeout
        self.session = NSURLSession(configuration: urlconfig, delegate: nil, delegateQueue: nil)
        
        
        /* 3. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD was there an error? */
            guard (error == nil) else {
                print("[Parse GET Method: \(method)] There was an error: \(error)")
                if error!.code == NSURLErrorTimedOut {
                    completionHandler(result: nil, error: error)
                }
                return
            }
            
            /* GUARD was there any data returned? */
            guard let data = data else {
                print("[Parse GET Method: \(method)] No data returned by request")
                completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not receive any data"]))
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
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLUserAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
}