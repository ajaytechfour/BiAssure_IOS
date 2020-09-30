//
//  LoginViewController.swift
//  BiAssure
//
//  Created by Swetha on 25/07/19.
//  Copyright © 2019 Techfour. All rights reserved.
//

import UIKit
import KSToastView
import AFNetworking
import SVProgressHUD
import FirebaseCrashlytics


class LoginViewController: UIViewController,UITextFieldDelegate {

  
    
    /*MARK: -IBOUTLETS
     */
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    var appDelegate:AppDelegate = AppDelegate()
    var gradient: CAGradientLayer = CAGradientLayer()
    var appConstants : AppConstants = AppConstants()
    
    /*MARK: -INBUILT FUNCTIONS
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
    
    
    
    
    /*MARK: -TEXTFIELD DELEGATES
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
  
    
    
    /*MARK: -FUNCTIONS
     */
    func showDashBoard()
    {
        self.performSegue(withIdentifier: "dashboardsegue", sender: self)
    }
    
    
    
    /*MARK: -TEXTFIELD VALIDATION
     */
    
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
    
    
    
    
    /*MARK: -BUTTON ACTION
     */
    
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
            
            
            let appversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            let OStype = appConstants.OSType
            let OSversion = appConstants.osversion
            let devicename = appConstants.devicename
            let imeinumber = appConstants.imeinumber
            let OSversionName = appConstants.OSversionName
            let ipaddress = appConstants.getWiFiAddress()
            let networkType = appConstants.getNetworkType()
            
            
            
            
            
            
            
            
            

            let parameters = ["username" :txtUsername.text!,"password":txtPassword.text!,
                              "device_info":[
                                  "app_version" :appversion,
                                  "device_id" : imeinumber,
                                  "device_name" : devicename,
                                  "ip_address" : ipaddress!,
                                  "os_version_name" : OSversionName,
                                  "os_type" : OStype,
                                  "network_type" : networkType,
                                  "os_version_code" : OSversion,
                                  "channel" : "M",
                                  "language" : "EN",
                                  "screen_name" : "LoginScreen"]
            
            
            ] as [String : Any]

            SVProgressHUD.show()

            manager.post(NSString.init(format: "\(Base_Url)login" as NSString, 0) as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
                SVProgressHUD.dismiss()
                if let jsonResponse = responseObject as? [String: AnyObject] {
                    // here read response
                    print("json response \(jsonResponse.description)")
                    let info : NSDictionary = jsonResponse as NSDictionary
                    if info["success"]as! Int == 1
                    {

                        self.appDelegate.storeSessionId(session_id: info["token"]as! String)

                        self.appDelegate.storeUserName(user_name: self.txtUsername.text!)

                        self.showDashBoard()
                    }
                    
                   else if info["responseCode"]as! Int == 402
               {
                   
                   self.appConstants.showAppStoreAlert(title: "", message: info["responseMessage"] as! String, controller: self)


               }
                   //405
               else if info["responseCode"]as! Int == 405 || info["responseCode"]as! Int == 406  || info["responseCode"]as! Int == 403
               {
                   self.appConstants.showLogoutAlert(title: "", message: info["responseMessage"] as! String, controller: self)
                  
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
    
    
    
    
    //GRADIENT
    
    func gradientAdd(gradientView:UIButton) {
        gradient.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5) // vertical gradient start
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = gradientView.layer.bounds
      gradient.cornerRadius = gradientView.layer.cornerRadius
        gradientView.layer.insertSublayer(gradient, at: 1)
    }
   
}
