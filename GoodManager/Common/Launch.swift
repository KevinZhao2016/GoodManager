//
//  Launch.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/18.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import SwiftyJSON

fileprivate let LaunchProvider = MoyaProvider<LaunchTarget>()

func getLaunchData(){
    var model:LaunchResultModel?
    LaunchProvider.request(.Launch, completion: { result in
            var success = true
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc
                print(statusCode)
                if(statusCode == 200){
                    do {
                        if let model = try? moyaResponse.mapObject(LaunchResultModel.self) {
                            if(model.errcode == 0){
                                picUrl = model.result[0].picUrl
                                linkUrl = model.result[0].linkUrl
                            }
                        } else {
                            print("maperror")
                            success = false
                        }
                    }catch {
                        print(error)
                        success = false
                    }
                }
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                print(error)
                success = false
            }
        })
}
