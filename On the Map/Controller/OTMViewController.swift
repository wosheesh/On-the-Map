//
//  OTMViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 24/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class OTMViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure the navbar */
        
        // TODO: see if this can be abstracted
        let button1 = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "Logout")
        let button2 = UIBarButtonItem(title: "Pin", style: .Plain, target: self, action: "SetStudentLocation")
        let button3 = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: "RefreshStudentData")
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.setLeftBarButtonItem(button1, animated: true)
        self.navigationItem.setRightBarButtonItems([button3, button2], animated: true)
    }
}