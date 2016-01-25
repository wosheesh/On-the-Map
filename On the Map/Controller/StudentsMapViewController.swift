//
//  StudentsMapViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 21/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import MapKit

class StudentsMapViewController: OTMViewController, MKMapViewDelegate {
    
    // var mapView: MKMapView!
    
    // MARK: Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadStudentData { success, students in
            if success {
                print(students)
            } else {
                print("nope")
            }
        }

        
        
        
        
//        dispatch_async(dispatch_get_main_queue(), {
//            for student in self.students {
//                print(student)
//            }
//            print("number of student locations entries: \(self.students.count)")
//        })
//        
//        for student in students {
//            print(student)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Add a mapView */
        var mapView = MKMapView()
        
        mapView.mapType = .Standard
        mapView.frame = view.frame
        mapView.delegate = self
        view.addSubview(mapView)
        
        /* define the allocations and load the array with student location data */
        var annotations = [MKPointAnnotation]()
        

        
            //            let lat = CLLocationDegrees(student[ParseClient.JSONResponseKeys.Latitude]) as Double
            //            let long = CLLocationDegrees(ParseClient.JSONResponseKeys.Longitude) as Double!
            
            // Create a coordinate
            //            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
    }

}


