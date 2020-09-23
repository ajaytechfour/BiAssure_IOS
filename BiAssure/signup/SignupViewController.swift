//
//  SignupViewController.swift
//  BiAssure
//
//  Created by Pulkit on 02/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import KSToastView

class SignupViewController: UIViewController {
    
    @IBOutlet weak var txtEmailid: UITextField!
    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var gradientbutton: CAGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        gradientAddbutton(button: btnSubmit)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientbutton.frame = btnSubmit.layer.bounds
        gradientbutton.cornerRadius = btnSubmit.layer.cornerRadius
        
    }
    
    @IBAction func btnLeft_didSelect(_ sender:UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit_didSelect(_ sender: UIButton)
    {
        if self.validateFields()
        {
            self.showalert(message: "Your request has been received and would be approved in due course by Assurant Team.You will receive further update on your email id.Thank you")
        }
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
            KSToastView.ks_showToast("Enter valid user name")
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
    
    func gradientAddbutton(button:UIButton) {
        
        gradientbutton.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradientbutton.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientbutton.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientbutton.frame = button.layer.bounds
        gradientbutton.cornerRadius = button.layer.cornerRadius
        button.layer.insertSublayer(gradientbutton, at: 1)
    }
    
    
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
