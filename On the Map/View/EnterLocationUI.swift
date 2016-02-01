//
//  EnterLocationUI.swift
//  On the Map
//
//  Created by Wojtek Materka on 01/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

extension EnterLocationVC {
    
    func setupUI() {
        
        /* transparent toolbar */
        topToolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        topToolbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.Any)
        
        /* top toolbar item text color */
        cancelButton.tintColor = OTMColors.topToolbarItemColor
        
        /* backround */
        self.view.backgroundColor = OTMColors.viewBgColor
        
    }
    
}
