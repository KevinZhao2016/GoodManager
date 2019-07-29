//
//  Global.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height
let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height
let iphone6Width:CGFloat = 375.0
let iphone6Height:CGFloat = 667.0
let ratioWidth = SCREEN_WIDTH / iphone6Width
let ratioHeight = SCREEN_HEIGHT / iphone6Height
let MediumFontName = "PingFangSC-Medium"
let RegularFontName = "PingFangSC-Regular"
var LaunchFlag:Bool = false //标志是否需要展示启动页
var mainViewControllers:Array<MainViewController> = []
let md5string = "amdsdfwrer21aafIos"  //加密串
var picUrl:String = ""
var linkUrl:String = ""
//var mainUrl:String = "http://hangzhou.hjlm.yiganzi.cn/Demo/App/testAPP.aspx"//主页测试地址
var mainUrl:String = "http://hangzhou.hjlm.yiganzi.cn"//主页首页地址


func findControllerByMark(mark:String) -> MainViewController{
    for vc in mainViewControllers{
        if(vc.mark == mark){
            return vc
        }
    }
    return MainViewController()
}

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

//获取系统时间
func getDateTime() -> String{
    let date = Date()
    let timeFormatter = DateFormatter.init()
    timeFormatter.dateFormat="yyyyMMddHHmmss"
    let timeZone = TimeZone(identifier: "GMT")
    timeFormatter.timeZone = timeZone
    return timeFormatter.string(from: date)
}

func jsonToData(jsonDic:Dictionary<String, Any>) -> Data? {
    if (!JSONSerialization.isValidJSONObject(jsonDic)) {
        print("is not a valid json object")
        return nil
    }
    //利用自带的json库转换成Data
    //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
    let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
    //Data转换成String打印输出
    let str = String(data:data!, encoding: String.Encoding.utf8)
    //输出json字符串
    print("Json Str:\(str!)")
    return data
}

func getLastMainViewController() -> MainViewController{
    print(mainViewControllers.count)
    if(mainViewControllers.count == 0){
        print("error")
        //var vc:UIViewController = mainViewController()
    }
    return mainViewControllers.last!
}


//根据后缀获取对应的Mime-Type
func mimeType(pathExtension: String) -> String {
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                       pathExtension as NSString,
                                                       nil)?.takeRetainedValue() {
        if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
            .takeRetainedValue() {
            return mimetype as String
        }
    }
    //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
    return "application/octet-stream"
}

class getLMVC: NSObject {
    @objc func getLastMainViewController() -> MainViewController{
        return mainViewControllers.last!
    }
}
