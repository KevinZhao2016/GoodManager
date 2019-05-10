//
//  JS.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import WebKit


//调用js方法
func APPExecWinJS(mark:String, JSFun:String){
    var vc:MainViewController?
    print("mark:  \(mark)")
    if (mark == "") {
        vc = getLastMainViewController()
    }else{
        let _mark = mark
        vc = findControllerByMark(mark: _mark)
    }
    if vc!.webview != nil {
        vc!.webview.evaluateJavaScript(JSFun) { (result, error) in
            //处理js调用结果
            print(result as Any)
        }
    }else{
        print("webview is nil!")
        print("\(JSFun)")
    }
}

func ExecWinJS(JSFun:String){
    let vc = getLastMainViewController()
    let Fun = "javascript:" + JSFun
    print(Fun)
    DispatchQueue.main.async {
        vc.webview.evaluateJavaScript(Fun) { (result, error) in
            //处理js调用结果
            print(result)
            print(error)
        }
    }
}

class ocUseSwift: NSObject {
    @objc func ExecWinJS(JSFun:String) -> Void{
        let vc = getLastMainViewController()
        let Fun = "javascript:" + JSFun
        print(Fun)
        vc.webview.evaluateJavaScript(Fun) { (result, error) in
            //处理js调用结果
            print("js处理结果result:  \(String(describing: result))")
            print("js处理结果result:  \(String(describing: error))")
        }
    }
}
