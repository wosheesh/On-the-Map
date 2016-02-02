//
//  LoginViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 10/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

// TODO: add app Transport security
// TODO: lift view with keyboard
// TODO: Sigin In
// TODO: Logout

import UIKit

class LoginViewController: UIViewController, AlertRenderer {
    
    // MARK: Properties
    
    @IBOutlet weak var loginToUdacityLabel: UILabel!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UdacityLoginButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginWithFBButton: FBLoginButton!
    
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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonTouch(sender: AnyObject) {

        self.setUIEnabled(enabled: false)
        
        UClient.sharedInstance().authenticateWithUserCredentials(emailTextField.text!, password: passwordTextField.text!) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    @IBAction func loginWithFBButtonTouchUp(sender: AnyObject) {
        
        self.setUIEnabled(enabled: false)
        
        UClient.sharedInstance().authenticateWithFacebook { (success, error) in
            if success {
                self.completeLogin()
            } else {
                if error?.domain == "authenticateWithFacebook - getSessionID" {
                    self.displayError("Couldn't link your Facebook account with Udacity profile. Check in https://www.udacity.com/account#!/linked-accounts")
                } else if error?.domain == "authenticateWithFacebook - cancel" {
                    self.displayError("Facebook authentication cancelled.")
                } else {
                    self.displayError("Something went wrong with Facebook authentication. Try again later.")
                }
            }
        }
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

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.passwordTextField {
            loginButtonTouch(textField)
        }
        return true
    }
    
    /* tapping outside of text field will dismiss keyboard */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
