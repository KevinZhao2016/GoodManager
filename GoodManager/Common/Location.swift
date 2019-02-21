//
//  Location.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/25.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation

func APPStartLocation(callBackfunName:String){
    let vc = getLastMainViewController()
    callbackfun = callBackfunName
    vc.loadLocation()
//    ExecWinJS(JSFun: "(\"" + callBackfunName + "\")")
}
