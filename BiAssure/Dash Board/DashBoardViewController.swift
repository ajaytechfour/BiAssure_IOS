//
//  DashBoardViewController.swift
//  BiAssure
//
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
    
    func showDashBoard()
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        let mainViewcontroller  = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewcontroller.rootViewController = navigationController
        mainViewcontroller .setupWithPresentationStyle(style:LGSideMenuPresentationStyle.slideAbove, type: 290)
        
        let window = UIApplication.shared.delegate?.window as? UIWindow
        
        window?.rootViewController = mainViewcontroller
        UIView .transition(with: (window)!, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
        
    }
    
    
    func showsClaimsDashboard()
    {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "ClaimsNavigationController") as! UINavigationController
        
        let mainViewcontroller  = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        
        mainViewcontroller.rootViewController = navigationController
        mainViewcontroller .setupWithPresentationStyle(style:LGSideMenuPresentationStyle.slideAbove, type: 290)
        
        let window = UIApplication.shared.delegate?.window as? UIWindow
        
        window?.rootViewController = mainViewcontroller
        UIView .transition(with: (window)!, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    
    @IBAction func btnSales_didSelect(_ sender:UIButton)
    {
        showDashBoard()
        
    }
    @IBAction func btnClaim_didSelect(_ sender:UIButton)
    {
        //showsClaimsDashboard()
        
    }
    
    func gradientAdd(button:UIButton) {
        
        gradient.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        // vertical gradient start
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
