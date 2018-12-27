//
//  NetWork.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import Reachability

func APPGetNetWork(){
    let reachability = Reachability()!
    
    // 检测网络连接状态
    if reachability.connection != .none {
        print("网络连接：可用")
    } else {
        print("网络连接：不可用")
    }
    
    // 检测网络类型
    if reachability.connection == .wifi {
        print("网络类型：Wifi")
    } else if reachability.connection == .cellular {
        print("网络类型：移动网络")
    } else {
        print("网络类型：无网络连接")
    }

}
