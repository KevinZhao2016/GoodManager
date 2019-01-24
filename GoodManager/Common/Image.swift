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

//图片多选
//func APPChooseMoreImage(source:Int, maxNum:Int, ifOriginalPic:Int ,callBackfunName:String){
//    let vc = mainViewControllers.last
//    let controller = TZImagePickerController(maxImagesCount: maxNum, delegate: vc)
//    if ifOriginalPic == 0{
//         controller!.allowPickingOriginalPhoto = false
//    }else{
//        controller!.allowPickingOriginalPhoto = true
//    }
//    if source == 0 {
//        //仅相册
//        controller!.allowTakePicture = false
//        controller!.allowPickingVideo = false
//        vc!.present(controller! , animated: true, completion: nil)
//    }else if source == 1 {
//        //仅拍照
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let imagePicker = CameraViewController()
//            // 表示操作为拍照
//            imagePicker.sourceType = .camera
//            // 拍照后允许用户进行编辑
//            imagePicker.allowsEditing = false
//            // 也可以设置成视频
//            imagePicker.cameraCaptureMode = .photo
//            // 设置代理为 ViewController,已经实现了协议
//            imagePicker.delegate = imagePicker
//            // 进入拍照界面
//            imagePicker.callbackfun = callBackfunName
//            vc!.present(imagePicker, animated: true, completion: nil)
//        }else {
//            // 照相机不可用
//        }
//    }else{
//        //相册和拍照
//        controller!.allowTakePicture = true
//        controller!.allowPickingVideo = false
//        vc!.present(controller! , animated: true, completion: nil)
//    }
//
//}
let imagePickTool = CLImagePickerTool()

func APPChooseSingleImage(source:Int, ifNeedEdit:Int, ifOriginalPic:Int ,callBackfunName:String){
    imagePickTool.singleImageChooseType = .singlePicture
    if(ifNeedEdit == 1){
        imagePickTool.singleModelImageCanEditor = true
    }else{
        imagePickTool.singleModelImageCanEditor = false
    }
    var size:CGSize?
    if(ifOriginalPic == 0){
        size = CGSize(width: PHImageManagerMaximumSize.width * 0.4, height: PHImageManagerMaximumSize.height * 0.4)
    }else{
        size = PHImageManagerMaximumSize
    }
    let vc = getLastMainViewController()
    var path:String = ""
    switch source {
    case 0:
        imagePickTool.cameraOut = false
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1, superVC: vc) { (asset,editorImage) in
            let phasset = asset.first!
            path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
            APPExecWinJS(mark: " ", JSFun: callBackfunName + "(" + path + ")")
        }
    case 1:
        imagePickTool.cameraOut = true
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1) { (asset,cutImage) in
            let phasset = asset.first!
            path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
            APPExecWinJS(mark: " ", JSFun: callBackfunName + "(" + path + ")")
        }
    case 2:
        imagePickTool.cameraOut = false
        imagePickTool.showCamaroInPicture = true
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1, superVC: vc) { (asset,editorImage) in
            let phasset = asset.first!
            path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
            APPExecWinJS(mark: " ", JSFun: callBackfunName + "(" + path + ")")
        }
    default:
        break
    }
    
   
}

func APPChooseMoreImage(source:Int, maxNum:Int, ifOriginalPic:Int ,callBackfunName:String){
    imagePickTool.isHiddenVideo = true
    var size:CGSize?
    if(ifOriginalPic == 0){
        size = CGSize(width: PHImageManagerMaximumSize.width * 0.4, height: PHImageManagerMaximumSize.height * 0.4)
    }else{
        size = PHImageManagerMaximumSize
    }
    var path:String = ""
    switch source {
    case 0:
        imagePickTool.cameraOut = false
        imagePickTool.showCamaroInPicture = false
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: maxNum) { (asset,cutImage) in
            for phasset in asset {
                path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
                APPExecWinJS(mark: " ", JSFun: callBackfunName + "(" + path + ")")
            }
        }
    case 1:
        imagePickTool.cameraOut = true
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: maxNum) { (asset,cutImage) in
            for phasset in asset {
                path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
                APPExecWinJS(mark: " ", JSFun: callBackfunName + "(" + path + ")")
            }
        }
    case 2:
        imagePickTool.showCamaroInPicture = true
        imagePickTool.cameraOut = false
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: maxNum) { (asset,cutImage) in
            for phasset in asset {
                path = getPathFromAsset(phasset: phasset, size: size!, ifOriginalPic: ifOriginalPic).joined(separator: ",")
                APPExecWinJS(mark: " ", JSFun: callBackfunName + "(" + path + ")")
            }
        }
    default:
        break
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

//图片预览
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

fileprivate func getPathFromAsset(phasset:PHAsset, size:CGSize, ifOriginalPic:Int) ->   [String]{
    var path:[String] = [String]()
    PHImageManager.default().requestImage(for: phasset,
                                          targetSize: size, contentMode: .aspectFit,
                                          options: nil, resultHandler: { (image, info:[AnyHashable : Any]?) in
                                            if(ifOriginalPic == 1){
                                                let imageURL = info!["PHImageFileURLKey"] as! URL
                                                path.append(imageURL.path)
                                                print("路径：",path)
                                            }else{
                                                let fileManager = FileManager.default
                                                let rootPath = NSHomeDirectory() + "/Documents/"
                                                let name = info!["PHImageResultDeliveredImageFormatKey"] as! Int
                                                let filePath = rootPath  + "\(name)" + ".jpg"
                                                let imageData = image?.jpegData(compressionQuality: 1)
                                                fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
                                                path.append(filePath)
                                                print("路径：",path)
                                            }
    })
    return path
}
