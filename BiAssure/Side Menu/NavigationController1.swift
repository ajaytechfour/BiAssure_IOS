//
//  NavigationController1.swift
//  BiAssure
//
//  Created by pulkit Tandon on 22/09/20.
//  Copyright © 2020 Techfour. All rights reserved.
//

import UIKit

class NavigationController1: UINavigationController {

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
