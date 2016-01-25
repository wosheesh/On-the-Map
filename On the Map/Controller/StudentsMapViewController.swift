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
    var students: [StudentInformation] = [StudentInformation]()
    
    // MARK: Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        
        loadStudentData { success, results in
            
            if success {
                self.students = results
                
                for student in self.students {
                    let lat = CLLocationDegrees(student.studentLocation[ParseClient.JSONResponseKeys.Latitude] as! Double)
                    let long = CLLocationDegrees(student.studentLocation[ParseClient.JSONResponseKeys.Longitude] as! Double)

                    /* Create a coordinate */
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let firstName = student.studentLocation[ParseClient.JSONResponseKeys.FirstName] as! String
                    let lastName = student.studentLocation[ParseClient.JSONResponseKeys.LastName] as! String
                    let mediaURL = student.studentLocation[ParseClient.JSONResponseKeys.MediaURL] as! String
                    
                    /* create annotation */
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
                    
                    /* append annotations to the array */
                    annotations.append(annotation)
                }
                
            } else {
                print("[StudentsMapViewController didn't receive students array")
            }
            
            /* add annotations to the map */
            mapView.addAnnotations(annotations)
        }
    }
    
    // MARK: 

}


