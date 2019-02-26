//
//  ABPeoplePickerController.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit
import ContactsUI
import SwiftyJSON

typealias ContactsString = (String) -> Void
class ContactPickerController: CNContactPickerViewController {
    var maxNum:Int = 0
    var contactArray:Array<String> = []
    var backClosure: ContactsString?// 数据回调闭包
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
}
extension ContactPickerController:CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]){
        if(contacts.count > maxNum){
            let alertVC = UIAlertController(title:nil, message:"选择联系人超过最大数量", preferredStyle: .alert)
            self.present(alertVC, animated:true, completion:nil)
        }
        
        for contact in contacts {
            //获取联系人的姓名
            let lastName = contact.familyName
            let firstName = contact.givenName
        
            //获取联系人电话号码
            let phones = contact.phoneNumbers
//            for phone in phones {
                //获得标签名（转为能看得懂的本地标签名，比如work、home）
                //let phoneLabel = CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)
                //获取号码
            let phoneValue = phones.first!.value.stringValue
                let contactModel = TelBookModel(Phonenumber: phoneValue, Name: lastName + firstName)
                contactArray.append(contactModel.toJSONString()!)
//            }
        }
        self.backClosure!(contactArray.getJSONStringFromArray())
    }
    
}
