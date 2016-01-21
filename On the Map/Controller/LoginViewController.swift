//
//  LoginViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 10/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.debugTextLabel.text = ""
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        // TODO: loginButtonTouch
        self.debugTextLabel.text = ""
        self.setUIEnabled(enabled: false)
        
        UClient.sharedInstance().authenticateWithUserCredentials(emailTextField.text!, password: passwordTextField.text!) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    // MARK: LoginViewController
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = "Login Complete"
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
                
                self.showAlert("Alert", message: errorString)
            }
        })
    }
    
    // MARK: LoginViewController - Configure UI
    
    func setUIEnabled(enabled enabled: Bool) {
        emailTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        debugTextLabel.enabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    // MARK: AlertViewController
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction!) in
//            print("You have pressed the Cancel button")
//        }
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { action in
            print("OK pressed on Alert Controller")
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}