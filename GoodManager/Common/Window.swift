//
//  Window.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation

func APPWinOpen(url:String,mark:String,progressBarColor:String,statusBarColor:String){
    print("===================APPWinOpen=====================")
    let vc = getLastMainViewController()
    let webvc = MainViewController()
    webvc.mark = mark
    webvc.url = url
    mainViewControllers.append(webvc)
    APPSetProgressBarColor(color: progressBarColor)
    AppSetStatusBarColor(color: statusBarColor)
    vc.present(webvc, animated: true, completion: nil)
}

func APPWinClose(mark:String){
    print("===================APPWinClose=====================")
    let vc = findControllerByMark(mark: mark)
    vc.dismiss(animated: false, completion: nil)
    print(mark)
    var mark_ = mark
    var i:Int = 0
    for VC_ in mainViewControllers {
        print(VC_.mark)
        if(VC_.mark == mark_){
            print("i: \(i)")
            mainViewControllers.remove(at: i)
            return
        }else{
            i = i + 1
        }
    }
    // 如果没有找到相关页面，关闭“mark_home_”页面
    mainViewControllers.remove(at: mainViewControllers.count-1)
    let vc_wrong = getLastMainViewController()
    vc_wrong.dismiss(animated: false, completion: nil)
}
