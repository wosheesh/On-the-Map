//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 26/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var EnterLocationContainer: UIView!
    @IBOutlet weak var PostLocationContainer: UIView!
    
    var postLocationVC: PostLocationVC?
    
    // MARK: Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        EnterLocationContainer.hidden = false
        PostLocationContainer.hidden = true
    }

    // MARK: Actions

    @IBAction func cancelButtonTouchUp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}



// MARK: EnterLocationVCDelegate

extension InformationPostingViewController: EnterLocationVCDelegate {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EnterLocationSegue" {
            let childViewController = segue.destinationViewController as! EnterLocationVC
            childViewController.enterLocationDelegate = self
        } else if segue.identifier == "PostLocationSegue" {
            self.postLocationVC = segue.destinationViewController as? PostLocationVC
        }
        
    }
    
    
    func enterLocationVCDidReturnMapItem(mapItem: MKMapItem) {
        
        /* make the PostLocation Container visible */
        EnterLocationContainer.hidden = true
        PostLocationContainer.hidden = false
        
        /* update user info with the new mapString and location as returned by MKLocalSearch */
        /* this will get over-written by old data unless the user submits the change in EnterLocationVC */
        UserInformation.mapString = mapItem.name

        UserInformation.lat = mapItem.placemark.coordinate.latitude
        UserInformation.long = mapItem.placemark.coordinate.longitude
        
        /* add annotation to the mapView */
        self.postLocationVC?.addAnnotationToMapFromMapItem(mapItem)
        self.postLocationVC?.showLocationfromMapItem(mapItem)
        
    }

}
