//
//  photo.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/6.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import LLPhotoBrowser

func APPPreviewImage(paths:String,defaultIndex:Int){
    var photoArray:Array<LLBrowserModel> = []
    let splitedArray:Array<String> = paths.components(separatedBy: ",")
    for path in splitedArray{
        let model = LLBrowserModel.init()
        model.imageURL = path
        photoArray.append(model)
    }
    let browser = LLPhotoBrowserViewController(photoArray: photoArray, currentIndex: defaultIndex)
    // 模态弹出
    let vc = mainViewControllers.last
    browser.actionSheetBackgroundColor = UIColor.white
    vc!.present(browser, animated: false, completion: nil)
}


