//
//  StudentsMapViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 21/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class StudentsMapViewController: UIViewController {

    override func viewDidLoad() {
        
        let button1 = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "Logout")
        let button2 = UIBarButtonItem(title: "Pin", style: .Plain, target: self, action: "SetStudentLocation")
        let button3 = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: "RefreshStudentData")

        navigationItem.hidesBackButton = true

        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.setLeftBarButtonItem(button1, animated: true)
        navigationItem.setRightBarButtonItems([button2, button3], animated: true)

    }
    
}


