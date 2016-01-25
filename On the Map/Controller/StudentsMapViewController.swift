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
    
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var mapView = MKMapView()
        
        mapView.mapType = .Standard
        mapView.frame = view.frame
        mapView.delegate = self
        view.addSubview(mapView)
    }

}


