//
//  StudentInformation.swift
//  On the Map
//
//  Created by Wojtek Materka on 22/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    // MARK: Properties
    
    var studentLocation : [String : AnyObject] = [
        ParseClient.JSONResponseKeys.ObjectId : "", // an auto-generated id/key generated by Parse which uniquely identifies a StudentLocation
        ParseClient.JSONResponseKeys.UniqueKey : "", // an extra (optional) key used to uniquely identify a StudentLocation; populated by the Udacity userID
        ParseClient.JSONResponseKeys.FirstName : "", // the first name of the student which matches their Udacity profile first name
        ParseClient.JSONResponseKeys.LastName : "", // the last name of the student which matches their Udacity profile last name
        ParseClient.JSONResponseKeys.MapString : "", // the location string used for geocoding the student location
        ParseClient.JSONResponseKeys.MediaURL : "", // the URL provided by the student
        ParseClient.JSONResponseKeys.Latitude : 0.0 as Float, // the latitude of the student location (ranges from -90 to 90)
        ParseClient.JSONResponseKeys.Longitude : 0.0 as Float // the longitude of the student location (ranges from -180 to 180)
    ]
    
    
    // MARK: Initialisers
    
    init(dictionary: [String : AnyObject]) {
        
        for (key, value) in dictionary {
            if studentLocation[key] != nil {
                studentLocation.updateValue(value, forKey: key)
            }
        }
        
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentInformation Objects */
    static func StudentInformationFromResults(results: [[String: AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }

}