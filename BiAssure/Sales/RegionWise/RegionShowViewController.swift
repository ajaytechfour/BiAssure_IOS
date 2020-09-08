//
//  RegionShowViewController.swift
//  BiAssure
//
//  Created by Pulkit on 04/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import SSMaterialCalendarPicker
import SVProgressHUD
import KSToastView
import AFNetworking
import Charts
import RMPickerViewController

class RegionShowViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,SSMaterialCalendarPickerDelegate,ChartViewDelegate
{
    
    
    var strRegionname = ""
    var apistr = ""
    var strCome = ""
    var strOEMname = ""
    var strdate = ""
    var regionName = ""
    
    var selectedIndex = 0
    
    var _startDate = NSDate()
    var _endDate = NSDate()
    
    var masterList = NSMutableArray()
    var arrRegionSales = NSMutableArray()
    var arrRegionPerSales = NSMutableArray()
    var arrRegionRevenue = NSMutableArray()
    
    var datePicker = SSMaterialCalendarPicker()
    var adtBarChartView = BarChartView()
    var pieChartOEM = PieChartView()
    var sePicker = CustomPicker()
    var appDele :AppDelegate = AppDelegate()
    
    var dictStartDateEndDate = NSDictionary()
    
    
    
    
    @IBOutlet weak var tblModelShow: UITableView!
    @IBOutlet weak var tblTabularDataShow: UITableView!
    @IBOutlet weak var btnGraphical: UIButton!
    @IBOutlet weak var btnTabular: UIButton!
    @IBOutlet weak var btnAllRegion: UIButton!
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        style()
        configureView()
        
        lblStartDate.text = String(format: "\(strdate)")
        
        if masterList.count == 0
        {
            btnAllRegion.isUserInteractionEnabled = false
        }
        else
        {
            btnAllRegion.isUserInteractionEnabled = true
        }
        
        btnTabular.isSelected = false
        btnGraphical.isSelected = true
        lblLine1.isHidden = false
        lblLine2.isHidden = true
        tblModelShow.isHidden = false
        tblTabularDataShow.isHidden = true
        
        tblModelShow.reloadData()
    }
    
    
    
    
    
    
    @IBAction func btnAllModels_didSelect(_ sender:UIButton)
    {
        let selectAction = RMAction(title: "Select", style: RMActionStyle.done, andHandler: { controller in
            let picker = UIPickerView()
            let selectedRow :NSInteger = picker.selectedRow(inComponent: 0)
            let selectedRegion = self.masterList.object(at: selectedRow) as! String
            sender.setTitle(selectedRegion, for: UIControl.State.normal)
            self.regionName = selectedRegion
            self.title = selectedRegion
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let RegionDetailViewController = mainStoryboard.instantiateViewController(withIdentifier: "RegionDetailViewController") as! RegionDetailViewControllerViewController
            RegionDetailViewController.strRegionModel = "Regionwise"
            RegionDetailViewController.apistr = self.apistr
            RegionDetailViewController.strRegionName = selectedRegion
            RegionDetailViewController.Region = self.regionName
            RegionDetailViewController.strOEM = self.strOEMname
            
            self.navigationController?.pushViewController(RegionDetailViewController, animated: true)
            
        })
        let cancelAction :RMAction = RMAction.init(title: "Cancel", style: RMActionStyle.cancel) { (controller) in
            print("Row selection was canceled")
            }!
        
        let pickerController : RMPickerViewController = RMPickerViewController.init(style: RMActionControllerStyle.white, select: selectAction as? RMAction<UIPickerView>, andCancel: cancelAction as? RMAction<UIPickerView>)!
        pickerController.picker.tag = 1
        pickerController.picker.delegate = self
        pickerController.picker.dataSource = self
        pickerController.title = "All Regions"
        pickerController.message = "Select a Region of your choice"
        self.present(pickerController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnDatePickerShow(_ sender:UIButton)
    {
        sePicker.showPickerViewWithAnimation(sourceView: self.view)
    }
    
    
    
    @IBAction func btnGraphical_didSelect(_ sender:UIButton)
    {
        btnTabular.isSelected = false
        btnGraphical.isSelected = true
        lblLine1.isHidden = false
        lblLine2.isHidden = true
        tblModelShow.isHidden = false
        tblTabularDataShow.isHidden = true
        tblModelShow.reloadData()
    }
    
    
    
    @IBAction func btnTabular_didSelect(_ sender:UIButton)
    {
        btnTabular.isSelected = true
        btnGraphical.isSelected = false
        lblLine1.isHidden = true
        lblLine2.isHidden = false
        tblModelShow.isHidden = true
        tblTabularDataShow.isHidden = false
        tblTabularDataShow.reloadData()
    }
    
    
    
    @IBAction func slidemenuAction(_ sender:UIButton)
    {
        kMainViewController.showRightView(animated: true, completionHandler: nil)
        
    }
    
    
    
    @IBAction func btnLeft_didSelect(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
        let view = UIView.init(frame: CGRect.init(x: -30, y: 0, width: 150, height: 33))
        let imageView = UIImageView.init(frame: CGRect.init(x: -30, y: 5, width: 20, height: 25))
        imageView.image = UIImage.init(named: "Regions-icon-white")
        let lblTitle : UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        
        lblTitle.text = "Regions"
        lblTitle.textColor = UIColor.white
        lblTitle.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(imageView)
        view.addSubview(lblTitle)
        self.navigationItem.titleView = view
        
        let backButton:UIButton =  UIButton(type:.custom)
        backButton.frame =  CGRect.init(x: -180, y: 0, width: 180, height: 22)
        backButton.setImage(UIImage.init(named: "arrow-left"), for: UIControl.State.normal)
        backButton.addTarget(self, action: #selector(btnLeft_didSelect), for: UIControl.Event.touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -30, bottom: 0, right: 0)
        backButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 0)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        backButton.setTitle(apistr, for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        
        
        let menuButton:UIButton =  UIButton(type:.custom)
        menuButton.frame =  CGRect.init(x: 30, y: 0, width: 52, height: 40)
        menuButton.setImage(UIImage.init(named: "right-menu-icon"), for: UIControl.State.normal)
        menuButton.addTarget(self, action: #selector(slidemenuAction), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: menuButton)
        
    }
    
    
    
    func updateDate(startDate:NSDate,endDate:NSDate)->Void
    {
        strdate = String(format: "\(Utilities.sharedUtilities.getDuration(date: startDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate))")
        
        if strCome == "OEM"{
            dictStartDateEndDate = ["start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate),"brand": apistr, "region": "all","oem":strOEMname]
        }
        else{
            dictStartDateEndDate = ["start_date" : Utilities.sharedUtilities.overViewDate(date: startDate),"end_date" : Utilities.sharedUtilities.overViewDate(date: endDate),"brand": apistr, "region": strRegionname,"oem":strOEMname]
        }
        
        ChartDataShowMethod()
    }
    
    
    
    
    
    
    func configureBarChartGraph(barChartView:BarChartView,arrchart:NSArray)->Void
    {
        let xVals = NSMutableArray.init()
        for eachData1 in arrchart
        {
            //let eachData = eachData1 as! NSNumber
            xVals.add(eachData1)
        }
        
        let dataSets = NSMutableArray.init()
        let colors = NSMutableArray.init(array: Utilities.sharedUtilities.colorArray())
        colors.add( ChartColorTemplates.joyful())
        colors.add( ChartColorTemplates.colorful())
        
        var i = 0
        var barChartdataEntry1: [BarChartDataEntry] = []
        for eachData1 in arrchart
        {
            let eachData = eachData1 as! NSString
            let dataEntry  = BarChartDataEntry.init(x: Double(i), y: Double(eachData.floatValue))
            barChartdataEntry1.append(dataEntry)
            
            
            let set1  = BarChartDataSet.init(entries:barChartdataEntry1, label: "")
            set1.axisDependency = .left
            set1.drawIconsEnabled = true
            set1.highlightColor = UIColor.red
            set1.drawValuesEnabled = true
            
            let colorapp =  NSMutableArray.init()
            for j in 0..<arrchart.count {
                
                let color = colors.object(at: j)
                colorapp.add(color)
                
            }
            
            set1.colors = colorapp as! [NSUIColor]
            dataSets.add(set1)
            i+=1
            
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
            barChartView.borderColor = UIColor.blue
            barChartView.borderLineWidth = 30
            let xAxis : XAxis = barChartView.xAxis
            xAxis.labelPosition = .bottom
            xAxis.labelFont = UIFont.systemFont(ofSize: 0)
            xAxis.drawGridLinesEnabled = false
            xAxis.granularity = 3.0
            xAxis.labelCount = 7
            
            let data : BarChartData = BarChartData(dataSet: set1)
            data.setValueTextColor(UIColor.black)
            data.setValueFont(UIFont.systemFont(ofSize: 9))
            data.setDrawValues(true)
            barChartView.data = data
            barChartView.animate(yAxisDuration: 2.0)
        }
        
    }
    
    
    func setupBarLineChartView(chartView:BarLineChartViewBase)->Void
    {
        chartView.chartDescription?.enabled = false
        chartView.drawGridBackgroundEnabled = false
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
        
        if arrchart.count == 0{
            pieChart.centerText = String(format: "No Chart data available")
        }
        else{
            
            self.setupPieChartView(chartView: pieChart)
            pieChart.holeColor = UIColor.white
            pieChart.holeRadiusPercent = 0.68
            pieChart.rotationEnabled = true
            pieChart.highlightPerTapEnabled = true
            pieChart.maxAngle = 180.0
            pieChart.rotationAngle = 180.0
            pieChart.centerTextOffset = CGPoint(x: 0.0, y: 0.0)
            
            var i = 0
            let values = NSMutableArray.init()
            var dataSet = PieChartDataSet()
            for eachdata1 in arrchart
            {
                // let eachdata = eachdata1 as! NSNumber
                let data = PieChartDataEntry.init(value: Double((eachdata1 as AnyObject).floatValue * 100), label: String(format: "\(masterList.object(at: i))" as String))
                i+=1
                values .add(data)
            }
            
            dataSet = PieChartDataSet.init(entries: values as? [ChartDataEntry], label: "")
            dataSet.sliceSpace = 1.0
            dataSet.selectionShift = 5.0
            dataSet.valueLineWidth = 30
            dataSet.drawValuesEnabled = true
            dataSet.entryLabelFont = UIFont.systemFont(ofSize: 0.0)
            dataSet.valueTextColor = UIColor.black
            
            let colors = NSMutableArray.init(array: Utilities.sharedUtilities.colorArray())
            colors.add( ChartColorTemplates.joyful())
            colors.add( ChartColorTemplates.colorful())
            
            dataSet.colors = colors as! [NSUIColor]
            let pFormatter : NumberFormatter = NumberFormatter.init()
            pFormatter.numberStyle = NumberFormatter.Style.percent
            pFormatter.maximumFractionDigits  = 1
            pFormatter.multiplier = 1
            pFormatter.percentSymbol = "%"
            let formatter = DefaultValueFormatter(formatter: pFormatter)
            dataSet.valueFormatter = formatter
            let data = PieChartData.init(dataSet: dataSet)
            pieChart.data = data
            pieChart.setNeedsDisplay()
            pieChart.animate(xAxisDuration: 1.0)
        }
    }
    
    
    func setupPieChartView(chartView: PieChartView)
    {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.chartDescription?.enabled = false
        chartView .setExtraOffsets(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0)
        chartView.holeRadiusPercent = 0.58
        chartView.drawHoleEnabled = true
        chartView.drawCenterTextEnabled = true
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        chartView.rotationAngle = 0.0
        
        let l = chartView.legend
        l.horizontalAlignment = Legend.HorizontalAlignment.left
        l.verticalAlignment = Legend.VerticalAlignment.bottom
        l.orientation = Legend.Orientation.horizontal
        l.drawInside = false
        l.xEntrySpace = 0.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblModelShow
        {
            if indexPath.row == 0
            {
                let cell = tableView .dequeueReusableCell(withIdentifier: "ModelviewCell0", for: indexPath)
                adtBarChartView = cell.viewWithTag(300) as! BarChartView
                configureBarChartGraph(barChartView: adtBarChartView, arrchart: arrRegionRevenue)
                return cell
            }
            else
            {
                let cell = tableView .dequeueReusableCell(withIdentifier: "ModelviewCell1", for: indexPath)
                pieChartOEM = cell.viewWithTag(100) as! PieChartView
                configurePieChart(pieChart: pieChartOEM, arrchart: arrRegionPerSales)
                return cell
            }
        }
        else
        {
            if indexPath.row == 0
            {
                let cell = tableView .dequeueReusableCell(withIdentifier: "TabularviewCell0", for: indexPath)
                let viewbg = cell .viewWithTag(10)
                
                var y:Float = 5.0
                var x:Float = 5.0
                
                if viewbg!.subviews.count > 0
                {
                    for v in viewbg!.subviews
                    {
                        v.removeFromSuperview()
                    }
                }
                
                for i in 0..<masterList.count
                {
                    let lblOne = UILabel()
                    let imgArrow = UIImageView()
                    let lbltwo = UILabel()
                    
                    lblOne.textColor = UIColor.darkGray
                    lblOne.font = UIFont.systemFont(ofSize: 14)
                    lbltwo.textColor = UIColor.darkGray
                    lbltwo.font = UIFont.systemFont(ofSize: 14)
                    
                    
                    lblOne.frame = CGRect(x: 3, y: CGFloat(y), width: 116, height: 21)
                    lblOne.text = "\(masterList.object(at: i))"
                    
                    imgArrow.frame = CGRect(x: 132, y: CGFloat(y + 5), width: 120, height: 15)
                    imgArrow.image = UIImage(named: "grid-arrow-line")
                    
                    
                    lbltwo.frame = CGRect(x: 263, y: CGFloat(x), width: 70, height: 21)
                    
                    
                    
                    
                    y = Float(lblOne.frame.origin.y + lblOne.frame.size.height + 10)
                    x = Float(lbltwo.frame.origin.y + lbltwo.frame.size.height + 10)
                    // z = Float(imgArrow.frame.origin.y + imgArrow.frame.size.height + 10)
                    
                    viewbg!.addSubview(lblOne)
                    viewbg!.addSubview(imgArrow)
                    viewbg!.addSubview(lbltwo)
                    
                    
                    
                    lbltwo.text = String(format: "%.1f", (arrRegionRevenue.object(at: i) as? NSString)!.floatValue)
                }
                
                return cell
            }
            else{
                let cell = tableView .dequeueReusableCell(withIdentifier: "TabularviewCell1", for: indexPath)
                let viewbg = cell .viewWithTag(10)
                
                var y:Float = 5.0
                var x:Float = 5.0
                
                if viewbg!.subviews.count > 0
                {
                    for v in viewbg!.subviews
                    {
                        v.removeFromSuperview()
                    }
                }
                
                for i in 0..<masterList.count
                {
                    let lblOne = UILabel()
                    let imgArrow = UIImageView()
                    let lbltwo = UILabel()
                    
                    lblOne.textColor = UIColor.darkGray
                    lblOne.font = UIFont.systemFont(ofSize: 14)
                    lbltwo.textColor = UIColor.darkGray
                    lbltwo.font = UIFont.systemFont(ofSize: 14)
                    
                    
                    lblOne.frame = CGRect(x: 3, y: CGFloat(y), width: 116, height: 21)
                    lblOne.text = "\(masterList.object(at: i))"
                    
                    imgArrow.frame = CGRect(x: 132, y: CGFloat(y + 5), width: 120, height: 15)
                    imgArrow.image = UIImage(named: "grid-arrow-line")
                    
                    
                    lbltwo.frame = CGRect(x: 263, y: CGFloat(x), width: 70, height: 21)
                    
                    
                    y = Float(lblOne.frame.origin.y + lblOne.frame.size.height + 10)
                    x = Float(lbltwo.frame.origin.y + lbltwo.frame.size.height + 10)
                    
                    viewbg?.addSubview(lblOne)
                    viewbg?.addSubview(imgArrow)
                    viewbg?.addSubview(lbltwo)
                    
                    
                    lbltwo.text = String(format: "%.1f", (arrRegionSales.object(at: i) as? NSNumber)!.floatValue)
                    
                }
                
                return cell
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblModelShow
        {
            return 270.0
        }
        else{
            return CGFloat((masterList.count * 50) + 50)
            
        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return masterList.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return String(format: "\(masterList.object(at: row))"as String)
    }
    
    
    
    
    
    
    func rangeSelected(withStart startDate: Date!, andEnd endDate: Date!)
    {
        _startDate = startDate! as NSDate
        _endDate = endDate! as NSDate
        strdate = String(format: "\(  Utilities.sharedUtilities.getDuration(date: startDate! as NSDate)) - \(Utilities.sharedUtilities.getDuration(date: endDate! as NSDate)  )")
        
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
        
        let token = appDele.getSessionId()
        
        serializerRequest.setValue(token, forHTTPHeaderField: "x-access-token")
        serializerRequest.setValue("\(timestamp)", forHTTPHeaderField: "timestamp")
        manager.responseSerializer = AFJSONResponseSerializer.init()
        
        
        
        let BaseUrl = "http://bi.servassure.net/api/"
        manager .post("\(BaseUrl)SalesOverviewOEMLevel2", parameters: dictStartDateEndDate, progress: nil, success: { (task: URLSessionDataTask!, responseObject: Any!) in
            
            
            if let jsonResponse = responseObject as? [String: AnyObject] {
                // here read response
                print("json response \(jsonResponse.description)")
                let info : NSDictionary = jsonResponse as NSDictionary
                if info["success"]as! Int == 1
                {
                    let dataArray = info["data"] as! NSArray
                    if dataArray.count != 0 {
                        let Data = dataArray.object(at: 0)as! NSDictionary
                        
                        self.masterList.removeAllObjects()
                        self.arrRegionPerSales.removeAllObjects()
                        self.arrRegionSales.removeAllObjects()
                        self.arrRegionRevenue.removeAllObjects()
                        
                        let arrayproduct = Data["group"] as! NSArray
                        self.masterList = arrayproduct.mutableCopy() as! NSMutableArray
                        let arrayproductclaim = Data["TotalSales"] as! NSArray
                        self.arrRegionSales = arrayproductclaim.mutableCopy() as! NSMutableArray
                        let arrayproductclaimno = Data["percentages_sales"] as! NSArray
                        self.arrRegionPerSales = arrayproductclaimno.mutableCopy() as! NSMutableArray
                        
                        
                        let arrayproductclaimarr = Data["TotalRevenue"]  as! NSArray
                        
                        let object = arrayproductclaimarr.mutableCopy() as! NSMutableArray
                        for num1 in object {
                            guard let num1 = num1 as? NSNumber else {
                                continue
                            }
                            let value = num1.floatValue / 100000
                            let strvalues = String(format: "%.2f", value)
                            
                            self.arrRegionRevenue.add(strvalues)
                            
                        }
                        
                    }
                    let strStartdate = (info["addtionalinfo"] as? [AnyHashable : Any])?["start_date"] as? String
                    let strEnddate = (info["addtionalinfo"] as? [AnyHashable : Any])?["end_date"] as? String
                    
                    let startdate = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: strStartdate!)
                    let enddate = Utilities.sharedUtilities.ClaimsMonthDateConversion(serverDate: strEnddate!)
                    self.strdate = "\(startdate) - \(enddate)"
                    
                    self.lblStartDate.text = self.strdate
                    
                    self.tblModelShow.reloadData()
                    self.tblTabularDataShow.reloadData()
                    
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
