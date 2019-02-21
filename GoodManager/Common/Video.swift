//
//  VideoSelect.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/7.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import TZImagePickerController
import MobileCoreServices


func APPChooseSingleVideo(source:Int, maxVideoLength:Int, callBackfunName:String){
    let vc = mainViewControllers.last
    vc!.videocallBackfunName = callBackfunName
    let controller = TZImagePickerController(maxImagesCount: 1, delegate: vc)
    controller?.videoMaximumDuration = TimeInterval(maxVideoLength)
    if source == 0 {
        //仅相册
        controller!.allowTakePicture = false
        controller!.allowPickingImage = false
        controller!.allowPickingVideo = true
        controller!.allowTakeVideo = false
        vc!.present(controller! , animated: true, completion: nil)
    }else if source == 1 {
        //仅拍摄
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = CameraViewController()
            // 表示操作为拍照
            imagePicker.sourceType = .camera
            // 拍照后允许用户进行编辑
            imagePicker.allowsEditing = false
            // 也可以设置成视频
            imagePicker.mediaTypes = [kUTTypeMovie] as [String]
            imagePicker.videoMaximumDuration = TimeInterval(maxVideoLength)
            // 设置代理为 ViewController,已经实现了协议
            imagePicker.delegate = imagePicker
            // 进入拍照界面
            imagePicker.callbackfun = callBackfunName
            vc!.present(imagePicker, animated: true, completion: nil)
        }else {
            // 照相机不可用
        }
    }else{
        //相册和拍照
        controller!.allowTakePicture = false
        controller!.allowPickingImage = false
        controller!.allowPickingVideo = true
        controller!.allowTakeVideo = true
        vc!.present(controller! , animated: true, completion: nil)
    }

}

func APPPlayVideo(path:String, startPosition:Double, callBackfunName:String){
    let basevc = getLastMainViewController()
    let vc = PlayerViewController()
    //"https://media.w3.org/2010/05/sintel/trailer.mp4"
    vc.urlpath = path
    vc.playfromtime = startPosition
    vc.callbackfun = callBackfunName
    basevc.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
}


