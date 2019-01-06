//
//  JS.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation

//调用js方法
func APPExecWinJS(mark:String, JSFun:String){
    let vc = mainViewControllers.last
    vc!.webview.evaluateJavaScript(JSFun) { (result, error) in

    }
}
