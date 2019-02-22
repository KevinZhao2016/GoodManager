//
//  Webview.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/24.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import UIKit

func APPSetProgressBarColor(color:String){
    let vc = getLastMainViewController()
    vc.progressView.tintColor = UIColor().hexStringToUIColor(hex: color)
}

func APPSetBrowserHomeURL(url:String){
    mainUrl = url
}

func AppSetStatusBarColor(color:String){
    let vc = getLastMainViewController()
    vc.view.backgroundColor = UIColor().hexStringToUIColor(hex: color)
}

func APPOutBrowserOpenURL(url:String!){
    UIApplication.shared.openURL(URL(string: url)!)
}
