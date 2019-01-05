//
//  FileExtension.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/3.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import Alamofire

fileprivate var callbackfun:String = ""

extension MainViewController{
    
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
}
