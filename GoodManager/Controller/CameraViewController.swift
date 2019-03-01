//
//  CameraViewController.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/7.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit

class CameraViewController: UIImagePickerController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var callbackfun:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let type = info[UIImagePickerController.InfoKey.mediaType] as! String
        if (type == "public.movie"){
            let filePath = info[UIImagePickerController.InfoKey.mediaURL] as! URL
//            print(info[UIImagePickerController.InfoKey.mediaURL])
            print("filePath.path:  " + filePath.path)
            APPExecWinJS(mark: "", JSFun: callbackfun! + "(\"" + filePath.path + "\")")
            self.dismiss(animated: true, completion: nil)
        }else{
            let image = info[UIImagePickerController.InfoKey.originalImage]  as! UIImage
            let fileManager = FileManager.default
            let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                               .userDomainMask, true)[0] as String
            let date = Date.init().hashValue
            let filePath = rootPath + "/" + "\(date)" + ".jpg"
            let imageData = image.jpegData(compressionQuality: 1)
            //        print ("name:"+"\(date)")
            fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
            print("filePath:  "+filePath)
            APPExecWinJS(mark: "", JSFun: callbackfun! + "(\"" + filePath + "\")")
        }
        print("hello error!")
    }
}
