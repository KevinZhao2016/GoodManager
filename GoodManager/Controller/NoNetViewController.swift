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
    
    
    var imageView:UIImageView = UIImageView()
    var label:UILabel = UILabel()
    var newButton:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "pic_refresh_1")
        imageView.image = image
        //指定图片显示的位置
//        imageView.frame.origin = CGPoint(x:UIScreen.main.bounds.width/2,y:100);
        imageView.frame = CGRect(x:UIScreen.main.bounds.width/2-90,y:150,width:180,height:180)
        self.view.addSubview(imageView)
        
        label = UILabel(frame: CGRect(x: SCWIDTH/2-100, y: 310, width: 200, height: 90))
        label.textColor = .lightGray
        label.text = "暂无网络，点击重试"
        label.textAlignment = .center
        self.view.addSubview(label)
        
        newButton = UIButton(frame: CGRect(x: SCWIDTH/2-50, y: 400, width: 100, height: 40))
        //开启遮罩（不开启遮罩设置圆角无效）
        newButton.layer.masksToBounds = true
        //设置圆角半径
        newButton.layer.cornerRadius = 5
        //设置按钮边框宽度
        newButton.layer.borderWidth = 1
        //设置按钮边框颜色
        newButton.layer.borderColor = UIColor.init(red: 77/255, green: 191/255, blue: 255/255, alpha: 1).cgColor
        newButton.backgroundColor = .white
        newButton.setTitle("点击重试", for: .normal)
        newButton.tintColor = .init(red: 77, green: 191, blue: 255, alpha: 1)
        newButton.setTitleColor(UIColor.init(red: 77/255, green: 191/255, blue: 255/255, alpha: 1), for: .normal)
        newButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        newButton.addTarget(self, action: #selector(newButtonAction), for: .touchUpInside)
        self.view.addSubview(newButton)
        
        self.view.backgroundColor = .white
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
