//
//  Pay.swift
//  GoodManager
//
//  Created by DJ on 2019/3/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation

func APPWXPay(partnerId:String,prepayId:String,packageValue:String,nonceStr:String,timeStamp:String,sign:String,callBackfunName:String) {
    print("--------------APPWXPay---------------")
    let req = PayReq()
    req.openID = "wxac7e2659ee456ef6"
    req.partnerId = partnerId
    req.prepayId = prepayId
    req.package = packageValue
    req.nonceStr = nonceStr
    req.sign = sign
    WXApi.send(req)
    // 在appDelegate中实现onResp方法，等待微信服务器返回code
}

func APPAlipay(orderString:String,callBackfunName:String) {
    print("--------------APPAlipay--------------")
    let URLScheme = "alipayforgoodmanager"
    AlipaySDK().payOrder(orderString, fromScheme: URLScheme){
        Result in
        print("\(Result)")
    }
}

//func payBack(resultDic: [NSObject: AnyObject]) {
//    if let Alipayjson: [String: AnyObject] = resultDic as? [String: AnyObject] {
//        let resultStatus = Alipayjson["resultStatus"] as! String
//        print("payBack resultStatus=\(resultStatus)")
//        if resultStatus == "9000" || resultStatus == "8000" {//   订单支付成功或正在处理中
//            aliPayBack?.finish(Alipayjson["result"] as? String)
//        } else {
//            aliPayBack?.failed()
//        }
//    }
//}
