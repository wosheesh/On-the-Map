//
//  AlertRenderer.swift
//  On the Map
//
//  Created by Wojtek Materka on 28/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

protocol AlertRenderer {
    func presentAlert(title: String, message: String)
}

// TODO: extend protocol with more customisable alerts completions and buttons

extension AlertRenderer where Self: UIViewController {
    func presentAlert(title: String, message: String) {
        print("AlertRenderer protocol executed by \(self)")

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        let OKAction = UIAlertAction(title: "OK", style: .Default) { action in
            print("OK pressed on Alert Controller")
        }

        alertController.addAction(OKAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
