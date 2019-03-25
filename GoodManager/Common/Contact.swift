//
//  Contact.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import Foundation
import Contacts
import SwiftyJSON

//var callbackfun:String = ""

func getTelBookRight(){
    //1.获取授权状态
    //CNContactStore 通讯录对象
    let status = CNContactStore.authorizationStatus(for: .contacts)
    //2.判断如果是未决定状态,则请求授权
    if status == .notDetermined {
        //创建通讯录对象
        let store = CNContactStore()
        //请求授权
        store.requestAccess(for: .contacts, completionHandler: { (isRight : Bool,error : Error?) in
            if isRight {
                print("授权成功")
            } else {
                print("授权失败")
            }
        })
    }
}

//获取所有联系人数据
func APPGetTelBookList(callBackfunName:String){
    var TelBookList = Array<TelBookModel>()
    //1.获取授权状态
    let status = CNContactStore.authorizationStatus(for: .contacts)
    //2.判断当前授权状态
    guard status == .authorized else { return }
    //3.创建通讯录对象
    let store = CNContactStore()
    //4.从通讯录中获取所有联系人
    //获取Fetch,并且指定之后要获取联系人中的什么属性
    let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]
    //创建请求对象   需要传入一个(keysToFetch: [CNKeyDescriptor]) 包含'CNKeyDescriptor'类型的数组
    let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
    //遍历所有联系人
    //需要传入一个CNContactFetchRequest
    do {
        try store.enumerateContacts(with: request, usingBlock: {(contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
            //1.获取姓名
            let lastName = contact.familyName
            let firstName = contact.givenName
            //print("姓名 : \(lastName)\(firstName)")
            //2.获取电话号码
            let phoneNumbers = contact.phoneNumbers
            for phoneNumber in phoneNumbers
            {
                //print(phoneNumber.value.stringValue)
            TelBookList.append(TelBookModel(Phonenumber:phoneNumbers.first!.value.stringValue, Name: lastName+firstName))
           }
        })
    } catch {
        print(error)
    }
    var result = TelBookList.toJSONString()!
    result = result.replacingOccurrences(of: "\"", with: "\\\"")
    print(result)
    ExecWinJS(JSFun: callBackfunName + "(\"" +  result + "\")")
}

func APPChooseTelBook(maxNum:Int,callBackfunName:String){
    let vc = ContactPickerController()
    let basevc = getLastMainViewController()
    vc.delegate = vc
    vc.maxNum = maxNum
    vc.backClosure = { (ContactString:String) ->Void in
        var result = ContactString
        result = result.replacingOccurrences(of: "\"", with: "\\\"")
        result = result.replacingOccurrences(of: "\\\\\"", with: "\\\"")
        ExecWinJS(JSFun: callBackfunName + "(\"" + result + "\")")
    }
    basevc.present(vc, animated: true, completion: nil)
}
