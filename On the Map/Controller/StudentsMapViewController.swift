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
    var students: [StudentInformation] = [StudentInformation]()
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: Load StudentLocations
        ParseClient.sharedInstance().getStudentLocations { students, error in
            if let students = students {
                self.students = students
                dispatch_async(dispatch_get_main_queue(), {
                    print(self.students)
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


