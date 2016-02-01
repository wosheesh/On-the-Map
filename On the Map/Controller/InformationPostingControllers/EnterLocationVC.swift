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
    
    var enterLocationDelegate: EnterLocationVCDelegate?
    
    @IBOutlet weak var locationTextField: EnterLocationTextField!
    @IBOutlet weak var FindOnMapButton: FindOnTheMapButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
 
    @IBOutlet weak var topToolbar: UIToolbar!
    
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
        // TODO: Change button state if textfield is not empty [http://stackoverflow.com/questions/28394933/how-do-i-check-when-a-uitextfield-changes]
        // TODO: progress indicator if searching
        
        if locationTextField.text!.isEmpty {
            presentAlert("Map Search", message: "Please enter location")
        } else {
            /* setup the location search request */
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = locationTextField.text
            
            /* make the location search request */
            let search = MKLocalSearch(request: request)
            search.startWithCompletionHandler { response, error in
                guard let response = response else {
                    print("There was an error: \(error) while searching for: \(request.naturalLanguageQuery)")
                    self.presentAlert("Map Search", message: "Couldn't find the location. Check your internet connection.")
                    return
                }
                
                /* pass the first mapItem found */
                self.enterLocationDelegate?.enterLocationVCDidReturnMapItem(response.mapItems[0])
                
            }
        }
        
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