//
//  File.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/27.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import Foundation

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
