//
//  NavigationViewController.swift
//  DominosApp
//
//  left menu view Created by Divya on 12/02/19 #task Id5861 
//  Copyright © 2020 Tech Four. All rights reserved.


import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override var shouldAutorotate : Bool {
        return true
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return sideMenuController!.isRightViewVisible ? .slide : .fade
    }
    
    

}
