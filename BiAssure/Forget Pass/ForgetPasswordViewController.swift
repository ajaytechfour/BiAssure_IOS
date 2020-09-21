//
//  ForgetPasswordViewController.swift
//  BiAssure
//
//  Created by Pulkit on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import KSToastView
import AFNetworking

class ForgetPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var txtEmailid: UITextField!
    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var gradient: CAGradientLayer = CAGradientLayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        hideKeyboardWhenTappedAround()
        btnSubmit.layer.cornerRadius = 10.0
        btnSubmit.clipsToBounds = true
        txtusername.layer.cornerRadius = 10.0
        txtusername.clipsToBounds = true
        txtEmailid.layer.cornerRadius = 10.0
        txtEmailid.clipsToBounds = true
        
        let backButton :UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "left-top-arrow"), style: UIBarButtonItem.Style.plain, target: self, action:#selector(btnLeft_didSelect))
        backButton.tintColor = UIColor.black
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        self.navigationController?.navigationBar.isTranslucent = true
        gradientAdd(button: btnSubmit)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = btnSubmit.layer.bounds
        gradient.cornerRadius = btnSubmit.layer.cornerRadius
        
    }
    
    
    
    
    @IBAction func btnSubmit_didSelect(_ sender:UIBarButtonItem)
    {
        if self.validateFields(){
            let timeStamp = NSDate().timeIntervalSince1970
            
            
            let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
            
            
            let serializerRequest = AFHTTPRequestSerializer()
            serializerRequest.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            serializerRequest.setValue("iOS", forHTTPHeaderField: "os")
            
            manager.requestSerializer = serializerRequest
            manager.requestSerializer.timeoutInterval = 90.0
            
            let token:NSString = Utilities.sharedUtilities.convertToken(timestamp: NSInteger(timeStamp), username: txtusername.text!) as NSString
            
            serializerRequest.setValue(token as String, forHTTPHeaderField: "token")
            serializerRequest.setValue("%ld", forHTTPHeaderField: "timestamp")
            
            let serializerResponse = AFJSONResponseSerializer()
            
            manager.responseSerializer = serializerResponse
            let parameters = ["user_name" :txtusername.text!,"email":txtEmailid.text!]
            
            
            let baseurl = "http://13.232.233.123/UserProfileAccess/api/forget_password"
            manager.post(NSString.init(format: baseurl as NSString ) as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
                
                if let jsonResponse = responseObject as? [String: AnyObject] {
                    
                    print("json response \(jsonResponse.description)")
                    let info : NSDictionary = jsonResponse as NSDictionary
                    if info["Status"]as! String == "1"
                    {
                        
                        self.showalert(message: info["message"]as! String)
                        
                        
                        
                    }
                        
                    else
                    {
                        
                        KSToastView.ks_showToast(info["message"]as! String)
                    }
                    
                }
                
            })
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                KSToastView.ks_showToast(error.localizedDescription)
            }
            
        }
    }
    @IBAction func btnLeft_didSelect(_ sender:UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func validateFields() -> Bool
    {
        if txtusername.text!.count > 1
        {
            if txtEmailid.text!.count > 1
            {
                
                return true
                
            }
            else
            {
                KSToastView.ks_showToast("Enter valid email")
            }
        }
        else{
            KSToastView.ks_showToast("Enter valid username")
        }
        return false
    }
    
    func showalert(message:String) -> Void
    {
        let alert : UIAlertController = UIAlertController.init(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let yesButton : UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(yesButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    func gradientAdd(button:UIButton) {
        
        gradient.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = button.layer.bounds
        gradient.cornerRadius = button.layer.cornerRadius
        button.layer.insertSublayer(gradient, at: 1)
        
    }
    
    
    
}
