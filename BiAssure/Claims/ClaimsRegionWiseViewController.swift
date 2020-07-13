//
//  ClaimsRegionWiseViewController.swift
//  BiAssure
//
//  Created by Swetha on 29/07/19.
//  Copyright © 2019 Techfour. All rights reserved.
//

import UIKit
import SVProgressHUD
import SSMaterialCalendarPicker
import KSToastView
import AFNetworking
import RMPickerViewController


class ClaimsRegionWiseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SSMaterialCalendarPickerDelegate {

    
    /*
     MARK: - DECLARATION OF VARIABLES
     */
    var datePicker = SSMaterialCalendarPicker()
    var appDelegate: AppDelegate = AppDelegate()
    
    var selectedIndex = 0
    
    var regionName = ""
    var strsetdate = ""
    var NameRegion = ""
    var apistr = ""
    var strNameShow = ""
    var strRegion = ""
    var OEMName = ""
    
    
    var _startDate = NSDate()
    var _endDate = NSDate()
    
    var viewStages = UITableView()
    var NonSurTable = UITableView()
    var SurTable = UITableView()
    
    
    var RegionList = NSMutableArray()
    var claim_approval_status = NSMutableArray()
    var claim_nos = NSMutableArray()
    var claim_lacs = NSMutableArray()
    var NonsurveyorSummary = NSMutableArray()
    var surveyorSummary = NSMutableArray()
    
    var dictRegion = NSDictionary()
    
     var sePicker = CustomPicker()
    
    
    
    /*
     MARK: - IBOUTLETS
     */
    @IBOutlet weak var tblToyotaData: UITableView!
    @IBOutlet weak var btnDaily: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnRange: UIButton!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var navbar: UINavigationBar!
    
    
    
    
    /*
     MARK: - INBUILT FUNCTIONS
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshMethod()
        style()
        configureView()
        btnDaily.isSelected = true
        btnMonth.isSelected = false
        btnRange.isSelected = false
        lblLine1.isHidden = false
        lblLine2.isHidden = true
        lblLine3.isHidden = true
        dictRegion = ["oem": apistr, "claim_type": strNameShow,"region":strRegion]
        WebserviceCallingForEWClaims()
        dictRegion = ["oem": apistr,"region":strRegion]
        webserviceForClaimsNonsurveyorSummary()
        webserviceForClaimSurveyorSummary()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
      
    }
    
    
    
    /*
     MARK: - TABLEVIEW DELEGATE AND DATASOURCE
     */
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblToyotaData
        {
            return 3
            
        }
        else
        {
            if selectedIndex == 0{
                return claim_approval_status.count
            }
            else{
                if selectedIndex == 1{
                    return NonsurveyorSummary.count
                }
                else{
                    return surveyorSummary.count
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblToyotaData{
            if indexPath.row == 0{
                let cell = tableView .dequeueReusableCell(withIdentifier: "DataCell0", for: indexPath)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                let btnDate = cell .viewWithTag(4) as! UIButton
                viewStages = cell .viewWithTag(5) as! UITableView
                selectedIndex = 0
                
                
                viewStages.dataSource = self
                viewStages.delegate = self
                
                
                
                btnDate.addTarget(self, action: #selector(btnDate_didSelect), for: UIControl.Event.touchUpInside)
                btnDate.setTitle(strsetdate, for: UIControl.State.normal)
                viewStages.reloadData()
                return cell
            }
            else{
                let cell = tableView .dequeueReusableCell(withIdentifier: "DataCell1", for: indexPath)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                let lblsurveyor = cell .viewWithTag(11) as! UILabel
                NonSurTable = cell .viewWithTag(13) as! UITableView
                NonSurTable.dataSource = self
                NonSurTable.delegate = self
                
                if indexPath.row == 1
                {
                    selectedIndex = 1
                    lblsurveyor.text = "Non Surveyor Claims"
                    
                }
                else if indexPath.row == 2
                {
                    selectedIndex = 2
                    lblsurveyor.text = "Surveyor Claims"
                    
                }
                
                
                NonSurTable.reloadData()
                return cell
            }
        }
        else if selectedIndex == 0{
            let cell = tableView .dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let icon = cell.viewWithTag(6) as! UIImageView
            let lblStages = cell .viewWithTag(21) as! UILabel
            let lblNumbers = cell .viewWithTag(22) as! UILabel
            let lblValues = cell .viewWithTag(23) as! UILabel
            lblStages.text = String(format: "\(claim_approval_status.object(at: indexPath.row))", 0)
            if (lblStages.text == "") {
                icon.image = UIImage(named: "question")
            } else if (lblStages.text == "Approved") {
                icon.image = UIImage(named: "7")
            } else if (lblStages.text == "In Process") {
                icon.image = UIImage(named: "4")
            } else if (lblStages.text == "Payment Made") {
                icon.image = UIImage(named: "1")
            } else if (lblStages.text == "Rejected") {
                icon.image = UIImage(named: "2")
            } else if (lblStages.text == "Submitted") {
                icon.image = UIImage(named: "3")
            } else if (lblStages.text == "Duplicate") {
                icon.image = UIImage(named: "Dupilcate")
            }
            lblNumbers.text = String(format: "\(claim_nos.object(at: indexPath.row))", 0)
            lblValues.text = String(format: "\(claim_lacs.object(at: indexPath.row))", 0)
            return cell
        }
            
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1")
            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
            
            let lblNumbers = cell?.viewWithTag(15) as! UILabel
            let lblValues = cell?.viewWithTag(16) as! UILabel
            let lblNonSur = cell?.viewWithTag(17) as! UILabel
            let img1 = cell?.viewWithTag(13) as! UIImageView
            let img2 = cell?.viewWithTag(14) as! UIImageView
            if (selectedIndex == 1) {
                let dict:NSDictionary = NonsurveyorSummary.object(at: indexPath.row) as! NSDictionary
                if dict.object(forKey: "_id") as! NSString == "Zeroto30Minutes"
                {
                    img1.isHidden = false
                    img2.isHidden = false
                    img1.image = UIImage.init(named: "0minus")
                    img2.image = UIImage.init(named: "30minus1")
                    lblNonSur.text = "to"
                    
                }
                else if dict.object(forKey: "_id") as! NSString == "30to60Minutes"
                {
                    img1.isHidden = false
                    img2.isHidden = false
                    img1.image = UIImage.init(named: "30Minus")
                    img2.image = UIImage.init(named: "60Minus")
                    lblNonSur.text = "to"
                    
                }
                else if dict.object(forKey: "_id") as! NSString == "Over60Minutes"
                {
                    img1.isHidden = false
                    img2.isHidden = true
                    img1.image = UIImage.init(named: ")60Minus")
                    lblNonSur.text = ""
                }
                else
                {
                    img1.isHidden = true
                    img2.isHidden = true
                    lblNonSur.text = ""
                }
                let number:Int = dict.object(forKey: "total_claim") as! Int
                lblNumbers.text = String(format: "\(number)")
                let num1:NSNumber = dict.object(forKey: "total_claim_amount") as! NSNumber
                let value:Float = (num1).floatValue/100000
                let strValues = String(format: "%.2f",value)
                lblValues.text = strValues
            }
            else {
                let dict:NSDictionary = surveyorSummary.object(at: indexPath.row) as! NSDictionary
                if dict.object(forKey: "_id") as! NSString == "Zeroto30Minutes"
                {
                    img1.isHidden = false
                    img2.isHidden = false
                    img1.image = UIImage.init(named: "0minus")
                    img2.image = UIImage.init(named: "30minus1")
                    lblNonSur.text = "to"
                    
                }
                else if dict.object(forKey: "_id") as! NSString == "30to60Minutes"
                {
                    img1.isHidden = false
                    img2.isHidden = false
                    img1.image = UIImage.init(named: "30Minus")
                    img2.image = UIImage.init(named: "60Minus")
                    lblNonSur.text = "to"
                    
                }
                else if dict.object(forKey: "_id") as! NSString == "Over60Minutes"
                {
                    img1.isHidden = false
                    img2.isHidden = true
                    img1.image = UIImage.init(named: ")60Minus")
                    lblNonSur.text = ""
                }
                else
                {
                    img1.isHidden = true
                    img2.isHidden = true
                    lblNonSur.text = ""
                }
                let number:Int = dict.object(forKey: "total_claim")as! Int
                lblNumbers.text = String(format: "\(number)" as String)
                
                let num1:NSNumber = dict.object(forKey: "total_claim_amount") as! NSNumber
                let value:Float = (num1).floatValue/100000
                let strValues = String(format: "%.2f",value)
                lblValues.text = strValues
                
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblToyotaData{
            if indexPath.row == 0{
                return (CGFloat((claim_approval_status.count * 52) + 100))

            }
            else{
                if NonsurveyorSummary.count > 0{
                    return (CGFloat((NonsurveyorSummary.count * 56) + 56))
                }
                else if surveyorSummary.count > 0{
                    return (CGFloat((surveyorSummary.count * 56) + 56))
                }
                else{
                    return 56.0
                }
            }
        }
        else{
            return 56.0
        }
    }
    
    
    
    
    
    
    /*
     MARK: - SSMATERIALCALENDARDELEGATE
     */
    
    func rangeSelected(withStart startDate: Date!, andEnd endDate: Date!) {
        _startDate = startDate! as NSDate
        _endDate = endDate! as NSDate
        strsetdate = String(format: "\(Utilities.sharedUtilities.getDuration(date: startDate! as NSDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate! as NSDate))", 0)
    }
    
    
    
    
    /*
     MARK: -  FUNCTIONS
     */
    
    func configureView()
    {
        
        sePicker = (Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?[0] as? CustomPicker)!
        weak var weakSelf = self
        sePicker.addPicker(on: self.view) { (strt, end) in
            weakSelf?.updateData(startDate: strt! as NSDate, endDate: end! as NSDate)
        }
    }
    
    
    
    
    func style()
    {
        
        let view = UIView.init(frame: CGRect.init(x: -10, y: 0, width: 150, height: 33))
        let imageView = UIImageView.init(frame: CGRect.init(x: -30, y: 5, width: 20, height: 25))
        imageView.image = UIImage.init(named: "Regions-icon-white")
        let lblTitle : UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 2, width: 200, height: 30))
        
        lblTitle.text = NameRegion
        lblTitle.textColor = UIColor.white
        lblTitle.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(imageView)
        view.addSubview(lblTitle)
        self.navigationItem.titleView = view
        
        let backButton:UIButton =  UIButton(type:.custom)
        backButton.frame =  CGRect.init(x: 0, y: 0, width: 130, height: 22)
        backButton.setImage(UIImage.init(named: "arrow-left"), for: UIControl.State.normal)
        backButton.addTarget(self, action: #selector(btnLeft_didSelect(_:)), for: UIControl.Event.touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -60, bottom: 0, right: 0)
        backButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -50, bottom: 0, right: 0)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        backButton.setTitle(OEMName, for: .normal)
        //[backButton setTitle:_brandname forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        
        
        let menuButton:UIButton =  UIButton(type:.custom)
        menuButton.frame =  CGRect.init(x: 0, y: 0, width: 52, height: 40)
        menuButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 25, bottom: 0, right: 0)
        menuButton.setImage(UIImage.init(named: "right-menu-icon"), for: UIControl.State.normal)
        menuButton.addTarget(self, action: #selector(slidemenuAction), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: menuButton)
    }
    
    func refreshMethod()
    {
        let MyIp:NSIndexPath = NSIndexPath.init(row: 0, section: 0)
        regionName = ""
        RegionList.removeAllObjects()
        claim_approval_status.removeAllObjects()
        claim_nos.removeAllObjects()
        claim_lacs.removeAllObjects()
        NonsurveyorSummary.removeAllObjects()
        surveyorSummary.removeAllObjects()
        
        tblToyotaData.reloadData()
        tblToyotaData.scrollToRow(at: MyIp as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
    }
    
    
    func updateData(startDate:NSDate,endDate:NSDate)->Void
    {
        strsetdate = String(format: "\(Utilities.sharedUtilities.getDuration(date: startDate))-\(Utilities.sharedUtilities.getDuration(date: endDate))", 0)
        
        if btnRange.isSelected == true{
            dictRegion = ["oem": apistr, "claim_type": strNameShow,"start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate),"region":strRegion]
            WebserviceCallingForEWClaims()
            dictRegion = ["oem": apistr,"start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate),"region":strRegion]
            webserviceForClaimsNonsurveyorSummary()
            webserviceForClaimSurveyorSummary()
        }
    }
    
    
    
    func rangeSelectedWithStartDate(startDate:NSDate,endDate:NSDate)->Void
    {
        _startDate = startDate
        _endDate = endDate
        strsetdate = String(format: "\(Utilities.sharedUtilities.getDuration(date: startDate))-\(Utilities.sharedUtilities.getDuration(date: endDate))", 0)
    }
    
    
    
    /*
     MARK: - BUTTON ACTIONS
     */
    
    @IBAction func slidemenuAction(_ sender:UIBarButtonItem)
    {
        kMainViewController.showRightView(animated: true, completionHandler: nil)
    }
    
    
    @IBAction func btnDaily_didSelect(_ sender:UIButton)
    {
        refreshMethod()
        btnDaily.isSelected = true
        btnMonth.isSelected = false
        btnRange.isSelected = false
        lblLine1.isHidden = false
        lblLine2.isHidden = true
        lblLine3.isHidden = true
        // [sePicker removePickerViewWithAnimaion:self.view];
        sePicker.removePickerViewWithAnimaion(sourceView: self.view)
        dictRegion = ["oem":apistr, "claim_type":strNameShow,"region":strRegion]
        WebserviceCallingForEWClaims()
        dictRegion = ["oem": apistr,"region":strRegion]
        webserviceForClaimsNonsurveyorSummary()
        webserviceForClaimSurveyorSummary()
    }
    
    
    
    @IBAction func btnMonth_didSelect(_ sender:UIButton)
    {
        refreshMethod()
        btnDaily.isSelected = false
        btnMonth.isSelected = true
        btnRange.isSelected = false
        lblLine1.isHidden = true
        lblLine2.isHidden = false
        lblLine3.isHidden = true
        // [sePicker removePickerViewWithAnimaion:self.view];
        sePicker.removePickerViewWithAnimaion(sourceView: self.view)
        let gregorian:NSCalendar = NSCalendar.current as NSCalendar
        let arbitraryDate = NSDate.init()
        let comp :NSDateComponents = gregorian.components(NSCalendar.Unit(rawValue: NSCalendar.Unit.year.rawValue|NSCalendar.Unit.month.rawValue|NSCalendar.Unit.day.rawValue), from: arbitraryDate as Date) as NSDateComponents
        comp.day = 1
        let firstDayOfMonthDate = gregorian.date(from: comp as DateComponents)
        
        dictRegion = ["oem": apistr, "claim_type": strNameShow,"start_date" : Utilities.sharedUtilities.overViewDate(date: firstDayOfMonthDate! as NSDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"region":strRegion]
        WebserviceCallingForEWClaims()
        dictRegion = ["oem":apistr,"start_date" : Utilities.sharedUtilities.overViewDate(date: firstDayOfMonthDate! as NSDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"region":strRegion]
        webserviceForClaimsNonsurveyorSummary()
        webserviceForClaimSurveyorSummary()
    }
    
    
    
    
    @IBAction func btnRange_didSelect(_ sender:UIButton)
    {
        refreshMethod()
        btnDaily.isSelected = false
        btnMonth.isSelected = false
        btnRange.isSelected = true
        lblLine1.isHidden = true
        lblLine2.isHidden = true
        lblLine3.isHidden = false
        // [sePicker showPickerViewWithAnimation:self.view];
        sePicker.showPickerViewWithAnimation(sourceView: self.view)
    }
    
    
    
    @IBAction func btnLeft_didSelect(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
   
    
    
    @IBAction func btnDate_didSelect(_ sender:UIButton)
    {
        // [sePicker showPickerViewWithAnimation:self.view];
        sePicker.showPickerViewWithAnimation(sourceView: self.view)
    }
    
    
    /*
     MARK: - API INTEGRATION
     */
    func WebserviceCallingForEWClaims()
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
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        
        manager .post("\(Base_Url)ClaimApprovalSummary", parameters: dictRegion, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
        

            SVProgressHUD.dismiss()
            if let jsonResponse = responseObject as? [String: AnyObject] {
                // here read response
                print("json response \(jsonResponse.description)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Int == 1
                {
                    if self.btnDaily.isSelected == true{
                        
                        let StrCurrentDate = (info["addtionalinfo"] as? [AnyHashable : Any])?["start_date"] as? String
                        let currentDate = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: StrCurrentDate!)
                        
                        self.strsetdate = currentDate
                    }
                    if self.btnMonth.isSelected == true {
                        let strcurrent_day_month = (info["addtionalinfo"] as? [AnyHashable : Any])?["end_date"] as? String
                        let first_day_month = (info["addtionalinfo"] as? [AnyHashable : Any])?["start_date"] as? String
                        
                        let currentDay = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: strcurrent_day_month!)
                        
                        
                        let firstDay = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: first_day_month!)
                        
                        
                        self.strsetdate = "\(firstDay) - \(currentDay)"
                    }
                    if self.btnRange.isSelected == true {
                        let strStartdate = (info["addtionalinfo"] as? [AnyHashable : Any])?["start_date"] as? String
                        let strEnddate = (info["addtionalinfo"] as? [AnyHashable : Any])?["end_date"] as? String
                        
                        let startdate = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: strStartdate!)
                        let enddate = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: strEnddate!)
                        self.strsetdate = "\(startdate) - \(enddate)"
                    }
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0{
                        
                        
                        let Datas =  dataArray.object(at: 0) as! NSDictionary
                        let Data = Datas.mutableCopy() as! NSMutableDictionary
                        
                        let regionlst =  info["region"] as! NSArray
                        self.RegionList = regionlst.mutableCopy() as! NSMutableArray
                        
                        let claimst = Data["claim_approval_status"] as! NSArray
                        self.claim_approval_status = claimst.mutableCopy() as! NSMutableArray
                        
                        let claimno =  Data["total_claim_arr"] as! NSArray
                        self.claim_nos = claimno.mutableCopy() as! NSMutableArray
                        
                        self.claim_lacs = NSMutableArray.init()
                        
                        let objects =  Data["claim_amount_arr"] as! NSArray
                        let object = objects.mutableCopy() as! NSMutableArray
                        //f (info["data"]? as AnyObject).count() != 0 {
                        
                        for num1 in object {
                            guard let num1 = num1 as? NSNumber else {
                                continue
                            }
                            let value = num1.floatValue / 100000
                            let strvalues = String(format: "%.2f", value)
                            self.claim_lacs.add(strvalues)
                        }}
                    
                    
                    self.tblToyotaData.reloadData()
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
    
    
    
    func webserviceForClaimsNonsurveyorSummary()
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
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        
        manager .post("\(Base_Url)ClaimNonSurveyorSummary", parameters: dictRegion, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
        
            SVProgressHUD.dismiss()
            if let jsonResponse = responseObject as? [String: AnyObject] {
                // here read response
                print("json response \(jsonResponse.description)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Int == 1
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0 {
                        self.NonsurveyorSummary  = dataArray.mutableCopy() as! NSMutableArray
                        
                    }
                    self.tblToyotaData.reloadData()
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
    
    func webserviceForClaimSurveyorSummary()
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
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        
        manager .post("\(Base_Url)ClaimSurveyorSummary", parameters: dictRegion, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
        
    
            SVProgressHUD.dismiss()
            if let jsonResponse = responseObject as? [String: AnyObject] {
                // here read response
                print("json response \(jsonResponse.description)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Int == 1
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0 {
                        if dataArray.count != 0 {
                            self.surveyorSummary  = dataArray.mutableCopy() as! NSMutableArray
                            
                        }
                    }
                    self.tblToyotaData.reloadData()
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
