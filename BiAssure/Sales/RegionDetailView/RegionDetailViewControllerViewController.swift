//
//  RegionDetailViewControllerViewController.swift
//  BiAssure
//
//  Created by Pulkit on 04/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import SVProgressHUD
import SSMaterialCalendarPicker
import Charts
import KSToastView
import AFNetworking
import RMPickerViewController

class RegionDetailViewControllerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ChartViewDelegate,SSMaterialCalendarPickerDelegate {
    
    var adtBarChartView : BarChartView!
    var pieChartOEMDetail : PieChartView!
    var horiBarChartview : HorizontalBarChartView!
    var viewModel : UIView!
    var btnallCampaings : UIButton!
    var btncalender : UIButton!
    var strsetdate = ""
    @IBOutlet var btnDaily : UIButton!
    @IBOutlet var btnMonth : UIButton!
    @IBOutlet var btnRange : UIButton!
    @IBOutlet var lblLine1 : UILabel!
    @IBOutlet var lblLine2 : UILabel!
    @IBOutlet var lblLine3 : UILabel!
    @IBOutlet var tblOEMShow : UITableView!
    var strDateRange = ""
    @IBOutlet var tblChartData : UITableView!
    //daily
    var showTodayDate = NSArray()
    var showPreviousDate = NSArray()
    var StrCurrentDate = ""
    var StrPreDate = ""
    var dictStartDateEndDate = NSDictionary()
    var arrRevenue = NSMutableArray()
    var arrSales = NSMutableArray()
    var arrPerRevenue = NSMutableArray()
    var arrPerSales = NSMutableArray()
    var dailytblIndexpath = NSIndexPath()
    
    var strcurrent_day_month = ""
    var first_day_month = ""
    var prestrcurrent_day_month = ""
    var prefirst_day_month = ""
    
    var strStartdate = ""
    var strEnddate = ""
    var prestartdate = ""
    var preenddate = ""
    
    var salseAVG = ""
    var RevenueAVG = ""
    var refreshControl : UIRefreshControl!
    
    var arrbarChartSales = NSMutableArray()
    var arrbarPerSales = NSMutableArray()
    var arrHbarChartSales = NSMutableArray()
    var arrHbarPerSales = NSMutableArray()
    var arrRegionRev = NSMutableArray()
    var arrModelRev = NSMutableArray()
    
    var Region = ""
    var apistr = ""
    var strRegionModel = ""
    var strRegionName = ""
    var strOEM = ""
    var masterList0 = NSMutableArray()
    var masterList2 = NSMutableArray()
    var masterList3 = NSMutableArray()
    var campiagnDateLable : UILabel!
    var regionName = ""
    var startDate : NSDate!
    var endDate : NSDate!
    var sePicker : CustomPicker!
    var dictRegion = NSDictionary()
    var dictPreRegion = NSDictionary()
    var appDelegate :AppDelegate = AppDelegate()
    var revenue = Float()
    var prerevenue = Float()
    var selectedIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        startDate = NSDate.init()
        endDate = NSDate.init()
        self.style()
        refreshControl = UIRefreshControl.init()
        refreshControl.backgroundColor = UIColor.purple
        refreshControl.tintColor = UIColor.white
        refreshControl .addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tblOEMShow .addSubview(refreshControl)
        self.configureView()
        
    }
    
    @objc func refreshTable()
    {
        refreshControl.endRefreshing()
        self .CurentDateWebserviceCallingMethod()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        let strname = appDelegate.getbuttonName()
        if strname == "Month"
        {
            btnDaily.isSelected = false
            btnMonth.isSelected = true
            btnRange.isSelected = false
            lblLine1.isHidden = true
            lblLine2.isHidden = false
            lblLine3.isHidden = true
            sePicker .removePickerViewWithAnimaion(sourceView: self.view)
            
            self.refreshMethod()
            appDelegate.storebuttonName(button: "Month")
            if strRegionModel == "Regionwise"
            {
                dictRegion = ["report_type":"cmth","brand":apistr,"oem":strOEM,"region":strRegionName]
                dictPreRegion = ["report_type":"pmth","brand":apistr,"oem":strOEM,"region":strRegionName]
            }
            else{
                dictRegion = ["report_type":"cmth","brand":apistr,"oem":strOEM,"model":strRegionName]
                dictPreRegion = ["report_type":"pmth","brand":apistr,"oem":strOEM,"model":strRegionName]
            }
            
            
            self.CurentDateWebserviceCallingMethod()
        }
        else if strname == "Range"
        {
            btnDaily.isSelected = false
            btnMonth.isSelected = false
            btnRange.isSelected = true
            lblLine1.isHidden = true
            lblLine2.isHidden = true
            lblLine3.isHidden = false
            
            
            self.refreshMethod()
            appDelegate.storebuttonName(button: "Range")
            sePicker .showPickerViewWithAnimation(sourceView: self.view)
        }
        else{
            btnDaily.isSelected = true
            btnMonth.isSelected = false
            btnRange.isSelected = false
            lblLine1.isHidden = false
            lblLine2.isHidden = true
            lblLine3.isHidden = true
            
            sePicker .removePickerViewWithAnimaion(sourceView: self.view)
            
            self.refreshMethod()
            if strRegionModel == "Regionwise"
            {
                dictRegion = ["report_type":"tdy","brand":apistr,"oem":strOEM,"region":strRegionName]
                dictPreRegion = ["report_type":"ydy","brand":apistr,"oem":strOEM,"region":strRegionName]
                dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"model":"all"]
                
                self.ModelChartDataShowMethod()
            }
            else{
                dictRegion = ["report_type":"tdy","brand":apistr,"oem":strOEM,"model":strRegionName]
                dictPreRegion = ["report_type":"ydy","brand":apistr,"oem":strOEM,"model":strRegionName]
                dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"region":"all"]
                self.ChartDataShowMethod()
            }
            
            
            appDelegate.storebuttonName(button: "Daily")
            self.CurentDateWebserviceCallingMethod()
        }
    }
    func style ()
    {
        let view = UIView.init(frame: CGRect(x: -30, y: 0, width: 150, height: 33))
        let imageView = UIImageView.init(frame: CGRect(x: -30, y: 5, width: 20, height: 25))
        if strRegionModel == "Regionwise"
        {
            imageView.image = UIImage.init(named: "Regions-icon-white")
        }
        else{
            imageView.image = UIImage.init(named: "models-white-icon")
        }
        
        let lblTitle = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        lblTitle.text = Region
        lblTitle.textColor = UIColor.white
        lblTitle.font = UIFont.systemFont(ofSize: 13)
        
        view .addSubview(imageView)
        view.addSubview(lblTitle)
        self.navigationItem.titleView = view
        
        let backButton  = UIButton.init(type: .custom)
        backButton.frame = CGRect(x: -140, y: 0, width: 130, height: 22)
        backButton .setImage(UIImage.init(named: "arrow-left"), for: .normal)
        if strRegionModel == "Regionwise"
        {
            backButton .setTitle("Regions", for: .normal)
        }
        else{
            backButton .setTitle("Models", for: .normal)
        }
        
        backButton.addTarget(self, action: #selector(btnDashboard_didSelect(_:)), for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -50, bottom: 0, right: 0)
        backButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -30, bottom: 0, right: 0)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        
        let menuButton  = UIButton.init(type: .custom)
        menuButton.frame = CGRect(x: 30, y: 0, width: 52, height: 40)
        menuButton .setImage(UIImage.init(named: "right-menu-icon"), for: .normal)
        
        menuButton.addTarget(self, action: #selector(slidemenuAction(_:)), for: .touchUpInside)
        menuButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 25, bottom: 0, right: 0)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: menuButton)
    }
    @IBAction func btnLeft_didSelect(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDashboard_didSelect(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func slidemenuAction(_ sender: UIBarButtonItem)
    {
        kMainViewController .showRightView(animated: true, completionHandler: nil)
    }
    func configureView()
    {
        sePicker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?[0] as? CustomPicker
        weak var weakSelf = self
        sePicker.addPicker(on: self.view) { (strt, end) in
            weakSelf?.updateData(startDate: strt! as NSDate, endDate: end! as NSDate)
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblOEMShow
        {
            return 4
        }
        else{
            if (dailytblIndexpath.row == 1)
            {
                return masterList0.count
            }
            else if (dailytblIndexpath.row == 2)
            {
                return masterList2.count
            }
            else
            {
                return masterList3.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblOEMShow
        {
            dailytblIndexpath = indexPath as NSIndexPath
            if dailytblIndexpath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableviewCell0")
                
                let lblCurrentDateNo = cell?.viewWithTag(10) as! UILabel
                let lblCurrentRemDate = cell?.viewWithTag(11) as! UILabel
                let lblCurrentSales = cell?.viewWithTag(12) as! UILabel
                let lblCurrentRevenue = cell?.viewWithTag(13) as! UILabel
                let lblMonthRangeCu = cell?.viewWithTag(22) as! UILabel
                let lblPolicySoldCu = cell?.viewWithTag(18) as! UILabel
                let btnSaleShow = cell?.viewWithTag(45) as! UIButton
                let btnRevenueShow = cell?.viewWithTag(46) as! UIButton
                
                let lblPreDateNo = cell?.viewWithTag(14) as! UILabel
                let lblPreRemDate = cell?.viewWithTag(15) as! UILabel
                let lblPreSales = cell?.viewWithTag(16) as! UILabel
                let lblPreRevnue = cell?.viewWithTag(17) as! UILabel
                let lblMonthRangePre = cell?.viewWithTag(44) as! UILabel
                let lblPolicySoldPre = cell?.viewWithTag(19) as! UILabel
                
                if btnMonth.isSelected
                {
                    lblCurrentDateNo.isHidden = true
                    lblPreDateNo.isHidden = true
                    lblMonthRangeCu.isHidden = false
                    lblMonthRangePre.isHidden = false
                    lblPreRemDate.isHidden = false
                    lblCurrentRemDate.isHidden = false
                    
                    if strcurrent_day_month != ""
                    {
                        let currentDay = Utilities.sharedUtilities.MonthDateConversion(serverDate: strcurrent_day_month)
                        let items = currentDay.components(separatedBy: " ") as NSArray
                        
                        let firstDay = Utilities.sharedUtilities.overViewDateConversion(serverDate: first_day_month)
                        let itemsfirst = firstDay.components(separatedBy: " ") as NSArray
                        
                        lblMonthRangeCu.text = "\(itemsfirst.object(at: 0)) - \(items.object(at: 0))"
                        lblCurrentRemDate.text = "\(items.object(at: 1)) \(items.object(at: 2))"
                    }
                    
                    if prestrcurrent_day_month != ""
                    {
                        let previousDate = Utilities.sharedUtilities.MonthDateConversion(serverDate: prestrcurrent_day_month)
                        let Preitems = previousDate.components(separatedBy: " ") as NSArray
                        
                        let previousfirstDate = Utilities.sharedUtilities.MonthDateConversion(serverDate: prefirst_day_month)
                        let Prefirstitems = previousfirstDate.components(separatedBy: " ") as NSArray
                        lblMonthRangePre.text = "\(Prefirstitems.object(at: 0)) - \(Preitems.object(at: 0))"
                        lblPreRemDate.text = "\(Preitems.object(at: 1)) \(Preitems.object(at: 2))"
                    }
                    
                }
                else if btnRange.isSelected
                {
                    lblCurrentDateNo.isHidden = true
                    lblPreDateNo.isHidden = true
                    lblMonthRangeCu.isHidden = false
                    lblMonthRangePre.isHidden = false
                    lblPreRemDate.isHidden = false
                    lblCurrentRemDate.isHidden = false
                    
                    if strStartdate != ""
                    {
                        let startdate = Utilities.sharedUtilities.RengeDateConversion(serverDate: strStartdate)
                        let enddate = Utilities.sharedUtilities.RengeDateConversion(serverDate: strEnddate)
                        lblMonthRangeCu.text = startdate
                        lblCurrentRemDate.text = enddate
                    }
                    
                    if prestartdate != ""
                    {
                        let prestartDate = Utilities.sharedUtilities.RengeDateConversion(serverDate: prestartdate)
                        let preendDate = Utilities.sharedUtilities.RengeDateConversion(serverDate: preenddate)
                        lblMonthRangePre.text = prestartDate
                        lblPreRemDate.text = preendDate
                    }
                    
                }
                else{
                    lblCurrentDateNo.isHidden = false
                    lblPreDateNo.isHidden = false
                    lblMonthRangeCu.isHidden = true
                    lblMonthRangePre.isHidden = true
                    lblPreRemDate.isHidden = false
                    lblCurrentRemDate.isHidden = false
                    
                    if StrCurrentDate != ""
                    {
                        let currentDate = Utilities.sharedUtilities.overViewDateConversion(serverDate: StrCurrentDate)
                        let items = currentDate.components(separatedBy: " ") as NSArray
                        lblCurrentDateNo.text = items.object(at: 0) as? String
                        lblCurrentRemDate.text = "\(items.object(at: 1)) \(items.object(at: 2))"
                    }
                    
                    if StrPreDate != ""
                    {
                        let previousDate = Utilities.sharedUtilities.overViewDateConversion(serverDate: StrPreDate)
                        let Preitems = previousDate.components(separatedBy: " ") as NSArray
                        lblPreDateNo.text = "\(Preitems.object(at: 0))"
                        lblPreRemDate.text = "\(Preitems.object(at: 1)) \(Preitems.object(at: 2))"
                    }
                    
                }
                if showTodayDate.count != 0
                {
                    let dictData = showTodayDate.object(at: 0) as! NSDictionary
                    if let val = dictData["TotalSales"] as? NSNumber {
                        lblCurrentSales.text = val.stringValue
                    }
                    
                    if btnMonth.isSelected
                    {
                        lblPolicySoldCu.text = "POLICY SOLD (CRORES)"
                        if let Revval = dictData["TotalRevenue"] as? NSNumber
                        {
                            revenue = Revval.floatValue / 10000000
                        }
                        
                    }
                    else
                    {
                        lblPolicySoldCu.text = "POLICY SOLD (LACS)"
                        if let Revval = dictData["TotalRevenue"] as? NSNumber
                        {
                            revenue = Revval.floatValue / 100000
                        }
                        
                    }
                    
                    let strresult = NSString(format: "%.1f", revenue)
                    lblCurrentRevenue.text = strresult as String
                }
                else{
                    lblCurrentSales.text = "0"
                    lblCurrentRevenue.text = "0"
                    showTodayDate = NSArray.init()
                    
                }
                if showPreviousDate.count != 0
                {
                    let dictData = showPreviousDate.object(at: 0) as! NSDictionary
                    if let val = dictData["TotalSales"] as? NSNumber {
                        lblPreSales.text = val.stringValue
                    }
                    
                    
                    if btnMonth.isSelected
                    {
                        lblPolicySoldPre.text = "POLICY SOLD (CRORES)"
                        if let Revval = dictData["TotalRevenue"] as? NSNumber
                        {
                            prerevenue = Revval.floatValue / 10000000
                        }
                        
                    }
                    else{
                        lblPolicySoldPre.text = "POLICY SOLD (LACS)"
                        if let Revval = dictData["TotalRevenue"] as? NSNumber
                        {
                            prerevenue = Revval.floatValue / 100000
                        }
                        
                    }
                    
                    lblPreRevnue.text = NSString(format: "%.1f", prerevenue) as String
                    let demo = Float(salseAVG)
                    
                    btnSaleShow .setTitle(NSString(format: "%.1f%%", demo!*100) as String, for: .normal)
                    
                    let demoRev = Float(RevenueAVG)
                    
                    btnRevenueShow .setTitle(NSString(format: "%.1f%%", demoRev!*100) as String, for: .normal)
                    
                    if demo! < 1
                    {
                        btnSaleShow .setImage(UIImage.init(named: "down-arrow_wh"), for: .normal)
                    }
                    else{
                        btnSaleShow .setImage(UIImage.init(named: "up-arrow"), for: .normal)
                    }
                    
                    if demoRev! < 1
                    {
                        btnRevenueShow .setImage(UIImage.init(named: "down-arrow_wh"), for: .normal)
                    }
                    else{
                        btnRevenueShow .setImage(UIImage.init(named: "up-arrow"), for: .normal)
                    }
                }
                else{
                    lblPreSales.text = "0"
                    lblPreRevnue.text = "0"
                    showPreviousDate = NSArray.init()
                }
                return cell!
            }
            else if dailytblIndexpath.row == 1
            {
                selectedIndex = 1
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableviewCell1")
                
                viewModel = cell?.viewWithTag(1)
                btnallCampaings = cell?.viewWithTag(5) as? UIButton
                btncalender = cell?.viewWithTag(6) as? UIButton
                pieChartOEMDetail = cell?.viewWithTag(100) as? PieChartView
                tblChartData = cell?.viewWithTag(111) as? UITableView
                tblChartData.dataSource = self
                tblChartData.delegate = self
                
                
                if strRegionModel == "Regionwise"
                {
                    btnallCampaings .setTitle("All Models", for: .normal)
                    btnallCampaings.setImage(UIImage.init(named: "models-gray-icon"), for: .normal)
                    self.configurePieChart(pieChart: pieChartOEMDetail, arrchart: arrRevenue)
                }
                else{
                    btnallCampaings .setTitle("All Regions", for: .normal)
                    btnallCampaings.setImage(UIImage.init(named: "Regions-icon-gray"), for: .normal)
                    self.configurePieChart(pieChart: pieChartOEMDetail, arrchart: arrSales)
                }
                
                btnallCampaings .addTarget(self, action: #selector(allCampaingsAction(_:)), for: .touchUpInside)
                btncalender.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside)
                btncalender .setTitle(strsetdate, for: .normal)
                
                btnallCampaings.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -12, bottom: 0, right: 0)
                btnallCampaings.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -16, bottom: 0, right: 0)
                
                tblChartData.reloadData()
                cell?.layoutIfNeeded()
                
                return cell!
            }
            else if dailytblIndexpath.row == 2
            {
                selectedIndex = 2
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableviewCell3")
                
                btnallCampaings = cell?.viewWithTag(9) as? UIButton
                btncalender = cell?.viewWithTag(10) as? UIButton
                adtBarChartView = cell?.viewWithTag(300) as? BarChartView
                tblChartData = cell?.viewWithTag(333) as? UITableView
                tblChartData.dataSource = self
                tblChartData.delegate = self
                
                btncalender .setTitle(strsetdate, for: .normal)
                self.configureBarChartGraph(barChartView: adtBarChartView, arrchart: arrbarChartSales)
                btncalender.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside)
                tblChartData.reloadData()
                
                return cell!
            }
            else{
                selectedIndex = 3
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableviewCell4")
                btnallCampaings = cell?.viewWithTag(11) as? UIButton
                btncalender = cell?.viewWithTag(12) as? UIButton
                horiBarChartview = cell?.viewWithTag(400) as? HorizontalBarChartView
                tblChartData = cell?.viewWithTag(444) as? UITableView
                tblChartData.dataSource = self
                tblChartData.delegate = self
                
                btncalender .setTitle(strsetdate, for: .normal)
                btncalender.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside)
                self.configreHorizontalChartGraph(horiGraph: horiBarChartview, arrchart: arrHbarChartSales)
                tblChartData.reloadData()
                return cell!
            }
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1")
            let lblicon = cell?.viewWithTag(112) as! UILabel
            let lblname = cell?.viewWithTag(113) as! UILabel
            let lblsales = cell?.viewWithTag(114) as! UILabel
            
            lblicon.layer.cornerRadius = lblicon.frame.size.width / 2
            print("\(Utilities.sharedUtilities.colorArray().count)")
            let color = Utilities.sharedUtilities.colorArray().object(at: indexPath.row)
            lblicon.backgroundColor = color as? UIColor
            lblicon.layer.masksToBounds = true
            
            
            if selectedIndex == 1
            {
                let Name = masterList0.object(at: indexPath.row) as! NSString
                lblname.text = Name .capitalized
                let lblrevenue = cell?.viewWithTag(115) as! UILabel
                
                if strRegionModel == "Regionwise"
                {
                    let salesValue = arrRevenue.object(at: indexPath.row) as! NSNumber
                    lblsales.text = NSString(format: "%.1f", salesValue.floatValue) as String
                    let revenueValue = (arrPerRevenue.object(at: indexPath.row) as AnyObject).floatValue * 100
                    lblrevenue.text = NSString(format: "%.1f%%", revenueValue) as String
                }
                else
                {
                    lblsales.text = NSString(format: "%@", arrSales.object(at: indexPath.row) as! CVarArg) as String
                    let revenueValue = ((arrPerSales.object(at: indexPath.row)) as AnyObject).floatValue * 100
                    lblrevenue.text = NSString(format: "%.1f%%", revenueValue) as String
                }
            }
            else if selectedIndex == 2
            {
                let lblrevenue = cell?.viewWithTag(115) as! UILabel
                
                lblname.text = "\(masterList2.object(at: indexPath.row))"
                
                
                if lblname.text == "0 - 60" || lblname.text == "0 - 30" || lblname.text == "0 - 90" || lblname.text == "0 - 45"
                {
                    lblsales.text = "Sales"
                }
                else{
                    lblsales.text = "Service"
                }
                //lblrevenue.text = arrbarChartSales.object(at: indexPath.row) as? String
                lblrevenue.text = NSString(format: "%@", arrbarChartSales.object(at: indexPath.row) as! CVarArg) as String
                
                
            }
            else{
                
                lblname.text = "\(masterList3.object(at: indexPath.row))"
                
                
                lblsales.text = NSString(format: "%@", arrHbarChartSales.object(at: indexPath.row) as! CVarArg) as String
                
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblOEMShow
        {
            if indexPath.row == 0
            {
                return 361.0
            }
            else{
                if (indexPath.row == 1)
                {
                    return self.ArraySizeCellSizeEstimation(array: masterList0)
                }else if (indexPath.row == 2)
                {
                    return self.ArraySizeCellSizeEstimation(array: masterList2)
                }else
                {
                    return self.ArraySizeCellSizeEstimation(array: masterList3)
                }
            }
        }
        else{
            return 35
        }
    }
    func ArraySizeCellSizeEstimation(array : NSMutableArray)-> CGFloat
    {
        if array.count <= 1
        {
            return 390.0
        }
        else if array.count == 2 || array.count == 3
        {
            return 460.0
        }
        else
            if (array.count == 4)
            {
                return 500.0
            }else if (array.count <= 8)
            {
                return 640.0
            }
            else if (array.count <= 11)
            {
                return 750.0
            }
            else if (array.count < 19)
            {
                return 1000.0
            }
            else if (array.count < 24)
            {
                return 1180.0
            }
            else
            {
                return 1250.0
        }
    }
    
    
    @IBAction func changeDate(_ sender : UIButton)
    {
        sePicker.showPickerViewWithAnimation(sourceView: self.view)
    }
    @IBAction func allCampaingsAction(_ sender : UIButton)
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if strRegionModel != "Regionwise"
        {
            let regionVC = storyboard.instantiateViewController(withIdentifier: "RegionShowViewController") as! RegionShowViewController
            regionVC.arrRegionSales = arrSales
            regionVC.arrRegionPerSales = arrPerSales
            regionVC.masterList = masterList0
            regionVC.strRegionname = Region
            regionVC.arrRegionRevenue = arrRegionRev
            regionVC.strdate = strsetdate
            regionVC.apistr = apistr
            regionVC.strCome = "RegionCome"
            regionVC.strOEMname = strOEM
            
            self.navigationController?.pushViewController(regionVC, animated: true)
        }
        else
        {
            let modelVC = storyboard.instantiateViewController(withIdentifier: "ModelShowViewController") as! ModelShowViewController
            modelVC.arrRegionSales = arrRevenue
            modelVC.arrRegionPerSales = arrPerRevenue
            modelVC.masterList = masterList0
            modelVC.strRegionname = Region
            modelVC.arrRegionRevenue = arrModelRev
            modelVC.strdate = strsetdate
            modelVC.apistr = apistr
            modelVC.strCome = "ModelCome"
            modelVC.strOEMname = strOEM
            
            self.navigationController?.pushViewController(modelVC, animated: true)
        }
    }
    func updateData(startDate:NSDate,endDate:NSDate)
    {
        strsetdate = "\(Utilities.sharedUtilities.getDuration(date: startDate as NSDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate as NSDate))"
        if btnRange.isSelected
        {
            if strRegionModel == "Regionwise"
            {
                dictRegion = ["report_type" : "crc",
                              "start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),
                              "end_date" : Utilities.sharedUtilities.overViewDate(date: endDate),"brand":apistr,"oem":strOEM,"region":strRegionName]
                
                dictPreRegion = ["report_type" : "crp","start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate),"brand":apistr,"oem":strOEM,"region":strRegionName]
            }
            else{
                dictRegion = ["report_type" : "crc",
                              "start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),
                              "end_date" : Utilities.sharedUtilities.overViewDate(date: endDate),"brand":apistr,"oem":strOEM,"model":strRegionName]
                
                dictPreRegion = ["report_type" : "crp","start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate),"brand":apistr,"oem":strOEM,"model":strRegionName]
            }
            
            self.CurentDateWebserviceCallingMethod()
            
        }
        else{
            dictStartDateEndDate = ["start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" :  Utilities.sharedUtilities.overViewDate(date: endDate),"brand":apistr,"oem":strOEM,"model":strRegionName,"report_type":"modelwise"]
            
            self.ChartDataShowMethod()
            self.ModelChartDataShowMethod()
            self.SlabsChartDataShowMethod()
            self.PlansChartDataShowMethod()
        }
    }
    func rangeSelected(withStart startDate: Date!, andEnd endDate: Date!) {
        self.startDate = startDate as NSDate?
        self.endDate = endDate as NSDate?
        strsetdate = "\(Utilities.sharedUtilities.getDuration(date: startDate! as NSDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate! as NSDate))"
        
    }
    @IBAction func btnDaily_didSelect(_ sender: UIButton)
    {
        btnDaily.isSelected = true
        btnMonth.isSelected = false
        btnRange.isSelected = false
        lblLine1.isHidden = false
        lblLine2.isHidden = true
        lblLine3.isHidden = true
        
        sePicker .removePickerViewWithAnimaion(sourceView: self.view)
        
        self.refreshMethod()
        
        if strRegionModel == "Regionwise"
        {
            dictRegion = ["report_type":"tdy","brand":apistr,"oem":strOEM,"region":strRegionName]
            dictPreRegion = ["report_type":"ydy","brand":apistr,"oem":strOEM,"region":strRegionName]
            dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"model":"all"]
            
            self.ModelChartDataShowMethod()
        }
        else{
            dictRegion = ["report_type":"tdy","brand":apistr,"oem":strOEM,"model":strRegionName]
            dictPreRegion = ["report_type":"ydy","brand":apistr,"oem":strOEM,"model":strRegionName]
            dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"region":"all"]
            self.ChartDataShowMethod()
        }
        
        appDelegate.storebuttonName(button: "Daily")
        
        self.CurentDateWebserviceCallingMethod()
    }
    
    @IBAction func btnMonth_didSelect(_ sender:UIButton)
    {
        btnDaily.isSelected = false
        btnMonth.isSelected = true
        btnRange.isSelected = false
        lblLine1.isHidden = true
        lblLine2.isHidden = false
        lblLine3.isHidden = true
        
        sePicker .removePickerViewWithAnimaion(sourceView: self.view)
        
        self.refreshMethod()
        
        if strRegionModel == "Regionwise"
        {
            dictRegion = ["report_type":"cmth","brand":apistr,"oem":strOEM,"region":strRegionName]
            dictPreRegion = ["report_type":"pmth","brand":apistr,"oem":strOEM,"region":strRegionName]
        }
        else{
            dictRegion = ["report_type":"cmth","brand":apistr,"oem":strOEM,"model":strRegionName]
            dictPreRegion = ["report_type":"pmth","brand":apistr,"oem":strOEM,"model":strRegionName]
        }
        
        
        appDelegate.storebuttonName(button: "Month")
        
        self.CurentDateWebserviceCallingMethod()
    }
    
    @IBAction func btnRange_didSelect(_ sender : UIButton)
    {
        btnDaily.isSelected = false
        btnMonth.isSelected = false
        btnRange.isSelected = true
        lblLine1.isHidden = true
        lblLine2.isHidden = true
        lblLine3.isHidden = false
        
        
        self.refreshMethod()
        appDelegate.storebuttonName(button: "Range")
        sePicker .showPickerViewWithAnimation(sourceView: self.view)
    }
    func refreshMethod()
    {
        let MyIP = NSIndexPath.init(row: 0, section: 0)
        regionName = ""
        
        selectedIndex = 0
        showTodayDate = NSArray.init()
        showPreviousDate = NSArray.init()
        masterList0 = NSMutableArray.init()
        arrPerRevenue = NSMutableArray.init()
        arrPerSales = NSMutableArray.init()
        arrSales = NSMutableArray.init()
        arrRegionRev = NSMutableArray.init()
        arrRevenue = NSMutableArray.init()
        arrModelRev = NSMutableArray.init()
        
        masterList2 = NSMutableArray.init()
        arrbarPerSales = NSMutableArray.init()
        arrbarChartSales = NSMutableArray.init()
        
        masterList3 = NSMutableArray.init()
        arrHbarChartSales = NSMutableArray.init()
        arrHbarPerSales = NSMutableArray.init()
        tblOEMShow.reloadData()
        
        tblOEMShow.scrollToRow(at: MyIP as IndexPath, at: .top, animated: true)
        
    }
    
    func configreHorizontalChartGraph(horiGraph:HorizontalBarChartView,arrchart:NSArray)
    {
        let xVals = NSMutableArray.init()
        
        for eachData in arrchart
        {
            xVals.add(eachData)
        }
        
        let dataSets = NSMutableArray.init()
        let colors = NSMutableArray.init(array: Utilities.sharedUtilities.colorArray())
        colors.add(ChartColorTemplates.joyful())
        colors.add(ChartColorTemplates.colorful())
        
        var i = 0
        var barChartdataEntry1: [BarChartDataEntry] = []
        for eachData1 in arrchart
        {
            let eachData = eachData1 as! NSNumber
            let dataEntry  = BarChartDataEntry.init(x: Double(i), y: Double(eachData.floatValue))
            barChartdataEntry1.append(dataEntry)
            i+=1
        }
        
        let set1  = BarChartDataSet.init(entries:barChartdataEntry1, label: "" )
        set1.axisDependency = .left
        set1.drawIconsEnabled = true
        set1.highlightColor = UIColor.red
        set1.drawValuesEnabled = false
        
        let colorapp =  NSMutableArray.init()
        for j in 0..<arrchart.count {
            
            let color = colors.object(at: j)
            colorapp.add(color)
            
        }
        
        set1.colors = colorapp as! [NSUIColor]
        dataSets.add(set1)
        
        let l = horiGraph.legend
        l.horizontalAlignment = Legend.HorizontalAlignment.left
        l.verticalAlignment = Legend.VerticalAlignment.bottom
        l.orientation = Legend.Orientation.horizontal
        l.drawInside = false
        l.form = Legend.Form.square
        l.formSize = 9.0
        l.font = UIFont.systemFont(ofSize: 10)
        l.xEntrySpace = 4.0
        
        self.setupBarLineChartView(chartView: horiGraph)
        horiGraph.delegate = self
        horiGraph.drawBarShadowEnabled = false
        horiGraph.drawValueAboveBarEnabled = true
        horiGraph.leftAxis.enabled = false
        horiGraph.rightAxis.enabled = false
        horiGraph.xAxis.enabled = false
        horiGraph.xAxis.axisRange = 0
        
        let xAxis = horiGraph.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0
        xAxis.labelCount = 7
        
        let data = BarChartData.init(dataSet: set1)
        data.setValueTextColor(UIColor.black)
        data.setValueFont(UIFont.systemFont(ofSize: 9))
        data.setDrawValues(true)
        
        horiGraph.data = data
        horiGraph.animate(yAxisDuration: 2)
    }
    
    func configureBarChartGraph(barChartView : BarChartView,arrchart : NSArray)
    {
        let xVals = NSMutableArray.init()
        
        for eachData in arrchart
        {
            xVals.add(eachData)
        }
        
        let dataSets = NSMutableArray.init()
        let colors = NSMutableArray.init(array: Utilities.sharedUtilities.colorArray())
        colors.add(ChartColorTemplates.joyful())
        colors.add(ChartColorTemplates.colorful())
        
        var i = 0
        var barChartdataEntry1: [BarChartDataEntry] = []
        for eachData1 in arrchart
        {
            let eachData = eachData1 as! NSNumber
            let dataEntry  = BarChartDataEntry.init(x: Double(i), y: Double(eachData.floatValue))
            barChartdataEntry1.append(dataEntry)
            i+=1
        }
        
        let set1  = BarChartDataSet.init(entries:barChartdataEntry1, label: "" )
        set1.axisDependency = .left
        set1.drawIconsEnabled = true
        set1.highlightColor = UIColor.red
        set1.drawValuesEnabled = false
        
        let colorapp =  NSMutableArray.init()
        for j in 0..<arrchart.count {
            
            let color = colors.object(at: j)
            colorapp.add(color)
            
        }
        
        set1.colors = colorapp as! [NSUIColor]
        dataSets.add(set1)
        
        let l = barChartView.legend
        l.horizontalAlignment = Legend.HorizontalAlignment.left
        l.verticalAlignment = Legend.VerticalAlignment.bottom
        l.orientation = Legend.Orientation.horizontal
        l.drawInside = false
        l.form = Legend.Form.square
        l.formSize = 9.0
        l.font = UIFont.systemFont(ofSize: 10)
        l.xEntrySpace = 4.0
        self.setupBarLineChartView(chartView: barChartView)
        barChartView.delegate = self
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = true
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.enabled = true
        barChartView.xAxis.axisRange = 0
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 0)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0
        xAxis.labelCount = 7
        
        let data = BarChartData.init(dataSet: set1)
        data.setValueTextColor(UIColor.black)
        data.setValueFont(UIFont.systemFont(ofSize: 9))
        data.setDrawValues(true)
        
        barChartView.data = data
        barChartView.animate(yAxisDuration: 2)
    }
    func setupBarLineChartView(chartView:BarLineChartViewBase)
    {
        chartView.chartDescription?.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.isUserInteractionEnabled = false
        
        chartView.rightAxis.enabled = false
    }
    
    func configurePieChart(pieChart: PieChartView ,arrchart : NSArray)
    {
        self.setupPieChartView(chartView: pieChart)
        pieChart.holeColor = UIColor.white
        pieChart.rotationEnabled = true
        pieChart.highlightPerTapEnabled = true
        pieChart.centerTextOffset = CGPoint(x: 0.0, y: 0.0)
        if arrchart.count == 0
        {
            pieChart.centerText = "No data available"
        }
        else
        {
            if strRegionModel == "Regionwise"
            {
                pieChart.centerText = "All Models"
            }
            else{
                pieChart.centerText = "All Regions"
            }
            
        }
        var i = 0
        let values = NSMutableArray.init()
        for eachData in arrchart {
            let datas =  Double((eachData as AnyObject).floatValue * 100)
            let data = PieChartDataEntry(value: Double(datas))
            
            i += 1
            values.add(data)
        }
        
        let dataSet = PieChartDataSet.init(entries: values as? [ChartDataEntry], label: "")
        dataSet.sliceSpace = 1.0
        dataSet.selectionShift = 5.0
        dataSet.valueLineWidth = 10
        dataSet.drawValuesEnabled = true
        dataSet.entryLabelFont = UIFont.systemFont(ofSize: 0.0)
        dataSet.valueTextColor = UIColor.clear
        
        let colors = NSMutableArray.init(array: Utilities.sharedUtilities.colorArray())
        colors.add(ChartColorTemplates.joyful())
        colors.add(ChartColorTemplates.colorful())
        
        dataSet.colors = colors as! [NSUIColor]
        
        let data : PieChartData = PieChartData.init(dataSet: dataSet)
        pieChart.data = data
        pieChart.setNeedsDisplay()
        pieChart.animate(xAxisDuration: 1.0)
    }
    
    func setupPieChartView(chartView: PieChartView)
    {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.chartDescription?.enabled = false
        chartView .setExtraOffsets(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0)
        chartView.drawCenterTextEnabled = true
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = Legend.HorizontalAlignment.left
        l.verticalAlignment = Legend.VerticalAlignment.bottom
        l.orientation = Legend.Orientation.vertical
        l.drawInside = false
        l.xEntrySpace = 0.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
    }
    
    func CurentDateWebserviceCallingMethod()
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
        
        
        let Url = "http://bi.servassure.net/api/"
        manager .post("\(Url)SalesOverview", parameters: dictRegion, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            if let jsonResponse = responseObject as? [String: AnyObject]
            {
                print("JSON: \(jsonResponse)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Bool == true
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0
                    {
                        self.showTodayDate = dataArray.mutableCopy() as! NSMutableArray
                    }
                    if self.btnMonth.isSelected
                    {
                        let addtionInfo = info["addtionalinfo"] as! NSDictionary
                        self.strcurrent_day_month = addtionInfo["date2"] as! String
                        self.first_day_month = addtionInfo["date1"] as! String
                        
                        let currentDay = Utilities .sharedUtilities.MonthDateConversion(serverDate: self.strcurrent_day_month)
                        let items = currentDay.components(separatedBy: " ") as NSArray
                        
                        let firstDay = Utilities.sharedUtilities.overViewDateConversion(serverDate: self.first_day_month)
                        let itemsfirst = firstDay.components(separatedBy: " ") as NSArray
                        
                        self.strsetdate = NSString.init(format: "%@ - %@ %@,%@", itemsfirst.object(at: 0) as! CVarArg,items.object(at: 0) as! CVarArg,items .object(at: 1) as! CVarArg,items.object(at: 2) as! CVarArg) as String
                        if self.strRegionModel == "Regionwise"
                        {
                            self.dictStartDateEndDate  = ["start_date" : self.strStartdate,"end_date" : self.strEnddate,"brand":self.apistr,"oem":self.strOEM,"region":self.strRegionName,"model":"all"]
                            
                            self.ModelChartDataShowMethod()
                        }
                        else{
                            self.dictStartDateEndDate  = ["start_date" : self.strStartdate,"end_date" : self.strEnddate,"brand":self.apistr,"oem":self.strOEM,"region":self.strRegionName,"region":"all","report_type":"modelwise"]
                            self.ChartDataShowMethod()
                        }
                        
                    }
                    else if self.btnRange.isSelected
                    {
                        let addtionInfo = info["addtionalinfo"] as! NSDictionary
                        self.strStartdate = addtionInfo["date1"] as! String
                        self.strEnddate = addtionInfo["date2"] as! String
                        
                        let startdate = Utilities.sharedUtilities.RengeDateConversion(serverDate: self.strStartdate)
                        let enddate = Utilities.sharedUtilities.RengeDateConversion(serverDate: self.strEnddate)
                        self.strsetdate = "\(startdate) - \(enddate)"
                        if self.strRegionModel == "Regionwise"
                        {
                            self.dictStartDateEndDate  = ["start_date" : self.strStartdate,"end_date" : self.strEnddate,"brand":self.apistr,"oem":self.strOEM,"region":self.strRegionName,"model":"all"]
                            
                            self.ModelChartDataShowMethod()
                        }
                        else{
                            self.dictStartDateEndDate  = ["start_date" : self.strStartdate,"end_date" : self.strEnddate,"brand":self.apistr,"oem":self.strOEM,"region":self.strRegionName,"region":"all","report_type":"modelwise"]
                            self.ChartDataShowMethod()
                        }
                        
                    }
                    else{
                        let addtionInfo = info["addtionalinfo"] as! NSDictionary
                        self.StrCurrentDate = addtionInfo["date1"] as! String
                        let currentDate = Utilities.sharedUtilities.MonthDateConversion(serverDate: self.StrCurrentDate)
                        let items = currentDate.components(separatedBy: " ") as NSArray
                        self.strsetdate = "\(items.object(at: 1)) \(items.object(at: 0)),\(items.object(at: 2))"
                        
                    }
                    
                    self.PreviousDateWebserviceCallingMethod()
                }
                else
                {
                    KSToastView .ks_showToast(jsonResponse["message"])
                }
            }
            
        }){ (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
            KSToastView.ks_showToast(error.localizedDescription)
        }
    }
    
    func PreviousDateWebserviceCallingMethod()
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
        
        
        let Url = "http://bi.servassure.net/api/"
        manager .post("\(Url)SalesOverview", parameters: dictPreRegion, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            if let jsonResponse = responseObject as? [String: AnyObject]
            {
                print("JSON: \(jsonResponse)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Bool == true
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0
                    {
                        self.showPreviousDate = dataArray.mutableCopy() as! NSMutableArray
                        if self.showTodayDate.count != 0
                        {
                            let dictdata = self.showPreviousDate.object(at: 0) as! NSDictionary
                            
                            let totalSales = dictdata["TotalSales"] as! NSNumber
                            let Presale : Float = totalSales.floatValue
                            
                            let dictTodaydata = self.showTodayDate.object(at: 0) as! NSDictionary
                            let todaysale = (dictTodaydata["TotalSales"] as! NSNumber).floatValue
                            let AVG = abs(todaysale - Presale)
                            self.salseAVG = NSString(format: "%f", AVG/Presale) as String
                            
                            let newPrerevenue : Float
                            let newRevenue : Float
                            if (self.btnMonth.isSelected == true)
                            {
                                newPrerevenue = (dictdata["TotalRevenue"]as! NSNumber).floatValue / 10000000
                                newRevenue = (dictTodaydata["TotalRevenue"]as! NSNumber).floatValue / 10000000
                            }
                            else
                            {
                                newPrerevenue = (dictdata["TotalRevenue"]as! NSNumber).floatValue / 100000
                                newRevenue = (dictTodaydata["TotalRevenue"]as! NSNumber).floatValue / 100000
                            }
                            
                            let AVGRev = abs(newRevenue - newPrerevenue)
                            self.RevenueAVG = NSString(format: "%f", AVGRev/newPrerevenue) as String
                        }
                    }
                    
                    if self.btnMonth.isSelected
                    {
                        let addtionInfo = info["addtionalinfo"] as! NSDictionary
                        self.prestrcurrent_day_month = addtionInfo["date2"] as! String
                        self.prefirst_day_month = addtionInfo["date1"] as! String
                        
                    }
                    else if self.btnRange.isSelected
                    {
                        let addtionInfo = info["addtionalinfo"] as! NSDictionary
                        self.prestartdate = addtionInfo["date1"] as! String
                        self.preenddate = addtionInfo["date2"] as! String
                        
                    }
                    else{
                        let addtionInfo = info["addtionalinfo"] as! NSDictionary
                        self.StrPreDate = addtionInfo["date1"] as! String
                        
                    }
                    
                    self.tblOEMShow.reloadData()
                    self.SlabsChartDataShowMethod()
                    self.PlansChartDataShowMethod()
                }
                else
                {
                    KSToastView .ks_showToast(jsonResponse["message"])
                }
            }
            
        }){ (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
            KSToastView.ks_showToast(error.localizedDescription)
        }
    }
    func ChartDataShowMethod()
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
        
        
        let Url = "http://bi.servassure.net/api/"
        manager .post("\(Url)SalesOverviewOEMLevel2", parameters: dictStartDateEndDate, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            if let jsonResponse = responseObject as? [String: AnyObject]
            {
                print("JSON: \(jsonResponse)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Bool == true
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0
                    {
                        
                        let data = dataArray.object(at: 0) as! NSDictionary
                        let groupArr = data ["group"] as! NSArray
                        self.masterList0 = groupArr.mutableCopy() as! NSMutableArray
                        let SalesArr = data ["TotalSales"] as! NSArray
                        self.arrSales = SalesArr.mutableCopy() as! NSMutableArray
                        let perSalesArr = data["percentages_sales"] as! NSArray
                        self.arrPerSales = perSalesArr.mutableCopy() as!NSMutableArray
                        
                        self.arrRegionRev = NSMutableArray.init()
                        
                        if self.btnMonth.isSelected
                        {
                            let arrayRev = data["TotalRevenue"]as! NSArray
                            for num in arrayRev
                            {
                                let num1 = num as! NSNumber
                                let value = num1.floatValue / 10000000
                                
                                let strvalues = NSString(format: "%.1f", value)
                                self.arrRegionRev .add(strvalues)
                            }
                        }
                        else{
                            let arrayRev = data["TotalRevenue"]as! NSArray
                            for num in arrayRev
                            {
                                let num1 = num as! NSNumber
                                let value = num1.floatValue / 100000
                                
                                let strvalues = NSString(format: "%.1f", value)
                                self.arrRegionRev .add(strvalues)
                            }
                        }
                    }
                    
                    self.tblOEMShow.reloadData()
                    self.tblChartData.reloadData()
                    
                }
                else
                {
                    KSToastView .ks_showToast(jsonResponse["message"])
                }
            }
            
        }){ (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
            KSToastView.ks_showToast(error.localizedDescription)
        }
    }
    func ModelChartDataShowMethod()
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
        
        
        let Url = "http://bi.servassure.net/api/"
        manager .post("\(Url)SalesOverviewOEMLevel2", parameters: dictStartDateEndDate, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            if let jsonResponse = responseObject as? [String: AnyObject]
            {
                print("JSON: \(jsonResponse)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Bool == true
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0
                    {
                        
                        let data = dataArray.object(at: 0) as! NSDictionary
                        let groupArr = data ["group"] as! NSArray
                        self.masterList0 = groupArr.mutableCopy() as! NSMutableArray
                        let SalesArr = data ["TotalSales"] as! NSArray
                        self.arrRevenue = SalesArr.mutableCopy() as! NSMutableArray
                        let perSalesArr = data["percentages_sales"] as! NSArray
                        self.arrPerRevenue = perSalesArr.mutableCopy() as!NSMutableArray
                        
                        self.arrModelRev = NSMutableArray.init()
                        
                        if self.btnMonth.isSelected
                        {
                            let arrayRev = data["TotalRevenue"]as! NSArray
                            for num in arrayRev
                            {
                                let num1 = num as! NSNumber
                                let value = num1.floatValue / 10000000
                                
                                let strvalues = NSString(format: "%.1f", value)
                                self.arrModelRev .add(strvalues)
                            }
                        }
                        else{
                            let arrayRev = data["TotalRevenue"]as! NSArray
                            for num in arrayRev
                            {
                                let num1 = num as! NSNumber
                                let value = num1.floatValue / 100000
                                
                                let strvalues = NSString(format: "%.1f", value)
                                self.arrModelRev .add(strvalues)
                            }
                        }
                    }
                    
                    self.tblOEMShow.reloadData()
                    self.tblChartData.reloadData()
                    
                }
                else
                {
                    KSToastView .ks_showToast(jsonResponse["message"])
                }
            }
            
        }){ (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
            KSToastView.ks_showToast(error.localizedDescription)
        }
    }
    func SlabsChartDataShowMethod()
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
        
        if btnDaily.isSelected
        {
            if strRegionModel == "Regionwise"
            {
                dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"slab":"all","region":strRegionName]
            }
            else{
                dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"slab":"all","model":strRegionName,"report_type":"modelwise"]
            }
        }
        else if btnMonth.isSelected
        {
            if strRegionModel == "Regionwise"
            {
                dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"slab":"all","region":strRegionName]
            }
            else{
                dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"slab":"all","model":strRegionName,"report_type":"modelwise"]
            }
        }
        else{
            if strRegionModel == "Regionwise"
            {
                dictStartDateEndDate = ["start_date":strStartdate,"end_date" : strEnddate,"brand":apistr,"oem":strOEM,"slab":"all","region":strRegionName]
            }
            else{
                dictStartDateEndDate = ["start_date":strStartdate,"end_date" : strEnddate,"brand":apistr,"oem":strOEM,"slab":"all","model":strRegionName,"report_type":"modelwise"]
            }
        }
        
        
        let Url = "http://bi.servassure.net/api/"
        manager .post("\(Url)SalesOverviewOEMLevel2", parameters: dictStartDateEndDate, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            if let jsonResponse = responseObject as? [String: AnyObject]
            {
                print("JSON: \(jsonResponse)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Bool == true
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0
                    {
                        
                        let data = dataArray.object(at: 0) as! NSDictionary
                        let groupArr = data ["group"] as! NSArray
                        self.masterList2 = groupArr.mutableCopy() as! NSMutableArray
                        let SalesArr = data ["TotalSales"] as! NSArray
                        self.arrbarChartSales = SalesArr.mutableCopy() as! NSMutableArray
                        let perSalesArr = data["percentages_sales"] as! NSArray
                        self.arrbarPerSales = perSalesArr.mutableCopy() as!NSMutableArray
                        
                    }
                    
                    self.tblOEMShow.reloadData()
                    self.tblChartData.reloadData()
                    
                }
                else
                {
                    KSToastView .ks_showToast(jsonResponse["message"])
                }
            }
            
        }){ (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
            KSToastView.ks_showToast(error.localizedDescription)
        }
    }
    func PlansChartDataShowMethod()
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
        
        if btnDaily.isSelected
        {
            if strRegionModel == "Regionwise"
            {
                dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"plan":"all","region":strRegionName]
            }
            else{
                dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"plan":"all","model":strRegionName,"report_type":"modelwise"]
            }
        }
        else if btnMonth.isSelected
        {
            if strRegionModel == "Regionwise"
            {
                dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"plan":"all","region":strRegionName]
            }
            else{
                dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":strOEM,"plan":"all","model":strRegionName,"report_type":"modelwise"]
            }
        }
        else{
            if strRegionModel == "Regionwise"
            {
                dictStartDateEndDate = ["start_date":strStartdate,"end_date" : strEnddate,"brand":apistr,"oem":strOEM,"plan":"all","region":strRegionName]
            }
            else{
                dictStartDateEndDate = ["start_date":strStartdate,"end_date" : strEnddate,"brand":apistr,"oem":strOEM,"plan":"all","model":strRegionName,"report_type":"modelwise"]
            }
        }
        
        
        let Url = "http://bi.servassure.net/api/"
        manager .post("\(Url)SalesOverviewOEMLevel2", parameters: dictStartDateEndDate, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            if let jsonResponse = responseObject as? [String: AnyObject]
            {
                print("JSON: \(jsonResponse)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Bool == true
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0
                    {
                        
                        let data = dataArray.object(at: 0) as! NSDictionary
                        let groupArr = data ["am_ext_warranty_years_km"] as! NSArray
                        self.masterList3 = groupArr.mutableCopy() as! NSMutableArray
                        let SalesArr = data ["TotalSales"] as! NSArray
                        self.arrHbarChartSales = SalesArr.mutableCopy() as! NSMutableArray
                        let perSalesArr = data["percentages_sales"] as! NSArray
                        self.arrHbarPerSales = perSalesArr.mutableCopy() as!NSMutableArray
                        
                    }
                    
                    self.tblOEMShow.reloadData()
                    self.tblChartData.reloadData()
                    
                }
                else
                {
                    KSToastView .ks_showToast(jsonResponse["message"])
                }
            }
            
        }){ (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
            KSToastView.ks_showToast(error.localizedDescription)
        }
    }
    
}
