//
//  PaddingTextField.swift
//  BiAssure
//
//  Created by Pulkit on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.

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
