//
//  BaseViewController.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/26.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(APPGetNetWork())
    }
    
    func AppSetStatusBarColor(color:String){
        self.view.backgroundColor = UIColor(named: color)
    }
    
    func APPOutBrowserOpenURL(url:String!){
        UIApplication.shared.openURL(URL(string: url)!)
    }

}
