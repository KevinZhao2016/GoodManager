//
//  Window.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation

func APPWinOpen(url:String,mark:String,progressBarColor:String,statusBarColor:String){
    let vc = mainViewControllers.last
    let webvc = MainViewController()
    webvc.mark = mark
    webvc.url = url
    webvc.APPSetProgressBarColor(color: progressBarColor)
    webvc.AppSetStatusBarColor(color: statusBarColor)
    mainViewControllers.append(webvc)
    vc!.present(webvc, animated: false, completion: nil)
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
