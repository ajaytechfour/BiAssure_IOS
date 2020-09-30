//
//  ClaimsSalesViewController.swift
//  BiAssure
//
//  Created by Pulkit on 22/09/20.
//  Copyright © 2020 Techfour. All rights reserved.

import UIKit
import SSMaterialCalendarPicker
import SVProgressHUD
import KSToastView
import RMPickerViewController
import AFNetworking

class ClaimsSalesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,SSMaterialCalendarPickerDelegate {
    //Mark Variable
    var datePicker = SSMaterialCalendarPicker()
    var ClaimsType = ""
    var regName = ""
    var strsetdate = ""
    var pickerselectedInd = 0
    var _startDate = NSDate()
    var _endDate = NSDate()
    var List = NSMutableArray()
    var List1 = NSMutableArray()
    var claimapprstatus = NSMutableArray()
    var claimnos = NSMutableArray()
    var claimlac = NSMutableArray()
    var AMCapprovalstatus = NSMutableArray()
    var AMCclaimnos = NSMutableArray()
    var AMCclaimlacs = NSMutableArray()
    var appDelegate :AppDelegate = AppDelegate()
    var Regiondictonery = NSDictionary()
    var picker = UIPickerView()
    var custPicker = CustomPicker()
    //Mark Outlet
    @IBOutlet weak var menuBarItem: UIBarButtonItem!
    @IBOutlet weak var tblSalesData: UITableView!
    @IBOutlet weak var btnDaily: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnRange: UIButton!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.revealViewController() != nil {
            menuBarItem.target = self.revealViewController()
            menuBarItem.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        updatehMethod()
        configView()
        view()
        btnDaily.isSelected = true
        btnMonth.isSelected = false
        btnRange.isSelected = false
        lblLine1.isHidden = false
        lblLine2.isHidden = true
        lblLine3.isHidden = true
        Regiondictonery = ["oem": "", "claim_type": "EW"]
        APIForEWClaims()
        Regiondictonery = ["oem": "", "claim_type": "AMC"]
        APIForAMCClaims()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        tblSalesData.reloadData()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblSalesData
        {
            return 2
            
        }
        else
        {
            if section == 0{
                return claimapprstatus.count
            }
            else{
                return AMCapprovalstatus.count
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblSalesData{
            let tblcell = tableView .dequeueReusableCell(withIdentifier: "SalesDataCell", for: indexPath)
            tblcell.selectionStyle = UITableViewCell.SelectionStyle.none
            let lblName = tblcell .viewWithTag(2) as! UILabel
            let btnOEMWise = tblcell .viewWithTag(3) as! UIButton
            let tblValues = tblcell .viewWithTag(4) as! UITableView
            let btnDate = tblcell .viewWithTag(5) as! UIButton
            tblValues.dataSource = self
            tblValues.delegate = self
            
            if indexPath.row == 0{
                lblName.text = "EW"
                ClaimsType = "EW"
                btnDate.isHidden = false
            }
            else{
                lblName.text = "AMC"
                ClaimsType = "AMC"
                btnDate.isHidden = true
            }
            
            
            btnOEMWise.addTarget(self, action: #selector(btnOEMWise_didSelect), for: UIControl.Event.touchUpInside)
            if btnRange.isSelected == true{
                btnDate.addTarget(self, action: #selector(btnDate_didSelect), for: UIControl.Event.touchUpInside)
            }
            btnDate.setTitle(strsetdate, for: UIControl.State.normal)
            tblValues.reloadData()
            return tblcell
        }
        else{
            let tblcell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            let icon = tblcell?.viewWithTag(6) as? UIImageView
            let lblStages = tblcell?.viewWithTag(7) as? UILabel
            let lblNosValue = tblcell?.viewWithTag(8) as? UILabel
            let lblInLacsValue = tblcell?.viewWithTag(9) as? UILabel
            
            if (ClaimsType == "EW") {
                lblStages?.text = "\(claimapprstatus[indexPath.row])"
                if (lblStages?.text == "") {
                    icon?.image = UIImage(named: "question")
                } else if (lblStages?.text == "Approved") {
                    icon?.image = UIImage(named: "7")
                } else if (lblStages?.text == "In Process") {
                    icon?.image = UIImage(named: "4")
                } else if (lblStages?.text == "Payment Made") {
                    icon?.image = UIImage(named: "1")
                } else if (lblStages?.text == "Rejected") {
                    icon?.image = UIImage(named: "2")
                } else if (lblStages?.text == "Submitted") {
                    icon?.image = UIImage(named: "3")
                } else if (lblStages?.text == "Duplicate") {
                    icon?.image = UIImage(named: "Dupilcate")
                }
                lblNosValue?.text = "\(claimnos[indexPath.row])"
                lblInLacsValue?.text = String(format: "₹%.2f", ((claimlac[indexPath.row] as! NSString)).floatValue)
            } else {
                lblStages?.text = "\(AMCapprovalstatus[indexPath.row])"
                if (lblStages?.text == "") {
                    icon?.image = UIImage(named: "question")
                } else if (lblStages?.text == "Approved") {
                    icon?.image = UIImage(named: "7")
                } else if (lblStages?.text == "In Process") {
                    icon?.image = UIImage(named: "4")
                } else if (lblStages?.text == "Payment Made") {
                    icon?.image = UIImage(named: "1")
                } else if (lblStages?.text == "Rejected") {
                    icon?.image = UIImage(named: "2")
                } else if (lblStages?.text == "Submitted") {
                    icon?.image = UIImage(named: "3")
                } else if (lblStages?.text == "Duplicate") {
                    icon?.image = UIImage(named: "Dupilcate")
                }
                lblNosValue?.text = "\(AMCclaimnos[indexPath.row])"
                lblInLacsValue?.text = String(format: "₹%.2f", (AMCclaimlacs[indexPath.row] as? NSNumber)!.floatValue)
                
            }
            return tblcell!
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblSalesData{
            if indexPath.row == 0{
                
                return (CGFloat((claimapprstatus.count * 52) + 100))
            }
            else{
                return (CGFloat((AMCapprovalstatus.count * 52) + 100))
                
            }
        }
        else{
            return 52
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 0
        {
            return List.count
        }
        else
        {
            return List1.count
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 0{
            pickerselectedInd = row
            let textToDisplay: NSString = List.object(at: row)as! NSString
            return textToDisplay.capitalized
        }
        else{
            pickerselectedInd = row
            let textToDisplay: NSString = List1.object(at: row)as! NSString
            return textToDisplay.capitalized
        }
        
    }
    
    
    func rangeSelected(withStart startDate: Date!, andEnd endDate: Date!)
    {
        strsetdate = String(format: "\(  Utilities.sharedUtilities.getDuration(date: startDate! as NSDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate! as NSDate)  )")
        
    }
    
    //Mark Action
    @IBAction func btnDaily_didSelect(_ sender:UIButton)
    {
        updatehMethod()
        btnDaily.isSelected = true
        btnMonth.isSelected = false
        btnRange.isSelected = false
        lblLine1.isHidden = false
        lblLine2.isHidden = true
        lblLine3.isHidden = true
        custPicker.removePickerViewWithAnimaion(sourceView: self.view)
        
        Regiondictonery = ["oem": "", "claim_type": "EW"]
        APIForEWClaims()
        Regiondictonery = ["oem": "", "claim_type": "AMC"]
        APIForAMCClaims()
    }
    
    
    
    @IBAction func btnMonth_didSelect(_ sender:UIButton)
    {
        updatehMethod()
        btnDaily.isSelected = false
        btnMonth.isSelected = true
        btnRange.isSelected = false
        lblLine1.isHidden = true
        lblLine2.isHidden = false
        lblLine3.isHidden = true
        custPicker.removePickerViewWithAnimaion(sourceView: self.view)
        
        let gregorian:NSCalendar = NSCalendar.current as NSCalendar
        let arbitraryDate = NSDate.init()
        let comp :NSDateComponents = gregorian.components(NSCalendar.Unit(rawValue: NSCalendar.Unit.year.rawValue|NSCalendar.Unit.month.rawValue|NSCalendar.Unit.day.rawValue), from: arbitraryDate as Date) as NSDateComponents
        comp.day = 1
        let firstDayOfMonthDate = gregorian.date(from: comp as DateComponents)
        
        Regiondictonery = ["oem": "", "claim_type": "EW","start_date" : Utilities.sharedUtilities.overViewDate(date: firstDayOfMonthDate! as NSDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init())]
        APIForEWClaims()
        Regiondictonery = ["oem": "", "claim_type": "AMC","start_date" : Utilities.sharedUtilities.overViewDate(date: firstDayOfMonthDate! as NSDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init())]
        APIForAMCClaims()
    }
    @IBAction func btnRange_didSelect(_ sender:UIButton)
    {
        updatehMethod()
        btnDaily.isSelected = false
        btnMonth.isSelected = false
        btnRange.isSelected = true
        lblLine1.isHidden = true
        lblLine2.isHidden = true
        lblLine3.isHidden = false
        
        custPicker.showPickerViewWithAnimation(sourceView: self.view)
    }
    
    
    
    @IBAction func btnLeft_didSelect(_ sender:UIButton)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "dashboardnavigation") as! UINavigationController
        let window = UIApplication.shared.delegate?.window as? UIWindow
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    @IBAction func slidemenuAction(_ sender:UIBarButtonItem)
    {
        if self.revealViewController() != nil {
            menuBarItem.target = self.revealViewController()
            menuBarItem.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    @IBAction func btnDate_didSelect(_ sender:UIButton)
    {
        custPicker.showPickerViewWithAnimation(sourceView: self.view)
        
    }

    @IBAction func btnOEMWise_didSelect(_ sender:UIButton)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblSalesData)
        let indexPath = self.tblSalesData.indexPathForRow(at:buttonPosition)! as NSIndexPath
        let selectAction = RMAction(title: "Select", style: RMActionStyle.done, andHandler: { controller in
            let selectedRow :NSInteger = self.picker.selectedRow(inComponent: 0)
            var selectedRegion = ""
            if (self.List.count != 0) || (self.List1.count != 0){
                if indexPath.row == 0{
                    selectedRegion = self.List.object(at: self.pickerselectedInd) as! String
                    self.ClaimsType = "EW"
                }
                else{
                    selectedRegion = self.List1.object(at: selectedRow) as! String
                    self.ClaimsType = "AMC"
                }
                self.regName = selectedRegion.capitalized
                self.title = self.regName
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let ClaimsToyotaViewController: ClaimsToyotaViewController = mainStoryboard.instantiateViewController(withIdentifier: "ClaimsToyotaViewController") as! ClaimsToyotaViewController
                            ClaimsToyotaViewController.strNameShow = self.ClaimsType
                ClaimsToyotaViewController.OEMName = self.regName
                
                            ClaimsToyotaViewController.apistr = selectedRegion
                           
                            self.navigationController!.pushViewController(ClaimsToyotaViewController, animated: true)
            }
        })
        let cancelAction :RMAction = RMAction.init(title: "Cancel", style: RMActionStyle.cancel) { (controller) in
            print("Row selection was canceled")
            }!
        
        let pickerController : RMPickerViewController = RMPickerViewController.init(style: RMActionControllerStyle.white, select: selectAction as? RMAction<UIPickerView>, andCancel: cancelAction as? RMAction<UIPickerView>)!
        pickerController.picker.tag = indexPath.row
        pickerController.picker.delegate = self
        pickerController.picker.dataSource = self
        pickerController.title = "OEM Wise"
        pickerController.message = "Select a OEM of your choice"
        self.present(pickerController, animated: true, completion: nil)
        
    }
    
    func updatehMethod()
    {
        let MyIp:NSIndexPath = NSIndexPath.init(row: 0, section: 0)
        regName = ""
        List.removeAllObjects()
        List1.removeAllObjects()
        claimapprstatus.removeAllObjects()
        claimnos.removeAllObjects()
        claimlac.removeAllObjects()
        AMCapprovalstatus.removeAllObjects()
        AMCclaimlacs.removeAllObjects()
        AMCclaimnos.removeAllObjects()
        tblSalesData.reloadData()
        tblSalesData.scrollToRow(at: MyIp as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
    }
    
    
    func configView()
    {
        
        custPicker = (Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?[0] as? CustomPicker)!
        weak var weakSelf = self
        custPicker.addPicker(on: self.view) { (strt, end) in
            weakSelf?.updateDate(startDate: strt! as NSDate, endDate: end! as NSDate)
        }
    }
    
    
    
    
    func view()
    {
        let view = UIView.init(frame: CGRect.init(x: -40, y: 0, width: 150, height: 33))
        
        self.navigationController?.navigationBar.topItem?.titleView = view
    }
    
    
    
    func updateDate(startDate:NSDate,endDate:NSDate)->Void
    {
        if btnRange.isSelected == true{
            Regiondictonery = ["oem": "", "claim_type": "EW","start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate)]
            APIForEWClaims()
            Regiondictonery = ["oem": "", "claim_type": "AMC","start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate)]
            APIForAMCClaims()
        }
    }
    
    //Mark WebServices
    func APIForEWClaims()
    {
        let timestamp = NSInteger(NSDate().timeIntervalSince1970)
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        let serializerRequest = AFHTTPRequestSerializer()
        serializerRequest .setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        serializerRequest.setValue("iOS", forHTTPHeaderField: "os")
        
        manager.requestSerializer = serializerRequest
        manager.requestSerializer.timeoutInterval = 1000.0
        
        let token = appDelegate.getSessionId()
        
        serializerRequest.setValue(token, forHTTPHeaderField: "x-access-token")
        serializerRequest.setValue("\(timestamp)", forHTTPHeaderField: "timestamp")
        manager.responseSerializer = AFJSONResponseSerializer.init()
        
        let baseurl = "http://bi.servassure.net/api/"
        manager .post("\(baseurl)ClaimApprovalSummary", parameters: Regiondictonery, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            
            
            if let jsonResponse = responseObject as? [String: AnyObject] {
                print("json response \(jsonResponse.description)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Int == 1
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0 {
                        let Data = dataArray.object(at: 0)as! NSDictionary
                        let arrayproduct = info["oem"] as! NSArray
                        self.List = arrayproduct.mutableCopy() as! NSMutableArray
                        let arrayproductclaim = Data["claim_approval_status"] as! NSArray
                        self.claimapprstatus = arrayproductclaim.mutableCopy() as! NSMutableArray
                        let arrayproductclaimno = Data["total_claim_arr"] as! NSArray
                        self.claimnos = arrayproductclaimno.mutableCopy() as! NSMutableArray
                        
                        self.claimlac = NSMutableArray.init()
                        let arrayproductclaimarr = Data["claim_amount_arr"]  as! NSArray
                        
                        let object = arrayproductclaimarr.mutableCopy() as! NSMutableArray
                        for num1 in object {
                            guard let num1 = num1 as? NSNumber else {
                                continue
                            }
                            let value = num1.floatValue / 100000
                            let strvalues = String(format: "%.2f", value)
                            
                            self.claimlac.add(strvalues)
                            
                        }
                        if self.btnRange.isSelected
                        {
                            let StrStartDate = (info["addtionalinfo"] as? [AnyHashable : Any])?["start_date"] as? String
                            let StrEndDate = (info["addtionalinfo"] as? [AnyHashable : Any])?["end_date"] as? String
                            
                            let startdate = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: StrStartDate!)
                            let enddate = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: StrEndDate!)
                            
                            self.strsetdate = "\(startdate) - \(enddate)"
                        }
                        else if self.btnMonth.isSelected
                        {
                            let StrStartDate = (info["addtionalinfo"] as? [AnyHashable : Any])?["start_date"] as? String
                            let StrEndDate = (info["addtionalinfo"] as? [AnyHashable : Any])?["end_date"] as? String
                            
                            let startdate = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: StrStartDate!)
                            let enddate = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: StrEndDate!)
                            
                            self.strsetdate = "\(startdate) - \(enddate)"
                        }
                        else{
                            
                            let StrCurrentDate = (info["addtionalinfo"] as? [AnyHashable : Any])?["start_date"] as? String
                            let currentDate = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: StrCurrentDate!)
                            self.strsetdate = "\( currentDate )"
                        }
                    }
                    self.tblSalesData.reloadData()
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
    
    //Mark WebServices
    func APIForAMCClaims()
    {
        let timestamp = NSInteger(NSDate().timeIntervalSince1970)
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        let serializerRequest = AFHTTPRequestSerializer()
        serializerRequest .setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        serializerRequest.setValue("iOS", forHTTPHeaderField: "os")
        
        manager.requestSerializer = serializerRequest
        manager.requestSerializer.timeoutInterval = 1000.0
        
        let token = appDelegate.getSessionId()
        
        serializerRequest.setValue(token, forHTTPHeaderField: "x-access-token")
        serializerRequest.setValue("\(timestamp)", forHTTPHeaderField: "timestamp")
        manager.responseSerializer = AFJSONResponseSerializer.init()
        
        
        
        let baseurl = "http://bi.servassure.net/api/"
        manager .post("\(baseurl)ClaimApprovalSummary", parameters: Regiondictonery, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            
            if let jsonResponse = responseObject as? [String: AnyObject] {
                print("json response \(jsonResponse.description)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Int == 1
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0 {
                        let Data = dataArray.object(at: 0)as! NSMutableDictionary
                        let arrayproduct = info["oem"] as! NSArray
                        self.List = arrayproduct.mutableCopy() as! NSMutableArray
                        let arrayproductsta = Data["claim_approval_status"] as! NSArray
                        self.AMCapprovalstatus = arrayproductsta.mutableCopy() as! NSMutableArray
                        let arrayproductno = Data["total_claim_arr"] as! NSArray
                        
                        self.AMCclaimnos = arrayproductno.mutableCopy() as! NSMutableArray
                        
                        self.AMCclaimlacs = NSMutableArray.init()
                        let arrayproductarr = Data["claim_amount_arr"] as! NSArray
                        
                        let object = arrayproductarr.mutableCopy() as! NSMutableArray
                        for num1 in object {
                            guard let num1 = num1 as? NSNumber else {
                                continue
                            }
                            let value = num1.floatValue / 10000000
                            let strvalues = String(format: "%.2f", value)
                            
                            self.AMCclaimlacs.add(strvalues)
                            
                        }
                        
                    }
                    self.tblSalesData.reloadData()
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
