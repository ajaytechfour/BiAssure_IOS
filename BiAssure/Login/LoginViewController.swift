//
//  LoginViewController.swift
//  BiAssure
//
//  Created by Pulkit on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import KSToastView
import AFNetworking
import SVProgressHUD

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    var appDelegate:AppDelegate = AppDelegate()
    var gradient: CAGradientLayer = CAGradientLayer()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Login View"
        txtPassword.delegate = self
        txtUsername.delegate = self
        btnLogin.layer.cornerRadius = 10.0
        btnLogin.clipsToBounds = true
        txtPassword.layer.cornerRadius = 10.0
        txtPassword.clipsToBounds = true
        txtUsername.layer.cornerRadius = 10.0
        txtUsername.clipsToBounds = true
        txtUsername.tintColor = UIColor.blue
        btnForgetPassword.isHidden = false
        gradientAdd(gradientView:btnLogin)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = btnLogin.layer.bounds
        gradient.cornerRadius = btnLogin.layer.cornerRadius
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func showDashBoard()
    {
        self.performSegue(withIdentifier: "dashboardsegue", sender: self)
    }
    
    
    func validateFields() -> Bool
    {
        if txtUsername.text!.count > 1
        {
            if txtPassword.text!.count >= 4
            {
                return true
            }
            else{
                KSToastView.ks_showToast("Enter valid password")
            }
        }
        else
        {
            KSToastView.ks_showToast("Enter user name")
        }
        return false
    }
    
    
    
    @IBAction func btnSingup_didSelect(_ sender:UIButton)
    {
        self.performSegue(withIdentifier: "Signupsegue", sender: self)
    }
    
    @IBAction func btnForgetPassword_didSelect(_ sender:UIButton)
    {
        self.performSegue(withIdentifier: "forgetpasswordsegue", sender: self)
    }
    
    
    @IBAction func btnLogin_didSelect(_ sender:UIButton)
    {
        if self.validateFields(){
            let timeStamp = NSDate().timeIntervalSince1970
            
            
            let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
            
            
            let serializerRequest = AFHTTPRequestSerializer()
            serializerRequest.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            serializerRequest.setValue("iOS", forHTTPHeaderField: "os")
            
            manager.requestSerializer = serializerRequest
            manager.requestSerializer.timeoutInterval = 90.0
            
            let token:NSString = Utilities.sharedUtilities.convertToken(timestamp: NSInteger(timeStamp), username: txtUsername.text!) as NSString
            
            serializerRequest.setValue(token as String, forHTTPHeaderField: "token")
            serializerRequest.setValue("%ld", forHTTPHeaderField: "timestamp")
            
            let serializerResponse = AFJSONResponseSerializer()
            
            manager.responseSerializer = serializerResponse
            
            let parameters = ["username" :txtUsername.text!,"password":txtPassword.text!]
            
            SVProgressHUD.show()
            
            let baseUrl = "http://bi.servassure.net/api/"
            manager.post(NSString.init(format: "\(baseUrl)login" as NSString, 0) as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
                if let jsonResponse = responseObject as? [String: AnyObject] {
                    
                    print("json response \(jsonResponse.description)")
                    let info : NSDictionary = jsonResponse as NSDictionary
                    if info["success"]as! Int == 1
                    {
                        
                        self.appDelegate.storeSessionId(session_id: info["token"]as! String)
                        
                        self.appDelegate.storeUserName(user_name: self.txtUsername.text!)
                        
                        self.showDashBoard()
                    }
                        
                    else
                    {
                        KSToastView.ks_showToast(info["message"]as! String)
                    }
                    
                }
                
            })
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                SVProgressHUD.dismiss()
                KSToastView.ks_showToast(error.localizedDescription)
            }
            
        }
    }
    
    
    func gradientAdd(gradientView:UIButton) {
        gradient.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5) // vertical gradient start
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = gradientView.layer.bounds
        gradient.cornerRadius = gradientView.layer.cornerRadius
        gradientView.layer.insertSublayer(gradient, at: 1)
    }
    
}
