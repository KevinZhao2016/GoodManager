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
import AVFoundation
import AVKit

func APPChooseSingleVideo(source:Int, maxVideoLength:Int, callBackfunName:String){
    print("---------------APPChooseSingleVideo----------------")
    let vc = mainViewControllers.last
    vc!.videocallBackfunName = callBackfunName
    // 只能选择一个视频
    let controller = TZImagePickerController(maxImagesCount: 1, videoMaxLength: TimeInterval(maxVideoLength), delegate: vc)
    //视频最大拍摄时间
    controller?.videoMaximumLength = TimeInterval(maxVideoLength)
    print("最大时长:  \(maxVideoLength)")
    if source == 0 {
        // 仅相册
        print("仅相册")
        //let controller_Video_Album = TZImagePickerController.init
        // 不能拍图片
        controller!.allowTakePicture = false
        // 不能拍视频
        controller!.allowTakeVideo = false
        // 不能选择图片
        controller!.allowPickingImage = false
        // 选择视频
        controller!.allowPickingVideo = true
        vc!.present(controller!, animated: true, completion: nil)
    } else if source == 1 {
        // 仅拍摄
        print("仅拍摄")
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
    print("---------------APPPlayVideo----------------")
    let basevc = getLastMainViewController()
    if (path.contains("http:")||path.contains("https:")){
        print("网络视频")
        if(basevc.reachability.isReachable){
            //do nothing
        }else{
            basevc.nonetLoad()
            return
        }
    }else{
        print("本地视频")
    }
    let vc = PlayerViewController()
    vc.urlpath = path    //"https://media.w3.org/2010/05/sintel/trailer.mp4"
    vc.playfromtime = startPosition
    vc.callbackfun = callBackfunName
    basevc.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
}


