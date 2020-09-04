//
//  Utilities.swift
//  BiAssure
//
//  Created by Pulkit on 03/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import TAKUUID
import Colours
import CommonCrypto


class Utilities: NSObject {
    
   
    var selectedIndex = 0
    var campiagnSelectedIndex = 0
    var storeSelectdIndex = 0
    
    var overViewDay = NSDictionary()
    var overViewMonth = NSDictionary()
    var overViewRange = NSDictionary()
    var storeViewDay = NSDictionary()
    var storeViewMonth = NSDictionary()

    var regionSalseData = NSArray()
    var regionServiceData = NSArray()
    var areaSalseData = NSArray()
    var areaServiceData = NSArray()
    var storesSalesData = NSArray()
    var storesServiceData = NSArray()
    var compiagnReport = NSArray()
    var plansReportArray = NSArray()
    
    var colorsArray = NSMutableArray()

    var fromDateCompaign = NSDate()
    var toDateCompaign = NSDate()
    var fromDatePlans = NSDate()
    var toDatePlans = NSDate()
    var fromDateMap = NSDate()
    var toDateMap = NSDate()
    var fromDateMonth_Compaign_daily = NSDate()
    var toDateMonth_Compaign_daily = NSDate()
    var fromDateMonth_Plans_daily = NSDate()
    var toDateMonth_Plans_daily = NSDate()

    fileprivate var count = 120
    fileprivate var hue: Hue = .random
    fileprivate var luminosity: Luminosity = .random
    var colors: [UIColor]!

    var appDelegate:AppDelegate = AppDelegate()

    
    
  
    static let sharedUtilities:Utilities = {
        let instance = Utilities ()
        return instance
    } ()
    
    func colorArray()-> NSMutableArray{
        if colorsArray.count == 0{
            colorsArray = NSMutableArray.init()

           colors = randomColors(count: count, hue: hue, luminosity: luminosity)
            for j in 0..<count  {
                
                let color = colors[j]
                colorsArray.add(color)
                
            }

            let INCREMENT:Double = 0.09
            
            for hue in stride(from: 0.0, through: 1.0, by: INCREMENT){
                let color:UIColor = UIColor.init(hue: CGFloat(hue), saturation: 1.0, brightness: 1.0, alpha: 1.0)
                colorsArray.add(color)
            }

        }
        
        return colorsArray
    }
    
    
    func overViewMonthAndYear(serverDate:String)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date: NSDate? = dateFormat.date(from: serverDate) as NSDate?
        dateFormat.dateFormat = "MMM yyyy"
        return dateFormat.string(from: date! as Date)
    }

    
    
    func overViewDateOnly(serverDate:String)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date: NSDate? = dateFormat.date(from: serverDate) as NSDate?
        dateFormat.dateFormat = "dd"
        return dateFormat.string(from: date! as Date)
    }
    
    func overViewDate(date:NSDate? = nil)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        if date == nil
        {
            return ""
        }
        
        return dateFormat.string(from: date! as Date)
    }
    
    
    func overViewrangeDate(serverDate:String)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date: NSDate? = dateFormat.date(from: serverDate) as NSDate?
        dateFormat.dateFormat = "MMM dd, YYYY"
        return dateFormat.string(from: date! as Date)
        
    }
    
    func overViewDateConversion(serverDate:String)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date: NSDate? = dateFormat.date(from: serverDate) as NSDate?
        dateFormat.dateFormat = "dd MMMM yyyy"
        return dateFormat.string(from: date! as Date)
        
    }
    
    func MonthDateConversion(serverDate:String)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date: NSDate? = dateFormat.date(from: serverDate) as NSDate?
        dateFormat.dateFormat = "dd MMM yyyy"
        return dateFormat.string(from: date! as Date)
        
    }
    //range date formate change
    func RengeDateConversion(serverDate:String)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date: NSDate? = dateFormat.date(from: serverDate) as NSDate?
        dateFormat.dateFormat = "MMM dd,yyyy"
        return dateFormat.string(from: date! as Date)
        
    }
    
    
    func overViewDateConversionDate(serverDate:String)-> NSDate
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: NSDate? = dateFormat.date(from: serverDate) as NSDate?
        return date!
    }
    
    func overViewStartAndEndDate(strtDate:String,enddate:String)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date: NSDate? = dateFormat.date(from: strtDate) as NSDate?
        let date2: NSDate? = dateFormat.date(from: enddate) as NSDate?
        dateFormat.dateFormat = "dd"
        let str :String = String(format: "\(dateFormat.string(from: date! as Date)))", "\(dateFormat.string(from: date2! as Date)))", 0)
        return str
    }
    
    func getCampiagnDate(date:NSDate)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.string(from: date as Date)
    }
    
    func getCampiagnEndDate(date:NSDate)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.string(from: date as Date)
    }
    
    func getDuration(date:NSDate)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM dd, yyyy"
        return dateFormat.string(from: date as Date)
    }
    
     func getDurationWith01(date:NSDate)-> String
     {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM 01-dd, yyyy"
        return dateFormat.string(from: date as Date)
    }
    
    func ClaimsMonthDateConversion(serverDate:String)-> String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date: NSDate? = dateFormat.date(from: serverDate) as NSDate?
        dateFormat.dateFormat = "MMM dd,yyyy"
        return dateFormat.string(from: date! as Date)
        
    }
    
    
    
    func convertToken(timestamp:NSInteger, username: String) -> String
    {
        
        let md5String = "af1cdd8etele7dc308G17D48craft886TH8dd477favrvpc88 \(timestamp) \(username)"
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, md5String, CC_LONG(md5String.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        return hexString
        
        
    }
    
    
    func getIPAddress()-> String
    {
        var address : String?
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else
        {
            return ""
            
        }
        guard let firstAddr = ifaddr else
        {
            return ""
            
        }
        
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address!
    }
    
   
    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
