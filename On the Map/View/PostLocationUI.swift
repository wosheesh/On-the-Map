//
//  PostLocationUI.swift
//  On the Map
//
//  Created by Wojtek Materka on 01/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

extension PostLocationVC {
    
    func setupUI() {
        
        /* transparent toolbar */
        topToolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        topToolbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.Any)
        
        /* top toolbar item text color */
        cancelButton.tintColor = OTMColors.PostLocationTopToolbarItemColor
        
        /* backround */
        self.view.backgroundColor = OTMColors.PostLocationViewBgColor
        
        /* for better UX in case url already exists display a query above url textfield*/
        updateQuery.textColor = OTMColors.updateQueryTint
        
        if urlTextField.text != "" {
            updateQuery.hidden = true
        } else {
            updateQuery.hidden = false
        }
        
    }
}
