//
//  File.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/27.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation
import Alamofire

let fileManager = FileManager.default

func APPIfExistFile(path:String) -> Bool {
    let documentPath = NSHomeDirectory() + "/Documents"
    let isExists = fileManager.fileExists(atPath: documentPath + path)
    return isExists
}

func APPDelFile(path:String) -> Bool{
    let documentPath = NSHomeDirectory() + "/Documents"
    do {
        try fileManager.removeItem(atPath: documentPath+path)
    }
      catch {
            print(error)
            return false
    }
    return true
}

func APPGetFileSize(path:String) -> Int{
    let documentPath = NSHomeDirectory() + "/Documents"
    let filePath = documentPath + path
    return Int(filePath.getFileSize())
}

func APPGetFileBase(path:String) -> String{
    let documentPath = NSHomeDirectory() + "/Documents"
    let fileUrl = URL(fileURLWithPath: documentPath + path)
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
    let fileURL = URL(string: NSHomeDirectory() + "/Documents" + path)
    //TODO: 上传地址初始化
    Alamofire.upload(fileURL!, to: "host")
        .response { response in
            print(response)
            APPExecWinJS(mark: "", JSFun: callBackfunName + "(" + (fileURL?.path)! + ")")
    }
    
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
            APPExecWinJS(mark:" ", JSFun: callBackfunName + "(" + (response.destinationURL?.path)! + ")")
    }
}
