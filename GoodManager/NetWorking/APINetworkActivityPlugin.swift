//
//  APINetworkActivityPlugin.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/18.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import Moya
import Result

final class APINetworkActivityPlugin: PluginType {
    
    typealias NetworkActivityClosure = (_ change: NetworkActivityChangeType) -> ()
    let networkActivityClosure: NetworkActivityClosure?
    
    init(networkActivityClosure: NetworkActivityClosure? = nil) {
        self.networkActivityClosure = networkActivityClosure
    }
    
    // MARK: Plugin
    
    /**
     Called by the provider as soon as the request is about to start
     
     - parameter request: Request type used by willSendRequest plugin function
     - parameter target:  Request target
     */
    func willSendRequest(_ request: RequestType, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        networkActivityClosure?(.began)
    }
    
    /**
     Called by the provider as soon as a response arrives
     
     - parameter result: Moya result
     - parameter target: Request target
     */
//    func didReceiveResponse(_ result: Result<Moya.Response, Moya.error>, target: TargetType) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        networkActivityClosure?(.ended)
//        
//        do {
//            switch result {
//            case .success(let response):
//                if response.statusCode == 401 {
//                    let body = try response.mapSwiftyJSON()
//                    if body["code"].intValue == 40101 {
//                        Network.presentInvalidTokenAlertController()
//                    } else {
//                        Network.showLoginViewController()
//                    }
//                }
//            default:
//                break
//            }
//        } catch {
//            //error("Parse response body failed: \(error)")
//        }
//    }
}
