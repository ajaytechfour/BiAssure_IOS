//
//  OEMWiseViewController.swift
//  BiAssure
//
//  Created by Pulkit on 04/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import SSMaterialCalendarPicker
import Charts
import RMPickerViewController
import AFNetworking
import SVProgressHUD
import KSToastView

class OEMWiseViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,SSMaterialCalendarPickerDelegate,UITableViewDelegate,UITableViewDataSource,ChartViewDelegate {
    var selectedIndex = 0
    var datePicker : SSMaterialCalendarPicker!
    var viewModel : UIView!
    @IBOutlet var btnDaily : UIButton!
    @IBOutlet var btnMonth : UIButton!
    @IBOutlet var btnRange : UIButton!
    @IBOutlet var tabView : UIView!
    @IBOutlet var tblDailySales : UITableView!
    var btnallCampaings : UIButton!
    var btncalender : UIButton!
    var strsetdate = ""
    @IBOutlet var lblLine1 : UILabel!
    @IBOutlet var lblLine2 : UILabel!
    @IBOutlet var lblLine3 : UILabel!
    
    var adtBarChartView : BarChartView!
    var pieChartabs : PieChartView!
    var tblPieChartData : UITableView!
    
    var showTodayDate = NSArray()
    var showPreviousDate = NSArray()
    var StrCurrentDate = ""
    var StrPreDate = ""
    var dictStartDateEndDate = NSDictionary()
    var arrRevenue = NSMutableArray()
    var arrSales = NSMutableArray()
    var arrPerRevenue = NSMutableArray()
    var arrPerSales = NSMutableArray()
    var dailytblIndexpath : NSIndexPath!
    
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
    
    var Brands = ""
    var targetView : UIView!
    var masterList = NSMutableArray()
    var regionName = ""
    var startDate : NSDate!
    var endDate : NSDate!
    var sePicker : CustomPicker!
    var dictRegion = NSDictionary()
    var dictPreRegion = NSDictionary()
    var appDelegate :AppDelegate = AppDelegate()
    var revenue = Float()
    var prerevenue = Float()
    var rowvalue = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDate = NSDate.init()
        endDate = NSDate.init()
        self.style()
        btnDaily.isSelected = true
        btnMonth.isSelected = false
        btnRange.isSelected = false
        lblLine1.isHidden = false
        lblLine2.isHidden = true
        lblLine3.isHidden = true
        dailytblIndexpath = nil
        
        refreshControl = UIRefreshControl.init()
        refreshControl.backgroundColor = UIColor.purple
        refreshControl.tintColor = UIColor.white
        refreshControl .addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tblDailySales .addSubview(refreshControl)
        dictRegion = ["report_type":"tdy"]
        dictPreRegion = ["report_type":"ydy"]
        
        dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init())]
        appDelegate.storebuttonName(button: "Daily")
        self.CurentDateWebserviceCallingMethod()
        self.configureView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    @IBAction func btnBackClicked(_ sender: UIBarButtonItem) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "dashboardnavigation") as! UINavigationController
        let window = UIApplication.shared.delegate?.window as? UIWindow
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    @IBAction func slidemenuAction(_ sender: UIBarButtonItem)
    {
        kMainViewController .showRightView(animated: true, completionHandler: nil)
    }
    func updateCampiagnData()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateCampiagnData"), object: nil, userInfo: nil)
    }
    @IBAction func btnLeft_didSelect(_ sender:UIButton)
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "dashboardnavigation") as! UINavigationController
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func style ()
    {
        let view = UIView.init(frame: CGRect(x: -40, y: 0, width: 150, height: 33))
        let lblTitle = UILabel.init(frame: CGRect(x: -15, y: 3, width: 100, height: 30))
        lblTitle.text = ""
        lblTitle.textColor = UIColor.white
        lblTitle.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(lblTitle)
        self.navigationController?.navigationBar.topItem?.titleView = view
    }
    func refreshMethod()
    {
        let MyIP = NSIndexPath.init(row: 0, section: 0)
        regionName = ""
        if (dailytblIndexpath == nil)
        {
            selectedIndex = 0
            masterList = NSMutableArray.init()
            arrPerRevenue = NSMutableArray.init()
            arrPerSales = NSMutableArray.init()
            arrSales = NSMutableArray.init()
            arrRevenue = NSMutableArray.init()
            revenue = 0.00
            prerevenue = 0.00
            
            tblDailySales.reloadData()
            
            tblDailySales.scrollToRow(at: MyIP as IndexPath, at: .top, animated: true)
            
        }
        
    }
    
    @objc func refreshTable()
    {
        refreshControl.endRefreshing()
        self .CurentDateWebserviceCallingMethod()
    }
    
    func configureView()
    {
        sePicker = Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)?[0] as? CustomPicker
        weak var weakSelf = self
        sePicker.addPicker(on: self.view) { (strt, end) in
            weakSelf?.updateData(startDate: strt! as NSDate, endDate: end! as NSDate)
        }
        
    }
    @IBAction func allCampaingsAction(_ sender:UIButton)
    {
        let selectAction = RMAction(title: "Select anyone", style: RMActionStyle.done, andHandler: { controller in
            
            
            let selectedRegion = self.masterList[self.rowvalue] as? String
            sender.setTitle(selectedRegion?.capitalized, for: .normal)
            self.Brands = selectedRegion!
            self.title = selectedRegion!
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let saleView = storyboard.instantiateViewController(withIdentifier: "SalesViewController") as? SalesViewController
            saleView?.BrandsName = self.Brands
            
            if let saleView = saleView {
                self.navigationController?.pushViewController(saleView, animated: false)
            }
            
        })
        let cancelAction = RMAction.init(title: "Cancel", style: RMActionStyle.cancel) { (controller) in
            print("Row selection was canceled")
        }
        let pickerController = RMPickerViewController.init(style: RMActionControllerStyle.white, select: selectAction as? RMAction<UIPickerView>, andCancel: cancelAction as? RMAction<UIPickerView>)
        pickerController?.picker.tag = 1
        pickerController?.picker.delegate = self
        pickerController?.picker.dataSource = self
        pickerController?.message = "Select a region of your choice"
        self.present(pickerController!, animated: true, completion: nil)
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
        dailytblIndexpath = nil
        self.refreshMethod()
        
        dictRegion = ["report_type":"tdy"]
        dictPreRegion = ["report_type":"ydy"]
        
        dictStartDateEndDate = ["start_date":Utilities.sharedUtilities.overViewDate(date: NSDate.init()),"end_date" : Utilities.sharedUtilities.overViewDate(date: NSDate.init())]
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
        dailytblIndexpath = nil
        self.refreshMethod()
        
        dictRegion = ["report_type":"cmth"]
        dictPreRegion = ["report_type":"pmth"]
        
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
        
        dailytblIndexpath = nil
        self.refreshMethod()
        appDelegate.storebuttonName(button: "Range")
        sePicker .showPickerViewWithAnimation(sourceView: self.view)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return masterList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let textToDisplay = masterList[row] as? String
        
        return textToDisplay?.capitalized
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rowvalue = row
    }
    @IBAction func changeDate(_ sender : UIButton)
    {
        sePicker.showPickerViewWithAnimation(sourceView: self.view)
    }
    
    func rangeSelected(withStart startDate: Date!, andEnd endDate: Date!) {
        self.startDate = startDate as NSDate?
        self.endDate = endDate as NSDate?
        strsetdate = "\(Utilities.sharedUtilities.getDuration(date: startDate! as NSDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate! as NSDate))"
        self.CurentDateWebserviceCallingMethod()
    }
    
    func updateData(startDate:NSDate,endDate:NSDate)
    {
        strsetdate = "\(Utilities.sharedUtilities.getDuration(date: startDate as NSDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate as NSDate))"
        if btnRange.isSelected
        {
            dictRegion = ["report_type" : "crc",
                          "start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),
                          "end_date" : Utilities.sharedUtilities.overViewDate(date: endDate)]
            
            dictPreRegion = ["report_type" : "crp","start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate)]
            self.CurentDateWebserviceCallingMethod()
            
        }
        else{
            dictStartDateEndDate = ["start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" :  Utilities.sharedUtilities.overViewDate(date: endDate)]
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblDailySales
        {
            return 3
        }
        else{
            return masterList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblDailySales
        {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DailyviewCell0")
                
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
                        lblPreDateNo.text = Preitems.object(at: 0) as? String
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
                    let strresult = NSString(format: "%.1f", prerevenue)
                    lblPreRevnue.text = strresult as String
                    
                    let demo = Float(salseAVG)
                    let result1 = NSString(format: "%.1f%%", demo!*100)
                    print("\(result1)")
                    btnSaleShow .setTitle(NSString(format: "%.1f%%", demo!*100) as String, for: .normal)
                    
                    let demoRev = Float(RevenueAVG)
                    
                    let result2 = NSString(format: "%.1f%%", demoRev!*100)
                    print("\(result2)")
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
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "DailyviewCell1")
                
                viewModel = cell?.viewWithTag(1)
                btnallCampaings = cell?.viewWithTag(5) as? UIButton
                btncalender = cell?.viewWithTag(6) as? UIButton
                pieChartabs = cell?.viewWithTag(100) as? PieChartView
                tblPieChartData = cell?.viewWithTag(111) as? UITableView
                tblPieChartData.dataSource = self
                tblPieChartData.delegate = self
                tblPieChartData.estimatedRowHeight = 35.0
                tblPieChartData.rowHeight = UITableView.automaticDimension
                
                btnallCampaings .setTitle("OEM wise", for: .normal)
                btnallCampaings .addTarget(self, action: #selector(allCampaingsAction(_:)), for: .touchUpInside)
                btncalender.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside)
                btncalender .setTitle(strsetdate, for: .normal)
                
                dailytblIndexpath = indexPath as NSIndexPath
                
                if dailytblIndexpath.row == 1
                {
                    selectedIndex = 1
                    self.configurePieChart(pieChart: pieChartabs, arrchart: arrSales)
                    
                }
                else{
                    selectedIndex = 2
                    self.configurePieChart(pieChart: pieChartabs, arrchart: arrRevenue)
                    
                }
                tblPieChartData.reloadData()
                cell?.layoutIfNeeded()
                
                return cell!
            }
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1")
            let lblicon = cell?.viewWithTag(112) as! UILabel
            let lblname = cell?.viewWithTag(113) as! UILabel
            let lblsales = cell?.viewWithTag(114) as! UILabel
            let lblrevenue = cell?.viewWithTag(115) as! UILabel
            
            lblicon.layer.cornerRadius = lblicon.frame.size.width / 2
            print("\(Utilities.sharedUtilities.colorArray().count)")
            let color = Utilities.sharedUtilities.colorArray().object(at: indexPath.row)
            lblicon.backgroundColor = color as? UIColor
            lblicon.layer.masksToBounds = true
            let Name = masterList.object(at: indexPath.row) as! NSString
            lblname.text = Name .capitalized
            
            if selectedIndex == 1
            {
                lblsales.text = NSString(format: "%@", arrSales.object(at: indexPath.row) as! CVarArg) as String
                let revenueValue = ((arrPerSales.object(at: indexPath.row)) as AnyObject).floatValue * 100
                lblrevenue.text = NSString(format: "%.1f%%", revenueValue) as String
            }
            else{
                let salesValue = arrRevenue.object(at: indexPath.row) as! NSString
                lblsales.text = NSString(format: "%.1f", salesValue.floatValue) as String
                let revenueValue = (arrPerRevenue.object(at: indexPath.row) as AnyObject).floatValue * 100
                lblrevenue.text = NSString(format: "%.1f%%", revenueValue) as String
            }
            
            cell?.layoutIfNeeded()
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblDailySales
        {
            if indexPath.row == 0
            {
                return 345.0
            }
            else{
                if masterList.count <= 4
                {
                    return 500.0
                }
                else if masterList.count < 6
                {
                    return 560.0
                    
                }
                else{
                    return 620.0
                }
            }
        }
        else{
            return 35
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
        print("chartValueSelected")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("chartValueNothingSelected")
    }
    
    func configurePieChart(pieChart: PieChartView ,arrchart : NSArray)
    {
        self.setupPieChartView(chartView: pieChart)
        pieChart.holeColor = UIColor.white
        pieChart.rotationEnabled = true
        pieChart.highlightPerTapEnabled = true
        pieChart.centerTextOffset = CGPoint(x: 0.0, y: 0.0)
        if selectedIndex == 1
        {
            pieChart.centerText = "EW Numbers"
        }
        else if selectedIndex == 2
        {
            pieChart.centerText = " Revenue"
        }
        var i = 0
        let values = NSMutableArray.init()
        for eachData in arrchart {
            let datas =  Double((eachData as AnyObject).floatValue * 100)
            let data = PieChartDataEntry(value: Double(round(10*datas)/10))
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
        
        
        let baseUrl = "http://bi.servassure.net/api/"
        manager .post("\(baseUrl)SalesOverview", parameters: dictRegion, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
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
                        self.dictStartDateEndDate  = ["start_date" : self.first_day_month,"end_date" : self.strcurrent_day_month]
                        
                    }
                    else if self.btnRange.isSelected
                    {
                        let addtionInfo = info["data1"] as! NSDictionary
                        self.strStartdate = addtionInfo["start_date"] as! String
                        self.strEnddate = addtionInfo["end_date"] as! String
                        
                        let startdate = Utilities.sharedUtilities.RengeDateConversion(serverDate: self.strStartdate)
                        let enddate = Utilities.sharedUtilities.RengeDateConversion(serverDate: self.strEnddate)
                        self.strsetdate = "\(startdate) - \(enddate)"
                        self.dictStartDateEndDate = ["start_date":self.strStartdate,"end_date":self.strEnddate]
                        
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
        
        
         let baseUrl = "http://bi.servassure.net/api/"
        manager .post("\(baseUrl)SalesOverview", parameters: dictPreRegion, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
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
                            let totalSales1 = dictTodaydata["TotalSales"] as! NSNumber
                            let todaysale : Float = totalSales1.floatValue
                            
                            let salesdiffrence = todaysale - Presale
                            let AVG = abs(salesdiffrence)
                            let AVGResult = AVG/Presale
                            self.salseAVG = NSString(format: "%f", AVGResult) as String
                            
                            let newPrerevenue : Float
                            let newRevenue : Float
                            let PreviousRev = dictdata["TotalRevenue"]as! NSNumber
                            let TodayRev = dictTodaydata["TotalRevenue"]as! NSNumber
                            
                            if (self.btnMonth.isSelected == true)
                            {
                                newPrerevenue = PreviousRev.floatValue / 10000000
                                newRevenue = TodayRev.floatValue / 10000000
                            }
                            else
                            {
                                newPrerevenue = PreviousRev.floatValue / 100000
                                newRevenue = TodayRev.floatValue / 100000
                            }
                            
                            let RevenueDiffrence = newRevenue - newPrerevenue
                            let AVGRev = abs(RevenueDiffrence)
                            let AVGRevResult = AVGRev/newPrerevenue
                            self.RevenueAVG = NSString(format: "%f", AVGRevResult) as String
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
                    
                    self.tblDailySales.reloadData()
                    self.ChartDataShowMethod()
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
        
        let baseUrl = "http://bi.servassure.net/api/"
        manager .post("\(baseUrl)SalesOverviewOEMLevel2", parameters: dictStartDateEndDate, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
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
                        self.masterList = groupArr.mutableCopy() as! NSMutableArray
                        let SalesArr = data ["TotalSales"] as! NSArray
                        self.arrSales = SalesArr.mutableCopy() as! NSMutableArray
                        let perSalesArr = data["percentages_sales"] as! NSArray
                        self.arrPerSales = perSalesArr.mutableCopy() as!NSMutableArray
                        let perRevenueArr = data["percentages_revenue"] as! NSArray
                        self.arrPerRevenue = perRevenueArr.mutableCopy() as! NSMutableArray
                        self.arrRevenue = NSMutableArray.init()
                        
                        if self.btnMonth.isSelected
                        {
                            let arrayRev = data["TotalRevenue"]as! NSArray
                            for num in arrayRev
                            {
                                let num1 = num as! NSNumber
                                let value = num1.floatValue / 10000000
                                
                                let strvalues = NSString(format: "%.1f", value)
                                self.arrRevenue .add(strvalues)
                            }
                        }
                        else{
                            let arrayRev = data["TotalRevenue"]as! NSArray
                            for num in arrayRev
                            {
                                let num1 = num as! NSNumber
                                let value = num1.floatValue / 100000
                                
                                let strvalues = NSString(format: "%.1f", value)
                                self.arrRevenue .add(strvalues)
                            }
                        }
                    }
                    
                    self.tblDailySales.reloadData()
                    self.tblPieChartData.reloadData()
                    
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
