//
//  MainViewController.swift
//  DominosApp
//
//  left menu view Created by Divya on 12/02/19 #task Id5861 
//  Copyright © 2020 Tech Four. All rights reserved.

import UIKit
import LGSideMenuController

class MainViewController: LGSideMenuController{

    
    func setupWithPresentationStyle(style:LGSideMenuPresentationStyle, type:Int) -> Void
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as? RightViewController
        
        self.rightViewWidth = CGFloat(type)
        self.rightViewPresentationStyle = style
        self.rightViewStatusBarStyle = UIStatusBarStyle.default
        self.rightViewAlwaysVisibleOptions = LGSideMenuAlwaysVisibleOptions(rawValue: 0)
        self.rightViewController?.view.backgroundColor=UIColor.clear
        self.rightViewController?.view.tintColor=UIColor .black
        self.rightViewBackgroundView?.backgroundColor = UIColor (white: 1, alpha: 0.9)
        
    }
    
        override func rightViewWillLayoutSubviews(with size: CGSize)
    {
        super.rightViewWillLayoutSubviews(with: size)
    }
    
    override func leftViewWillLayoutSubviews(with size: CGSize)
    {
        super.leftViewWillLayoutSubviews(with: size)
    }

}
