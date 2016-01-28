//
//  PostLocationVC.swift
//  On the Map
//
//  Created by Wojtek Materka on 27/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import MapKit

class PostLocationVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var mapForPosting: MKMapView!
    
    
    // MARK: addAnnotationToMapFromMapItem
    func addAnnotationToMapFromMapItem(mapItem: MKMapItem) {
        print(mapItem)

        /* create a new annotation from the mapItem passed through */
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        
        /* add the annotation to the map */
        mapForPosting.addAnnotation(annotation)
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