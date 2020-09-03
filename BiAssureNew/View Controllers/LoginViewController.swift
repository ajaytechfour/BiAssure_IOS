//
//  LoginViewController.swift
//  BiAssureNew
//
//  Created by pulkit Tandon on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD
import SCLAlertView
import KSToastView


class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forGetBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var gradient: CAGradientLayer = CAGradientLayer()
    var userName = ""
    var password = ""
    var appDelegate:AppDelegate = AppDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientAdd(gradientView:loginBtn)
        userNameTextField.layer.cornerRadius = 10
        userNameTextField.clipsToBounds =  true
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.clipsToBounds =  true
        loginBtn.layer.cornerRadius = 10
        loginBtn.clipsToBounds =  true
        
        userNameTextField.setLeftPaddingPoints(10)
        passwordTextField.setLeftPaddingPoints(10)
        hideKeyboardWhenTappedAround()
        
    }
    
    
    
    
    //Mark Action
    
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
        
        if  self.validteField(){
            
            loginApi()
            
        }
        
        
        
        
    }
    
    
    func validteField() -> Bool {
        if userNameTextField.text!.count > 1
        {
            if passwordTextField.text!.count >= 4
            {
            return true
            }
        else{
         SCLAlertView().showEdit("Enter valid password", subTitle: "")
            }
        }
        else
        {
            SCLAlertView().showEdit("Enter user name", subTitle: "")
        }
        return false
        
    }
    
    
    
    
    @IBAction func forgetBtnTapped(_ sender: UIButton) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgetPasswordViewController") as? ForgetPasswordViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    
    
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    func gradientAdd(gradientView:UIButton) {
        gradient.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient.frame = gradientView.layer.bounds
        gradient.cornerRadius = gradientView.layer.cornerRadius
        gradientView.layer.insertSublayer(gradient, at: 1)
    }
    
    
    
    func loginApi()
    {
        let timeStamp = NSDate().timeIntervalSince1970
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        
        
        let serializerRequest = AFHTTPRequestSerializer()
        serializerRequest.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        serializerRequest.setValue("iOS", forHTTPHeaderField: "os")
        
        serializerRequest.setValue("%ld", forHTTPHeaderField: "timestamp")
        manager.requestSerializer = serializerRequest
        manager.requestSerializer.timeoutInterval = 90.0
        
        let token:NSString = Utilities.sharedUtilities.convertToken(timestamp: NSInteger(timeStamp), username: userNameTextField.text!) as NSString
        serializerRequest.setValue(token as String, forHTTPHeaderField: "token")
        
        
        let serializerResponse = AFJSONResponseSerializer()
        
        manager.responseSerializer = serializerResponse
        
        
        let dictdata = ["username": userNameTextField.text!,
                        "password" : passwordTextField.text!,
            ]
            as [String : Any]
        //SVProgressHUD.show()
        
        var strurl = "http://bi.servassure.net/api/login"
        
        strurl = (strurl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed))!
        print(strurl)
        
        
        manager.post(NSString.init(format: "\(strurl)" as NSString, 0) as String, parameters: dictdata, headers: ["Content-Type" : "application/x-www-form-urlencoded; charset=UTF-8"], progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            
            if let jsonResponse = responseObject{
                print("json response \(jsonResponse)")
                
                let info : NSDictionary = jsonResponse as! NSDictionary
                
                if info["success"]as? Int == 1
                {
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashBoardViewController") as? DashBoardViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                }
                else if info["success"]as? Int == 0
                {
                    print("\(info)")
                    SCLAlertView().showEdit(info["message"]as! String, subTitle: "")
                    
                    
                    
                }
                
            }
            
            
        })
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
           // SVProgressHUD.dismiss()
            
        }
    }
 
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
}

