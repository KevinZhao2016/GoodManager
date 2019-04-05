//
//  FileListTableViewController.swift
//  GoodManager
//
//  Created by DJ on 2019/2/25.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit
import QuickLook

class FileListTableViewController: UITableViewController {

    var callbackfun:String?
    
    
    // 文件管理
    var fileManager = FileManager.default

    // 文件存放总目录
    let documentsDir = NSHomeDirectory() + "/Documents"
    var fileDir = ""
    
    // 文件名字的数组变量
    var fileNames = [String]()
    
    // 存储不同的文件的URL
    var fileURLs = [String]()
    
    //返回cell个数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNames.count
    }
    
    //返回cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FileCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FileCellTableViewCell") as! FileCellTableViewCell
        //        cell?.textLabel?.numberOfLines = 0       // 根据内容显示高度
        //        print(self.items)
        //        self.mainViewModel.getSearchDate(infoName: items[indexPath.row], found: { (word) in
        //            cell.titleName.text = self.items[indexPath.row]
        //            cell.visitTime.text = word.date
        //            cell.searchTimes.text = "查询次数:" + String(word.count)
        //            print("cell中的内容\n" + cell.titleName.text! + "\n" + cell.visitTime.text!)
        //        })
        cell.fileNameLabel.text = self.fileNames[indexPath.row]
        print("fileNameLabel:  " + cell.fileNameLabel.text!)
        return cell
    }
    
    // 返回cell高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // cell点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("-------------cell clicked-------------")
        print("indexPath:    \(indexPath))")
        print("fileName:     \(fileNames[indexPath.row])")
        ExecWinJS(JSFun: self.callbackfun! + "(\"" + "\(self.fileURLs[indexPath.row])" + "\")")
        back()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "File List"
        self.tableView.register(UINib(nibName:"FileCellTableViewCell", bundle:nil), forCellReuseIdentifier:"FileCellTableViewCell")
        let newBackButton = UIBarButtonItem(title: "返回", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("back")))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        // 本地文件存放地址
        fileDir = documentsDir + "/localDocuments"
        do {
            try fileManager.createDirectory(atPath: fileDir, withIntermediateDirectories: true, attributes: nil)
        } catch is Error {
            print("Error")
        }
        
        // 获取文件列表
        getFiles()
        
        self.tableView.reloadData()
    }
    
    // 获取文件列表 -> fileNames 、fileURLs
    func getFiles() {
        // test
        // 存储一个普通的文本文件
        let info = "欢迎来到hange.com"
        try! info.write(toFile: fileDir+"/ll.txt", atomically: true, encoding: String.Encoding.utf8)
        // 检查文件是否存在
//        let exsit = fileManager.fileExists(atPath: fileDir+"/ll.txt")
//        print(exsit)
        
        // 遍历指定目录下内容
        var contentResult = [String]()
        do {
            try contentResult = fileManager.contentsOfDirectory(atPath: fileDir)
        } catch is Error {
            print("error")
        }
        print("contentResult:  \(contentResult)")
        
        // 文件名
        self.fileNames = contentResult
        
        // 拼接文件路径
        for var _filenames in self.fileNames {
            self.fileURLs.append(fileDir+"/"+_filenames)
        }
        print(self.fileURLs)
    }
    
    // 根据文件的URL，获得 文件名、文件后缀（文件类型）
//    func extractAndBreakFilenameInComponents(fileURL: NSURL) -> (fileName: String, fileExtension: String) {
//        let fileURLParts = fileURL.path!.components(separatedBy: "/")
//        let fileName = fileURLParts.last
//        let filenameParts = fileName?.components(separatedBy: ".")
//        return (filenameParts![0], filenameParts![1])
//    }
    
    // 为fileURLs添加值
//    func prepareFileURLs() {
//        for file in fileNames {
//            // components(separatedBy:)方法用于把String按照给定的分隔符，分解成[String]
//            let fileParts = file.components(separatedBy: ".")
//            if let fileURL = Bundle.main.url(forResource: fileParts[0], withExtension: fileParts[1]) {
//                // 判断文件地址是否存在
//                if FileManager.default.fileExists(atPath: fileURL.path) {
//                    fileURLs.append(fileURL as NSURL)
//                }
//            }
//        }
//    }
    
    // 返回按钮
    @objc func back() {
        var present = self.presentingViewController
        while (true) {
            if ((present?.presentingViewController) != nil) {
                present = present?.presentingViewController;
            }else{
                break;
            }
        }
        present?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //    //
    //    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    //        return 1
    //    }
    
    //    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    //
    //    }
}
