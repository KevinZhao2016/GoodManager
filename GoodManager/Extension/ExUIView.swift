//
//  ExUIView.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func clearAllSubviews() {
        for item in subviews {
            item.removeFromSuperview()
        }
    }
}
