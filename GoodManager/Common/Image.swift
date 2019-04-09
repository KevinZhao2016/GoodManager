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

// 相册
func chooseSingleImageFromAlbum(source:Int, ifNeedEdit:Int, ifOriginalPic:Int ,callBackfunName:String){
    print("--------------ChooseSingleImage -- from album----------------")
    let vc = getLastMainViewController()
    let ijsip = IJSImagePickerController(maxImagesCount: 1, columnNumber: 4, pushPhotoPickerVc: false)
    // 不能选择视频
    ijsip?.allowPickingVideo = false
    // 编辑
    if ifNeedEdit == 0 {
        // 不需要编辑
        ijsip?.isHiddenEdit = true
    }else{
        // 需要编辑
        ijsip?.isHiddenEdit = false
    }
    var size:CGSize?
    size = PHImageManagerMaximumSize
    // 原图
    if ifOriginalPic == 0 {
        // 不显示
        ijsip?.hiddenOriginalButton = true
    }else{
        // 显示
        ijsip?.allowPickingOriginalPhoto = true
        ijsip?.hiddenOriginalButton = false
    }
    ijsip?.dataSource = source
    // 获取数据
    ijsip?.dataSource = 0
    ijsip?.loadTheSelectedData({(images: [UIImage]?, urls: [URL]?, assets: [PHAsset]?, x: [[AnyHashable:Any]]?, type: IJSPExportSourceType,error: Error?) in
        getPathFromAsset(phasset: assets![0], size: size!, ifOriginalPic: ifOriginalPic)
    })
    vc.present(ijsip!, animated: true, completion: nil)
}

// 拍照
func chooseSingleImageFromCamera(source:Int, ifNeedEdit:Int, ifOriginalPic:Int ,callBackfunName:String){
    print("--------------ChooseSingleImage -- from camera----------------")
    let vc = getLastMainViewController()
    let ijsip_1 = IJSImagePickerController(maxImagesCount: 1, columnNumber: 4, pushPhotoPickerVc: false, dataSource: 1)
    ijsip_1?.dataSource = 1
    // 不能选择视频
    ijsip_1?.allowPickingVideo = false
    // 编辑
    if ifNeedEdit == 0 {
        // 不需要编辑
        ijsip_1?.isHiddenEdit = true
    }else{
        // 需要编辑
        ijsip_1?.isHiddenEdit = false
    }
    var size:CGSize?
    size = PHImageManagerMaximumSize
    // 原图
    if ifOriginalPic == 0 {
        // 不显示
        ijsip_1?.hiddenOriginalButton = true
    }else{
        // 显示
        ijsip_1?.allowPickingOriginalPhoto = true
        ijsip_1?.hiddenOriginalButton = false
    }
    // 获取数据
    ijsip_1?.loadTheSelectedData({(images: [UIImage]?, urls: [URL]?, assets: [PHAsset]?, x: [[AnyHashable:Any]]?, type: IJSPExportSourceType,error: Error?) in
        getPathFromAsset(phasset: assets![0], size: size!, ifOriginalPic: ifOriginalPic)
    })
    vc.present(ijsip_1!, animated: true, completion: nil)
}

// 单选图片
func APPChooseSingleImage(source:Int, ifNeedEdit:Int, ifOriginalPic:Int ,callBackfunName:String){
    print("--------------APPChooseSingleImage----------------")
    callbackfun = callBackfunName
    if source == 0 {
        // 相册
        chooseSingleImageFromAlbum(source: 0, ifNeedEdit: ifNeedEdit, ifOriginalPic: ifOriginalPic, callBackfunName: callBackfunName)
    }else if source == 1 {
        // 拍照
        chooseSingleImageFromCamera(source: 1, ifNeedEdit: ifNeedEdit, ifOriginalPic: ifOriginalPic, callBackfunName: callBackfunName)
    }else{
        print("拍照/相册")
        let vc = getLastMainViewController()
        let alert = UIAlertController(title: "拍照或从相册选择", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "拍照", style: UIAlertAction.Style.default, handler: { (UIAlertView) in
            print("拍照")
            chooseSingleImageFromCamera(source: 1, ifNeedEdit: ifNeedEdit, ifOriginalPic: ifOriginalPic, callBackfunName: callBackfunName)
        }))
        alert.addAction(UIAlertAction(title: "相册", style: UIAlertAction.Style.default, handler: { (UIAlertView) in
            print("相册")
            chooseSingleImageFromAlbum(source: 0, ifNeedEdit: ifNeedEdit, ifOriginalPic: ifOriginalPic, callBackfunName: callBackfunName)
        }))
        vc.present(alert, animated: true, completion: nil)
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
    vc.present(controller!, animated: true, completion: nil)
}

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

func getPathFromAsset(phasset:PHAsset, size:CGSize, ifOriginalPic:Int) ->   [String]{
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

class getPathOfImages: NSObject {
    @objc func getPathFromAsset(phasset:PHAsset, size:CGSize, ifOriginalPic:Int) ->   [String]{
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
}
