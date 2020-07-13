//
//  ViewController.swift
//  BiAssure
//
//  Created by Swetha on 30/07/19.
//  Copyright © 2019 Techfour. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /*MARK: -DECLARATION OF VARIABLES
     */
    var timer = Timer()
    var appDelegate :AppDelegate = AppDelegate()
    
    
    
    /*MARK: -IBOUTLETS
     */
    @IBOutlet weak var imageCircle: UIView!
    
    
    /*MARK: -INBUILT FUNCTIONS
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
    
    
    /*MARK: - FUNCTIONS
     */
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
