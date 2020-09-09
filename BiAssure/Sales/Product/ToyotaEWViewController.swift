//
//  ToyotaEWViewController.swift
//  BiAssure
//
//  Created by Pulkit on 04/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD
import SSMaterialCalendarPicker
import KSToastView
import AFNetworking

class ToyotaEWViewController: UIViewController,SSMaterialCalendarPickerDelegate,ChartViewDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    
    
    
    var strsetdate = ""
    var strDateRange = ""
    var StrCurrentDate = ""
    var StrPreDate = ""
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
    var Region = ""
    var regionName = ""
    var apistr = ""
    var brandname = ""
    var strSalesOrRevenue = ""
    
    
    var selectedIndex = 0
    
    var dailytblIndexpath = IndexPath()
    
    var _startDate = NSDate()
    var _endDate = NSDate()
    
    var arrRevenue = NSMutableArray()
    var arrSales = NSMutableArray()
    var arrPerRevenue = NSMutableArray()
    var arrPerSales = NSMutableArray()
    var arrbarChartSales = NSMutableArray()
    var arrbarPerSales = NSMutableArray()
    var arrHbarChartSales = NSMutableArray()
    var arrHbarPerSales = NSMutableArray()
    var arrRegionRev = NSMutableArray()
    var arrModelRev = NSMutableArray()
    var arrbarChartRevenue = NSMutableArray()
    var arrbarPerRevenue = NSMutableArray()
    var arrHbarChartRevenue = NSMutableArray()
    var arrHbarPerRevenue = NSMutableArray()
    var masterList0 = NSMutableArray()
    var masterList1 = NSMutableArray()
    var masterList2 = NSMutableArray()
    var masterList3 = NSMutableArray()
    var arrRegionRevPercentage = NSMutableArray()
    var arrModelRevPercentage = NSMutableArray()
    
    
    var showTodayDate = NSArray()
    var showPreviousDate = NSArray()
    
    var datePicker = SSMaterialCalendarPicker()
    var adtBarChartView = BarChartView()
    var pieChartOEM = PieChartView()
    var horiBarChartview = HorizontalBarChartView()
    var sePicker = CustomPicker()
    var refreshControl = UIRefreshControl()
    var appDelegate :AppDelegate = AppDelegate()
    
    var dictRegion = NSDictionary()
    var dictPreRegion = NSDictionary()
    
    var dictStartDateEndDate = NSMutableDictionary()
    
    var Slabs = Bool()
    
    var viewModel = UIView()
    
    var btnallCampaings = UIButton()
    var btncalender = UIButton()
    
    var tblChartData = UITableView()
    
    
    
    
    
    
    @IBOutlet weak var tblOEMShow: UITableView!
    @IBOutlet weak var btnDaily: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnRange: UIButton!
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var campiagnDateLable: UILabel!
    @IBOutlet weak var tableBHeightConstraints: NSLayoutConstraint!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tblOEMShow.estimatedRowHeight = 361.0
        tblOEMShow.rowHeight = UITableView.automaticDimension
        refreshMethod()
        refreshControl = UIRefreshControl.init()
        refreshControl.backgroundColor = UIColor.purple
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refreshTable), for: UIControl.Event.valueChanged)
        
        tblOEMShow.addSubview(refreshControl)
        tblOEMShow.setNeedsLayout()
        tblOEMShow.layoutIfNeeded()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        style()
        configureView()
        let strname:NSString = appDelegate.getbuttonName() as NSString
        if strname == "Month"
        {
            btnDaily.isSelected=false;
            btnMonth.isSelected=true;
            btnRange.isSelected=false;
            lblLine1.isHidden=true;
            lblLine2.isHidden=false;
            lblLine3.isHidden=true;
            
            sePicker.removePickerViewWithAnimaion(sourceView: self.view)
            refreshMethod()
            dictRegion = ["report_type": "cmth", "oem": brandname,"brand" :apistr]
            dictPreRegion = ["report_type": "pmth", "oem": brandname,"brand" :apistr]
            CurentDateWebserviceCallingMethod()
        }
        else if strname == "Range"
        {
            btnDaily.isSelected=false;
            btnMonth.isSelected=false;
            btnRange.isSelected=true;
            lblLine1.isHidden=true;
            lblLine2.isHidden=true;
            lblLine3.isHidden=false;
            
            sePicker.removePickerViewWithAnimaion(sourceView: self.view)
            refreshMethod()
        }
        else
        {
            btnDaily.isSelected=true;
            btnMonth.isSelected=false;
            btnRange.isSelected=false;
            lblLine1.isHidden=false;
            lblLine2.isHidden=true;
            lblLine3.isHidden=true;
            
            tblOEMShow.estimatedRowHeight = 361.0
            tblOEMShow.rowHeight = UITableView.automaticDimension
            dictRegion = ["report_type": "tdy", "oem": brandname,"brand" :apistr]
            dictPreRegion = ["report_type": "ydy", "oem": brandname,"brand" :apistr]
            dictStartDateEndDate = ["start_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()), "brand": apistr, "oem": brandname]
            
            CurentDateWebserviceCallingMethod()
        }
    }
    
    override func viewDidLayoutSubviews() {
        tblOEMShow.layoutIfNeeded()
        let height:Float = Float(tblOEMShow.contentSize.height)
        tableBHeightConstraints.constant = CGFloat(height)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        sePicker.removePickerViewWithAnimaion(sourceView: self.view)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblOEMShow
        {
            if Slabs
            {
                return 5
            }
            else{
                return 4
            }
        }
        else{
            if selectedIndex == 1
            {
                return masterList0.count
            }
            else if selectedIndex == 2
            {
                return masterList1.count
            }
            else if selectedIndex == 3
            {
                return masterList2.count
            }
            else{
                return masterList3.count
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblOEMShow
        {
            dailytblIndexpath = indexPath
            if dailytblIndexpath.row == 0
            {
                selectedIndex = 0
                let cell = tableView .dequeueReusableCell(withIdentifier: "TableviewCell0", for: indexPath)
                let lblCurrentDateNo = cell.viewWithTag(10) as! UILabel
                let lblCurrentRemDate = cell.viewWithTag(11) as! UILabel
                let lblCurrentSales = cell.viewWithTag(12) as! UILabel
                let lblCurrentRevenue = cell.viewWithTag(13) as! UILabel
                let lblMonthRangeCu = cell.viewWithTag(22) as! UILabel
                
                let btnSaleShow = cell.viewWithTag(45) as! UIButton
                let btnRevenueShow = cell.viewWithTag(46) as! UIButton
                
                let lblPreDateNo = cell.viewWithTag(14) as! UILabel
                let lblPreRemDate = cell.viewWithTag(15) as! UILabel
                let lblPreSales = cell.viewWithTag(16) as! UILabel
                let lblPreRevnue = cell.viewWithTag(17) as! UILabel
                let lblMonthRangePre = cell.viewWithTag(44) as! UILabel
                let lblPolicySoldCu = cell.viewWithTag(18) as! UILabel
                let lblPolicySoldPre = cell.viewWithTag(19) as! UILabel
                
                
                if btnMonth.isSelected == true
                {
                    lblCurrentDateNo.isHidden = true
                    lblPreDateNo.isHidden = true
                    lblMonthRangeCu.isHidden = false
                    lblMonthRangePre.isHidden = false
                    lblCurrentRemDate.isHidden = false
                    lblPreRemDate.isHidden = false
                    
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
                        lblPreDateNo.text = Preitems.object(at: 0) as? String
                        lblPreRemDate.text = "\(Preitems.object(at: 1)) \(Preitems.object(at: 2))"
                    }
                    
                }
                if showTodayDate.count != 0
                {
                    let dictData = showTodayDate.object(at: 0) as! NSDictionary
                    lblCurrentSales.text = "\(dictData["TotalSales"] as! NSNumber)"
                    
                    let revenue: Float
                    if btnMonth.isSelected
                    {
                        lblPolicySoldCu.text = "POLICY SOLD (CRORES)"
                        revenue = (dictData["TotalRevenue"] as! NSNumber).floatValue / 10000000
                    }
                    else{
                        lblPolicySoldCu.text = "POLICY SOLD (LACS)"
                        revenue = (dictData["TotalRevenue"] as! NSNumber).floatValue / 100000
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
                    lblPreSales.text = "\(dictData["TotalSales"] as! NSNumber)"
                    let prerevenue: Float
                    if btnMonth.isSelected
                    {
                        lblPolicySoldPre.text = "POLICY SOLD (CRORES)"
                        prerevenue = (dictData["TotalRevenue"] as! NSNumber).floatValue / 10000000
                    }
                    else{
                        lblPolicySoldPre.text = "POLICY SOLD (LACS)"
                        prerevenue = (dictData["TotalRevenue"] as! NSNumber).floatValue / 100000
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
                return cell
            }
            else if dailytblIndexpath.row == 1
            {
                selectedIndex = 1
                let cell = tableView .dequeueReusableCell(withIdentifier: "TableviewCell1", for: indexPath)
                viewModel = cell.viewWithTag(2)! 
                btnallCampaings = cell.viewWithTag(5) as! UIButton
                btncalender = cell.viewWithTag(6) as! UIButton
                pieChartOEM = cell.viewWithTag(100) as! PieChartView
                tblChartData = cell.viewWithTag(111) as! UITableView
                tblChartData.dataSource = self
                tblChartData.delegate = self
                tblChartData.estimatedRowHeight = 35.0
                tblChartData.rowHeight = UITableView.automaticDimension
                
                btnallCampaings.addTarget(self, action: #selector(allCampaingsAction(_:)), for: UIControl.Event.touchUpInside)
                btncalender.addTarget(self, action: #selector(changeDate(_:)), for: UIControl.Event.touchUpInside)
                
                btncalender.setTitle(strsetdate, for: UIControl.State.normal)
                
                if strSalesOrRevenue == "Sales"
                {
                    configurePieChart(pieChart: pieChartOEM, arrchart: arrSales)
                }
                else{
                    configurePieChart(pieChart: pieChartOEM, arrchart: arrRegionRev)
                    
                }
                tblChartData.reloadData()
                
                viewModel.frame(forAlignmentRect: CGRect.init(x:viewModel.frame.origin.x, y: viewModel.frame.origin.y, width: viewModel.frame.size.width, height: tblChartData.contentSize.height+tblChartData.frame.origin.y+5))
                
                cell.contentView.frame(forAlignmentRect: CGRect.init(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: viewModel.frame.size.height+viewModel.frame.origin.y))
                
                viewModel.setNeedsUpdateConstraints()
                cell.contentView.setNeedsUpdateConstraints()
                cell.setNeedsUpdateConstraints()
                
                return cell
            }
                
            else if dailytblIndexpath.row == 2
            {
                selectedIndex = 2
                let cell = tableView .dequeueReusableCell(withIdentifier: "TableviewCell2", for: indexPath)
                viewModel = cell.viewWithTag(3)!
                btnallCampaings = cell.viewWithTag(7) as! UIButton
                btncalender = cell.viewWithTag(8) as! UIButton
                pieChartOEM = cell.viewWithTag(200) as! PieChartView
                tblChartData = cell.viewWithTag(222) as! UITableView
                tblChartData.dataSource = self
                tblChartData.delegate = self
                tblChartData.estimatedRowHeight = 35.0
                tblChartData.rowHeight = UITableView.automaticDimension
                
                btnallCampaings.addTarget(self, action: #selector(allCampaingsAction(_:)), for: UIControl.Event.touchUpInside)
                btncalender.addTarget(self, action: #selector(changeDate(_:)), for: UIControl.Event.touchUpInside)
                
                btncalender.setTitle(strsetdate, for: UIControl.State.normal)
                
                if strSalesOrRevenue == "Sales"
                {
                    configurePieChart(pieChart: pieChartOEM, arrchart: arrRevenue)
                }
                else{
                    configurePieChart(pieChart: pieChartOEM, arrchart: arrModelRev)
                    
                }
                tblChartData.reloadData()
                
                viewModel.frame(forAlignmentRect: CGRect.init(x:viewModel.frame.origin.x, y: viewModel.frame.origin.y, width: viewModel.frame.size.width, height: tblChartData.contentSize.height+tblChartData.frame.origin.y+5))
                
                cell.contentView.frame(forAlignmentRect: CGRect.init(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: viewModel.frame.size.height+viewModel.frame.origin.y))
                
                viewModel.setNeedsUpdateConstraints()
                cell.contentView.setNeedsUpdateConstraints()
                cell.setNeedsUpdateConstraints()
                
                return cell
                
            }
            else if dailytblIndexpath.row == 3
            {
                let cell = tableView .dequeueReusableCell(withIdentifier: "TableviewCell3", for: indexPath)
                if Slabs{
                    selectedIndex = 3
                    viewModel = cell.viewWithTag(4)!
                    btnallCampaings = cell.viewWithTag(9) as! UIButton
                    btncalender = cell.viewWithTag(10) as! UIButton
                    adtBarChartView = cell.viewWithTag(300) as! BarChartView
                    tblChartData = cell.viewWithTag(333) as! UITableView
                    tblChartData.dataSource = self
                    tblChartData.delegate = self
                    tblChartData.estimatedRowHeight = 35.0
                    tblChartData.rowHeight = UITableView.automaticDimension
                    
                    
                    btncalender.addTarget(self, action: #selector(changeDate(_:)), for: UIControl.Event.touchUpInside)
                    
                    btncalender.setTitle(strsetdate, for: UIControl.State.normal)
                    
                    if strSalesOrRevenue == "Sales"
                    {
                        configureBarChartGraph(barChartView: adtBarChartView, arrchart: arrbarChartSales)
                    }
                    else{
                        configureBarChartGraph(barChartView: adtBarChartView, arrchart: arrbarChartRevenue)
                        
                    }
                    tblChartData.reloadData()
                    
                    viewModel.frame(forAlignmentRect: CGRect.init(x:viewModel.frame.origin.x, y: viewModel.frame.origin.y, width: viewModel.frame.size.width, height: tblChartData.contentSize.height+tblChartData.frame.origin.y+5))
                    
                    cell.contentView.frame(forAlignmentRect: CGRect.init(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: viewModel.frame.size.height+viewModel.frame.origin.y))
                    
                    viewModel.setNeedsUpdateConstraints()
                    cell.contentView.setNeedsUpdateConstraints()
                    cell.setNeedsUpdateConstraints()
                    
                    
                }
                return cell
                
                
            }
            else
            {
                selectedIndex = 4
                let cell = tableView .dequeueReusableCell(withIdentifier: "TableviewCell4", for: indexPath)
                viewModel = cell.viewWithTag(5)!
                btnallCampaings = cell.viewWithTag(11) as! UIButton
                btncalender = cell.viewWithTag(12) as! UIButton
                horiBarChartview = cell.viewWithTag(400) as! HorizontalBarChartView
                tblChartData = cell.viewWithTag(444) as! UITableView
                tblChartData.dataSource = self
                tblChartData.delegate = self
                tblChartData.estimatedRowHeight = 35.0
                tblChartData.rowHeight = UITableView.automaticDimension
                
                
                btncalender.addTarget(self, action: #selector(changeDate(_:)), for: UIControl.Event.touchUpInside)
                
                btncalender.setTitle(strsetdate, for: UIControl.State.normal)
                
                if strSalesOrRevenue == "Sales"
                {
                    configreHorizontalChartGraph(horiGraph: horiBarChartview, arrchart: arrHbarChartSales)
                }
                else{
                    configreHorizontalChartGraph(horiGraph: horiBarChartview, arrchart: arrHbarChartRevenue)
                    
                }
                tblChartData.reloadData()
                
                viewModel.frame(forAlignmentRect: CGRect.init(x:viewModel.frame.origin.x, y: viewModel.frame.origin.y, width: viewModel.frame.size.width, height: tblChartData.contentSize.height+tblChartData.frame.origin.y+5))
                
                cell.contentView.frame(forAlignmentRect: CGRect.init(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: viewModel.frame.size.height+viewModel.frame.origin.y))
                
                viewModel.setNeedsUpdateConstraints()
                cell.contentView.setNeedsUpdateConstraints()
                cell.setNeedsUpdateConstraints()
                
                
                
                return cell
                
            }
        }
        else{
            
            let cell = tableView .dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
            let lblicon = cell.viewWithTag(112) as! UILabel
            let lblname = cell.viewWithTag(113) as! UILabel
            let lblsales = cell.viewWithTag(114) as! UILabel
            
            lblicon.layer.cornerRadius = lblicon.frame.size.width/2
            let color: UIColor = (Utilities.sharedUtilities.colorArray()).object(at: indexPath.row) as! UIColor
            lblicon.backgroundColor = color
            lblicon.layer.masksToBounds = true
            
            if selectedIndex == 1
            {
                let lblrevenue = cell.viewWithTag(115) as! UILabel
                lblname.text = "\(masterList0.object(at: indexPath.row))"
                
                if strSalesOrRevenue == "Sales"
                {
                    lblsales.text = NSString(format: "%@", arrSales.object(at: indexPath.row) as! CVarArg) as String
                    let revenueValue = (arrPerSales.object(at: indexPath.row) as! NSNumber).floatValue * 100
                    lblrevenue.text = NSString(format: "%.1f%%", revenueValue) as String
                }
                else{
                    let salesValue = arrRegionRev.object(at: indexPath.row) as! NSString
                    lblsales.text = NSString(format: "%.1f", salesValue.floatValue) as String
                    let revenueValue = (arrRegionRevPercentage.object(at: indexPath.row) as! NSNumber).floatValue * 100
                    lblrevenue.text = NSString(format: "%.1f%%", revenueValue) as String
                }
            }
                
            else if selectedIndex == 2
            {
                let lblrevenue = cell.viewWithTag(115) as! UILabel
                lblname.text = "\(masterList1.object(at: indexPath.row))"
                
                if strSalesOrRevenue == "Sales"
                {
                    lblsales.text = NSString(format: "%@", arrRevenue.object(at: indexPath.row) as! CVarArg) as String
                    let revenueValue = (arrPerRevenue.object(at: indexPath.row) as! NSNumber).floatValue * 100
                    lblrevenue.text = NSString(format: "%.1f%%", revenueValue) as String
                }
                else{
                    let salesValue = arrModelRev.object(at: indexPath.row) as! NSString
                    lblsales.text = NSString(format: "%.1f", salesValue.floatValue) as String
                    let revenueValue = (arrModelRevPercentage.object(at: indexPath.row) as! NSNumber).floatValue * 100
                    lblrevenue.text = NSString(format: "%.1f%%", revenueValue) as String
                }
            }
            else if selectedIndex == 3
            {
                let lblrevenue = cell.viewWithTag(115) as! UILabel
                lblname.text = "\(masterList2.object(at: indexPath.row))"
                
                if lblname.text == "0 - 60" || lblname.text == "0 - 30" || lblname.text == "0 - 90" || lblname.text == "0 - 45" {
                    
                    lblsales.text = "Sales"
                }
                else{
                    lblsales.text = "Service"
                    
                }
                
                if strSalesOrRevenue == "Sales"
                {
                    lblrevenue.text = NSString(format: "%@", arrbarChartSales.object(at: indexPath.row) as! CVarArg) as String
                    
                }
                else{
                    
                    let revenueValue = (arrbarChartRevenue.object(at: indexPath.row) as! NSString).floatValue * 100
                    lblrevenue.text = NSString(format: "%.1f%%", revenueValue) as String
                }
            }
                
            else{
                lblname.text = "\(masterList3.object(at: indexPath.row))"
                
                
                if strSalesOrRevenue == "Sales"
                {
                    lblsales.text = NSString(format: "%@", arrHbarChartSales.object(at: indexPath.row) as! CVarArg) as String
                    
                }
                else{
                    
                    let salesValue = (arrHbarChartRevenue.object(at: indexPath.row) as! NSString).floatValue * 100
                    lblsales.text = NSString(format: "%.1f%%", salesValue) as String
                }
            }
            
            return cell
            
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
                if indexPath.row == 1
                {
                    return ArraySizeCellSizeEstimation(array: masterList0)
                }
                else if indexPath.row == 2
                {
                    return ArraySizeCellSizeEstimation(array: masterList1)
                }
                else if indexPath.row == 3
                {
                    return ArraySizeCellSizeEstimation(array: masterList2)
                }
                else
                {
                    return ArraySizeCellSizeEstimation(array: masterList3)
                }
            }
        }
        else{
            return 35
        }
    }
    
    
    func rangeSelected(withStart startDate: Date!, andEnd endDate: Date!)
    {
        _startDate = startDate! as NSDate
        _endDate = endDate! as NSDate
        strsetdate = String(format: "\(  Utilities.sharedUtilities.getDuration(date: startDate! as NSDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate! as NSDate)  )")
    }
    
    
    
    
    func refreshMethod()
    {
        let MyIp:NSIndexPath = NSIndexPath.init(row: 0, section: 0)
        
        selectedIndex = 0
        
        showTodayDate = NSArray.init()
        showPreviousDate = NSArray.init()
        
        masterList0.removeAllObjects()
        arrPerSales.removeAllObjects()
        arrSales.removeAllObjects()
        arrRegionRev.removeAllObjects()
        arrRegionRevPercentage.removeAllObjects()
        
        masterList1.removeAllObjects()
        arrPerRevenue.removeAllObjects()
        arrRevenue.removeAllObjects()
        arrModelRev.removeAllObjects()
        arrModelRevPercentage.removeAllObjects()
        
        masterList2.removeAllObjects()
        arrbarPerSales.removeAllObjects()
        arrbarChartSales.removeAllObjects()
        arrbarChartRevenue.removeAllObjects()
        arrbarPerRevenue.removeAllObjects()
        
        masterList3.removeAllObjects()
        arrHbarPerSales.removeAllObjects()
        arrHbarChartSales.removeAllObjects()
        arrHbarChartRevenue.removeAllObjects()
        arrHbarPerRevenue.removeAllObjects()
        
        tblOEMShow.reloadData()
        tblChartData.reloadData()
        tblOEMShow.scrollToRow(at: MyIp as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
        
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
        
        let view = UIView.init(frame: CGRect.init(x: -10, y: 0, width: 150, height: 33))
        let imageView = UIImageView.init(frame: CGRect.init(x: -25, y: 8, width: 24, height: 15))
        imageView.image = UIImage.init(named: "car-icon")
        let lblTitle : UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 2, width: 200, height: 30))
        
        lblTitle.text = Region
        lblTitle.textColor = UIColor.white
        lblTitle.font = UIFont.systemFont(ofSize: 13)
        
        view.addSubview(imageView)
        view.addSubview(lblTitle)
        self.navigationItem.titleView = view
        
        let backButton:UIButton =  UIButton(type:.custom)
        backButton.frame =  CGRect.init(x: -30, y: 0, width: 130, height: 40)
        backButton.setImage(UIImage.init(named: "arrow-left"), for: UIControl.State.normal)
        backButton.addTarget(self, action: #selector(btnDashboard_didSelect), for: UIControl.Event.touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 0)
        backButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -18, bottom: 0, right: 0)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        backButton.titleLabel?.numberOfLines = 2
        backButton.setTitle(brandname, for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        
        
        let menuButton:UIButton =  UIButton(type:.custom)
        menuButton.frame =  CGRect.init(x: 0, y: 0, width: 52, height: 40)
        menuButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 25, bottom: 0, right: 0)
        menuButton.setImage(UIImage.init(named: "right-menu-icon"), for: UIControl.State.normal)
        menuButton.addTarget(self, action: #selector(slidemenuAction), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: menuButton)
    }
    
    func updateDate(startDate:NSDate,endDate:NSDate)->Void
    {
        strsetdate = String(format: "\(Utilities.sharedUtilities.getDuration(date: startDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate))")
        
        
        if btnRange.isSelected == true{
            dictRegion = ["report_type": "crc", "oem": brandname,"start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate), "brand": apistr]
            
            dictPreRegion = ["report_type": "crp", "oem": brandname,"start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate), "brand": apistr]
            
            CurentDateWebserviceCallingMethod()
            
        }
        else{
            dictStartDateEndDate = ["start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate), "brand": apistr, "oem": brandname]
        }
    }
    
    
    @objc func refreshTable()
    {
        refreshControl.endRefreshing()
        CurentDateWebserviceCallingMethod()
    }
    
    
    
    func ArraySizeCellSizeEstimation(array:NSMutableArray)-> CGFloat
    {
        if array.count <= 1
        {
            return 390.0
        }
        else if array.count == 2 || array.count == 3
        {
            return 460.0
        }
        else if array.count == 4
        {
            return 510.0
        }else if array.count <= 8
        {
            return 600.0
        }
        else if array.count <= 11
        {
            return 720.0
        }
        else if array.count < 19
        {
            return 1100.0
        }
        else if array.count < 24
        {
            return 1180.0
        }
        else
        {
            return 1800.0
        }
        
    }
    
    
    
    
    func configureBarChartGraph(barChartView:BarChartView,arrchart:NSArray)->Void
    {
        let xVals = NSMutableArray.init()
        for eachData1 in arrchart
        {
            let eachData = eachData1 as! NSNumber
            xVals.add(eachData)
        }
        
        let dataSets = NSMutableArray.init()
        let colors = NSMutableArray.init(array: Utilities.sharedUtilities.colorArray())
        colors.add( ChartColorTemplates.joyful())
        colors.add( ChartColorTemplates.colorful())
        
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
        
        
        let l:Legend = barChartView.legend
        l.horizontalAlignment = Legend.HorizontalAlignment.left
        l.verticalAlignment = Legend.VerticalAlignment.bottom
        l.orientation = Legend.Orientation.horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 9.0
        l.font = UIFont.init(name: "HelveticaNeue-Light", size: 10)!
        l.xEntrySpace = 4.0
        
        setupBarLineChartView(chartView: barChartView)
        
        barChartView.delegate = self
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = true
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.enabled = true
        barChartView.xAxis.axisRange = 0
        
        let xAxis : XAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 0)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0
        xAxis.labelCount = 7
        
        let data : BarChartData = BarChartData.init(dataSet: set1)
        data.setValueTextColor(UIColor.black)
        data.setValueFont(UIFont.systemFont(ofSize: 9))
        data.setDrawValues(true)
        barChartView.data = data
        barChartView.animate(yAxisDuration: 2)
        
    }
    
    
    func setupBarLineChartView(chartView:BarLineChartViewBase)->Void
    {
        chartView.chartDescription?.enabled = true
        chartView.drawGridBackgroundEnabled = true
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.isUserInteractionEnabled = false
        let xAxis : XAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        chartView.rightAxis.enabled = false
        
    }
    
    
    func configurePieChart(pieChart:PieChartView,arrchart:NSArray)->Void
    {
        self.setupPieChartView(chartView: pieChart)
        pieChart.holeColor = UIColor.white
        pieChart.rotationEnabled = true
        pieChart.highlightPerTapEnabled = true
        pieChart.centerTextOffset = CGPoint(x: 0.0, y: 0.0)
        
        
        if arrchart.count == 0{
            pieChart.centerText = String(format: "No Chart data available")
        }
        else{
            if strSalesOrRevenue == "Sales"
            {
                if selectedIndex == 1
                {
                    pieChart.centerText = "All Regions"
                }
                else if selectedIndex == 2
                {
                    pieChart.centerText = "All Models"
                    
                }
            }
            else{
                if selectedIndex == 1
                {
                    pieChart.centerText = "All Regions"
                }
                else if selectedIndex == 2
                {
                    pieChart.centerText = "All Models"
                    
                }
            }
            
        }
        
        
        
        var i = 0
        let values = NSMutableArray.init()
        var dataSet = PieChartDataSet()
        for eachdata1 in arrchart
        {
            let eachdata = eachdata1 as! NSNumber
            let data = PieChartDataEntry.init(value: Double(eachdata.floatValue * 100))
            
            i+=1
            values .add(data)
        }
        
        dataSet = PieChartDataSet.init(entries: values as? [ChartDataEntry], label: "")
        dataSet.sliceSpace = 1.0
        dataSet.selectionShift = 5.0
        dataSet.valueLineWidth = 10
        dataSet.drawValuesEnabled = false
        dataSet.entryLabelFont = UIFont.systemFont(ofSize: 0.0)
        dataSet.valueTextColor = UIColor.black
        
        let colors = NSMutableArray.init(array: Utilities.sharedUtilities.colorArray())
        colors.add( ChartColorTemplates.joyful())
        colors.add( ChartColorTemplates.colorful())
        
        dataSet.colors = colors as! [NSUIColor]
        
        let data = PieChartData.init(dataSet: dataSet)
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
    
    func configreHorizontalChartGraph(horiGraph:HorizontalBarChartView,arrchart:NSArray)->Void
    {
        let xVals = NSMutableArray.init()
        for eachData1 in arrchart
        {
            let eachData = eachData1 as! NSNumber
            xVals.add(eachData)
        }
        
        let dataSets = NSMutableArray.init()
        let colors = NSMutableArray.init(array: Utilities.sharedUtilities.colorArray())
        colors.add( ChartColorTemplates.joyful())
        colors.add( ChartColorTemplates.colorful())
        
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
        
        
        
        let l:Legend = horiGraph.legend
        l.horizontalAlignment = Legend.HorizontalAlignment.left
        l.verticalAlignment = Legend.VerticalAlignment.bottom
        l.orientation = Legend.Orientation.horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 9.0
        l.font = UIFont.init(name: "HelveticaNeue-Light", size: 10)!
        l.xEntrySpace = 4.0
        
        setupBarLineChartView(chartView: horiGraph)
        
        horiGraph.delegate = self
        horiGraph.drawBarShadowEnabled = false
        horiGraph.drawValueAboveBarEnabled = true
        horiGraph.leftAxis.enabled = false
        horiGraph.rightAxis.enabled = false
        horiGraph.xAxis.enabled = false
        horiGraph.xAxis.axisRange = 0
        
        let xAxis : XAxis = horiGraph.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0
        xAxis.labelCount = 7
        
        let data : BarChartData = BarChartData.init(dataSet: set1)
        data.setValueTextColor(UIColor.darkGray)
        data.setValueFont(UIFont.systemFont(ofSize: 9))
        data.setDrawValues(true)
        horiGraph.data = data
        horiGraph.animate(yAxisDuration: 2)
    }
    
    
    
    @IBAction func btnDashboard_didSelect(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func slidemenuAction(_ sender:UIButton)
    {
        kMainViewController.showRightView(animated: true, completionHandler: nil)
    }
    
    @IBAction func btnLeft_didSelect(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
        sePicker.removePickerViewWithAnimaion(sourceView: self.view)
        
        refreshMethod()
        
        dictRegion = ["report_type": "tdy", "oem": brandname,"brand" :apistr]
        dictPreRegion = ["report_type": "ydy", "oem": brandname,"brand" :apistr]
        dictStartDateEndDate = ["start_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()), "brand": apistr, "oem": brandname]
        
        appDelegate.storebuttonName(button: "Daily")
        CurentDateWebserviceCallingMethod()
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
        
        
        dictRegion = ["report_type": "cmth", "oem": brandname,"brand" :apistr]
        dictPreRegion = ["report_type": "pmth", "oem": brandname,"brand" :apistr]
        appDelegate.storebuttonName(button: "Month")
        CurentDateWebserviceCallingMethod()
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
        appDelegate.storebuttonName(button: "Range")
        CurentDateWebserviceCallingMethod()
    }
    
    @IBAction func allCampaingsAction(_ sender:UIButton)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: tblOEMShow)
        let indexpath = tblOEMShow.indexPathForRow(at: buttonPosition)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if indexpath?.row == 1
        {
            let regionvc = storyboard.instantiateViewController(withIdentifier: "RegionShowViewController") as! RegionShowViewController
            regionvc.arrRegionSales = arrSales
            regionvc.arrRegionPerSales = arrPerSales
            regionvc.masterList = masterList0
            regionvc.strRegionname = Region
            regionvc.arrRegionRevenue = arrRegionRev
            regionvc.strdate = strsetdate
            regionvc.apistr = apistr
            regionvc.strCome = "OEM"
            regionvc.strOEMname = brandname
            
            self.navigationController?.pushViewController(regionvc, animated: true)
        }
        else if indexpath?.row == 2
        {
            let modelvc = storyboard.instantiateViewController(withIdentifier: "ModelShowViewController") as! ModelShowViewController
            modelvc.arrRegionSales = arrRevenue
            modelvc.arrRegionPerSales = arrPerRevenue
            modelvc.masterList = masterList1
            modelvc.strRegionname = Region
            modelvc.arrRegionRevenue = arrModelRev
            modelvc.strdate = strsetdate
            modelvc.apistr = apistr
            modelvc.strCome = "OEM"
            modelvc.strOEMname = brandname
            
            self.navigationController?.pushViewController(modelvc, animated: true)
        }
    }
    
    
    @IBAction func changeDate(_ sender:UIButton)
    {
        sePicker.showPickerViewWithAnimation(sourceView: self.view)
        
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
                        
                        self.dictStartDateEndDate  = ["start_date" : self.first_day_month,"end_date" : self.strcurrent_day_month,"brand":self.apistr,"oem":self.brandname]
                        
                    }
                    else if self.btnRange.isSelected
                    {
                        let addtionInfo = info["addtionalinfo"] as! NSDictionary
                        self.strStartdate = addtionInfo["date1"] as! String
                        self.strEnddate = addtionInfo["date2"] as! String
                        
                        let startdate = Utilities.sharedUtilities.RengeDateConversion(serverDate: self.strStartdate)
                        let enddate = Utilities.sharedUtilities.RengeDateConversion(serverDate: self.strEnddate)
                        self.strsetdate = "\(startdate) - \(enddate)"
                        
                        self.dictStartDateEndDate  = ["start_date" : self.strStartdate,"end_date" : self.strEnddate,"brand":self.apistr,"oem":self.brandname]
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
                    self.ChartDataShowMethod()
                    self.ModelChartDataShowMethod()
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
        
        if btnDaily.isSelected
        {
            self.dictStartDateEndDate  = ["start_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":self.apistr,"oem":self.brandname,"region":"all"]
        }
        else if btnMonth.isSelected
        {
            self.dictStartDateEndDate  = ["start_date" : self.first_day_month,"end_date" : self.strcurrent_day_month,"brand":self.apistr,"oem":self.brandname,"region":"all"]
        }
        else{
            
            self.dictStartDateEndDate  = ["start_date" : strStartdate,"end_date" : strEnddate,"brand":self.apistr,"oem":self.brandname,"region":"all"]
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
                        self.masterList0 = groupArr.mutableCopy() as! NSMutableArray
                        let SalesArr = data ["TotalSales"] as! NSArray
                        self.arrSales = SalesArr.mutableCopy() as! NSMutableArray
                        let perSalesArr = data["percentages_sales"] as! NSArray
                        self.arrPerSales = perSalesArr.mutableCopy() as!NSMutableArray
                        let perRev = data["percentages_revenue"] as! NSArray
                        self.arrRegionRevPercentage = perRev.mutableCopy() as! NSMutableArray
                        
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
        
        if btnDaily.isSelected
        {
            self.dictStartDateEndDate  = ["start_date" :Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" :Utilities.sharedUtilities.overViewDate(date: NSDate.init()) ,"brand":self.apistr,"oem":self.brandname,"model":"all"]
        }
        else if btnMonth.isSelected
        {
            self.dictStartDateEndDate  = ["start_date" : self.first_day_month,"end_date" : self.strcurrent_day_month,"brand":self.apistr,"oem":self.brandname,"model":"all"]
        }
        else{
            
            self.dictStartDateEndDate  = ["start_date" : strStartdate,"end_date" : strEnddate,"brand":self.apistr,"oem":self.brandname,"model":"all"]
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
                        self.masterList1 = groupArr.mutableCopy() as! NSMutableArray
                        let SalesArr = data ["TotalSales"] as! NSArray
                        self.arrRevenue = SalesArr.mutableCopy() as! NSMutableArray
                        let perSalesArr = data["percentages_sales"] as! NSArray
                        self.arrPerRevenue = perSalesArr.mutableCopy() as!NSMutableArray
                        let perRevArr = data["percentages_revenue"] as! NSArray
                        self.arrModelRevPercentage = perRevArr.mutableCopy() as!NSMutableArray
                        
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
            
            dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":brandname,"slab":"all"]
            
        }
        else if btnMonth.isSelected
        {
            
            dictStartDateEndDate = ["start_date":first_day_month,"end_date" : strcurrent_day_month,"brand":apistr,"oem":brandname,"slab":"all"]
            
        }
        else{
            
            dictStartDateEndDate = ["start_date":strStartdate,"end_date" : strEnddate,"brand":apistr,"oem":brandname,"slab":"all"]
            
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
                        let perRevArr = data["percentages_revenue"] as! NSArray
                        self.arrbarPerRevenue = perRevArr.mutableCopy() as!NSMutableArray
                        
                        self.arrbarChartRevenue = NSMutableArray.init()
                        
                        if self.btnMonth.isSelected
                        {
                            let arrayRev = data["TotalRevenue"]as! NSArray
                            for num in arrayRev
                            {
                                let num1 = num as! NSNumber
                                let value = num1.floatValue / 10000000
                                
                                let strvalues = NSString(format: "%.1f", value)
                                self.arrbarChartRevenue .add(strvalues)
                            }
                        }
                        else{
                            let arrayRev = data["TotalRevenue"]as! NSArray
                            for num in arrayRev
                            {
                                let num1 = num as! NSNumber
                                let value = num1.floatValue / 100000
                                
                                let strvalues = NSString(format: "%.1f", value)
                                self.arrbarChartRevenue .add(strvalues)
                            }
                        }
                    }
                    
                    self.Slabs = true
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
            
            dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"brand":apistr,"oem":brandname,"plan":"all"]
            
        }
        else if btnMonth.isSelected
        {
            
            dictStartDateEndDate = ["start_date":first_day_month,"end_date" : strcurrent_day_month,"brand":apistr,"oem":brandname,"plan":"all"]
            
        }
        else{
            
            dictStartDateEndDate = ["start_date":strStartdate,"end_date" : strEnddate,"brand":apistr,"oem":brandname,"plan":"all"]
            
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
                        let perRevArr = data["percentages_revenue"] as! NSArray
                        self.arrHbarPerRevenue = perRevArr.mutableCopy() as!NSMutableArray
                        
                        self.arrHbarChartRevenue = NSMutableArray.init()
                        
                        if self.btnMonth.isSelected
                        {
                            let arrayRev = data["Revenue"]as! NSArray
                            for num in arrayRev
                            {
                                let num1 = num as! NSNumber
                                let value = num1.floatValue / 10000000
                                
                                let strvalues = NSString(format: "%.1f", value)
                                self.arrHbarChartRevenue .add(strvalues)
                            }
                        }
                        else{
                            let arrayRev = data["Revenue"]as! NSArray
                            for num in arrayRev
                            {
                                let num1 = num as! NSNumber
                                let value = num1.floatValue / 100000
                                
                                let strvalues = NSString(format: "%.1f", value)
                                self.arrHbarChartRevenue .add(strvalues)
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
    
    
}
