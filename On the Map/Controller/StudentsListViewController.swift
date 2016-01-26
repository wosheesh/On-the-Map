//
//  StudentsListViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 21/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit


class StudentsListViewController: OTMViewController {

    
    @IBOutlet weak var StudentTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("vvvvvvvvvvvvvvvvvvvvvvvvvvv data from: \(__FUNCTION__) in \(__FILE__)")
        print(ParseClient.sharedInstance().studentInformationArray)
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^ data from: \(__FUNCTION__) in \(__FILE__)")
        
        StudentTableView.reloadData()
    }
    
}

extension StudentsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get the cell type */
        let cellReuseIdentifier = "StudentsListViewCell"
        let student = ParseClient.sharedInstance().studentInformationArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        let firstName = student.studentLocation[ParseClient.JSONResponseKeys.FirstName] as! String
        let lastName = student.studentLocation[ParseClient.JSONResponseKeys.LastName] as! String
//        let mediaURL = student.studentLocation[ParseClient.JSONResponseKeys.MediaURL] as! String
        
        cell.textLabel!.text = "\(firstName) \(lastName)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentInformationArray.count

    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let selectedCell = ParseClient.sharedInstance().studentInformationArray[indexPath.row]
        
        /* if the corresponding studentLocation has mediaURL try open safari */
        if let toOpen = selectedCell.studentLocation[ParseClient.JSONResponseKeys.MediaURL] as? String {
            
            /* check if they left http(s) prefix - many students don't and safari fails to open */
            if toOpen.hasPrefix("http://") || toOpen.hasPrefix("https://") {
                app.openURL(NSURL(string: toOpen)!)
            } else {
                app.openURL(NSURL(fileURLWithPath: toOpen, relativeToURL: NSURL(string: "http://")))
            }
        }

    }
    
    
}