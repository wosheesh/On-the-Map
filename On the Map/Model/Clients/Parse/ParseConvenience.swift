//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Wojtek Materka on 03/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: getStudentLocations
    /// GETs all lat 100 student location objects and loads them to StudentInformation.StudentArray
    func getStudentLocations(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify the parameters */
        
        /* limit the search to last 100 entries and sort by the most recently updated */
        let parameters = [
            ParameterKeys.LimitQuery : 100,
            ParameterKeys.OrderQuery : "-updatedAt"
        ]
        
        /* 2. Make the request */
        taskForHTTPMethod(Methods.StudentLocation, httpMethod: "GET", parameters: parameters, jsonBody: nil) { JSONResult, error in
            
            /* check for errors */
            if let error = error {
                print(error)
                completionHandler(success: false, error: error)
            } else {
                
                /* if JSON parse successful store the student informations as an array in StudentInformation model */
                if let results = JSONResult[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    StudentInformation.StudentArray = StudentInformation.StudentInformationFromResults(results)
                    
                    completionHandler(success: true, error: nil)
                    
                } else {
                    completionHandler(success: false, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Student Data"]))
                }
            }
        }
    }
    
    
    // MARK: queryForStudentLocation
    /// Looks for StudentLocation data with uniqueKey. Returns the data through completionHandler
    func queryForStudentLocation(uniqueKey: String, completionHandler: (results: [[String:AnyObject]]?, error: NSError?) -> Void) {
        
        /* 1. Specify the parameters, method */
        
        /* declare the query for a specific userKey */
        let query = "{\"\(JSONResponseKeys.UniqueKey)\":\"\(UserInformation.udacityKey!)\"}"
        /* declare the parameters for Parse API */
        let parameters = [ParameterKeys.ArrayQuery : query]
        
        /* 2. Make the request */
        taskForHTTPMethod(Methods.StudentLocation, httpMethod: "GET", parameters: parameters, jsonBody: nil) { JSONResult, error in
            
            if let error = error {
                print("[Parse: \(__FUNCTION__)] There was an error: \(error)")
                completionHandler(results: nil, error: error)
            } else {
                if let results = JSONResult[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    completionHandler(results: results, error: nil)
                } else {
                    completionHandler(results: nil, error: NSError(domain: "queryForStudentLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not resolve query"]))
                }
            }
        }
    }
    
    // MARK: submitStudentLocation
    /// Submits new StudentLocation of the current app user to the Parse StudentInformation array.
    func submitStudentLocation(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        var httpMethod : String
        
        /* 1. Specify parameters, method and HTTP Body */
        var mutableMethod : String = Methods.UpdateStudentLocation
        
        if let objectID = UserInformation.objectID {
            mutableMethod = ParseClient.subtituteKeyInMethod(mutableMethod, key: ParseClient.URLKeys.UniqueKey, value: objectID)! // user.objectID!
            httpMethod = ParseClient.HttpMethods.UpdateExistingUser
        } else {
            mutableMethod = ParseClient.subtituteKeyInMethod(mutableMethod, key: ParseClient.URLKeys.UniqueKey, value: "")!
            httpMethod = ParseClient.HttpMethods.PostNewUser
        }
        
        let jsonBody : [String : AnyObject] = [
            ParseClient.JSONResponseKeys.UniqueKey : UserInformation.udacityKey!,
            ParseClient.JSONResponseKeys.FirstName : UserInformation.firstName!,
            ParseClient.JSONResponseKeys.LastName : UserInformation.lastName!,
            ParseClient.JSONResponseKeys.MapString : UserInformation.mapString!,
            ParseClient.JSONResponseKeys.MediaURL : UserInformation.mediaURL!,
            ParseClient.JSONResponseKeys.Latitude : UserInformation.lat!,
            ParseClient.JSONResponseKeys.Longitude: UserInformation.long!
        ]
        
        print("Calling PARSEmethod: \(mutableMethod) with HTTPmethod: \(httpMethod)")
        
        /* 2. make the request */
        taskForHTTPMethod(mutableMethod, httpMethod: httpMethod, parameters: nil, jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                if error.code == -1001 {
                    completionHandler(success: false, errorString: "Request timed out")
                } else {
                    completionHandler(success: false, errorString: "Something went wrong: \(error.userInfo.description)")
                }
            } else if let _ = JSONResult[ParseClient.JSONResponseKeys.PUTResponse] as? String {
                completionHandler(success: true, errorString: nil)
            } else if let _ = JSONResult[ParseClient.JSONResponseKeys.POSTResponse] as? String {
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "Could not PUT new user information")
            }
            
        }
    }
    
}