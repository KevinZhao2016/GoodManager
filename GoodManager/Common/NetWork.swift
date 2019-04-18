//
//  NetWork.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import Reachability
import SystemConfiguration.CaptiveNetwork
import CoreTelephony
import SwiftyJSON

class Network{
    
    func getSSidInfo() -> String {
        var currentSSID = ""
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces) {
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary
                    currentSSID = interfaceData["SSID" as NSObject] as! String
                }
            }
        }
        return currentSSID
    }
    
    func getNetworkType() -> String{
        let info = CTTelephonyNetworkInfo()
        var result:String = ""
        if let carrier = info.subscriberCellularProvider {
            let currentRadioTech = info.currentRadioAccessTechnology!
            print("数据业务信息：\(currentRadioTech)")
            print("网络制式：\(getNetworkType(currentRadioTech: currentRadioTech))")
            result = getNetworkType(currentRadioTech: currentRadioTech)
            print("运营商名字：\(carrier.carrierName!)")
            print("移动国家码(MCC)：\(carrier.mobileCountryCode!)")
            print("移动网络码(MNC)：\(carrier.mobileNetworkCode!)")
            print("ISO国家代码：\(carrier.isoCountryCode!)")
            print("是否允许VoIP：\(carrier.allowsVOIP)")
        }
        return result
    }
    
    private func getNetworkType(currentRadioTech:String) -> String {
        var networkType = ""
        switch currentRadioTech {
            case CTRadioAccessTechnologyGPRS:
                networkType = "2G"
            case CTRadioAccessTechnologyEdge:
                networkType = "2G"
            case CTRadioAccessTechnologyeHRPD:
                networkType = "3G"
            case CTRadioAccessTechnologyHSDPA:
                networkType = "3G"
            case CTRadioAccessTechnologyCDMA1x:
                networkType = "2G"
            case CTRadioAccessTechnologyLTE:
                networkType = "4G"
            case CTRadioAccessTechnologyCDMAEVDORev0:
                networkType = "3G"
            case CTRadioAccessTechnologyCDMAEVDORevA:
                networkType = "3G"
            case CTRadioAccessTechnologyCDMAEVDORevB:
                networkType = "3G"
            case CTRadioAccessTechnologyHSUPA:
                networkType = "3G"
            default:
                break
            }
    return networkType
    }
    
}

func APPGetNetWork() -> String{
    let reachability = Reachability()!
    var networkStatus = NetworkStatus(Mode:0,Describe:"")
    let network = Network()
    
    let checkNetObject = checkNet()
    
//    var isNetGood = false
//    isNetGood = checkNetObject.checkNetCanUse()
    
    var isReach = false
    isReach = checkNetObject.isReach()
    print(isReach)
    
    // 检测网络连接状态
    if reachability.connection != .none {
        // 检测网络类型
        if reachability.connection == .wifi {
            print("网络类型：Wifi")
            
            if isReach{
                print("网络连接：可用")
                networkStatus.mode = 2
                networkStatus.describe = network.getSSidInfo()
                print(networkStatus.toJSON())
            }else{
                print("网络连接：不可用")
                networkStatus.mode = 0
                networkStatus.describe = network.getSSidInfo()
                print(networkStatus.toJSON())
            }
            
            
        } else if reachability.connection == .cellular {
            print("网络类型：移动网络")
            print("网络连接：可用")
            networkStatus.mode = 1
            networkStatus.describe = network.getNetworkType()
        } else {
            print("网络连接：不可用")
            print("网络连接：可用")
        }
    }
        return networkStatus.toJSONString()!
}



