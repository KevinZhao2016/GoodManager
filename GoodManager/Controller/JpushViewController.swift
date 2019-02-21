//
//  JpushViewController.swift
//  GoodManager
//
//  Created by charles on 2019/2/21.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import UIKit

class JpushViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //
    //    @IBAction func aliasBtnClick(_ sender: Any) {
    //        APPJiGuangSetAlias("fpm0259")
    //
    //    }
    //
    //    @IBAction func closeBtnCLick(_ sender: Any) {
    //    }
    //设置极光设备别名
    func APPJiGuangSetAlias(_ alias:String)  {
        JPUSHService.setAlias(alias, completion: { (seq, alias, res) in
            print("\(seq)---\(alias)---\(res)");
        }, seq: 110);
    }
    //    取消极光账号
    func APPJiGuangCancelAlias()  {
        UIApplication.shared.unregisterForRemoteNotifications();
    }
    //    设置新消息提醒方式接口
    func APPJiGuangMsgRemindType(_ ifOpenVoice:Int,ifOpenVibration:Int)  {
        let entity:JPUSHRegisterEntity = JPUSHRegisterEntity();
        if ifOpenVoice == 0 {
            
            entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.badge.rawValue);
        }else
        {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.badge.rawValue)|Int(JPAuthorizationOptions.sound.rawValue);
        }
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: delegate);
    
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
