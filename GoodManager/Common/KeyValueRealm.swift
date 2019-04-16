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
    
    func addKeyValue(key:String, value:String){
        print("添加数据")
        
        // 如果主键为空，直接返回
        if(key == "") {
            let alert = UIAlertController(title: "插入空键！", message: nil, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(action)
            let vc = getLastMainViewController()
            vc.present(alert, animated: true, completion: nil)
            return
        }
        // 使用默认数据库
        let realm = try! Realm()
        // 实例化对象
        let keyValue = KeyValue()
        keyValue.key = key
        keyValue.value = value
        // 获取已有对象
        let lists = realm.objects(KeyValue.self)
        print(lists)
        // 删除已存在记录
        if lists.count > 0 {
            for temp in lists{
                if (temp.key == keyValue.key){
                    try! realm.write {
                        realm.delete(temp)
                        print("删除已存在记录")
                    }
                }
            }
        }
        // 加入新纪录
        try! realm.write {
            realm.add(keyValue)
            print("插入记录  1")
        }
        
        // 获取所有对象
        let lists_test = realm.objects(KeyValue.self)
        print("所有元素:   \(lists_test)")
        
    }

    func deleteKeyValue(key:String){
        print("删除数据")
        // 如果主键为空，直接返回
        if(key == "") {
            let alert = UIAlertController(title: "主键为空！", message: nil, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(action)
            let vc = getLastMainViewController()
            vc.present(alert, animated: true, completion: nil)
            return
        }

        // 使用默认数据库
        let realm = try! Realm()
        
        // 获取已有对象
        let lists = realm.objects(KeyValue.self).filter("key == %lu",key)
        
        print(lists)
        
        // 删除已存在记录
        if lists.count > 0 {
            for temp in lists{
                if (temp.key == key){
                    try! realm.write {
                        realm.delete(temp)
                        print("删除已存在记录")
                    }
                }
            }
        }
        
        // 获取所有对象
        let lists_test = realm.objects(KeyValue.self)
        print("所有元素:   \(lists_test)")
    }
    
    func queueKeyValue(key:String) -> KeyValue{
        print("查询数据")
        // 如果主键为空，直接返回
        if(key == "") {
            let alert = UIAlertController(title: "主键为空！", message: nil, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(action)
            let vc = getLastMainViewController()
            vc.present(alert, animated: true, completion: nil)
            return KeyValue()
        }
        
        // 使用默认数据库
        let realm = try! Realm()
        
        // 获取已有对象
        let tem = realm.object(ofType: KeyValue.self, forPrimaryKey: key)
        
        // 获取所有对象
        let lists_test = realm.objects(KeyValue.self)
        print("所有元素:   \(lists_test)")
        
        return tem ?? KeyValue()
    }
    
}

func APPSetValue(key:String, value:String){
    let agent = KeyValueRealm()
    agent.addKeyValue(key: key, value: value)
}

func APPGetValue(key:String) -> String{
    let agent = KeyValueRealm()
    return agent.queueKeyValue(key: key).value
}

func APPDelValue(key:String) {
    let agent = KeyValueRealm()
    agent.deleteKeyValue(key: key)
}
