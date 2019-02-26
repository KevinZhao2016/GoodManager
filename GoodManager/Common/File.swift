//
//  File.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/27.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import ObjectMapper
import SwiftyJSON
import QuickLook


let fileManager = FileManager.default

let quickLookViewController = QLPreviewController()

//  单选文件
func APPChooseSingleFile(callBackfunName:String) {
    print("-------------APPChooseSingleFile--------------")
    let vc = getLastMainViewController()
    vc.imagecallBackfunName = callBackfunName
    let FileListVC = FileListTableViewController()
    FileListVC.callbackfun = callBackfunName
    let nvc = UINavigationController(rootViewController: FileListVC)
    vc.present(nvc, animated: true, completion: nil)
}

func APPIfExistFile(path:String) -> Int {
//    let documentPath = NSHomeDirectory() + "/Documents"
    let isExists = fileManager.fileExists(atPath:  path)
    if (isExists){
        return 1
    }else {
        return 0
    }
}

func APPDelFile(path:String,callBackfunName:String){
//    let documentPath = NSHomeDirectory() + "/Documents"
    do {
        try fileManager.removeItem(atPath: path)
    }
      catch {
            ExecWinJS(JSFun: callBackfunName + "(\"0\")")
            print(error)
    }
    ExecWinJS(JSFun: callBackfunName + "(\"1\")")
}

func APPGetFileSize(path:String) -> String{
    print("-------------APPGetFileSize--------------")
    let manager = FileManager.default
    let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
//    let docPath = urlForDocument[0]
//    let file = docPath.appendingPathComponent("test.txt")
    let attributes = try? manager.attributesOfItem(atPath: path) //结果为Dictionary类型
    print(attributes![FileAttributeKey.size]!)
    return "\"\(attributes![FileAttributeKey.size]!)\""
}

func APPGetFileBase(path:String) -> String{
    let fileUrl = URL(fileURLWithPath: path)
    let fileData = try? Data(contentsOf: fileUrl)
    //将文件转为base64编码
    let base64 = fileData?.base64EncodedString(options: .endLineWithLineFeed)
    return base64 ?? ""
}

//在线预览文件
func APPPreviewFile(path:String){
    let vc = mainViewControllers.last
    let controller = BaseNavigationController(rootViewController:PreviewFileViewController(Path: path))
    vc!.present(controller, animated: true, completion: nil)
}

func APPUploadFile(path:String, callBackfunName:String){
//    let fileURL = URL(string: NSHomeDirectory() + "/Documents" + path)
    let LaunchProvider = MoyaProvider<LaunchTarget>()
    //TODO: 上传地址初始化
//    Alamofire.upload(fileURL!, to: "host")
//        .response { response in
//            print(response)
//            APPExecWinJS(mark: "", JSFun: callBackfunName + "(" + (fileURL?.path)! + ")")
//    }
    LaunchProvider.request(.uploadFile(path), completion: { result in
        switch result {
        case let .success(moyaResponse):
            let data = moyaResponse.data // Data, your JSON response is probably in here!
            let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc
            print(statusCode)
            if(statusCode == 200){
                do {
                    if let model = try? moyaResponse.mapObject(LaunchResultModel.self) {
                        if(model.code == 1){
                            print(model)
                            //TODO：执行回调
                            ExecWinJS(JSFun: callBackfunName + "(\"" + String(data: data, encoding: String.Encoding.utf8)! + "\")")
                        }
                    } else {
                        print("maperror")
                    }
                }catch {
                    print(error)
                }
            }
        case let .failure(error):
            guard let error = error as? CustomStringConvertible else {
                break
            }
            print(error)
        }
    })
    
}

func APPDownFile(path:String, callBackfunName:String){
    //指定下载路径和保存文件名
    //指定下载路径（文件名不变）
    let destination: DownloadRequest.DownloadFileDestination = { _, response in
        let documentsURL = URL(string: NSHomeDirectory() + "/Documents")
        let fileURL = documentsURL?.appendingPathComponent(response.suggestedFilename!)
        //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
        return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    //需要下载的文件
    let fileURL = URL(string: path)!
    //开始下载
    Alamofire.download(fileURL, to: destination)
        .response { response in
            print(response)
            ExecWinJS(JSFun: callBackfunName + "(\"" + (response.destinationURL?.path)! + "\")")
    }
}
