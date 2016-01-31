//
//  LoginViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 10/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

// TODO: add app Transport security

import UIKit

class LoginViewController: UIViewController, AlertRenderer {
    
    // MARK: Properties
    
    @IBOutlet weak var loginToUdacityLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginWithFBButton: BorderedButtonFB!
    
    
    // TODO: signup at Udacity
    
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
        setupUI()
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        // TODO: loginButtonTouch

        self.setUIEnabled(enabled: false)
        
//        UClient.sharedInstance().authenticateWithUserCredentials(emailTextField.text!, password: passwordTextField.text!) { (success, errorString) in
//            if success {
//                self.completeLogin()
//            } else {
//                self.displayError(errorString)
//            }
//        }
    }
    
    // MARK: LoginViewController
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {

            self.setUIEnabled(enabled: false)
            // TODO: instantiate login view
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabsController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            self.setUIEnabled(enabled: true)
            if let errorString = errorString {
                
                self.presentAlert("On The Map", message: errorString)
            }
        })
    }
    

    
    
}