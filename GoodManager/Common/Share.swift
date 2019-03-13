//
//  Share.swift
//  GoodManager
//
//  Created by DJ on 2019/3/13.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation

func APPShare(title: String, description: String, thumbImage: String, url: String, callBackfunName: String) {
    print("-------------APPShare--------------")
    let vc = getLastMainViewController()
    vc.imagecallBackfunName = callBackfunName
    var shareView = XMShareView()
    shareView = XMShareView.init(frame: vc.view.bounds)
    shareView.alpha = 0.0;
    shareView.shareTitle = title
    shareView.shareText = description
    shareView.shareUrl = url
    vc.view.addSubview(shareView)
    shareView.alpha = 1.0
    ExecWinJS(JSFun: callBackfunName)
}
