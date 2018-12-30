//
//  Verion.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/30.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import ObjectMapper

struct VersionModel:Mappable{
    var appType:String = "iOS"
    var appVersion:String = ""
    var mobileBrand:String = "Apple"
    var mobileModel:String = ""
    var mobileSystemVersion:String = ""
    
    init?(map: Map) {
        
    }
    
    init(){
        
    }
    
    mutating func mapping(map: Map) {
        appType <- map["appType"]
        appVersion <- map["appVersion"]
        mobileBrand <- map["mobileBrand"]
        mobileModel <- map["mobileModel"]
        mobileSystemVersion <- map["mobileSystemVersion"]
    }
    
}
