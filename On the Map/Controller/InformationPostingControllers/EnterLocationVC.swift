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
    func enterLocationVCDidPressButton(childViewController: EnterLocationVC)
}

class EnterLocationVC: UIViewController {
    
    var delegate: EnterLocationVCDelegate?
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var FindOnMapButton: UIButton!
    
    @IBAction func FindOnMapButtonTouchUp(sender: AnyObject) {
        // TODO: Change button state if textfield is not empty [http://stackoverflow.com/questions/28394933/how-do-i-check-when-a-uitextfield-changes]
        
//        print(__FUNCTION__)
//        self.delegate?.enterLocationVCDidPressButton(self)
        
        /* setup the location search request */
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationTextField.text
        
        /* make the location search request */
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, error in
            guard let response = response else {
                print("There was an error: \(error) while searching for: \(request.naturalLanguageQuery)")
                return
            }
            
            for item in response.mapItems {
                print(item)
            }
        }
        
    }
}