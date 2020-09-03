//
//  SignUpViewController.swift
//  BiAssureNew
//
//  Created by pulkit Tandon on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import SCLAlertView



class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var userNameTxtField: UITextField!
    
    @IBOutlet weak var emailTextFiled: UITextField!
    
    
    
    @IBOutlet weak var submitBtn: UIButton!
    
    
    var gradient4: CAGradientLayer = CAGradientLayer()
    
    var userName = ""
    var email = ""
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gradientAdd(gradientView:submitBtn)
        userNameTxtField.layer.cornerRadius = 10
        userNameTxtField.clipsToBounds =  true
        emailTextFiled.layer.cornerRadius = 10
        emailTextFiled.clipsToBounds =  true
        submitBtn.layer.cornerRadius = 10
        submitBtn.clipsToBounds =  true
        
        userNameTxtField.setLeftPaddingPoints(10)
        emailTextFiled.setLeftPaddingPoints(10)
        self.hideKeyboardWhenTappedAround()
        
        
        
    }
    func gradientAdd(gradientView:UIButton) {
        gradient4.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient4.frame = gradientView.layer.bounds
        gradient4.cornerRadius = gradientView.layer.cornerRadius
        gradientView.layer.insertSublayer(gradient4, at: 1)
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        if validteField()
        {
            let alert = UIAlertController(title: "", message: "Your request has been received and would be approved in due course by Assurant Team.You will receive further update on your email id.Thank you", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    func validteField() -> Bool  {
        userName =  userNameTxtField.text!
        email =  emailTextFiled.text!
        if userName.count == 0
        {
            let alert = UIAlertController(title: "", message: "Enter the user name.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if email.count == 0 {
            let alert = UIAlertController(title: "", message: "Enter the  emailid.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return true
        
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
