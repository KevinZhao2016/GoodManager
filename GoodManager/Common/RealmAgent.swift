//
//  RealmAgent.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/28.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import RealmSwift

// Define your models like regular Swift classes
class InterfaceName: Object {
    @objc dynamic var name = ""
}

class RealmAgent {
 
    func add(name:String) -> Bool{
        let realm = try! Realm()
        print(realm.configuration.fileURL ?? "")
        let interface = queue(name: name)
        if(interface.name != ""){
            return false
        }
        do{
            try realm.write {
                realm.delete(interface)
            }
        }catch{
            return false
        }
        return true
    }
    
    func delete(name:String) -> Bool{
        let realm = try! Realm()
        print(realm.configuration.fileURL ?? "")
        let interface = queue(name: name)
        do{
            try realm.write {
                realm.delete(interface)
            }
        }catch{
            return false
        }
        return true
    }
    
    func queue(name:String) -> InterfaceName{
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
