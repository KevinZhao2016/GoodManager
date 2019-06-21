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
    // test
    for VC_ in mainViewControllers {
        print(VC_.mark)
    }
    print("lastmainviecontroller.mark:  \(vc.mark)")
    vc.navigationController?.pushViewController(webvc, animated: true)
}

func APPWinClose(mark:String){
    print("===================APPWinClose=====================")
    let mark_ = mark
    print("相关mark:  \(mark_)")
    var i:Int = 0
    for VC_ in mainViewControllers {
        if(VC_.mark == mark_){
            print("i: \(i)")
            let vc = mainViewControllers.remove(at: i)
            vc.navigationController?.popViewController(animated: true)
            // test
            for test_ in mainViewControllers {
                print(test_.mark)
            }
            return
        }else{
            i = i + 1
        }
    }
    print("没有找到： "+mark)
}
