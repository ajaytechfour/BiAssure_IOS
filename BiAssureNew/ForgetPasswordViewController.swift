//
//  ForgetPasswordViewController.swift
//  BiAssureNew
//
//  Created by pulkit Tandon on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD
import SCLAlertView


class ForgetPasswordViewController: UIViewController {
    
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    @IBOutlet weak var emailIdTextField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var gradient3: CAGradientLayer = CAGradientLayer()
    
    var userName = ""
    var email = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientAdd(gradientView:submitBtn)
        userNameTextField.layer.cornerRadius = 10
        userNameTextField.clipsToBounds =  true
        emailIdTextField.layer.cornerRadius = 10
        emailIdTextField.clipsToBounds =  true
        submitBtn.layer.cornerRadius = 10
        submitBtn.clipsToBounds =  true
        
        userNameTextField.setLeftPaddingPoints(10)
        emailIdTextField.setLeftPaddingPoints(10)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        if validteField()
        {
            forgetpassApi()
            
            
        }
    }
    
    func validteField () -> Bool  {
        userName =  userNameTextField.text!
        email =  emailIdTextField.text!
        if userName.count == 0
        {
            SCLAlertView().showEdit("", subTitle: "Enter the user name.")
            
            
        }
            
        else if email.count == 0 {
            SCLAlertView().showEdit("", subTitle: "Enter the  emailid.")
        }
        
        return true
    }
    
    
    
    
    
    
    func gradientAdd(gradientView:UIButton) {
        gradient3.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient3.frame = gradientView.layer.bounds
        gradient3.cornerRadius = gradientView.layer.cornerRadius
        gradientView.layer.insertSublayer(gradient3, at: 1)
    }
    
    
    
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func forgetpassApi()
    {
        let timeStamp = NSDate().timeIntervalSince1970
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        
        
        let serializerRequest = AFHTTPRequestSerializer()
        serializerRequest.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        serializerRequest.setValue("iOS", forHTTPHeaderField: "os")
        
        serializerRequest.setValue("%ld", forHTTPHeaderField: "timestamp")
        manager.requestSerializer = serializerRequest
        manager.requestSerializer.timeoutInterval = 90.0
        
        let token:NSString = Utilities.sharedUtilities.convertToken(timestamp: NSInteger(timeStamp), username: userName) as NSString
        serializerRequest.setValue(token as String, forHTTPHeaderField: "token")
        
        
        let serializerResponse = AFJSONResponseSerializer()
        
        manager.responseSerializer = serializerResponse
        
        
        let dictdata = ["user_name": userName,
                        "email" : email,
            ]
            as [String : Any]
       
        var strurl = "http://13.232.233.123/UserProfileAccess/api/forget_password"
        
        strurl = (strurl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed))!
        print(strurl)
        
        
        manager.post(NSString.init(format: "\(strurl)" as NSString, 0) as String, parameters: dictdata, headers: ["Content-Type" : "application/x-www-form-urlencoded; charset=UTF-8"], progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            
            if let jsonResponse = responseObject{
                print("json response \(jsonResponse)")
                
                let info : NSDictionary = jsonResponse as! NSDictionary
                
                if info["Status"]as! String == "1"
                {
                    
                    
                    
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                }
                else if info["success"]as? Int == 0
                {
                    print("\(info)")
                }
                
            }
            
            
        })
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
        }
    }
    
    
    
}
