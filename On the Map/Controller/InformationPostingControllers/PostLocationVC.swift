//
//  PostLocationVC.swift
//  On the Map
//
//  Created by Wojtek Materka on 27/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import MapKit

class PostLocationVC: UIViewController, MKMapViewDelegate, AlertRenderer {
    
    // MARK: Properties
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var mapForPosting: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /* if the user already has a mediaURL set update the text field */
        urlTextField.text = ParseClient.sharedInstance().user.mediaURL
        
    }
    
    
    // MARK: addAnnotationToMapFromMapItem
    func addAnnotationToMapFromMapItem(mapItem: MKMapItem) {
        print(mapItem)

        /* create a new annotation from the mapItem passed through */
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        
        /* add the annotation to the map */
        mapForPosting.addAnnotation(annotation)
    }
    
    
    // MARK: Actions
    
    @IBAction func submitButtonTouchUp(sender: AnyObject) {
        
        if urlTextField.text!.isEmpty {
            presentAlert("Submit New Data", message: "Please enter media URL")
        }
        /* update the mediaURL with new information */
        ParseClient.sharedInstance().user.mediaURL = urlTextField.text
        
        // TODO: if a new user updates this information than when he hits cancel user data should go back ... or not -> ux choice?
        
        // TODO: submit the information to Parse DB
        ParseClient.sharedInstance().submitStudentLocation(ParseClient.sharedInstance().user) { success, error in
            if success {
                print("success")
            } else {
                print(error)
                print("not updated submitStudentLocation")
            }
        }

        
    }
    
    // MARK: MKMapDelegate
    
    /* View for annotations */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "LocationPin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = UIColor(red: 0.984, green: 0.227, blue: 0.184, alpha: 1.00)
            pinView!.animatesDrop = false
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

}