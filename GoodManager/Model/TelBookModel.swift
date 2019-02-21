//
//  TelBookModel.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/29.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import ObjectMapper

struct TelBookModel:Mappable{
    var phone:String = ""
    var name:String = ""
    
    init?(map: Map) {
        
    }
    
    init(Phonenumber:String, Name:String){
        phone = Phonenumber
        name = Name
    }
    
    mutating func mapping(map: Map) {
        phone <- map["phone"]
        name <- map["name"]
    }
    
}
