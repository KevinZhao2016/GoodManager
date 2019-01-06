//
//  ImageSelect.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/6.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import TZImagePickerController

//图片多选
func APPChooseMoreImage(source:Int, maxNum:Int, ifOriginalPic:Int ,callBackfunName:String){
    let vc = mainViewControllers.last
    let controller = TZImagePickerController(maxImagesCount: maxNum, delegate: vc)
    if ifOriginalPic == 0{
         controller!.allowPickingOriginalPhoto = false
    }else{
        controller!.allowPickingOriginalPhoto = true
    }
    if source == 0 {
        //仅相册
        controller!.allowTakePicture = false
    }else if source == 1 {
        //仅拍照
    }else{
        //相册和拍照
        controller!.allowTakePicture = true
    }
    controller!.allowPickingVideo = false
    vc!.present(controller! , animated: true, completion: nil)
}


