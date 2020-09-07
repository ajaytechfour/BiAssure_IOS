//
//  CustomPicker.swift
//  BiAssure
//
//  Created by Pulkit on 04/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit

let STRT_TITLE = "Start Date"
let END_TITLE = "End Date"

class CustomPicker: UIView {
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var datePickerView : UIDatePicker!
    @IBOutlet var btnDone : UIButton!
    var superView : UIView!
    var selectedStartDate : NSDate!
    var selectedEndDate : NSDate!
    var completionHandler: ((_ status: Date?, _ result: Date?) -> Void)?
    
    func addPicker(on sourceView: UIView?, handler completionHandler: @escaping (Date?, Date?) -> Void) {
        self.completionHandler = completionHandler
        superView = sourceView
        datePickerView.backgroundColor = UIColor.white
        reset()
        datePickerView.locale = NSLocale.current
        frame = CGRect(x: 0, y: (sourceView?.frame.size.height ?? 0.0) + 250, width: sourceView?.frame.size.width ?? 0.0, height: 250)
        datePickerView.addTarget(self, action: #selector(dateIsChanged(_:)), for: .valueChanged)
        
        sourceView?.addSubview(self)
    }
    
    @objc func dateIsChanged(_ sender:UIButton)
    {
        
    }
    
    func showPickerViewWithAnimation(sourceView : UIView)
    {
        UIView .animate(withDuration: 0.7) {
            self.frame = CGRect(x: 0, y: sourceView.frame.size.height-self.frame.size.height, width: sourceView.frame.size.width, height: self.frame.size.height)
            sourceView.layoutIfNeeded()
        }
    }
    func removePickerViewWithAnimaion(sourceView : UIView)
    {
        UIView .animate(withDuration: 0.7) {
            self.frame = CGRect(x: 0, y: sourceView.frame.size.height+self.frame.size.height, width: sourceView.frame.size.width, height: self.frame.size.height)
            sourceView.layoutIfNeeded()
        }
        sourceView .reloadInputViews()
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton)
    {
        self.removePickerViewWithAnimaion(sourceView: self.superView)
        if (Utilities.sharedUtilities.selectedIndex == 4)
        {
            selectedStartDate = nil
            selectedEndDate = nil
            self.completionHandler!(selectedStartDate as Date?,selectedEndDate as Date?)
        }
        self.reset()
    }
    
    @IBAction func btnDoneClicked(_ sender : UIButton)
    {
        if sender.titleLabel?.text == "Next"
        {
            self.isHidden = true
            self.btnDone.setTitle("Done", for: UIControl.State.normal)
            selectedStartDate = datePickerView.date as NSDate
            datePickerView.minimumDate = selectedStartDate as Date?
            self.lblTitle.text = "Select End Date"
            
            self.frame = CGRect(x: self.superView.frame.size.width, y: self.frame.origin.y, width: self.superView.frame.size.width, height: self.frame.size.height)
            self.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
                self .layoutIfNeeded()
            }
        }
        else if sender.titleLabel?.text == "Done"
        {
            selectedEndDate = datePickerView.date as NSDate
            self.removePickerViewWithAnimaion(sourceView: self.superView)
            self.reset()
            if self.completionHandler != nil{
                self.completionHandler!(selectedStartDate as Date?,selectedEndDate as Date?)
                
                let strdaterange = "\(Utilities.sharedUtilities.getCampiagnDate(date: selectedStartDate)) to \(Utilities.sharedUtilities.getCampiagnEndDate(date: selectedEndDate))"
                
                UserDefaults.standard.set(strdaterange, forKey: "GetDate")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func reset()
    {
        self.datePickerView.maximumDate = Date.init()
        let gregorian = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let currentDate = Date.init()
        let comps = NSDateComponents.init()
        comps.year = -2
        let minDate = gregorian .date(byAdding: comps as DateComponents, to: currentDate)
        self.datePickerView.minimumDate = minDate
        self.lblTitle.text = "Select Start Date"
        self.btnDone .setTitle("Next", for: .normal)
        
    }
    
    
    
}
