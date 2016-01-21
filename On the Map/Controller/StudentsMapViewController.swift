//
//  StudentsMapViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 21/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class StudentsMapViewController: UIViewController {
    
    // MARK: Properties
    
    var session: NSURLSession!
    
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure the navbar */
        let button1 = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "Logout")
        let button2 = UIBarButtonItem(title: "Pin", style: .Plain, target: self, action: "SetStudentLocation")
        let button3 = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: "RefreshStudentData")

        navigationItem.hidesBackButton = true

        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.setLeftBarButtonItem(button1, animated: true)
        navigationItem.setRightBarButtonItems([button3, button2], animated: true)

        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // load the data
        ParseClient.sharedInstance().getStudentLocations()
    }
    
    
    // MARK: Load StudentLocations
    

    
}


