//
//  AppDelegate.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate, WXApiDelegate{
    
    
    // 屏幕旋转变量
    var blockRotation: Bool = false
    
    // wxpay
    func onResp(_ resp: BaseResp) {
        ExecWinJS(JSFun: "APPWXPay" + "(\"" +  "\(resp.errCode)" + "\")")
    }
    
    // alipay
    let URLScheme = "alipayforgoodmanager"
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay"{
            AlipaySDK.defaultService().processOrder(withPaymentResult: url){
                value in
                let code = value!
                let resultStatus = code["resultStatus"] as!String
                var content = ""
                ExecWinJS(JSFun: "APPAlipay" + "(\"" +  "\(resultStatus)" + "\")")
                switch resultStatus {
                case "9000":
                    content = "支付成功"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPaySucceess"), object: content)
                case "8000":
                    content = "订单正在处理中"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
                case "4000":
                    content = "支付失败"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                case "5000":
                    content = "重复请求"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                case "6001":
                    content = "中途取消"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                case "6002":
                    content = "网络连接出错"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefault"), object: content)
                case "6004":
                    content = "支付结果未知"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
                default:
                    content = "支付失败"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                    break
                }
            }
        }else if url.scheme == "file"{
            

            let vc = getLastMainViewController()
            print("文件")
            let inbox = NSHomeDirectory() + "/Documents/Inbox/"
            print(inbox)
            let documents = NSHomeDirectory() + "/Documents/localDocuments/"
            print(documents)
            var originPath = url.absoluteString
            
            
            if (FileManager.default.fileExists(atPath: inbox)){
                print("inbox 存在")
                let fileName = originPath.split(separator: "/").last!.removingPercentEncoding!
                if (FileManager.default.fileExists(atPath: inbox + fileName)){
                    let fileName = originPath.split(separator: "/").last!
                    let sourceFilePath = inbox + fileName
                    print("源文件:    "+sourceFilePath)
                    let aimFilePath = documents + fileName
                    print("目标地址:  "+aimFilePath)
//                    if(FileManager.default.fileExists(atPath: aimFilePath.removingPercentEncoding!)){
//                        let alert = UIAlertController(title: "文件已存在！", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//                        // 传参
//                        let alertAction1 = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler:{(alert: UIAlertAction!) in
//                            return true
//                        })
//                        alert.addAction(alertAction1)
//                        vc.present(alert, animated: true, completion: nil)
//                    }
                    do{
                        try FileManager.default.copyItem(at: URL.init(fileURLWithPath: sourceFilePath.removingPercentEncoding!), to: URL.init(fileURLWithPath: aimFilePath.removingPercentEncoding!))
                        let alert = UIAlertController(title: "文件已保存！", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                        // 传参
                        let alertAction1 = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler:nil)
                        alert.addAction(alertAction1)
                        vc.present(alert, animated: true, completion: nil)
                    }catch let error as NSError{
                        print(error)
                        let alert = UIAlertController(title: "文件保存失败！", message: "error: \(error.code)", preferredStyle: UIAlertController.Style.actionSheet)
                        // 传参
                        let alertAction1 = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler:nil)
                        alert.addAction(alertAction1)
                        vc.present(alert, animated: true, completion: nil)
                    }
                }else{
                    let alert = UIAlertController(title: "文件保存失败！", message: "文件丢失！", preferredStyle: UIAlertController.Style.actionSheet)
                    // 传参
                    let alertAction1 = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler:nil)
                    alert.addAction(alertAction1)
                    vc.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "文件保存失败！", message: "文件丢失！", preferredStyle: UIAlertController.Style.actionSheet)
                // 传参
                let alertAction1 = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler:nil)
                alert.addAction(alertAction1)
                vc.present(alert, animated: true, completion: nil)
            }
        }else{
            print("url.host != safepay")
            if (url.absoluteString.hasPrefix("tencent")){
                print("qq推送")
                ExecWinJS(JSFun: "appShareCallBack")
                return QQApiInterface.handleOpen(url, delegate: nil)
            }else if(url.absoluteString.hasPrefix("wb")||url.absoluteString.hasPrefix("sinaweibo")){
                print("weibo推送")
                ExecWinJS(JSFun: "appShareCallBack")
                return WeiboSDK.handleOpen(url, delegate: nil)
            }else if(url.absoluteString.hasPrefix("wx")){
                print("wx推送")
                ExecWinJS(JSFun: "appShareCallBack")
                return WXApi.handleOpen(url, delegate: nil)
            }else{
                ExecWinJS(JSFun: "appShareCallBack")
                print(url.absoluteString)
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.host == "safepay"{
            AlipaySDK.defaultService().processOrder(withPaymentResult: url){
                value in
                let code = value!
                let resultStatus = code["resultStatus"] as!String
                var content = ""
                ExecWinJS(JSFun: "APPAlipay" + "(\"" +  "\(resultStatus)" + "\")")
                switch resultStatus {
                case "9000":
                    content = "支付成功"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPaySucceess"), object: content)
                case "8000":
                    content = "订单正在处理中"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
                case "4000":
                    content = "支付失败"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                case "5000":
                    content = "重复请求"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                case "6001":
                    content = "中途取消"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                case "6002":
                    content = "网络连接出错"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefault"), object: content)
                case "6004":
                    content = "支付结果未知"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
                default:
                    content = "支付失败"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                    break
                }
            }
        }else{
            print("url.host != safepay")
            if (url.absoluteString.hasPrefix("tencent")){
                print("qq推送")
                return QQApiInterface.handleOpen(url, delegate: nil)
            }else if(url.absoluteString.hasPrefix("wb")||url.absoluteString.hasPrefix("sinaweibo")){
                print("weibo推送")
                return WeiboSDK.handleOpen(url, delegate: nil)
            }else if(url.absoluteString.hasPrefix("wx")){
                print("wx推送")
                return WXApi.handleOpen(url, delegate: nil)
            }else{
                print(url.absoluteString)
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.host == "safepay"{
            AlipaySDK.defaultService().processOrder(withPaymentResult: url){
                value in
                let code = value!
                let resultStatus = code["resultStatus"] as!String
                var content = ""
                ExecWinJS(JSFun: "APPAlipay" + "(\"" +  "\(resultStatus)" + "\")")
                switch resultStatus {
                case "9000":
                    content = "支付成功"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPaySucceess"), object: content)
                case "8000":
                    content = "订单正在处理中"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
                case "4000":
                    content = "支付失败"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                case "5000":
                    content = "重复请求"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                case "6001":
                    content = "中途取消"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                case "6002":
                    content = "网络连接出错"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefault"), object: content)
                case "6004":
                    content = "支付结果未知"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
                default:
                    content = "支付失败"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                    break
                }
            }
        }else{
            print("url.host != safepay")
            if (url.absoluteString.hasPrefix("tencent")){
                print("qq推送")
                return QQApiInterface.handleOpen(url, delegate: nil)
            }else if(url.absoluteString.hasPrefix("wb")||url.absoluteString.hasPrefix("sinaweibo")){
                print("weibo推送")
                return WeiboSDK.handleOpen(url, delegate: nil)
            }else if(url.absoluteString.hasPrefix("wx")){
                print("wx推送")
                return WXApi.handleOpen(url, delegate: nil)
            }else if(url.absoluteString.hasPrefix("QQ")){
                print(url.absoluteString)
            }else{
                print(url.absoluteString)
            }
        }
        return true
    }
    
    
    
    
    
    
    // 极光推送
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger is UNPushNotificationTrigger) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(JPAuthorizationOptions.alert.rawValue))
        
      
        Voice()
        
    
    }
    func Voice() {
        // 提醒方式 0：无声无震动  1：有声无震动（未实现） 2：无声有震动  3：有声有震动
        let vc: MainViewController =
            getLastMainViewController()
        switch vc.remaindWay {
        case 0:
            do {
                // 无声无震动
            }
            break
        case 1:
            do {
                // 有声无震动
                let playSound1 = LxxPlaySound()
                playSound1.playWithSound()
            }
            break
        case 2:
            do {
                // 有声有震动
                let playSound = LxxPlaySound(forPlayingVibrate: ())
                playSound!.play()
            }
            break
        case 3:
            do {
                // 有声有震动
                let playSound = LxxPlaySound(forPlayingVibrate: ())
                playSound!.play()
                
                let playSound1 = LxxPlaySound()
                playSound1.playWithSound()
            }
            break
        default:
            break
        }
    }
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print("方法调用");
        if ( (response?.notification) != nil && response.notification.request.trigger is UNPushNotificationTrigger)  {
            //从通知界面直接进入应用
            
            let userInfo = response?.notification.request.content.userInfo as? [String:String] ?? [:];
            let msgLinkMark:String = (userInfo["msgLinkMark"]) ?? "m1";
            let msgLinkURL:String = (userInfo["msgLinkURL"]) ?? "https://www.baidu.com";
            print("传入链接");
//            UIApplication.shared.openURL(URL.init(string: msgLinkURL)!);
            
            UIApplication.shared.open(URL.init(string: msgLinkURL)!, options: [:], completionHandler: nil);
            print("执行完成");
            
        }else{
            //从通知设置界面进入应用
            //             print(response?.notification.request.content.userInfo)
        }
        
        
        print("")
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        print("")
    }
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       
        
        //启动页
        getLaunchData()
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let vc = MainViewController()
        let mainNV = UINavigationController.init(rootViewController: vc);
        vc.mark = "main"
        mainViewControllers.append(vc)
        self.window?.rootViewController = mainNV
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        //检查通讯录权限
        getTelBookRight()
        // 注册微信支付
        WXApi.registerApp("wxac7e2659ee456ef6")
        // 注册QQ
        //TencentOAuth.init(appId: "1108245066", andDelegate: nil)
        // 注册weibo
        WeiboSDK.registerApp("580085537")
        WeiboSDK.enableDebugMode(true)
        
        initJpush(launchOptions ?? [:]);
        initNISDK() ;
        return true
    }
    //网易im初始化
    func initNISDK()  {
        //663b09bceebf709aae5d09e4f6b03fab
        
        let appKey:String = "c867717d00ce3a9a623ba68ca2cad96b";
        let option:NIMSDKOption = NIMSDKOption.init(appKey: appKey);
        option.apnsCername = "GoodManagerPush"
        option.pkCername = "xx"//如需要，填上相应的pushkit
        NIMSDK.shared().register(with: option);
    }
    //初始化极光推送
    func  initJpush(_ launchOptions:[UIApplication.LaunchOptionsKey: Any]){
        //Required
        //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
        let entity:JPUSHRegisterEntity = JPUSHRegisterEntity();
        entity.types = Int(JPAuthorizationOptions.alert.rawValue);
        
        
//        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self);
//        let appKey:String = "c0a25071e3f4e28e80fbea4b"
//        let channel:String = "https://www.baidu.com"
//        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: channel, apsForProduction: true)
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self);
        let appKey:String = "c0a25071e3f4e28e80fbea4b"
        let channel:String = "https://www.baidu.com"
        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: channel, apsForProduction: false)
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.blockRotation{
            return UIInterfaceOrientationMask.all
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }
}
