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
    let vc = findControllerByMark(mark: mark)
    vc.webview.evaluateJavaScript(JSFun) { (result, error) in
        //处理js调用结果
        print(result as Any)
    }
}

func APPExecWinJS(JSFun:String){
    let vc = getLastMainViewController()
    vc.webview.evaluateJavaScript(JSFun) { (result, error) in
        //处理js调用结果
        print(result as Any)
    }
}
