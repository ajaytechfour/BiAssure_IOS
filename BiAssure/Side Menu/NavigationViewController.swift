//
//  NavigationViewController.swift
//  left menu view Created by Pulkit on 04/09/20.
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
