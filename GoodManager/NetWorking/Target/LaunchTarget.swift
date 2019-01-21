//
//  LaunchTarget.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/18.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import Moya


enum LaunchTarget{
    case Launch
}

extension LaunchTarget: TargetType{
    var headers: [String : String]? {
       return nil
    }
    
    public var task: Task{
        switch self {
        case .Launch:
            let appid = "mAPPIos01"
            let time = getDateTime()
            let body = ["mAPPIos01",getDateTime()]
            //let sign = (body.sorted().joined() + md5string).MD5String
            let sign = (body.joined() + md5string).MD5String
            let params = [
                "time" : time,
                "appid": appid,
                "sign" : sign
            ]
            //return .requestCompositeData(bodyData: jsonToData(jsonDic: params)!, urlParameters: ["action" : "getStartupData"])
            return .requestCompositeParameters(bodyParameters: params, bodyEncoding: URLEncoding.httpBody, urlParameters: ["action" : "getStartupData"])
        default:
            return .requestPlain
        }
    }
    
    var baseURL: URL{
        return URL(string: "http://api.yiganzi.cn")!
    }
    
    var path: String{
        switch self {
        case .Launch:
            return "/StartupPage.ashx"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .Launch:
            return .post
        }
    }
    
//    var parameters: [String: Any]?{
//        switch self {
//        case .Launch:
//            let appid = "mAPPIos01"
//            let time = getDateTime()
//            let sign = ["mAPPIos01",getDateTime()]
//            print(appid)
//            print(time)
//            print(sign)
//            return [
//                "appid": appid,
//                "time" : time,
//                "sign" : (sign.sorted().joined() + md5string).MD5String
//            ]
//        default:
//            return nil
//        }
//    }
//
    var acceptVersion: String{
        return ""
    }
    
    var auth: APIAuthType{
        return .None
    }
    
    var sampleData: Data{
        return "".data(using: String.Encoding.utf8)!
    }
}
