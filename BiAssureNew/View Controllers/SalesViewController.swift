//
//  SalesViewController.swift
//  BiAssureNew
//
//  Created by pulkit Tandon on 02/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD
import KSToastView

class SalesViewController: UIViewController {

    
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var View3: UIView!
    @IBOutlet weak var View4: UIView!
    @IBOutlet weak var mainView1: UIView!
    @IBOutlet weak var extendDate: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var extendYear: UILabel!
    @IBOutlet weak var currentYear: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        View1.clipsToBounds = true
        View1.layer.cornerRadius = 8
        View2.clipsToBounds = true
        View2.layer.cornerRadius = 8
        View3.clipsToBounds = true
        View3.layer.cornerRadius = 8
        View4.clipsToBounds = true
        View4.layer.cornerRadius = 8
        mainView1.clipsToBounds = true
        mainView1.layer.cornerRadius = 5
        
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd"
        let result = formatter.string(from: date)
        extendDate.text = result
        
        
        var myDate = Date()
        myDate.changeDays(by: -1)
        let formatter1 = DateFormatter()
        
        formatter1.dateFormat = "dd"
        let results = formatter.string(from: myDate)
        currentDate.text = results
        
        let dates = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyy"
        let months = dateFormatter.string(from: dates)
        currentYear.text = months
        extendYear.text =  months
        
        
    }
    


    @IBAction func backbtntap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
extension Date {
    mutating func changeDays(by days: Int) {
        self = Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
