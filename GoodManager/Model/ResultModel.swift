//
//  ResultModel.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/18.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import ObjectMapper

struct ResultModel:Mappable {
    var picUrl:String = ""
    var linkUrl:String = ""
    init?(map: Map) {
        
    }
    
    init(){
        
    }
    mutating func mapping(map: Map) {
        picUrl <- map["picUrl"]
        linkUrl <- map["linkUrl"]
    }
}
