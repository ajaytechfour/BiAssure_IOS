//
//  ViewController.swift
//  BiAssure
//
//  Created by Pulkit on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    var timer = Timer()
    var appDelegate :AppDelegate = AppDelegate()
    
    
    
    
    @IBOutlet weak var imageCircle: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         hideKeyboardWhenTappedAround()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
   
    @objc func handleTimer(){
        let strUserName:NSString = appDelegate.getUserName() as NSString
        
        if (strUserName != "") && (strUserName.length != 0) {
            showDashBoard()
        }
        else{
             let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let loginview = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginview, animated: true)
        }
        
    }
 
    func showDashBoard(){
         let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DashBoardViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
        self.navigationController?.pushViewController(DashBoardViewController, animated: true)
    }

}
