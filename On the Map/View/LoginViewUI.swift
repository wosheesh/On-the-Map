//
//  LoginViewUI.swift
//  On the Map
//
//  Created by Wojtek Materka on 31/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

//        CUSTOM FONT NAMES
//            == Roboto-Thin
//            == Roboto-Regular
//            == Roboto-Medium

import UIKit

extension LoginViewController {
    
    func setupUI() {
        
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 0.949, green: 0.592, blue: 0.243, alpha: 1.00).CGColor
        let colorBottom = UIColor(red: 0.937, green: 0.455, blue: 0.231, alpha: 1.00).CGColor
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
//        /* Add Udacity Logo */
//        let udacityLogo = UIImageView(image: UIImage(named: "Udacity U"))
//        udacityLogo.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
//        view.addSubview(udacityLogo)
        
//        /* Configure header text label */
//        headerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
//        headerTextLabel.textColor = UIColor.whiteColor()
//        
//        /* Configure debug text label */
//        debugTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
//        debugTextLabel.textColor = UIColor.whiteColor()
//        
//        // Configure login button
//        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
//        loginButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
//        loginButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
//        loginButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
//        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        
        
        

    }
    
    // MARK: LoginViewController - Configure UI
    
        func setUIEnabled(enabled enabled: Bool) {
//            emailTextField.enabled = enabled
//            passwordTextField.enabled = enabled
//            loginButton.enabled = enabled
//    
//    
//            if enabled {
//                loginButton.alpha = 1.0
//            } else {
//                loginButton.alpha = 0.5
//            }
        }
    
}
