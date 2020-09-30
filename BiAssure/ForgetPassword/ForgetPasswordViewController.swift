//
//  ForgetPasswordViewController.swift
//  BiAssure
//
//  Created by Swetha on 26/07/19.
//  Copyright © 2019 Techfour. All rights reserved.
//

import UIKit
import SVProgressHUD
import KSToastView
import AFNetworking

class ForgetPasswordViewController: UIViewController {

    /*MARK: -IBOUTLETS
     */
    @IBOutlet weak var txtEmailid: UITextField!
    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!

    var gradient: CAGradientLayer = CAGradientLayer()
    var appConstants : AppConstants = AppConstants()
    
    /*MARK: -INBUILT FUNCTION
     */
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
    /*MARK: -BUTTON ACTION
     */
    
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
            //            manager.requestSerializer .timeoutInterval = 500.0
            
            let appversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            let OStype = appConstants.OSType
            let OSversion = appConstants.osversion
            let devicename = appConstants.devicename
            let imeinumber = appConstants.imeinumber
            let OSversionName = appConstants.OSversionName
            let ipaddress = appConstants.getWiFiAddress()
            let networkType = appConstants.getNetworkType()
            
            
            
            let parameters = ["user_name" :txtusername.text!,"email":txtEmailid.text!,
            
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
            
            
            
            
            
            manager.post(NSString.init(format: "http://13.232.233.123/UserProfileAccess/api/forget_password") as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
                
                if let jsonResponse = responseObject as? [String: AnyObject] {
                    // here read response
                    print("json response \(jsonResponse.description)")
                    let info : NSDictionary = jsonResponse as NSDictionary
                    if info["Status"]as! String == "1"
                    {
                        
                        self.showalert(message: info["message"]as! String)
                        
                        
                        
                    }
                    
                    else if info["Status"]as! Int == 402
                {
                    
                    self.appConstants.showAppStoreAlert(title: "", message: info["message"] as! String, controller: self)


                }
                    //405
                else if info["Status"]as! Int == 405 || info["Status"]as! Int == 406  || info["Status"]as! Int == 403
                {
                    self.appConstants.showLogoutAlert(title: "", message: info["message"] as! String, controller: self)
                   
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
    @IBAction func btnLeft_didSelect(_ sender:UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    /*MARK: -TEXTFIELD VALIDATION
     */
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
    
    
    
    /*MARK: -ALERT VIEW-
     */
    
    func showalert(message:String) -> Void
    {
        let alert : UIAlertController = UIAlertController.init(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let yesButton : UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(yesButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    /*MARK: -GRADIENT
     */
    func gradientAdd(button:UIButton) {
        
        gradient.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        // vertical gradient start
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = button.layer.bounds
        gradient.cornerRadius = button.layer.cornerRadius
        button.layer.insertSublayer(gradient, at: 1)
        
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
