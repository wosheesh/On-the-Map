//
//  EnterLocationVC.swift
//  On the Map
//
//  Created by Wojtek Materka on 27/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

protocol EnterLocationVCDelegate {
    func enterLocationVCDidPressButton(childViewController: EnterLocationVC)
}

class EnterLocationVC: UIViewController {
    
    var delegate: EnterLocationVCDelegate?
    
    @IBOutlet weak var FindOnMapButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
    }
    
    @IBAction func FindOnMapButtonTouchUp(sender: AnyObject) {
        print(__FUNCTION__)
        self.delegate?.enterLocationVCDidPressButton(self)
    }
}