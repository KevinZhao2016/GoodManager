//
//  LoginViewController.swift
//  GoodManager
//
//  Created by fpm0258 on 2019/2/21.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit
var isNimLogout = false;
func APPNELogin(account: String, password:String)  {
    let account:String = account //按测试给的内容更换
    let token = password//按测试给的内容更换
    let vc = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
        NIMSDK.shared().loginManager.login(account, token: token) { (error) in
            if let myError = error {
                print("登录出现错误--%@",myError);
            }else
            {
                isNimLogout = true
            }
        };
    }else{
        vc.nonetLoad()
    }
    
    
    
}
//注销
func APPNELoginOut()  {
    let vc = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
        let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
  
        if (isLogin) {
            if(isNimLogout){
                isNimLogout = false;
                NIMSDK.shared().loginManager.logout { (error) in
                    if let myError = error {
                        isNimLogout = true;
                        //退出失败
                        print("登出出现错误--%@",myError);
                    }else
                    {//退出成功
                        
                        
                        
                    }
             }
           
            }else
            {
                print("不起作用")
                
            }
        }else
        {
            //用户没有登录
            print("不起作用1")
        }
    }else{
        vc.nonetLoad()
    }
   
    
   
    
}
//    打开网易云信会话列表
func APPNEOpenDialog(account:String, password:String, statusBarColor:String)  {
    
    let vc = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
        let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
        let vc:NTESMainTabController = NTESMainTabController();
        vc.hexColor = statusBarColor;
        let basevc = getLastMainViewController()
        if (isLogin) {
            
            basevc.navigationController?.pushViewController(vc, animated:true );
            
        }else{
            //alert(content: "请先登录！")
//            NIMSDK.shared().loginManager.login(account, token: password) { (error) in
//                if let myError = error {
//                    print("登录出现错误--%@",myError);
//                }else{
//
//                    basevc.navigationController?.pushViewController(vc, animated:true );
//                }
//            };
        }
    }else{
        vc.nonetLoad()
    }
  
    
    
    
}

//    获取网易云信通讯录
func APPNEOpenTelBook(account:String, password:String, statusBarColor:String) {
    
    let Main = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
       
    }else{
        Main.nonetLoad()
        return;
    }
    
    
    
    
    
    
    
    
    
    let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
    let vc:NTESContactViewController = NTESContactViewController();
    let basevc = getLastMainViewController()
//    let nav:UINavigationController = UINavigationController.init(rootViewController: vc)
   
    
    if (isLogin) {
        
      basevc.navigationController?.pushViewController(vc, animated:true );
    }else{
        //alert(content: "请先登录！")
//        NIMSDK.shared().loginManager.login(account, token: password) { (error) in
//            if let myError = error {
//                print("登录出现错误--%@",myError);
//            }else{
//
//               basevc.navigationController?.pushViewController(vc, animated:true );
//            }
//        };
    }
    
}
//打开网易云信好友聊天窗口
func  APPNEChatWithFriend(fAccount:String, statusBarColor:String){
    let Main = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
        
    }else{
        Main.nonetLoad()
        return;
    }
    let session:NIMSession = NIMSession(fAccount, type: .P2P)//按测试给h的内容更换
    let vc:NTESSessionViewController = NTESSessionViewController(session: session)
    let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
    let basevc = getLastMainViewController()
    
//    let nav:UINavigationController = UINavigationController.init(rootViewController: vc)
    
 
    
    if (isLogin) {
       basevc.navigationController?.pushViewController(vc, animated:true );
    }else
    {
        //alert(content: "请先登录！")
    }
    
    
}

//打开网易云信好友聊天窗口
func  APPNEChatWithQ(qMark:String, statusBarColor:String){
    let Main = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
        
    }else{
        Main.nonetLoad()
        return;
    }
    let session:NIMSession = NIMSession(qMark, type: .team)//按测试给的内容更换
    let vc:NTESSessionViewController = NTESSessionViewController(session: session)
    let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
    let basevc = getLastMainViewController()
    
//    let nav:UINavigationController = UINavigationController.init(rootViewController: vc)
    
   
    
    if (isLogin) {
       basevc.navigationController?.pushViewController(vc, animated:true );
    }else{
        //alert(content: "请先登录！")
    }
    
    
    
}


//获取网易云信全部未读消息数
func  APPNEGetUnreadNum() ->String {
    let Main = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
        
    }else{
        Main.nonetLoad()
        return "0";
    }
    let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
 
    if (isLogin) {
        let unreadCount:Int = NIMSDK.shared().conversationManager.allUnreadCount()
        return "\(unreadCount)"
    }else{
        //alert(content: "请先登录！")
        return "0"
    }
   
}
//获取网易云信某个群未读消息数
func  APPNEGetUnreadWithQNum(_ qMark:String) -> String {
    let Main = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
        
    }else{
        Main.nonetLoad()
        return "0";
    }
    let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
    
    if (isLogin) {
        let session:NIMSession = NIMSession.init(qMark, type: .team)
        let recentSession:NIMRecentSession? = NIMSDK.shared().conversationManager.recentSession(by: session)
        //这个群的未读消息数
        let unreadCount:Int =  recentSession?.unreadCount ?? 0
        return "\(unreadCount)"
    }else{
        //alert(content: "请先登录！")
        return "0"
    }
   
}
//获取网易云信某个群未读消息数
func  APPNEGetQUnreadWithFNum(_ fAccount:String) -> String {
    let Main = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
        
    }else{
        Main.nonetLoad()
        return "0";
    }
    let isLogin:Bool = NIMSDK.shared().loginManager.isLogined()
    
    if (isLogin) {
        let session:NIMSession = NIMSession.init(fAccount, type: .P2P)
        let recentSession:NIMRecentSession? = NIMSDK.shared().conversationManager.recentSession(by: session)
        //这个好友的未读消息数
        let unreadCount:Int =  recentSession?.unreadCount ?? 0
        return "\(unreadCount)"
    }else{
        //alert(content: "请先登录！")
        return "0"
    }
    
   
}
func alert(content:String){
    let vc:MainViewController = getLastMainViewController();
    let alertC:UIAlertController = UIAlertController.init(title: nil, message: content, preferredStyle: .alert)
    let action:UIAlertAction
        = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
    alertC.addAction(action)
    vc.present(alertC, animated: true, completion: nil)
    
    
    
}
