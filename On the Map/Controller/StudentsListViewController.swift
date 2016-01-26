//
//  StudentsListViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 21/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit


class StudentsListViewController: OTMViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("--------!---------")
        print(ParseClient.sharedInstance().studentInformationArray)
        print("----------!-------")
    }
    
}
