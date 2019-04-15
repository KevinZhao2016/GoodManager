//
//  Value.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/28.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import RealmSwift

class KeyValue: Object {
    @objc dynamic var key:String = ""
    @objc dynamic var value:String = ""
    override class func primaryKey() -> String?{
        return "key"
    }
}


class KeyValueRealm{
    
    func addKeyValue(key:String, value:String) -> Bool{
        // 使用默认数据库
        let realm = try! Realm()
        
        let keyValue = KeyValue()
        keyValue.key = key
        keyValue.value = value
        
        try! realm.write {
            print("key   : " + keyValue.key)
            print("value : " + keyValue.value)
            realm.add(keyValue, update: true)
        }
        return true
    }
    
    func deleteKeyValue(key:String) -> Bool{
        let realm = try! Realm()
        let keyValue = queueKeyValue(key: key)
        print("keyValue : \(keyValue.key)  \(keyValue.value)")
        do{
            try realm.write {
                realm.delete(keyValue)
            }
        }catch{
            return false
        }
        return true
    }
    
    func queueKeyValue(key:String) -> KeyValue{
        let realm = try! Realm()
        var result =  realm.objects(KeyValue.self).filter("key == %@",key).first
        return result ?? KeyValue()
    }
}

func APPSetValue(key:String, value:String){
    let agent = KeyValueRealm()
    print(agent.addKeyValue(key: key, value: value))
}

func APPGetValue(key:String) -> String{
    let agent = KeyValueRealm()
    print(agent.queueKeyValue(key: key).value)
    return agent.queueKeyValue(key: key).value
}

func APPDelValue(key:String) {
    let agent = KeyValueRealm()
    _ = agent.deleteKeyValue(key: key)
}
