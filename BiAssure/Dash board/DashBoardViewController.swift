//
//  DashBoardViewController.swift
//  BiAssure
//  Created by Pulkit on 02/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.

import UIKit
import LGSideMenuController

class DashBoardViewController: UIViewController {
    
    @IBOutlet weak var btnClaims: UIButton!
    @IBOutlet weak var btnSales: UIButton!
    
    
    var gradient: CAGradientLayer = CAGradientLayer()
    var gradient1: CAGradientLayer = CAGradientLayer()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        gradientAddSales(button: btnSales)
        gradientAdd(button: btnClaims)
        btnSales.layer.cornerRadius = 10.0
        btnSales.clipsToBounds = true
        btnClaims.layer.cornerRadius = 10.0
        btnClaims.clipsToBounds = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = btnClaims.layer.bounds
        gradient.cornerRadius = btnClaims.layer.cornerRadius
        gradient1.frame = btnSales.layer.bounds
        gradient1.cornerRadius = btnSales.layer.cornerRadius
    }
    
    
    //Mark Action
    @IBAction func btnSales_didSelect(_ sender:UIButton)
    {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)

                           let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController

                           self.view.window?.rootViewController = sw
                           
                          let navigationControllers = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        
        
                           let destinationController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController

                             destinationController.rootViewController =  navigationControllers
                          sw.pushFrontViewController(navigationControllers, animated: true)
        
    }
    @IBAction func btnClaim_didSelect(_ sender:UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

                           let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController

                           self.view.window?.rootViewController = sw
                           
                          let navigationControllers = storyboard.instantiateViewController(withIdentifier: "NavigationController1") as! UINavigationController
        
        
                           let destinationController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController

                             destinationController.rootViewController =  navigationControllers
                          sw.pushFrontViewController(navigationControllers, animated: true)
        
    }
    //Mark Gradient
    func gradientAdd(button:UIButton) {
        
        gradient.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = button.layer.bounds
        gradient.cornerRadius = button.layer.cornerRadius
        button.layer.insertSublayer(gradient, at: 1)
        
    }
    
    func gradientAddSales(button:UIButton) {
        
        gradient1.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = button.layer.bounds
        gradient1.cornerRadius = button.layer.cornerRadius
        button.layer.insertSublayer(gradient1, at: 1)
        
    }
    
}
