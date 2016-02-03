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
    
    let mapView = MKMapView()
    var annotations = [MKPointAnnotation]()
    var mapUpdated: Bool = false
    
    // MARK: Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Add a mapView */
        mapView.mapType = .Standard
        mapView.frame = view.frame
        mapView.delegate = self
        view.addSubview(mapView)
        
        /* check if the user has Parse data */
        updateUserInformation()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* inital load of data */
        refreshStudentData()
        
    }
    
    // MARK: refreshStudentData
    
    @IBAction func refreshStudentData() {
        
        /* clear the existing annotations */
        if mapUpdated {
            self.mapView.removeAnnotations(mapView.annotations)
            annotations = []
        }
        
        /* define the allocations and load the array with student location data  */
        loadStudentData { success, error in
            if success {
                for student in StudentInformation.StudentArray {
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
                    
                    /* append new annotation to the array */
                    self.annotations.append(annotation)
                }
                
                /* add new annotations to the map */
                dispatch_async(dispatch_get_main_queue(), {
                    self.mapView.addAnnotations(self.annotations)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.mapUpdated = true
                    })
                })
                
            } else {
                self.displayError("Oops", message: "Something went wrong while fetching Student data. Try again later.")
                print("Error: \(error) in \(__FUNCTION__)")
            }
        }
    }

    
    // MARK: MKMapDelegate
    
    /* View for annotations */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor(red: 0.984, green: 0.227, blue: 0.184, alpha: 1.00)
            pinView!.animatesDrop = !mapUpdated
            pinView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    /* open safari on annotation tap */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            /* if annotation has a subtitle than try open safari */
            if let urlString = view.annotation?.subtitle! {
                openSafariWithURLString(urlString)
            }
        }
    }
    
    

}


