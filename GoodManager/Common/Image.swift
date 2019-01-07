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
        controller!.allowPickingVideo = false
        vc!.present(controller! , animated: true, completion: nil)
    }else if source == 1 {
        //仅拍照
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = CameraViewController()
            // 表示操作为拍照
            imagePicker.sourceType = .camera
            // 拍照后允许用户进行编辑
            imagePicker.allowsEditing = false
            // 也可以设置成视频
            imagePicker.cameraCaptureMode = .photo
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
        controller!.allowTakePicture = true
        controller!.allowPickingVideo = false
        vc!.present(controller! , animated: true, completion: nil)
    }
   
}

func APPGetBankImage(callBackfunName:String){
    let vc = mainViewControllers.last
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
        let imagePicker = CameraViewController()
        // 表示操作为拍照
        imagePicker.sourceType = .camera
        // 拍照后允许用户进行编辑
        imagePicker.allowsEditing = true
        // 也可以设置成视频
        imagePicker.cameraCaptureMode = .photo
        // 设置代理为 ViewController,已经实现了协议
        imagePicker.delegate = imagePicker
        // 进入拍照界面
        imagePicker.callbackfun = callBackfunName
        vc!.present(imagePicker, animated: true, completion: nil)
    }else {
        // 照相机不可用
    }
}

func APPGetIdentityCardImage(callBackfunName:String){
    let vc = mainViewControllers.last
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
        let imagePicker = CameraViewController()
        // 表示操作为拍照
        imagePicker.sourceType = .camera
        // 拍照后允许用户进行编辑
        imagePicker.allowsEditing = true
        // 也可以设置成视频
        imagePicker.cameraCaptureMode = .photo
        // 设置代理为 ViewController,已经实现了协议
        imagePicker.delegate = imagePicker
        // 进入拍照界面
        imagePicker.callbackfun = callBackfunName
        vc!.present(imagePicker, animated: true, completion: nil)
    }else {
        // 照相机不可用
    }
}
