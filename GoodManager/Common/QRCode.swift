//
//  QRCodeExtension.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import UIKit

//扫描二维码
func APPScanQRCode(callBackfunName:String){
    let controller = ScanQRCodeViewController()
    let basevc = getLastMainViewController()
    controller.backClosure = { (QRcode:String) ->Void in
        print("main  " + QRcode)
        APPExecWinJS(mark: "", JSFun: callBackfunName + "(" + QRcode + ")")
    }
    controller.callbackfun = callBackfunName
    basevc.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
}

