//
//  PrivacyViewController.swift
//  GoodManager
//
//  Created by DJ on 2019/7/29.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController,UINavigationControllerDelegate {
    
    var SCWIDTH = UIScreen.main.bounds.width
    var SCHEIGHT = UIScreen.main.bounds.height
    
    var socrView:UIScrollView = UIScrollView()
    var lable:UILabel = UILabel()
    
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white
        self.title = "隐私政策"
        
        
        socrView = UIScrollView(frame:CGRect(x:5,y:10,width: SCWIDTH, height: SCHEIGHT))
        //内容大小
        socrView.contentSize = CGSize(width: SCWIDTH, height: 2000);
        //可以上下滚动
        socrView.isScrollEnabled = true;
        //会滚到顶点
        socrView.scrollsToTop = true;
        //反弹效果
        socrView.bounces = true;
        //分页显示
        //socrView.isPagingEnabled = true;
        //水平/垂直滚动条是否可见
        socrView.showsVerticalScrollIndicator = true;
        //socrView.showsHorizontalScrollIndicator = true;
        //滚动条颜色
        socrView.indicatorStyle = .white
        self.view.addSubview(socrView)
        
        
        lable = UILabel(frame: CGRect(x: 0,y: 0, width: SCWIDTH, height: SCHEIGHT*3))
        
        
        let pravicyBundlePath = Bundle.main.path(forResource: "privacyDoc", ofType: "bundle")
        let privacyResourceBundle = Bundle.init(path: pravicyBundlePath!)
        
        
        do {
            /*
             * try 和 try! 的区别
             * try 发生异常会跳到catch代码中
             * try! 发生异常程序会直接crash
             */
            let docpath = privacyResourceBundle?.path(forResource: "APPprivacyDoc", ofType: "txt")
            let docurl = URL(fileURLWithPath: docpath!)
            var str = try? NSString(contentsOf: docurl, encoding: String.Encoding.utf8.rawValue)
            print(str)
            
            
            lable.lineBreakMode = .byWordWrapping
            //（默认只显示一行，设为0表示没有行数限制）
            lable.numberOfLines = 0
            lable.textAlignment = .left
            lable.textColor = .lightGray
            lable.text = String(str!)
            
            
            socrView.addSubview(lable)
            
        } catch let error as Error! {
            print("读取本地数据出现错误!",error)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
    }
    
    override func viewDidAppear(_ animated:Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
    }
}
