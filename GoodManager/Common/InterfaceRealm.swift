//
//  RealmAgent.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/28.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import RealmSwift

func APPIfExistInterfaceName(interfaceName:String) -> String {
    let AppInterfaces = ["APPGetNetwork","APPGetVersion","APPWinOpen","APPWinClose","APPShare","APPExecWinJS","APPSetValue","APPGetValue","APPDelValue","APPOutBrowserOpenURL","APPGetBankImage","APPGetIdentityCardImage","APPChooseSingleImage","APPChooseMoreImage","APPPreviewImage","APPChooseSingleVideo","APPPlayVideo","APPChooseSingleFile","APPGetFileSize","APPGetFileBase","APPUploadFile","APPDownFile","APPIfExistFile","APPDelFile","APPPreviewFile","APPStartLocation","APPGetTelBookList","APPChooseTelBook","APPScanQRCode","APPSetStatusBarColor","APPSetProgressBarColor","APPSetBrowserHomeURL","APPPushSetAlias","APPPushCancelAlias","APPPushMsgRemindType","APPNELogin","APPNEOpenDialog","APPNELoginOut","APPNEOpenTelBook","APPNEChatWithFriend","APPNEChatWithQ","APPNEGetUnreadNum","APPNEGetUnreadWithQNum","APPNEGetQUnreadWithFNum","APPWXPay","APPIfExistInterfaceName"]
    print(AppInterfaces.count)
    if AppInterfaces.contains(interfaceName) {
        return "1"
    }
    return "0"
}

// Define your models like regular Swift classes
class InterfaceName: Object {
    @objc dynamic var name = ""
}



func APPIfExistInterfaceName(interfaceName:String) -> Int{
    var flag = 0
    let agent = InterfaceRealm()
    if(agent.queueInterface(name: interfaceName).name != ""){
        flag = 1
    }else{
        flag = 0
    }
    return flag
}

class InterfaceRealm {
 
    func addInterface(name:String) -> Bool{
        let realm = try! Realm()
        print(realm.configuration.fileURL ?? "")
        let interface = queueInterface(name: name)
        if(interface.name != ""){
            return false
        }
        do{
            try realm.write {
                realm.add(interface)
            }
        }catch{
            return false
        }
        return true
    }
    
    func deleteInterface(name:String) -> Bool{
        let realm = try! Realm()
        print(realm.configuration.fileURL ?? "")
        let interface = queueInterface(name: name)
        do{
            try realm.write {
                realm.delete(interface)
            }
        }catch{
            return false
        }
        return true
    }
    
    func queueInterface(name:String) -> InterfaceName{
        let realm = try! Realm()
        let result =  realm.objects(InterfaceName.self).filter("name == %@",name).first
        return result ?? InterfaceName()
    }
    
    func deleteAll(){
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
