//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 26/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, EnterLocationVCDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var EnterLocationContainer: UIView!
    @IBOutlet weak var PostLocationContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EnterLocationSegue" {
            let childViewController = segue.destinationViewController as! EnterLocationVC
            childViewController.delegate = self
        }
    }
    
    @IBAction func cancelButtonTouchUp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changeViews() {
        EnterLocationContainer.hidden = true
        PostLocationContainer.hidden = false
    }
    
    // MARK: EnterLocationVCDelegate
    func enterLocationVCDidPressButton(childViewController: EnterLocationVC) {
        print("button clicked")
        self.changeViews()
    }
    
}
