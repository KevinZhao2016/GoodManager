//
//  LoginViewController.swift
//  GoodManager
//
//  Created by fpm0258 on 2019/2/21.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    func APPNELogin()  {
        let account:String = "用户登录的账号"//按测试给的内容更换
        let token = "从自家服务器返回的token"//按测试给的内容更换
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
    func APPNEOpenDialog()  {
        let vc:NIMSessionListViewController = NIMSessionListViewController();
        self.present(vc, animated: true, completion: nil);
    }
    //    获取网易云信通讯录
    func APPNEOpenTelBook() ->[NIMUser]  {
        let users:[NIMUser] =  NIMSDK.shared().userManager.myFriends() ?? []
        return users;
        //users 这个就是数据源  具体ui 自定义
    }
    //打开网易云信好友聊天窗口
    func  APPNEChatWithFriend(){
        let session:NIMSession = NIMSession("要聊天的那个人得sessionid", type: .P2P)//按测试给的内容更换
        let vc:NIMSessionViewController = NIMSessionViewController(session: session)
        //这个一般是导航
        //        self.navigationController?.pushViewController(vc, animated: true)
        self .present(vc, animated: true, completion: nil);
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
