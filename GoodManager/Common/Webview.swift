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
    let numComponents = UIColor().hexStringToUIColor(hex: color).cgColor.components
    //CGFloat R, G, B;
    if numComponents != nil {
        let R = numComponents![0]
        let G = numComponents![1]
        let B = numComponents![2]
        let colorBirghtness = ((R * 299) + (G * 587) + (B * 114)) / 1000
        if(colorBirghtness < 0.5){
            //Color is dark
//            print("Color is dark")
            vc.style = .lightContent
            vc.setNeedsStatusBarAppearanceUpdate()
        }else{
            //Color is light
//            print("Color is light")
            vc.style = .default
            vc.setNeedsStatusBarAppearanceUpdate()
        }
    }
    vc.view.backgroundColor = UIColor().hexStringToUIColor(hex: color)
}

func APPOutBrowserOpenURL(url:String!){
    UIApplication.shared.openURL(URL(string: url)!)
}
