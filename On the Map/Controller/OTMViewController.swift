//
//  OTMViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 24/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

/* Superclass for map and list views */
// TODO: Change this into a delegate

import UIKit

class OTMViewController: UIViewController, AlertRenderer {

    // MARK: Properties
    
    var session: NSURLSession!
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure the navbar */
        
        // TODO: see if this can be abstracted
        let button1 = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        let button2 = UIBarButtonItem(title: "Pin", style: .Plain, target: self, action: "setStudentLocation")
        let button3 = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: "refreshStudentData")
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.setLeftBarButtonItem(button1, animated: true)
        self.navigationItem.setRightBarButtonItems([button3, button2], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    // MARK: loadStudentData
    
    func loadStudentData(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        ParseClient.sharedInstance().getStudentLocations { success, error in
            if success {
                completionHandler(success: true, error: nil)
            } else {
                print(error)
                if error?.code == NSURLErrorTimedOut {
                    self.displayError("Timed Out", message: "Cannot connect to server. Please check your connection.")
                } else {
                    self.displayError("Oops", message: "Something went wrong while fetching Student data. Try again later.")
                }
                return
            }
        }
    }
    
    // MARK: setStudentLocation
    
    @IBAction func setStudentLocation() {
        
        // TODO: Check if the user has a student location already set

        let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("InformationPosting") as! InformationPostingViewController
        print(nextController)
        
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    /* returns true if student found in parse database */
    /* (assumption that it has a location if it is in parse) */
//    func checkUserLocation() -> Bool {
//        //
//    }
    
    
    /* Helpers */
    
    func displayError(alertTitle: String?, message: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let message = message {
                
                self.presentAlert("Alert", message: message)
            }
        })
    }
    
    func openSafariWithURLString(urlString: String) {
        let app = UIApplication.sharedApplication()
        
        /* check if they left http(s) prefix - many students don't and safari fails to open */
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            app.openURL(NSURL(string: urlString)!)
        } else {
            app.openURL(NSURL(fileURLWithPath: urlString, relativeToURL: NSURL(string: "http://")))
        }
    }
    
}