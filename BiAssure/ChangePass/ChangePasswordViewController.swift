//
//  ChangePasswordViewController.swift
//  BiAssure
//
//  Created by Pulkit on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.

import UIKit
import KSToastView
import AFNetworking

class ChangePasswordViewController: UIViewController {
    
    
    
    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var txtOldpassword: UITextField!
    @IBOutlet weak var txtNewpassword: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var btnSave_didshow: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        btnSave_didshow.layer.cornerRadius = 10.0
        btnSave_didshow.clipsToBounds = true
        txtusername.layer.cornerRadius = 10.0
        txtusername.clipsToBounds = true
        txtOldpassword.layer.cornerRadius = 10.0
        txtOldpassword.clipsToBounds = true
        txtNewpassword.layer.cornerRadius = 10.0
        txtNewpassword.clipsToBounds = true
        gradientAdd(button: btnSave_didshow)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        style()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    
    
    
    func style()
    {
        let view : UIView = UIView.init(frame: CGRect.init(x: -10, y: 0, width: 150, height: 33))
        //        let imageView : UIImageView = UIImageView.init(frame: CGRect.init(x: -30, y: 0, width: 25, height: 25))
        //        imageView.image = UIImage.init(named: "dashboard-icon")
        
        let lblTitle : UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 30))
        
        lblTitle.text = "Change Password"
        lblTitle.textColor = UIColor.white
        // view.addSubview(imageView)
        view.addSubview(lblTitle)
        navBar.topItem?.titleView = view
        
        
    }
    
    
    
    
    
    
    
    @IBAction func slidemenuAction(_ sender:UIBarButtonItem)
    {
        kMainViewController.showRightView(animated: true, completionHandler: nil)
    }
    
    @IBAction func btnSave_didSelect(_ sender:UIButton)
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
            let parameters = ["user_name" :txtusername.text!,"user_password":txtOldpassword.text!,"new_password":txtNewpassword.text!]
            
            manager.post(NSString.init(format: "http://13.232.233.123/UserProfileAccess/api/change_password") as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
                
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
    
    
    
    
    func validateFields() -> Bool
    {
        if txtusername.text!.count > 1
        {
            if txtOldpassword.text!.count > 4
            {
                if txtNewpassword.text!.count > 4
                {
                    return true
                }
                else{
                    KSToastView.ks_showToast("Enter new password")
                }
            }
            else
            {
                KSToastView.ks_showToast("Enter old password")
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
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = button.layer.bounds
        gradient.cornerRadius = button.layer.cornerRadius
        button.layer.insertSublayer(gradient, at: 1)
        
    }
    
    
    
}
