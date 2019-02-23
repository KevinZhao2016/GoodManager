//
//  AppDelegate.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,JPUSHRegisterDelegate {
    //极光推送
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        if ( (response?.notification) != nil && response.notification.request.trigger is UNPushNotificationTrigger)  {
            //从通知界面直接进入应用
            
            let extras = response?.notification.request.content.userInfo["extras"] as? [String:String] ?? [:];
            let msgLinkMark:String = (extras["msgLinkMark"]) ?? "msgLinkMark";
            let msgLinkURL:String = (extras["msgLinkURL"]) ?? "https://www.baidu.com";
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

