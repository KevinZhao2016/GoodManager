//
//  JpushViewController.swift
//  GoodManager
//
//  Created by charles on 2019/2/21.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation


func APPPushSetAlias(_ alias:String)  {
    let Main = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
        
    }else{
        Main.nonetLoad()
        return ;
    }
    JPUSHService.setAlias(alias, completion: { (seq, alias, res) in
        print("\(seq)---\(alias)---\(res)");
    }, seq: 110);
}
//    取消极光账号
func APPPushCancelAlias()  {
    let Main = getLastMainViewController()
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    print(isReach)
    if(isReach){
        
    }else{
        Main.nonetLoad()
        return ;
    }
    JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
        
    }, seq: 110)
}

//    设置新消息提醒方式接口
func APPPushMsgRemindType(_ ifOpenVoice:Int,ifOpenVibration:Int)  {
    let Main = getLastMainViewController()
    
    let checkNetObject = checkNet()
    let isReach = checkNetObject.isReach()
    if(isReach){
        // 网络连接成功
        let entity:JPUSHRegisterEntity = JPUSHRegisterEntity();
        
        if ifOpenVoice == 0 {
            //不开声音
            print("不开声音")
            // 不设置声音就会自动静音
            entity.types = Int(JPAuthorizationOptions.alert.rawValue);
            if ifOpenVibration == 0 {
                //无声 无震动
                print("不开震动")
                entity.types = Int(JPAuthorizationOptions.alert.rawValue);
                
                Main.remaindWay = 0
            }else{
                //无声 有震动
                print("开启震动")
                entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.sound.rawValue);
                
                //开启震动时的调用方法
                let playSound = LxxPlaySound.init(forPlayingVibrate: ())
                playSound!.play()
                Main.remaindWay = 2
            }
        }else{
            //开启声音
            print("开启声音")
            entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.sound.rawValue);
            if ifOpenVibration == 0 {
                //有声 无震动
                print("不开震动")
                entity.types = Int(JPAuthorizationOptions.alert.rawValue);
                Main.remaindWay = 1
            }else{
                //开启震动
                print("开启震动")
                entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.sound.rawValue);
                
                //开启震动时的调用方法
                let playSound = LxxPlaySound.init(forPlayingVibrate: ())
                playSound!.play()
                
                // 有声 有震动
                Main.remaindWay = 3
            }
            
            // 开启声音时的调用方法
            let playSound = LxxPlaySound()
            playSound.playWithSound()
        }
        
        
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: delegate);
        
        print(Main.remaindWay)
    }else{
        Main.nonetLoad()
        return ;
    }
}




