//
//  Window.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation

func APPWinOpen(url:String,mark:String,progressBarColor:String,statusBarColor:String){
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
    let vc = findControllerByMark(mark: mark)
    vc.dismiss(animated: false, completion: nil)
    var i:Int = 0
    for VC in mainViewControllers {
        if(VC.mark == mark){
            break
        }
        i = i + 1
    }
    mainViewControllers.remove(at: i)
}
