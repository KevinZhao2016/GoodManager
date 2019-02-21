//
//  ExDictionary.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/30.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation

extension Dictionary{
    //字典转json
    func json() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData = try! JSONSerialization.data(withJSONObject: self, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}
