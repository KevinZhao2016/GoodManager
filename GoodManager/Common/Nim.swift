//
//  LoginViewController.swift
//  GoodManager
//
//  Created by fpm0258 on 2019/2/21.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit


func APPNELogin(account: String, password:String)  {
    let account:String = account //按测试给的内容更换
    let token = password//按测试给的内容更换
    NIMSDK.shared().loginManager.login(account, token: token) { (error) in
        if let myError = error {
            print("登录出现错误--%@",myError);
        }
    };
}

func APPNELoginOut()  {
    NIMSDK.shared().loginManager.logout { (error) in
        if let myError = error {
            print("登出出现错误--%@",myError);
        }
    }
    
}
//    打开网易云信会话列表
func APPNEOpenDialog(account:String, password:String, statusBarColor:String)  {
    let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
    let vc:NIMSessionListViewController = NIMSessionListViewController();
    let basevc = getLastMainViewController()
    let nav:UINavigationController = UINavigationController.init(rootViewController: vc)

    
    if (isLogin) {
        
        basevc.present(nav, animated: true, completion: nil);
    }else{
        NIMSDK.shared().loginManager.login(account, token: password) { (error) in
            if let myError = error {
                print("登录出现错误--%@",myError);
            }else{
                
                basevc.present(nav, animated: true, completion: nil);
            }
        };
    }
}

//    获取网易云信通讯录
func APPNEOpenTelBook(account:String, password:String, statusBarColor:String) {
    let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
    let vc:NTESContactViewController = NTESContactViewController();
    let basevc = getLastMainViewController()
    let nav:UINavigationController = UINavigationController.init(rootViewController: vc)
   
    
    if (isLogin) {
        
        basevc.present(nav, animated: true, completion: nil);
    }else{
        NIMSDK.shared().loginManager.login(account, token: password) { (error) in
            if let myError = error {
                print("登录出现错误--%@",myError);
            }else{
                
                basevc.present(nav, animated: true, completion: nil);
            }
        };
    }
    
}
//打开网易云信好友聊天窗口
func  APPNEChatWithFriend(fAccount:String, statusBarColor:String){
    let session:NIMSession = NIMSession(fAccount, type: .P2P)//按测试给h的内容更换
    let vc:NIMSessionViewController = NIMSessionViewController(session: session)
    let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
    let basevc = getLastMainViewController()
    
    let nav:UINavigationController = UINavigationController.init(rootViewController: vc)
    
 
    
    if (isLogin) {
        basevc.present(nav, animated: true, completion: nil);
    }
    
    
}

//打开网易云信好友聊天窗口
func  APPNEChatWithQ(qMark:String, statusBarColor:String){
    let session:NIMSession = NIMSession(qMark, type: .team)//按测试给的内容更换
    let vc:NIMSessionViewController = NIMSessionViewController(session: session)
    let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
    let basevc = getLastMainViewController()
    
    let nav:UINavigationController = UINavigationController.init(rootViewController: vc)
    
   
    
    if (isLogin) {
        basevc.present(nav, animated: true, completion: nil);
    }
    
    
    
}


//获取网易云信全部未读消息数
func  APPNEGetUnreadNum() ->Int {
    let unreadCount:Int = NIMSDK.shared().conversationManager.allUnreadCount()
    return unreadCount
}
//获取网易云信某个群未读消息数
func  APPNEGetUnreadWithQNum(_ qMark:String) -> Int {
    let session:NIMSession = NIMSession.init(qMark, type: .team)
    let recentSession:NIMRecentSession? = NIMSDK.shared().conversationManager.recentSession(by: session)
    //这个群的未读消息数
    let unreadCount:Int =  recentSession?.unreadCount ?? 0
    return unreadCount
}
//获取网易云信某个群未读消息数
func  APPNEGetQUnreadWithFNum(_ fAccount:String) ->Int {
    let session:NIMSession = NIMSession.init(fAccount, type: .P2P)
    let recentSession:NIMRecentSession? = NIMSDK.shared().conversationManager.recentSession(by: session)
    //这个好友的未读消息数
    let unreadCount:Int =  recentSession?.unreadCount ?? 0
    return unreadCount;
}

