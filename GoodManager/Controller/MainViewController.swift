//
//  ViewController.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/25.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage
import TZImagePickerController
import dsBridge
import CoreLocation

class MainViewController: BaseViewController,TZImagePickerControllerDelegate {
    var mark:String = "main"
    var url:String = mainUrl
    var webview:DWKWebView!
    var image = FLAnimatedImageView(frame: UIScreen.main.bounds)
    lazy var videocallBackfunName:String = ""
    lazy var imagecallBackfunName:String = ""
    var photoPath:String = ""
    lazy  var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 2))
        self.progressView.tintColor = UIColor.green      // 进度条颜色
        self.progressView.trackTintColor = UIColor.white // 进度条背景色
        return self.progressView
    }()
    
    lazy var locationManager = CLLocationManager()//用于定位
    lazy var currLocation = CLLocation()
    lazy var locationModel = LocationModel()
    
    override func viewDidLoad() {
        print(UIScreen.main.bounds)
        super.viewDidLoad()
        setupWebview()
        if(LaunchFlag == false){
            setupLaunchView() //启动页
        }
        locationManager.delegate = self //定位代理方法
        
//        let notificationName = Notification.Name(rawValue: "idCardFront")
//        NotificationCenter.default.addObserver(self,selector:#selector(receiveImagePath(notification:)),name: notificationName,object: nil)
    }
//    @objc func receiveImagePath(notification: Notification){
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let value1 = userInfo["idCardFrontImage"] as! String
//        print("idCardFrontImage  "+value1)
//        //ExecWinJS(JSFun: <#T##String#>)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
//        APPChooseSingleVideo(source:1, maxVideoLength:10, callBackfunName:"String")
//       APPPlayVideo(path:"https://media.w3.org/2010/05/sintel/trailer.mp4", startPosition:10, callBackfunName:"String")
//        APPChooseMoreImage(source: 0, maxNum: 9, ifOriginalPic: 1, callBackfunName: "String")
//        APPChooseSingleImage(source:0, ifNeedEdit:0, ifOriginalPic:1 ,callBackfunName:"String")
//        APPChooseSingleVideo(source:0, maxVideoLength:3, callBackfunName:"String")
    }
    
    func setupLaunchView(){
        //启动图片 异步获取
        self.view.backgroundColor = UIColor.white
        image.image = UIImage(named: "好监理_启动页")
        image.contentMode = .scaleAspectFit
//        image.sd_setImage(with: URL(string: picUrl), placeholderImage: UIImage(named: "好监理_启动页"))
        image.sd_setImage(with: URL(string: picUrl), placeholderImage: UIImage(named: "好监理_启动页"), options: SDWebImageOptions()) { (Image, error, type, url) in
            self.image.contentMode = .scaleAspectFill;
            print(url)
        }
       
        self.view.addSubview(image)
        //添加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        image.addGestureRecognizer(singleTapGesture)
        image.isUserInteractionEnabled = true
        _ = Timer.scheduledTimer(withTimeInterval: 3.3, repeats: false, block: { (Timer) in
            self.removeImageWithDelay()
        })
        LaunchFlag = true
    }
    
    func setupWebview(){
        // 创建配置
//        let config = WKWebViewConfiguration()
//        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
//        let userContent = WKUserContentController()
//        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
//        userContent.add(self, name: "NativeMethod")
//        // 将UserConttentController设置到配置文件
//        config.userContentController = userContent
        webview = DWKWebView(frame: CGRect(x: 0, y: STATUS_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - STATUS_HEIGHT))
        //bridge
        webview.addJavascriptObject(JsApiSwift(), namespace: nil)
        webview.load(URLRequest(url: URL(string: url)!))
        webview.navigationDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        self.view.addSubview(webview)
        //进度条监听
        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webview.addSubview(self.progressView)
        //适配全面屏,隐藏安全区域
        if #available(iOS 11.0, *) {
            webview.scrollView.contentInsetAdjustmentBehavior = .never;
        }
    }
    
    func removeImageWithDelay(){
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.image.alpha = 0
            }, completion: { (finished) -> Void in
                if(finished){
                    self.image.removeFromSuperview()
                }
            })
    }
    
    @objc func imageViewClick(){
        if (linkUrl != "" && picUrl != ""){
            APPOutBrowserOpenURL(url: linkUrl)
        }
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
        let option = PHVideoRequestOptions.init()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = PHVideoRequestOptionsDeliveryMode.automatic
        PHImageManager.default().requestAVAsset(forVideo: asset, options: option) { (Asset:AVAsset?, AudioMix:AVAudioMix?, info:[AnyHashable : Any]?) in
            let  avAsset = Asset as? AVURLAsset
            let path = avAsset?.url.path
            print(path)
            self.VideoCallBack(path:path!, callBackfunName:self.videocallBackfunName)
        }
    }
    
    private func VideoCallBack(path:String, callBackfunName:String){
        ExecWinJS(JSFun: callBackfunName + "(\"" + path + "\")")
    }
    
    private func ImageCallBack(path:String, callBackfunName:String){
        ExecWinJS(JSFun: callBackfunName + "(\"" + path + "\")")
    }
    
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        self.photoPath = ""
        var zipImageURLS = [String]()
        var targetSize = PHImageManagerMaximumSize
        if isSelectOriginalPhoto == true {
            targetSize = PHImageManagerMaximumSize
        }else{
            targetSize = CGSize(width: 200, height: 200)
            // 压缩图片
            for _image in photos {
                var i = 1
                print("压缩图片！")
                let imageData = _image.jpegData(compressionQuality: 0.4)
                let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
                let name = _image.accessibilityIdentifier
                let filePath = rootPath + "/" + "image_\(i)" + ".jpg"
                let fileManager = FileManager.default
                zipImageURLS.append(filePath)
                print("zipFilePath:  " + filePath)
                fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
            }
        }
        
        
        

        
        var i = 0
        var j = 0
        print("assets:  \(assets)")
        for asset in assets {
            i = i + 1
            print("i:  \(i)")
            PHImageManager.default().requestImage(for: asset as! PHAsset, targetSize: targetSize, contentMode: .aspectFit, options:nil, resultHandler: {(image, info:[AnyHashable : Any]?) in
                print ("j:  \(j)")
                if(isSelectOriginalPhoto == true){
                    print("请求原图！")
                    let imageURL = info!["PHImageFileURLKey"] as! URL
                    print("路径：",imageURL)
                    self.photoPath.append(imageURL.path + ",")
                    print("photopath:",self.photoPath)
                    self.ImageCallBack(path: imageURL.path, callBackfunName: self.imagecallBackfunName)
                }else if((isSelectOriginalPhoto == false)&&j<zipImageURLS.count){
                    print("请求缩略图！")
                    self.photoPath.append(zipImageURLS[j] + ",")
                    print(zipImageURLS[j])
                    self.ImageCallBack(path: zipImageURLS[j], callBackfunName: self.imagecallBackfunName)
                }
                j = j + 1
//                if(i == assets.count){
//                    self.ImageCallBack(path: self.photoPath, callBackfunName: self.imagecallBackfunName)
//                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.uiDelegate = nil
        self.webview.navigationDelegate = nil
        webview.configuration.userContentController.removeScriptMessageHandler(forName: "NativeMethod")
    }
    
}
