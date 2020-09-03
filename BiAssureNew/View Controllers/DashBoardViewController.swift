//
//  DashBoardViewController.swift
//  BiAssureNew
//
//  Created by pulkit Tandon on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController {
    
    @IBOutlet weak var SaledBtn: UIButton!
    
    
    @IBOutlet weak var claimBtn: UIButton!
    
    var gradient: CAGradientLayer = CAGradientLayer()
    var gradient1: CAGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SaledBtn.layer.cornerRadius = 10
        SaledBtn.clipsToBounds = true
        claimBtn.layer.cornerRadius = 10
        claimBtn.clipsToBounds = true
        
        gradientAdd(gradientView:SaledBtn)
        gradientAdd1(gradientView:claimBtn)
    }
    
    
    
    
    @IBAction func salesBtnTappe(_ sender: UIButton) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OEMWiseViewController") as? OEMWiseViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    
    @IBAction func claimBtnTapped(_ sender: UIButton) {
    }
    
    func gradientAdd(gradientView:UIButton) {
        gradient.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient.frame = gradientView.layer.bounds
        gradient.cornerRadius = gradientView.layer.cornerRadius
        gradientView.layer.insertSublayer(gradient, at: 1)
    }
    func gradientAdd1(gradientView:UIButton) {
        gradient1.colors = [UIColor(red: 237.0/255.0, green: 86.0/255.0, blue: 38.0/255.0, alpha: 1.0).cgColor,UIColor(red: 233.0/255.0, green: 22.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor]
        gradient1.frame = gradientView.layer.bounds
        gradient1.cornerRadius = gradientView.layer.cornerRadius
        gradientView.layer.insertSublayer(gradient1, at: 1)
    }
    
    
}
