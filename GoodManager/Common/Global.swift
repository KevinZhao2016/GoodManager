//
//  Global.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import UIKit
let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height
let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height
let iphone6Width:CGFloat = 375.0
let iphone6Height:CGFloat = 667.0
let ratioWidth = SCREEN_WIDTH / iphone6Width
let ratioHeight = SCREEN_HEIGHT / iphone6Height
let MediumFontName = "PingFangSC-Medium"
let RegularFontName = "PingFangSC-Regular"

//判断是否全面屏
var isFullScreen: Bool {
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
            print(unwrapedWindow.safeAreaInsets)
            return true
        }
    }
    return false
}
