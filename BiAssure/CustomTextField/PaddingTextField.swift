//
//  PaddingTextField.swift
//  BiAssure
//
//  Created by Swetha on 26/07/19.
//  Copyright © 2019 Techfour. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField {


    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: padding)

    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: padding)

    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: padding)

    }
    
    
}
