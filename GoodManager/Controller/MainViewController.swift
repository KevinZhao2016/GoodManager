//
//  ViewController.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/25.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage

class MainViewController: BaseViewController {
    
    var webview = WKWebView(frame: CGRect(x: 0, y: STATUS_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    var image = FLAnimatedImageView(frame: UIScreen.main.bounds)
    var index = 0
    var urlArr = NSArray()
    var titleArr = NSArray()
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 2))
        self.progressView.tintColor = UIColor.green      // 进度条颜色
        self.progressView.trackTintColor = UIColor.white // 进度条背景色
        return self.progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webview)
        self.view.addSubview(self.image)
        //启动图片
        image.sd_setImage(with: URL(string: "http://img.zcool.cn/community/01d7e15a0f0f2ca801204a0e8190bc.gif"), placeholderImage: UIImage(named: "bigimage"))
        setupWebview()
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (Timer) in
            self.removeImageWithDelay()
        })
//        APPSetProgressBarColor(color: "#FFFFFF")
    }
    
    func setupWebview(){
        webview.load(URLRequest(url: URL(string: "https://www.apple.com/cn")!))
        webview.navigationDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        //进度条监听
        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webview.addSubview(self.progressView)
        //适配全面屏,隐藏安全区域
        if #available(iOS 11.0, *) {
            webview.scrollView.contentInsetAdjustmentBehavior = .never;
        }
    }
    
    func removeImageWithDelay(){
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.image.alpha = 0
            }, completion: { (finished) -> Void in
                if(finished){
                    self.image.removeFromSuperview()
                }
            })
    }
    
    func APPSetProgressBarColor(color:String){
        self.progressView.tintColor = UIColor(named: color)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.uiDelegate = nil
        self.webview.navigationDelegate = nil
    }
    
}

extension MainViewController:WKNavigationDelegate,WKUIDelegate{
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //  加载进度条
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float((self.webview.estimatedProgress) ), animated: true)
            if (self.webview.estimatedProgress )  >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webview.load(URLRequest(url: URL(string: "https://www.baidu.com")!))
    }
    
}
