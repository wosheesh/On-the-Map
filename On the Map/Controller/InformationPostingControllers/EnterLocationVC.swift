//
//  EnterLocationVC.swift
//  On the Map
//
//  Created by Wojtek Materka on 27/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import MapKit

protocol EnterLocationVCDelegate {
    func enterLocationVCDidReturnMapItem(mapItem: MKMapItem)
}

class EnterLocationVC: UIViewController, AlertRenderer {
    
    // MARK: Properties

    
    @IBOutlet weak var locationTextField: EnterLocationTextField!
    @IBOutlet weak var FindOnMapButton: FindOnTheMapButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    
    var enterLocationDelegate: EnterLocationVCDelegate?
    
    /* for progress view */
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    // MARK: Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /* if the user already has a location set update the text field */
        locationTextField.text = ParseClient.sharedInstance().user.mapString 
    }
    
    override func viewDidLoad() {
        setupUI()
        
        locationTextField.delegate = self
        
    }
    
    // MARK: Actions
    
    
    @IBAction func cancelButtonTouchUp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func FindOnMapButtonTouchUp(sender: AnyObject) {
        
        if locationTextField.text!.isEmpty {
            presentAlert("Map Search", message: "Please enter location")
        } else {
            
            showProgressView("Searching...")
            
            /* setup the location search request */
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = locationTextField.text
            
            /* make the location search request */
            let search = MKLocalSearch(request: request)
            search.startWithCompletionHandler { response, error in
                guard let response = response else {
                    
                    /* make sure we remove the activity indicator */
                    self.messageFrame.removeFromSuperview()
                    
                    print("There was an error: \(error) while searching for: \(request.naturalLanguageQuery)")
                    self.presentAlert("Map Search", message: "Couldn't find the location. Check your internet connection.")
                    return
                }
                
                /* make sure we remove the activity indicator */
                self.messageFrame.removeFromSuperview()
                
                /* pass the first mapItem found */
                self.enterLocationDelegate?.enterLocationVCDidReturnMapItem(response.mapItems[0])
                
            }
        }
        
    }
    
    /* shows an activity indicator with a simple message */
    func showProgressView(message: String) {
        
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

// MARK: UITextFieldDelegate
extension EnterLocationVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.locationTextField {
            FindOnMapButtonTouchUp(textField)
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}