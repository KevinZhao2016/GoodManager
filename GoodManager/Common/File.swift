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
    let isExists = fileManager.fileExists(atPath: NSHomeDirectory() + path)
    return isExists
}

func APPDelFile(path:String) -> Bool{
    do {
        try fileManager.removeItem(atPath: NSHomeDirectory()+path)
    }
      catch {
            print(error)
            return false
    }
    return true
}

func APPGetFileSize(path:String) -> Int{
    let filePath = NSHomeDirectory() + path
    return Int(filePath.getFileSize())
}

