//
//  LaunchResultModel.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/18.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import ObjectMapper

struct LaunchResultModel:Mappable{
    
    var code:Int = 0
    var errcode:Int = 0
    var errmsg:String = ""
    var serverTime:String = ""
    var result:ResultModel = ResultModel()
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        errcode <- map["errcode"]
        errmsg <- map["errmsg"]
        serverTime <- map["serverTime"]
        result <- map["result"]
    }
}
