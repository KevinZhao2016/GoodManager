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
        
    //
    var callbackfun:String?
    
    
    
    // 文件名字的数组变量
    let fileNames = ["AppCoda-PDF.pdf","AppCoda-Pages.pages","AppCoda-Word.docx","AppCoda-Keynote.key","AppCoda-Text.txt","AppCoda-Image.jpeg"]
    
    // 存储不同的文件的URL
    var fileURLs = [NSURL]()
    
    //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellFile", for: indexPath as IndexPath)
        let currentFileParts = extractAndBreakFilenameInComponents(fileURL: fileURLs[indexPath.row])
        cell.textLabel?.text = currentFileParts.fileName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FileCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FileCellTableViewCell") as! FileCellTableViewCell
        //        cell?.textLabel?.numberOfLines = 0       // 根据内容显示高度
        
        //print(self.items)
        //        self.mainViewModel.getSearchDate(infoName: items[indexPath.row], found: { (word) in
        //            cell.titleName.text = self.items[indexPath.row]
        //            cell.visitTime.text = word.date
        //            cell.searchTimes.text = "查询次数:" + String(word.count)
        //            print("cell中的内容\n" + cell.titleName.text! + "\n" + cell.visitTime.text!)
        //        })
        cell.fileNameLabel.text = self.fileNames[indexPath.row]
        print("cell中的内容\n" + cell.fileNameLabel.text!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "file list"
        
        self.tableView.register(UINib(nibName:"FileCellTableViewCell", bundle:nil), forCellReuseIdentifier:"FileCellTableViewCell")
        
        prepareFileURLs()
    }
    
    
    
    // 为fileURLs添加值
    func prepareFileURLs() {
        for file in fileNames {
            // components(separatedBy:)方法用于把String按照给定的分隔符，分解成[String]
            let fileParts = file.components(separatedBy: ".")
            if let fileURL = Bundle.main.url(forResource: fileParts[0], withExtension: fileParts[1]) {
                // 判断文件地址是否存在
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    fileURLs.append(fileURL as NSURL)
                }
            }
        }
    }
    
    // 根据文件的URL，获得文件名和文件后缀（文件类型）
    func extractAndBreakFilenameInComponents(fileURL: NSURL) -> (fileName: String, fileExtension: String) {
        let fileURLParts = fileURL.path!.components(separatedBy: "/")
        let fileName = fileURLParts.last
        let filenameParts = fileName?.components(separatedBy: ".")
        return (filenameParts![0], filenameParts![1])
    }
    
    //    //
    //    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    //        return 1
    //    }
    
    //    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    //
    //    }
}
