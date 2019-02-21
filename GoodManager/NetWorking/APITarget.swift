//
//  APITarget.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/18.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import Moya

enum APIAuthType {
    case None
    case Default
}

protocol APITarget: TargetType {
    var acceptVersion: String { get }
    var auth: APIAuthType { get }
    
}
