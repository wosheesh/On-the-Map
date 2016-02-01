//
//  UrlTextField.swift
//  On the Map
//
//  Created by Wojtek Materka on 01/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class UrlTextField: UITextField {
    
    let textFieldFontSize : CGFloat = 20.0
    let urlTextFieldCornerRadius : CGFloat = 0
    let phoneTextFieldExtraPadding : CGFloat = 34.0
    let urlTextFieldWidthBounds : CGFloat = 14
    let urlTextFieldHeightBounds : CGFloat = 18
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.themeEnterLocationTextField()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.themeEnterLocationTextField()
    }
    
    func themeEnterLocationTextField() {
        self.backgroundColor = OTMColors.urlTextFieldBgColor
        self.font = UIFont(name: "Roboto-Medium", size: textFieldFontSize)
        self.textColor = OTMColors.urlTextFieldTextColor
        self.layer.cornerRadius = urlTextFieldCornerRadius
        self.borderStyle = .None
        
    }
    
    /* Increasing the padding for text */
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(
            bounds.origin.x,
            bounds.origin.y + urlTextFieldHeightBounds / 2,
            bounds.size.width - urlTextFieldWidthBounds,
            bounds.size.height - urlTextFieldHeightBounds
        )
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.textRectForBounds(bounds)
    }

}
