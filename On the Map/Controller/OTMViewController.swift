//
//  OTMViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 24/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

/* Superclass for map and list views */

import UIKit

class OTMViewController: UIViewController {

    // MARK: Properties
    
    var session: NSURLSession!
    var students: [StudentInformation] = [StudentInformation]()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure the navbar */
        
        // TODO: see if this can be abstracted
        let button1 = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "Logout")
        let button2 = UIBarButtonItem(title: "Pin", style: .Plain, target: self, action: "SetStudentLocation")
        let button3 = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: "RefreshStudentData")
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.setLeftBarButtonItem(button1, animated: true)
        self.navigationItem.setRightBarButtonItems([button3, button2], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: Load StudentLocations
        ParseClient.sharedInstance().getStudentLocations { students, error in
            if let students = students {
                self.students = students
                dispatch_async(dispatch_get_main_queue(), {
                    print(self.students)
                    print("number of student locations entries: \(self.students.count)")
                })
            } else {
                print(error)
                if error?.code == NSURLErrorTimedOut {
                    self.displayError("Timed Out", message: "Cannot connect to server. Please check your connection.")
                } else {
                    self.displayError("Oops", message: "Something went wrong while fetching Student data. Try again later.")
                }
            }
        }
    }
    
    // MARK: AlertViewController
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { action in
            print("OK pressed on Alert Controller")
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /* Helpers */
    
    func displayError(alertTitle: String?, message: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let message = message {
                
                self.showAlert("Alert", message: message)
            }
        })
    }
    
}