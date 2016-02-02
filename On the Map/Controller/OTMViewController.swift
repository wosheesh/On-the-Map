//
//  OTMViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 24/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

/* Superclass for map and list views */

import UIKit

class OTMViewController: UIViewController, AlertRenderer {

    // MARK: Properties
    var isNewUser: Bool = true
    
    /* for progress view */
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure the navbar */

        let button1 = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        let button2 = UIBarButtonItem(image: UIImage(named: "PinIcon"), style: .Plain, target: self, action: "setStudentLocation")
        let button3 = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshStudentData")
        
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
        
        /* Get all the student data */
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
        
        updateUserInformation(ParseClient.sharedInstance().user.udacityKey)
    }
    
    // MARK: updateUserInformation
    /* Check if user has location already set */
    /* If yes update user information with data from StudentInformation array */
    func updateUserInformation(uniqueKey: String) {
        ParseClient.sharedInstance().queryForStudentLocation(ParseClient.sharedInstance().user.udacityKey) { results, error in
            
            if let error = error {
                print("\(__FUNCTION__) Error : \(error)")
            } else {
                print("\(__FUNCTION__) Results: \(results)")
                
                if results?.count == 0 {
                    print("user has no info")

                } else {
                            
                    /* Update the user variable with information from results */
                    ParseClient.sharedInstance().user = UserInformation.updateUserInformationFromDictionary(ParseClient.sharedInstance().user, userData: results![0])
                    
                    /* change the flag */
                    self.isNewUser = false
                }
            }
        }
    }
    
    // MARK: setStudentLocation
    
    @IBAction func setStudentLocation() {
        
        /* queue the controller for location updating */
        let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("InformationPosting") as! InformationPostingViewController
        
        if isNewUser {
            /* go ahead and present the informationPosting controller */
            self.presentViewController(nextController, animated: true, completion: nil)
            
        } else {
            
            /* ask for user permission to update location */
            let alertController = UIAlertController(title: "On the Map", message: "You already have a location set. Do you want to update it?", preferredStyle: .Alert)
            
            let YESAction = UIAlertAction(title: "Update", style: .Default) { action in
                print("Yes pressed on Alert Controller")
                self.presentViewController(nextController, animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
                print("Cancel pressed on Alert Controller")
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(YESAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func logout() {
        /* check if it was a facebook login? */
        
        showProgressView("Logging out...")
        
        UClient.sharedInstance().logoutUdacityUser() { success, errorString in
            if success {
                print("success logging out from Udacity")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.messageFrame.removeFromSuperview()
                })
                
                let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
                self.presentViewController(nextController, animated: true, completion: nil)
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.messageFrame.removeFromSuperview()
                })
                
                print(errorString)
            }
        }
        /* Udacity logout */
    }
    
    
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
    
    /* shows an activity indicator with a simple message */
    func showProgressView(message: String) {
        
        // TODO: turn this into a class or UIView extension for re-use
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = message
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
        
    }
    
}