//
//  BaseNavigationViewController.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/29.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = UIBarStyle.default
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.barTintColor = UIColor(named: "#2566D0")
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}
