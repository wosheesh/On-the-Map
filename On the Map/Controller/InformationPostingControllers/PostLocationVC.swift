//
//  PostLocationVC.swift
//  On the Map
//
//  Created by Wojtek Materka on 27/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import MapKit

class PostLocationVC: UIViewController, MKMapViewDelegate, AlertRenderer {
    
    // MARK: Properties
    
    @IBOutlet weak var urlTextField: UrlTextField!
    @IBOutlet weak var mapForPosting: MKMapView!
    @IBOutlet weak var submitButton: SubmitUserDataButton!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var updateQuery: UILabel!
    
    /* for progress view */
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    // MARK: Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /* if the user already has a mediaURL set update the text field */
        urlTextField.text = UserInformation.mediaURL
        
    }
    
    override func viewDidLoad() {
        setupUI()
        
        urlTextField.delegate = self
        
    }
    
    func showLocationfromMapItem(mapItem: MKMapItem) {
        
        mapForPosting.setCenterCoordinate(mapItem.placemark.coordinate, animated: true)
        
    }
    
    func addAnnotationToMapFromMapItem(mapItem: MKMapItem) {
        print(mapItem)

        /* create a new annotation from the mapItem passed through */
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        
        /* add the annotation to the map */
        mapForPosting.addAnnotation(annotation)
    }
    
    
    // MARK: Actions
    
    @IBAction func cancelButtonTouchUp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButtonTouchUp(sender: AnyObject) {
        
        if urlTextField.text!.isEmpty {
            presentAlert("Submit New Data", message: "Please enter media URL")
        } else {
            
            showProgressView("Submitting...")
            
            /* update the mediaURL with new information */
            UserInformation.mediaURL = urlTextField.text
            
            ParseClient.sharedInstance().submitStudentLocation() { success, errorString in
                if success {
                    
                    /* inform the user of the successful update and dismiss the view */
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        /* make sure we remove the activity indicator */
                        self.messageFrame.removeFromSuperview()
                        
                        let alertController = UIAlertController(title: "On the Map", message: "Data updated successfully", preferredStyle: .Alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { action in
                            print("OK pressed on Alert Controller")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                        alertController.addAction(OKAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    })
                    
                    
                    
                } else if let errorString = errorString {

                    print("not updated submitStudentLocation")
                    
                    /* make sure the user sees an alert if the post fails */
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        /* make sure we remove the activity indicator */
                        self.messageFrame.removeFromSuperview()
                        
                        self.presentAlert("On the Map", message: errorString)
                    })
                    
                }
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
    
    // MARK: MKMapDelegate
    
    /* View for annotations */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "LocationPin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = UIColor(red: 0.984, green: 0.227, blue: 0.184, alpha: 1.00)
            pinView!.animatesDrop = false
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

}

// MARK: UITextFieldDelegate
extension PostLocationVC : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.urlTextField {
            submitButtonTouchUp(textField)
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}