//
//  BundleInfo.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation

struct BundleInfo {
    static let Identifier = Bundle.main
        .infoDictionary!["CFBundleIdentifier"] as? String
    
    static let Version = Bundle.main
        .infoDictionary!["CFBundleVersion"] as? String
    
    static let ShortVersion = Bundle.main
        .infoDictionary!["CFBundleShortVersionString"] as? String
}

