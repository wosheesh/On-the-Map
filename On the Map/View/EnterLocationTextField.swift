//
//  EnterLocationTextField.swift
//  On the Map
//
//  Created by Wojtek Materka on 01/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class EnterLocationTextField: UITextField {
    
    let textFieldFontSize : CGFloat = 20.0
    let EnterLocationTextFieldCornerRadius : CGFloat = 0
    let phoneTextFieldExtraPadding : CGFloat = 34.0
    let EnterLocationTextFieldWidthBounds : CGFloat = 14
    let EnterLocationTextFieldHeightBounds : CGFloat = 18
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.themeEnterLocationTextField()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.themeEnterLocationTextField()
    }
    
    func themeEnterLocationTextField() {
        self.backgroundColor = OTMColors.enterLocationTextFieldBgColor
        self.font = UIFont(name: "Roboto-Medium", size: textFieldFontSize)
        self.textColor = OTMColors.enterLocationTextFieldTextColor
        self.layer.cornerRadius = EnterLocationTextFieldCornerRadius
        self.borderStyle = .None
        
    }
    
    /* Increasing the padding for text */
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(
            bounds.origin.x,
            bounds.origin.y + EnterLocationTextFieldHeightBounds / 2,
            bounds.size.width - EnterLocationTextFieldWidthBounds,
            bounds.size.height - EnterLocationTextFieldHeightBounds
        )
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.textRectForBounds(bounds)
    }
}
