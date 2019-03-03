//
//  ImageSelect.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/6.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import LLPhotoBrowser
import CLImagePickerTool
import Photos
import TZImagePickerController

let imagePickTool = CLImagePickerTool()

//单选图片
/**
 source：图片来源
    0 仅相册
    1 仅拍照
    2 相册或拍照
 ifNeedEdit：是否需要编辑
    0 不需要
    1 需要
 ifOriginalPic：是否显示原图上传
    0 不显示
    1 显示，默认不勾选。压缩的图片在200KB以内
 callBackfunName：选择完成后回调函数名,返回选择图片路径。
 
    0 0 0   √
    0 0 1
 
 */
func APPChooseSingleImage(source:Int, ifNeedEdit:Int, ifOriginalPic:Int ,callBackfunName:String){
    print("--------------APPChooseSingleImage----------------")
    callbackfun = callBackfunName
    
    let vc = getLastMainViewController()
    let controller = TZImagePickerController(maxImagesCount: 1, delegate: vc)

//    if source == 0 {
//        if ifNeedEdit == 0 {
//            if ifOriginalPic == 1 {
//                //0相册 0不编辑 1原图
//                vc.imagecallBackfunName = callBackfunName
//                controller!.allowTakePicture = false
//                controller!.allowPickingVideo = false
//                controller!.allowPickingOriginalPhoto = true
//                vc.present(controller! , animated: true, completion: nil)
//            }
//        }
//    }
    
    imagePickTool.singleImageChooseType = .singlePicture
    if(ifNeedEdit == 1){    //需要编辑
        imagePickTool.singleModelImageCanEditor = true
    }else{
        imagePickTool.singleModelImageCanEditor = false
    }
    var size:CGSize?
    if(ifOriginalPic == 0){ //非原图
        size = CGSize(width: PHImageManagerMaximumSize.width * 0.4, height: PHImageManagerMaximumSize.height * 0.4)
    }else{
        size = PHImageManagerMaximumSize
    }
//    let vc = getLastMainViewController()
//    var path:String = ""
    switch source {
    case 0:
        imagePickTool.cameraOut = false
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1, superVC: vc) { (asset,editorImage) in
            let phasset = asset.first!
            getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic)
            //            path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
            //            ExecWinJS(JSFun: callBackfunName + "(\"" + path + "\")")
        }
    case 1:
        imagePickTool.cameraOut = true
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1) { (asset,cutImage) in
            let phasset = asset.first!
            getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic)
            //            path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
            //            ExecWinJS(JSFun: callBackfunName + "(\"" + path + "\")")
        }
    case 2:
        imagePickTool.cameraOut = false
        imagePickTool.showCamaroInPicture = true
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1, superVC: vc) { (asset,editorImage) in
            let phasset = asset.first!
            getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic)
            //            path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
            //            ExecWinJS(JSFun: callBackfunName + "(\"" + path + "\")")
        }
    default:
        break
    }
    
    
}

//图片多选
func APPChooseMoreImage(source:Int, maxNum:Int, ifOriginalPic:Int ,callBackfunName:String){
    print("--------------APPChooseMoreImage----------------")
    print("图片最多可选:  \(maxNum)")
    let vc = getLastMainViewController()
    vc.imagecallBackfunName = callBackfunName
    let controller = TZImagePickerController(maxImagesCount: maxNum, delegate: vc)
    
    //不能选视频
    controller!.allowPickingVideo = false
    
    if ifOriginalPic == 0{
        print("显示原图")
        controller!.allowPickingOriginalPhoto = false
    }else{
        print("非原图")
        controller!.allowPickingOriginalPhoto = true
    }
    
    if source == 0 {
        print("仅相册")
        controller!.allowTakePicture = false
    }else if source == 1 {
        // 应当直接进入拍照页面 目前想做成和 均可 一样
        print("仅拍照")
        controller!.allowTakeVideo = true
        
    }else{
        print("均可")
        controller!.allowTakeVideo = true
    }
    
//    if source == 0 {
//        //仅相册
//        controller!.allowTakePicture = false
//        controller!.allowPickingVideo = false
//        vc.present(controller! , animated: true, completion: nil)
//    }else if source == 1 {
//        //仅拍照
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
////            let imagePicker = CameraViewController()
////            // 表示操作为拍照
////            imagePicker.sourceType = .camera
////            // 拍照后允许用户进行编辑
////            imagePicker.allowsEditing = false
////            // 也可以设置成视频
////            imagePicker.cameraCaptureMode = .photo
////            // 设置代理为 ViewController,已经实现了协议
////            imagePicker.delegate = imagePicker
////            // 进入拍照界面
////            imagePicker.callbackfun = callBackfunName
////            vc.present(imagePicker, animated: true, completion: nil)
//
//            controller!.allowTakePicture = true
//            controller!.allowPickingVideo = false
//            vc.present(controller! , animated: true, completion: nil)
//        }else {
//            // 照相机不可用
//        }
//    }else{
//        //相册和拍照
//        controller!.allowTakePicture = true
//        controller!.allowPickingVideo = false
//        vc.present(controller! , animated: true, completion: nil)
//    }
    
    vc.present(controller!, animated: true, completion: nil)
}



//func APPChooseMoreImage(source:Int, maxNum:Int, ifOriginalPic:Int ,callBackfunName:String){
//    imagePickTool.isHiddenVideo = true
//    var size:CGSize?
//    if(ifOriginalPic == 0){
//        size = CGSize(width: PHImageManagerMaximumSize.width * 0.4, height: PHImageManagerMaximumSize.height * 0.4)
//    }else{
//        size = PHImageManagerMaximumSize
//    }
//    var path:String = ""
//    switch source {
//    case 0:
//        imagePickTool.cameraOut = false
//        imagePickTool.showCamaroInPicture = false
//        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: maxNum) { (asset,cutImage) in
//            for phasset in asset {
//                path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
//                ExecWinJS(JSFun: callBackfunName + "(\"" + path + "\")")
//            }
//        }
//    case 1:
//        imagePickTool.cameraOut = true
//        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: maxNum) { (asset,cutImage) in
//            for phasset in asset {
//                path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
//                ExecWinJS(JSFun: callBackfunName + "(\"" + path + "\")")
//            }
//        }
//    case 2:
//        imagePickTool.showCamaroInPicture = true
//        imagePickTool.cameraOut = false
//        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: maxNum) { (asset,cutImage) in
//            for phasset in asset {
//                path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
//                ExecWinJS(JSFun: callBackfunName + "(\"" + path + "\")")
//            }
//        }
//    default:
//        break
//    }
//}

// TODO 获取银行卡照片
func APPGetBankImage(callBackfunName:String){
    let vc = getLastMainViewController()
    vc.imagecallBackfunName = callBackfunName
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
        var BankAuthVC = BankAuthViewController()
        BankAuthVC.callbackfun = callBackfunName;
        let nvc = UINavigationController(rootViewController: BankAuthVC)
        vc.present(nvc, animated: true, completion: nil)
    }else {
        // 照相机不可用
    }
}

// 获取身份证照片
func APPGetIdentityCardImage(callBackfunName:String){
    var vc = getLastMainViewController()
    vc.imagecallBackfunName = callBackfunName
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
        var IDAuthVC = IDAuthViewController()
        IDAuthVC.callbackfun = callBackfunName;
        let nvc = UINavigationController(rootViewController: IDAuthVC)
        vc.present(nvc, animated: true, completion: nil)
    }else {
        // 照相机不可用
    }
}

//图片预览
func APPPreviewImage(paths:String,defaultIndex:Int){
    var photoArray:Array<LLBrowserModel> = []
    var path = paths.replacingOccurrences(of: " ", with: "")
    path = path.replacingOccurrences(of: "\n", with: "")
    let splitedArray:Array<String> = path.components(separatedBy: ",")
    for path in splitedArray{
        let model = LLBrowserModel.init()
        model.imageURL = path
        photoArray.append(model)
    }
    let browser = LLPhotoBrowserViewController(photoArray: photoArray, currentIndex: defaultIndex)
    // 模态弹出
    let vc = getLastMainViewController()
    browser.actionSheetBackgroundColor = UIColor.white
    
    vc.present(browser, animated: false, completion: nil)
}

fileprivate func getPathFromAsset(phasset:PHAsset, size:CGSize, ifOriginalPic:Int) ->   [String]{
    var path:[String] = [String]()
    PHImageManager.default().requestImage(for: phasset,
                                          targetSize: size, contentMode: .aspectFit,
                                          options: nil, resultHandler: { (image, info:[AnyHashable : Any]?) in
                                            if(ifOriginalPic == 1){
                                                let imageURL = info!["PHImageFileURLKey"] as! URL
                                                path.append(imageURL.path)
//                                                path = imageURL.path
                                                print("路径：",path)
                                            }else{
                                                let fileManager = FileManager.default
                                                let rootPath = NSHomeDirectory() + "/Documents/"
                                                let name = info!["PHImageResultDeliveredImageFormatKey"] as! Int
                                                let filePath = rootPath  + "\(name)" + ".jpg"
                                                let imageData = image?.jpegData(compressionQuality: 1)
                                                fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
                                                path.append(filePath)
//                                                path = filePath
                                                print("路径：",path)
                                            }
                                            var result = path.getJSONStringFromArray()
                                            result = result.replacingOccurrences(of: "\"", with: "\\\"")
                                            ExecWinJS(JSFun: callbackfun + "(\"" + result + "\")")
    })
   
    return path
}
