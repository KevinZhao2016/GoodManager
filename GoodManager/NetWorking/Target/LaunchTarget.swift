//
//  LaunchTarget.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/18.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import Moya

var uploadDomainName:String = ""

enum LaunchTarget{
    case Launch
    case uploadFile(String,String,String)
}

extension LaunchTarget: TargetType{
    
    var headers: [String : String]? {
        switch self{
        case .Launch:
            return nil
        case .uploadFile(let filepath, let domainName, let folderName):
            let appid:String = "mAPPIos01"
            let time:String = getDateTime()
            let fileType:String = mimeType(pathExtension: filepath)
            let fileSize:String = APPGetFileSize(path: filepath)
            let s = filepath.split(separator: "/").last
            let fileName = String(s!)
            let sign = (appid + fileName + "\(fileSize)" + fileType + folderName + time + md5string).MD5String
            let params = ["appid": appid,
                         "fileType": fileType,
                         "fileName": fileName,
                         "fileSize": "\(fileSize)",
                         "folderName": folderName,
                         "time": time,
                         "sign": sign
                ]
            print(params)
            return params
        }
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
        case .uploadFile(let filepath, let domainName, let folderName):
            let s = filepath.split(separator: "/").last
            let fileName = String(s!)
            let data = MultipartFormData(provider: MultipartFormData.FormDataProvider.file(URL(fileURLWithPath: filepath)), name: fileName)
            return .uploadCompositeMultipart([data], urlParameters: ["action" : "uploadFile"])
        default:
            return .requestPlain
        }
    }
    
    var baseURL: URL{
        switch self {
        case .uploadFile(let filepath, let domainName, let folderName):
            return URL(string: domainName)!
        default:
            var url = "http://api.yiganzi.cn"
            url = GoodManager.APPGetValue(key: "_StartDomainName_")
            if url == ""{
                print("===================启动图片使用默认url====================")
                return URL(string: "http://api.yiganzi.cn")!
            }
            print("===================启动图片使用新url====================")
            print("\(url)")
            return URL(string: url)!
        }
    }
    
    var path: String{
        switch self {
        case .Launch:
                return "/StartupPage.ashx"
        case .uploadFile(let filepath, let domainName, let folderName):
                return "/upFile.ashx"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .Launch:
            return .post
        case .uploadFile(let filepath, let domainName, let folderName):
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
