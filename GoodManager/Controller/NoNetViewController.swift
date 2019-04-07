//
//  NoNetViewController.swift
//  GoodManager
//
//  Created by DJ on 2019/4/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit
import SwiftyJSON


class NoNetViewController: UIViewController {
    
    var SCWIDTH = UIScreen.main.bounds.width
    var SCHEIGHT = UIScreen.main.bounds.height
    
    var label:UILabel = UILabel()
    
    var newButton:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel(frame: CGRect(x: SCWIDTH/2-100, y: (SCHEIGHT/5)*1, width: 200, height: 90))
        label.textColor = .darkGray
        label.text = "请检查网络！"
        label.textAlignment = .center
//        tipsLabel.textAlignment = NSTextAlignmentCenter;
        self.view.addSubview(label)
        
        newButton = UIButton(frame: CGRect(x: SCWIDTH/2-50, y: (SCHEIGHT/5)*1+100, width: 100, height: 40))
        //开启遮罩（不开启遮罩设置圆角无效）
        newButton.layer.masksToBounds = true
        //设置圆角半径
        newButton.layer.cornerRadius = 5
        //设置按钮边框宽度
        newButton.layer.borderWidth = 1
        //设置按钮层边框颜色为浅灰色
        newButton.layer.borderColor = UIColor.lightGray.cgColor
        newButton.backgroundColor = .white
        newButton.setTitle("刷新", for: .normal)
        newButton.tintColor = .lightGray
        newButton.setTitleColor(UIColor.lightGray, for: .normal)
        newButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        newButton.addTarget(self, action: #selector(newButtonAction), for: .touchUpInside)
        self.view.addSubview(newButton)
        
        self.view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
    }

    @objc func newButtonAction() {
        print("检查网络！")
        var netSituation = APPGetNetWork()
        let jsonString = JSON(parseJSON: netSituation)
        netSituation = jsonString["mode"].stringValue
        if netSituation != "0" {
            print("网络可用！")

            var present = self.presentingViewController
            
            while (true) {
                if ((present?.presentingViewController) != nil) {
                    present = present?.presentingViewController;
                }else {
                    break;
                }
            }
            present?.dismiss(animated: true, completion: nil)

        }else{
            print("网络不可用！")
        }
    }
}
