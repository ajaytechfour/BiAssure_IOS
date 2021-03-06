//
//  SignupViewController.swift
//  BiAssure
//
//  Created by Divya on 10/09/19.
//  Copyright © 2019 Techfour. All rights reserved.
//

import UIKit
import KSToastView

class SignupViewController: UIViewController {

    @IBOutlet weak var txtEmailid: UITextField!
    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
     var gradient: CAGradientLayer = CAGradientLayer()
    
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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = btnSubmit.layer.bounds
        gradient.cornerRadius = btnSubmit.layer.cornerRadius
        
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
