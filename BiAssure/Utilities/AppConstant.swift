//
//  AppConstant.swift
//  MPartner
//
//  Created by Swetha on 18/02/19.
//  Copyright © 2019 Divya. All rights reserved.
//add appconstant class by Divya at 18/02/19 #taskId 5861

import Foundation
import UIKit
import SVProgressHUD
import AFNetworking
import CommonCrypto
import CoreTelephony


var appdelegate : AppDelegate = AppDelegate()

class AppConstants {
    
    //App Constants
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    let defaults = UserDefaults.standard
   
    // Dev
 // let BaseUrl = "http://166.62.100.102:5265/Api/MpartnerApi/"
   // let BaseUrlImage = "http://166.62.100.102:5265/Api/MpartnerApi/"

    // UAT NEW
    
  


    
    
    // Data Constants
    let token = "pass@1234"
    let appversion =  Bundle.main.infoDictionary!["CFBundleShortVersionString"]
    let imeinumber =  UIDevice.current.identifierForVendor!.uuidString
    let devicename = UIDevice.current.name
    let osversion = UIDevice.current.systemVersion
    let OSType = "iOS"
    let OSversionName = UIDevice.current.systemName
  
    //userid+appversion+deviceid
    

    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return text.filter {okayChars.contains($0) }
    }
   
    
    
    
    
    
    //Appstore
    func showAppStoreAlert(title: String , message: String, controller: UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
            { action in
                let newToken = appdelegate.getNewToken()
                 print("\(newToken)")
                appdelegate.saveToken(Token: newToken )
                let updatedToken = appdelegate.getToken()
                print("\(updatedToken)")

                //https://itunes.apple.com/us/app/luminous-mpartner/id1436674203?ls=1&mt=8
                let urlStr = "https://www.google.com/"
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
                    
                } else {
                    UIApplication.shared.openURL(URL(string: urlStr)!)
                }
        }))
       // alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    func showAlert(title: String , message: String, controller: UIViewController){
         DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.view.backgroundColor = UIColor.black
        //alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true, completion: nil)
        // duration in seconds
        let duration: Double = 2.0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
        }
    }

    //Logout
    func showLogoutAlert(title: String , message: String, controller: UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
            { action in
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "rootnavigation") as! UINavigationController
                
                let window = UIApplication.shared.delegate?.window as? UIWindow
                
                window?.rootViewController = navigationController
                UIView .transition(with: (window)!, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    /* -----MARK: -  NETWORK TYPE
      */
      
//      func getNetworkType()-> String
//      {
//          var network = "wifi"
//          let networkInfo = CTTelephonyNetworkInfo()
//          let networkString = networkInfo.currentRadioAccessTechnology
//
//          if networkString == CTRadioAccessTechnologyLTE{
//              network = "4G"
//              return network
//              // LTE (4G)
//          }else if networkString == CTRadioAccessTechnologyWCDMA{
//              // 3G
//              network = "3G"
//              return network
//          }else if networkString == CTRadioAccessTechnologyEdge{
//              // EDGE (2G)
//              network = "2G"
//              return network
//          }
//          return network
//      }
    
    
    func getFCMToken() -> String
    {
        return UserDefaults.standard.value(forKey: "FCMToken") as? String ?? ""
        
    }
    
    
    
    
    
    func overViewdateOnly(serverDate : String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        var date = Date()
        date = dateFormatterGet .date(from: serverDate)!
        dateFormatterGet.dateFormat = "dd"
        return dateFormatterGet .string(from: date)
        
    }
    func overViewMonthAndYear(serverDate : String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        var date = Date()
        date = dateFormatterGet .date(from: serverDate)!
        dateFormatterGet.dateFormat = "MMMM yyyy"
        return dateFormatterGet .string(from: date)
        
    }
    func overViewDateConversionDate (serverDate : String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
        var date = Date()
        date = dateFormatterGet .date(from: serverDate)!
        
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatterGet .string(from: date)
    }

   // MARK: To show progress HUD
        func showLoadingHUD(to_view: UIView) {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            // hud.label.text = "Loading..."
        }
    
        //MARK: To hide progress HUD
        func hideLoadingHUD(for_view: UIView) {
            SVProgressHUD.dismiss()
        }
    
    //MARK : OSVersion
    func getOSInfo()->String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    //MARK : APPVersion
    func getAppInfo()->String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return version + "(" + build + ")"
    }
    
    //MARK : hexString
    //"Hax color string get" by Divya 19/02/19 #TASKID:5861
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    //Mark : Cell Height dyanamic
    //"adjust Image Height" by Divya 19/02/19 #TASKID:5861

    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
        let widthOffset = downloadedImage.size.width - cellImageFrame.width
        let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
        let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
        let effectiveHeight = downloadedImage.size.height - heightOffset
        return(effectiveHeight)
    }
    //get IPAddress
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        if address == nil{
            return ""
        }
        else{
           return address
        }
        
    }
    
    func getNetworkType()-> String
       {
           var network = "wifi"
           let networkInfo = CTTelephonyNetworkInfo()
           if #available(iOS 12.0, *) {
               let networkString = networkInfo.serviceCurrentRadioAccessTechnology
               if networkString != nil{
               if networkString!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyLTE") }) != nil {
                   network = "4G"
                   
               }
               else if networkString!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyWCDMA") }) != nil {
                   network = "2G"
                   
               }
                   
               else if networkString!.first(where: { (_, value) in value.contains("CTRadioAccessTechnologyEdge") }) != nil {
                   network = "3G"
                   
                   
                   }}
               return network
               
               
           } else {
               let networkString = networkInfo.currentRadioAccessTechnology
               
               if networkString == CTRadioAccessTechnologyLTE{
                   network = "4G"
                   return network
                   // LTE (4G)
               }else if networkString == CTRadioAccessTechnologyWCDMA{
                   // 3G
                   network = "3G"
                   return network
               }else if networkString == CTRadioAccessTechnologyEdge{
                   // EDGE (2G)
                   network = "2G"
                   return network
               }
               return network
               
           }
       }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - TextField Corner Radius
     
     func setTextFieldCornerRadius(txtFName: PaddingTextField)
     {
         txtFName.layer.borderWidth = 1.0
         txtFName.layer.borderColor = UIColor.lightGray.cgColor
         txtFName.layer.cornerRadius = 2.0
         txtFName.clipsToBounds = true
         txtFName.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
     }
     
     
     func setViewCornerRadius(view: UITextView)
     {
         view.layer.borderWidth = 4.0
         view.layer.borderColor = UIColor.lightGray.cgColor//UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
         view.layer.cornerRadius = 2.0
         view.clipsToBounds = true
     }
     
     func setButtonCornerRadius(view: UIButton)
     {
         view.layer.borderWidth = 1.0
         view.layer.borderColor = UIColor.lightGray.cgColor//UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
         view.layer.cornerRadius = 2.0
         view.clipsToBounds = true
     }

     
    // MARK: - Email Validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }


    // MARK: - Set FontName
    
    func setFontInList(str1:String, str2:String) -> NSMutableAttributedString
    {
        var myMutableString = NSMutableAttributedString()
        var myMutableString1 = NSMutableAttributedString()
        var myMutableString2 = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: str1, attributes: [NSAttributedString.Key.font:UIFont(name: "Muli-ExtraBold", size: 18.0)!])
        
        myMutableString1 = NSMutableAttributedString(string: str2 , attributes: [NSAttributedString.Key.font:UIFont(name: "Muli-Regular", size: 15.0)!])
        
        myMutableString2 = NSMutableAttributedString(string: "\n" , attributes: nil)
        
        
        let combination = NSMutableAttributedString()
        
        combination.append(myMutableString)
        combination.append(myMutableString2)
        combination.append(myMutableString1)
        
        return combination
        
    }
    
    func setStatusBarColor(controller: UIViewController){
    
    if #available(iOS 13.0, *) {
              var statusBarHeight: CGFloat = 0
              let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
              statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
              
              let statusbarView = UIView()
              statusbarView.backgroundColor = UIColor.init(red: 49/255, green: 76/255, blue: 207/255, alpha: 1)
              
            controller.view.addSubview(statusbarView)
                        
              statusbarView.translatesAutoresizingMaskIntoConstraints = false
              statusbarView.heightAnchor
                  .constraint(equalToConstant: statusBarHeight).isActive = true
              statusbarView.widthAnchor
                .constraint(equalTo: controller.view.widthAnchor, multiplier: 1.0).isActive = true
              statusbarView.topAnchor
                .constraint(equalTo: controller.view.topAnchor).isActive = true
              statusbarView.centerXAnchor
                .constraint(equalTo: controller.view.centerXAnchor).isActive = true
            
          } else {
              let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
              statusBar?.backgroundColor = UIColor.red
          }
    
    
    }
    
    //MARK: - GRADIENT
    func gradientAdd(gradientView:UIView, color1:UIColor, color2:UIColor) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        //gradient.startPoint = CGPoint(x: 0.0, y: 0.5) // vertical gradient start
       // gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = gradientView.layer.bounds
        gradient.cornerRadius = gradientView.layer.cornerRadius
        gradientView.layer.insertSublayer(gradient, at: 1)
        
       }
    
    
    
    
    

     
    
}
