//
//  MainViewControllerExtension.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/29.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import UIKit
import WebKit

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

extension MainViewController:WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if "NativeMethod" == message.name {
            // 判断message的内容，然后做相应的操作
            //window.webkit.messageHandlers.NativeMethod.postMessage("fun");根据body判断执行的方法
            if "close" == message.body as! String {
                
            }
        }
    }
}
