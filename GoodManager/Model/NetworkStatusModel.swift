//
//  NetworkStatus.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import ObjectMapper

struct NetworkStatus: Mappable {
    var mode:Int?
    var describe:String?
    
    init?(map: Map) {
      
    }
    
    init(Mode:Int,Describe:String){
        mode = Mode
        describe = Describe
    }
    
    mutating func mapping(map: Map) {
        mode <- map["mode"]
        describe <- map["describe"]
    }
 
}
