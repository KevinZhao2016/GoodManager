//
//  JsApiSwift.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/23.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation

class JsApiSwift: NSObject {
    
    //MUST use "_" to ignore the first argument name explicitly。
    @objc func testSyn( _ arg:String) -> String {
        
        return String(format:"%@[Swift sync call:%@]", arg, "test")
    }
    
    
    
}
