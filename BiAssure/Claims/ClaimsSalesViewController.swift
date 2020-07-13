//
//  ClaimsSalesViewController.swift
//  BiAssure
//
//  Created by Swetha on 26/07/19.
//  Copyright © 2019 Techfour. All rights reserved.
//

import UIKit
import SSMaterialCalendarPicker
import SVProgressHUD
import KSToastView
import RMPickerViewController
import AFNetworking

class ClaimsSalesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,SSMaterialCalendarPickerDelegate {
   
    /*MARK: -DECLARATION OF VARIABLES
     */
    var datePicker = SSMaterialCalendarPicker()

    var strClaimsType = ""
    var regionName = ""
    var strsetdate = ""

    var pickerselectedIndex = 0
    
    var _startDate = NSDate()
    var _endDate = NSDate()

    var masterList = NSMutableArray()
    var masterList1 = NSMutableArray()
    var claim_approval_status = NSMutableArray()
    var claim_nos = NSMutableArray()
    var claim_lacs = NSMutableArray()
    var AMC_approval_status = NSMutableArray()
    var AMC_claim_nos = NSMutableArray()
    var AMC_claim_lacs = NSMutableArray()
    var appDelegate :AppDelegate = AppDelegate()
    var dictRegion = NSDictionary()
     var picker = UIPickerView()
    
    var sePicker = CustomPicker()
    
    /*MARK: -IBOUTLETS
     */
    @IBOutlet weak var tblSalesData: UITableView!
    @IBOutlet weak var btnDaily: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnRange: UIButton!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!

    /*MARK: -INBUILT FUNCTIONS
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshMethod()
        configureView()
        style()
        btnDaily.isSelected = true
        btnMonth.isSelected = false
        btnRange.isSelected = false
        lblLine1.isHidden = false
        lblLine2.isHidden = true
        lblLine3.isHidden = true
        dictRegion = ["oem": "", "claim_type": "EW"]
        WebserviceCallingForEWClaims()
        dictRegion = ["oem": "", "claim_type": "AMC"]
        WebserviceCallingForAMCClaims()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        tblSalesData.reloadData()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
    /*MARK: -TABLEVIEW DELEGATE AND DATASOURCE
     */
    
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
                return claim_approval_status.count
            }
            else{
                return AMC_approval_status.count
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblSalesData{
            let cell = tableView .dequeueReusableCell(withIdentifier: "SalesDataCell", for: indexPath)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let lblName = cell .viewWithTag(2) as! UILabel
            let btnOEMWise = cell .viewWithTag(3) as! UIButton
            let tblValues = cell .viewWithTag(4) as! UITableView
            let btnDate = cell .viewWithTag(5) as! UIButton
            tblValues.dataSource = self
            tblValues.delegate = self
            
            if indexPath.row == 0{
                lblName.text = "EW"
                strClaimsType = "EW"
                btnDate.isHidden = false
            }
            else{
                lblName.text = "AMC"
                strClaimsType = "AMC"
                btnDate.isHidden = true
            }
            
            
            btnOEMWise.addTarget(self, action: #selector(btnOEMWise_didSelect), for: UIControl.Event.touchUpInside)
            if btnRange.isSelected == true{
             btnDate.addTarget(self, action: #selector(btnDate_didSelect), for: UIControl.Event.touchUpInside)
            }
            btnDate.setTitle(strsetdate, for: UIControl.State.normal)
            tblValues.reloadData()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            let icon = cell?.viewWithTag(6) as? UIImageView
            let lblStages = cell?.viewWithTag(7) as? UILabel
            let lblNosValue = cell?.viewWithTag(8) as? UILabel
            let lblInLacsValue = cell?.viewWithTag(9) as? UILabel
            
            if (strClaimsType == "EW") {
                lblStages?.text = "\(claim_approval_status[indexPath.row])"
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
                lblNosValue?.text = "\(claim_nos[indexPath.row])"
                lblInLacsValue?.text = String(format: "₹%.2f", ((claim_lacs[indexPath.row] as! NSString)).floatValue)
            } else {
                lblStages?.text = "\(AMC_approval_status[indexPath.row])"
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
                lblNosValue?.text = "\(AMC_claim_nos[indexPath.row])"
                lblInLacsValue?.text = String(format: "₹%.2f", (AMC_claim_lacs[indexPath.row] as? NSNumber)!.floatValue)
                
            }
            return cell!
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblSalesData{
            if indexPath.row == 0{

                return (CGFloat((claim_approval_status.count * 52) + 100))
            }
            else{
                return (CGFloat((AMC_approval_status.count * 52) + 100))

            }
        }
        else{
            return 52
        }
    }
    
    
    /*MARK: -PICKERVIEW DELEGATE AND DATASOURCE
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 0
        {
            return masterList.count
        }
        else
        {
            return masterList1.count
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 0{
            pickerselectedIndex = row
            let textToDisplay: NSString = masterList.object(at: row)as! NSString
            return textToDisplay.capitalized
        }
        else{
            pickerselectedIndex = row
            let textToDisplay: NSString = masterList1.object(at: row)as! NSString
            return textToDisplay.capitalized
        }
        
    }
    
    /*
     MARK: - SSMATERIALCALENDARDELEGATE
     */
    
    func rangeSelected(withStart startDate: Date!, andEnd endDate: Date!)
    {
        strsetdate = String(format: "\(  Utilities.sharedUtilities.getDuration(date: startDate! as NSDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate! as NSDate)  )")
        
    }
    
    /*MARK: -BUTTON ACTION
     */
    
    @IBAction func btnDaily_didSelect(_ sender:UIButton)
    {
        refreshMethod()
        btnDaily.isSelected = true
        btnMonth.isSelected = false
        btnRange.isSelected = false
        lblLine1.isHidden = false
        lblLine2.isHidden = true
        lblLine3.isHidden = true
        sePicker.removePickerViewWithAnimaion(sourceView: self.view)
       
        dictRegion = ["oem": "", "claim_type": "EW"]
        WebserviceCallingForEWClaims()
        dictRegion = ["oem": "", "claim_type": "AMC"]
        WebserviceCallingForAMCClaims()
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
       sePicker.removePickerViewWithAnimaion(sourceView: self.view)
        
        let gregorian:NSCalendar = NSCalendar.current as NSCalendar
        let arbitraryDate = NSDate.init()
        let comp :NSDateComponents = gregorian.components(NSCalendar.Unit(rawValue: NSCalendar.Unit.year.rawValue|NSCalendar.Unit.month.rawValue|NSCalendar.Unit.day.rawValue), from: arbitraryDate as Date) as NSDateComponents
        comp.day = 1
        let firstDayOfMonthDate = gregorian.date(from: comp as DateComponents)
        
        dictRegion = ["oem": "", "claim_type": "EW","start_date" : Utilities.sharedUtilities.overViewDate(date: firstDayOfMonthDate! as NSDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init())]
        WebserviceCallingForEWClaims()
        dictRegion = ["oem": "", "claim_type": "AMC","start_date" : Utilities.sharedUtilities.overViewDate(date: firstDayOfMonthDate! as NSDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init())]
        WebserviceCallingForAMCClaims()
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
       
        sePicker.showPickerViewWithAnimation(sourceView: self.view)
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
        kMainViewController.showRightView(animated: true, completionHandler: nil)
    }
    
    
    
    @IBAction func btnDate_didSelect(_ sender:UIButton)
    {
        sePicker.showPickerViewWithAnimation(sourceView: self.view)

    }
    
    
    
    @IBAction func btnOEMWise_didSelect(_ sender:UIButton)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblSalesData)
        let indexPath = self.tblSalesData.indexPathForRow(at:buttonPosition)! as NSIndexPath
        let selectAction = RMAction(title: "Select", style: RMActionStyle.done, andHandler: { controller in
           // let picker = UIPickerView() //=  (controller as? RMPickerViewController)!.picker
            let selectedRow :NSInteger = self.picker.selectedRow(inComponent: 0)
            var selectedRegion = ""
            if (self.masterList.count != 0) || (self.masterList1.count != 0){
            if indexPath.row == 0{
                selectedRegion = self.masterList.object(at: self.pickerselectedIndex) as! String
                self.strClaimsType = "EW"
            }
            else{
                selectedRegion = self.masterList1.object(at: selectedRow) as! String
                self.strClaimsType = "AMC"
            }
            self.regionName = selectedRegion.capitalized
            self.title = self.regionName
             let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ClaimsToyotaViewController: ClaimsToyotaViewController = mainStoryboard.instantiateViewController(withIdentifier: "ClaimsToyotaViewController") as! ClaimsToyotaViewController
            ClaimsToyotaViewController.strNameShow = self.strClaimsType
            ClaimsToyotaViewController.OEMName = self.regionName

            ClaimsToyotaViewController.apistr = selectedRegion
           // self.navigationController?.isNavigationBarHidden = true
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

    
    /*MARK: -FUNCTION
     */
    
    
    func refreshMethod()
    {
        let MyIp:NSIndexPath = NSIndexPath.init(row: 0, section: 0)
        regionName = ""
        masterList.removeAllObjects()
        masterList1.removeAllObjects()
        claim_approval_status.removeAllObjects()
        claim_nos.removeAllObjects()
        claim_lacs.removeAllObjects()
        AMC_approval_status.removeAllObjects()
        AMC_claim_lacs.removeAllObjects()
        AMC_claim_nos.removeAllObjects()
        tblSalesData.reloadData()
        tblSalesData.scrollToRow(at: MyIp as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
    }
    
    
    func configureView()
    {

        sePicker = (Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?[0] as? CustomPicker)!
        weak var weakSelf = self
        sePicker.addPicker(on: self.view) { (strt, end) in
            weakSelf?.updateDate(startDate: strt! as NSDate, endDate: end! as NSDate)
        }
    }
    
    
    
    
    func style()
    {
        let view = UIView.init(frame: CGRect.init(x: -40, y: 0, width: 150, height: 33))
        let imageView = UIImageView.init(frame: CGRect.init(x: -40, y: 5, width: 20, height: 20))
        imageView.image = UIImage.init(named: "dashboard-icon")
        let lblTitle : UILabel = UILabel.init(frame: CGRect.init(x: -15, y: 3, width: 100, height: 30))
        
        lblTitle.text = "Dashboard"
        lblTitle.textColor = UIColor.white
        lblTitle.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(imageView)
        view.addSubview(lblTitle)
        self.navigationController?.navigationBar.topItem?.titleView = view
    }
    
    
    
    func updateDate(startDate:NSDate,endDate:NSDate)->Void
    {
        if btnRange.isSelected == true{
            dictRegion = ["oem": "", "claim_type": "EW","start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate)]
            WebserviceCallingForEWClaims()
            dictRegion = ["oem": "", "claim_type": "AMC","start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate)]
            WebserviceCallingForAMCClaims()
        }
    }
    
   
    
    
    /*MARK: -API INTEGRATION
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
                    let dataArray = info["data"] as! NSArray
                if dataArray.count != 0 {
                    let Data = dataArray.object(at: 0)as! NSDictionary
                        let arrayproduct = info["oem"] as! NSArray
                        self.masterList = arrayproduct.mutableCopy() as! NSMutableArray
                    let arrayproductclaim = Data["claim_approval_status"] as! NSArray
                    self.claim_approval_status = arrayproductclaim.mutableCopy() as! NSMutableArray
                     let arrayproductclaimno = Data["total_claim_arr"] as! NSArray
                    self.claim_nos = arrayproductclaimno.mutableCopy() as! NSMutableArray
                        
                        self.claim_lacs = NSMutableArray.init()
                    let arrayproductclaimarr = Data["claim_amount_arr"]  as! NSArray

                    let object = arrayproductclaimarr.mutableCopy() as! NSMutableArray
                            for num1 in object {
                                guard let num1 = num1 as? NSNumber else {
                                    continue
                                }
                                let value = num1.floatValue / 100000
                                let strvalues = String(format: "%.2f", value)
                                
                                self.claim_lacs.add(strvalues)
                            
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
            SVProgressHUD.dismiss()
            KSToastView.ks_showToast(error.localizedDescription)
        }
        
    
    }
    
    
    func WebserviceCallingForAMCClaims()
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
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0 {
                        let Data = dataArray.object(at: 0)as! NSMutableDictionary
                        let arrayproduct = info["oem"] as! NSArray
                        self.masterList = arrayproduct.mutableCopy() as! NSMutableArray
                        let arrayproductsta = Data["claim_approval_status"] as! NSArray
                        self.AMC_approval_status = arrayproductsta.mutableCopy() as! NSMutableArray
                        let arrayproductno = Data["total_claim_arr"] as! NSArray

                        self.AMC_claim_nos = arrayproductno.mutableCopy() as! NSMutableArray

                        self.AMC_claim_lacs = NSMutableArray.init()
                        let arrayproductarr = Data["claim_amount_arr"] as! NSArray

                        let object = arrayproductarr.mutableCopy() as! NSMutableArray
                        for num1 in object {
                            guard let num1 = num1 as? NSNumber else {
                                continue
                            }
                            let value = num1.floatValue / 10000000
                            let strvalues = String(format: "%.2f", value)
                            
                            self.AMC_claim_lacs.add(strvalues)
                            
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
