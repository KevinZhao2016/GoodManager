//
//  LocationModel.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/31.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import ObjectMapper

struct LocationModel : Mappable{
    var longitude:String = ""
    var dimension:String = ""
    var cityName:String = ""
    var GBCode:String = ""
    
    init?(map: Map) {
        
    }
    
    init(){
        
    }
    
    mutating func mapping(map: Map) {
        longitude <- map["longitude"]
        dimension <- map["dimension"]
        cityName <- map["cityName"]
        GBCode <- map["GBCode"]
    }
}
