//
//  Value.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/28.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation

var Dict = [Int: String]()

func APPSetValue(key:Int, value:String){
    Dict[key] = value
}

func APPGetValue(key:Int) -> String{
    return Dict[key] ?? ""
}

func APPDelValue(key:Int) {
    Dict.removeValue(forKey: key)
}
