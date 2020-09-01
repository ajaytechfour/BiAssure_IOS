//
//  Utilities.swift
//  BiAssureNew
//
//  Created by pulkit Tandon on 01/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.
//

import UIKit
import TAKUUID
import Colours
import CommonCrypto


class Utilities: NSObject {
    
    //DECLARATION OF VARIABLED
    
    var selectedIndex = 0
    var campiagnSelectedIndex = 0
    var storeSelectdIndex = 0
    
    
    
    fileprivate var count = 120
    var colors: [UIColor]!
    
    var appDelegate:AppDelegate = AppDelegate()
    
    
    
    //DECLARATION OF SINGLETON CLASS
    
    static let sharedUtilities:Utilities = {
        let instance = Utilities ()
        return instance
    } ()
    
    
    func convertToken(timestamp:NSInteger, username: String) -> String
    {
        
        let md5String = "af1cdd8etele7dc308G17D48craft886TH8dd477favrvpc88 \(timestamp) \(username)"
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, md5String, CC_LONG(md5String.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        //context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        return hexString
        
        
    }
    
    
    func getIPAddress()-> String
    {
        var address : String?
        
        // Get list of all interfaces on the local machine:
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

