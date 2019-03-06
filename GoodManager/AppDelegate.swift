//
//  AppDelegate.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate, WXApiDelegate {

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
        }
        return true
    }
    
    
    
    // 极光推送
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger is UNPushNotificationTrigger) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.badge.rawValue)|Int(JPAuthorizationOptions.sound.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        if ( (response?.notification) != nil && response.notification.request.trigger is UNPushNotificationTrigger)  {
            //从通知界面直接进入应用
            
            let userInfo = response?.notification.request.content.userInfo as? [String:String] ?? [:];
            let msgLinkMark:String = (userInfo["msgLinkMark"]) ?? "m1";
            let msgLinkURL:String = (userInfo["msgLinkURL"]) ?? "https://www.baidu.com";
            UIApplication.shared.openURL(URL.init(string: msgLinkURL)!);
            
        }else
        {
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
        vc.mark = "main"
        mainViewControllers.append(vc)
        self.window?.rootViewController = vc
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        getTelBookRight()//检查通讯录权限
        // 注册微信支付
        WXApi.registerApp("wxac7e2659ee456ef6")

        
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
        entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.badge.rawValue)|Int(JPAuthorizationOptions.sound.rawValue);
        
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self);
        let appKey:String = "d415b3cf50f978503dd1113b"
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
