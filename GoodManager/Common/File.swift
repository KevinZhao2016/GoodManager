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
//let documentPath = NSHomeDirectory() + "/Documents"

// 单选文件
func APPChooseSingleFile(callBackfunName:String) {
    print("-------------APPChooseSingleFile--------------")
    let vc = getLastMainViewController()
    vc.imagecallBackfunName = callBackfunName
    let FileListVC = FileListTableViewController()
    FileListVC.callbackfun = callBackfunName
    let nvc = UINavigationController(rootViewController: FileListVC)
    vc.present(nvc, animated: true, completion: nil)
}

// 文件是否存在
func APPIfExistFile(path:String) -> String {
    let isExists = fileManager.fileExists(atPath:  path)
    var result:String = ""
    if (isExists){
        result = "1"
    }else {
        result = "0"
    }
    return result
}

func APPDelFile(path:String,callBackfunName:String){
    do {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: path,isDirectory: &isDir){
            if isDir.boolValue {
                // file exists and is a directory
            }
            else {
                // file exists and is not a directory
            }
            try! fileManager.removeItem(atPath: path)
        }
        ExecWinJS(JSFun: callBackfunName + "(\"1\")")
    } catch {
        print(error)
        ExecWinJS(JSFun: callBackfunName + "(\"0\")")
    }
}

func APPGetFileSize(path:String) -> String{
    print("-------------APPGetFileSize--------------")
    // let fileType = _path.components(separatedBy: ".")[1]
    var _path = path
    // 路径整理
    if (_path != "")&&(_path.contains("[\"")&&(_path.contains("\"]")) ) {
        _path = _path.components(separatedBy: "[\"")[1].components(separatedBy: "\"]")[0]
    }
    while (_path.contains(",")) {
        _path.remove(at: _path.firstIndex(of: ",")!)
    }
    // 两条路径
    var TwoPath = [String]()
    if (_path.firstIndex(of: ".") != _path.lastIndex(of: ".")) {
        TwoPath = _path.components(separatedBy: ".")
        TwoPath[0].append("."+TwoPath[2])
        TwoPath[1].append("."+TwoPath[2])
        var str = TwoPath[1].dropFirst(3)
        TwoPath[1] = String(str)

        print("filePath_1:  " + TwoPath[0])
        print("filePath_2:  " + TwoPath[1])
    }
    let manager = FileManager.default
    let attributes = try? manager.attributesOfItem(atPath: _path) //结果为Dictionary类型
    print("filePath:  \(_path)")
    if attributes != nil {
        print("fileSize:  \(attributes![FileAttributeKey.size]!)")
        return "\(attributes![FileAttributeKey.size]!)"
    }else{
        if FileManager.default.fileExists(atPath: path){
            do{
                var fileinfo = try FileManager.default.attributesOfItem(atPath: path)
                let size = "\(fileinfo[FileAttributeKey.size])"
                return size
            }catch{
                return "unknow"
            }
        }
        return "unknow"
    }
}

func APPGetFileBase(path:String) -> String{
    print("-------------APPGetFileBase--------------")
    let vc = getLastMainViewController()
    var isDir: ObjCBool = false
    // 如果文件存在
    if FileManager.default.fileExists(atPath: path,isDirectory: &isDir){
        if isDir.boolValue {
            // file exists and is a directory
        }
        else {
            // file exists and is not a directory
        }
        let fileUrl = URL(fileURLWithPath: path)
        let fileData = try? Data(contentsOf: fileUrl)
        // 将文件转为base64编码
        let base64 = fileData?.base64EncodedString(options: .endLineWithLineFeed)
        return base64 ?? ""
    }else{
        //文件不存在
        let alert = UIAlertController(title: "文件不存在！", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        return ""
    }
}

//在线预览文件
func APPPreviewFile(path:String){
    print("-------------APPPreviewFile--------------")
    let vc = getLastMainViewController()
    var isDir: ObjCBool = false
    // 如果文件存在
    if FileManager.default.fileExists(atPath: path,isDirectory: &isDir){
        if isDir.boolValue {
            // file exists and is a directory
        }
        else {
            // file exists and is not a directory
        }
        let filevc = PreviewFileViewController(Path: path)
        vc.present(filevc, animated: true, completion: nil)
    }else{
        //文件不存在
        let alert = UIAlertController(title: "文件不存在！", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}

func APPUploadFile(path:String, domainName:String, folderName:String, callBackfunName:String){
    print("-------------APPUploadFile--------------")
    let vc = getLastMainViewController()
    
    var isDir: ObjCBool = false
    // 如果文件存在
    if FileManager.default.fileExists(atPath: path,isDirectory: &isDir){
        if isDir.boolValue {
            // file exists and is a directory
        }
        else {
            // file exists and is not a directory
        }
        let LaunchProvider = MoyaProvider<LaunchTarget>()
        LaunchProvider.request(.uploadFile(path,domainName,folderName), completion: { result in
            switch result {
            case let .success(moyaResponse):
                // Data, your JSON response is probably in here!
                let data = moyaResponse.data
                // Int - 200, 401, 500, etc
                let statusCode = moyaResponse.statusCode
                print("APPUploadFile  -- success: " + "\(statusCode)")
                if(statusCode == 200){
                    do {
                        if let model = try? moyaResponse.mapObject(LaunchResultModel.self) {
                            print("上传文件 code：\(model.code)")
                            let str = model.result.toJSONString()?.replacingOccurrences(of: "\"", with: "\\\"")
                            ExecWinJS(JSFun: callBackfunName + "(\"" + (str ?? "no data") + "\")")
                        } else {
                            print("map  error")
                            print("data : \(data)")
                            ExecWinJS(JSFun: callBackfunName + "(\"" + "no data" + "\")")
                            let alert = UIAlertController(title: "文件上传异常！", message: "文件上传成功，获取返回值异常!", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: nil))
                            vc.present(alert, animated: true, completion: nil)
                        }
                    }catch {
                        print("APPUploadFile  -- error:  "+"\(error)")
                        let alert = UIAlertController(title: "文件上传失败！", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: nil))
                        vc.present(alert, animated: true, completion: nil)
                    }
                }
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                let alert = UIAlertController(title: "文件上传失败！", message: error.description, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: nil))
                vc.present(alert, animated: true, completion: nil)
                print("APPUploadFile  -- error:  " + "\(error)")
            }
        })
    }else{
        //文件不存在
        let alert = UIAlertController(title: "文件不存在！", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}

func APPDownFile(path:String, callBackfunName:String){
    print("-------------APPDownFile--------------")
    //指定下载路径和保存文件名
    //指定下载路径（文件名不变）
    let destination: DownloadRequest.DownloadFileDestination = { _, response in
        let documentsURL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/localDocuments")
        let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
        //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    //需要下载的文件
    let fileURL = URL(string: path)
    //开始下载
    Alamofire.download(fileURL!, to: destination)
        .response { response in
            print("Download:")
            print(response.error)
            ExecWinJS(JSFun: callBackfunName + "(\"" + (response.destinationURL?.path)! + "\")")
    }
}
