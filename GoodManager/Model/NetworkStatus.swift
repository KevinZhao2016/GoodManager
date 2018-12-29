//
//  NetworkStatus.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation

struct NetworkStatus {
    var mode:Int
    var describe:String
    
    init(imode:Int, idescribe:String){
        mode = imode
        describe = idescribe
    }
}
