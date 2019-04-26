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
import SDWebImage

fileprivate let LaunchProvider = MoyaProvider<LaunchTarget>()

func getLaunchData(){
    LaunchProvider.request(.Launch, completion: { result in
            switch result {
            case let .success(moyaResponse):
//                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc
                print(statusCode)
                if(statusCode == 200){
                    do {
                        if let model = try? moyaResponse.mapObject(LaunchResultModel.self) {
                            if(model.errcode == 0){
//                                print(model)
//                                print(String(bytes: (moyaResponse.request?.httpBody)!, encoding: String.Encoding.utf8))
//                                var i = model.result.range(of: "{picUrl:'")
//                                var j = model.result.range(of: "',")
//                                var subStr =  model.result.substring(with: (i?.upperBound)!..<(j?.lowerBound)!)
                                picUrl = model.result.picUrl
//                                i = model.result.range(of: "linkUrl:'")
//                                j = model.result.range(of: "'}")
//                                subStr =  model.result.substring(with: (i?.upperBound)!..<(j?.lowerBound)!)
                                linkUrl = model.result.linkUrl
                                //显示图片
                                let vc = getLastMainViewController()
                                vc.image.sd_setImage(with: URL(string: picUrl), placeholderImage: UIImage(named: "好监理_启动页"), options: SDWebImageOptions()) { (Image, error, type, url) in
                                    if (url != nil){
                                        vc.image.contentMode = .scaleAspectFill;
                                        print(url)
                                    }
                                }
                                print("picurl:" + picUrl)
                            }
                        } else {
                            print("maperror")
                        }
                    }catch {
                        print(error)
                    }
                }
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                print(error)
            }
        })
}
