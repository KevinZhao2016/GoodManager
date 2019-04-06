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
import SwiftyJSON

class MainViewController: BaseViewController,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    var mark:String = "main"
    var url:String = mainUrl
    var webview:DWKWebView!
    
    // 倒计时更改
    var timeCount:Int = 5
    var timer:Timer?
    
    let button:UIButton = UIButton(type: .custom);
    
    
    var image = FLAnimatedImageView(frame: UIScreen.main.bounds)
    var bottomImage:UIImageView = UIImageView(frame: UIScreen.main.bounds)
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
            var netSituation = APPGetNetWork()
            let jsonString = JSON(parseJSON: netSituation)
            netSituation = jsonString["mode"].stringValue
            if netSituation == "0" {
                let vc = getLastMainViewController()
                let noNetVC = NoNetViewController()
                vc.present(noNetVC, animated: true, completion: nil)
            } else {
                setupLaunchView() //启动页
            }
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
        self.view.addSubview(image)
        let isIPhoneX:Bool = self.isIPhoneX()
        if isIPhoneX   {
            image.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.8)
            
            bottomImage.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT * 0.8, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.2)
            bottomImage.backgroundColor = UIColor.white;
            bottomImage.image = UIImage(named: "好监理_启动页")
            bottomImage.contentMode = .scaleAspectFit
            self.view.addSubview(bottomImage)
        }
        image.image = UIImage(named: "好监理_启动页")
        image.contentMode = .scaleAspectFit
        
        // 倒计时按钮
        button.frame = CGRect.init(x: SCREEN_WIDTH - 70, y: STATUS_HEIGHT + 10, width: 65, height: 25)
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        let title:String = String.init(format: "%d 跳过", self.timeCount)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        
        image.addSubview(button)
        
     
        
//        image.sd_setImage(with: URL(string: picUrl), placeholderImage: UIImage(named: "好监理_启动页"))
       
        //添加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        image.addGestureRecognizer(singleTapGesture)
        image.isUserInteractionEnabled = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.timeCount = self.timeCount - 1
            let title:String = String.init(format: "%d 跳过", self.timeCount)
            self.button.setTitle(title, for: .normal)
            if(self.timeCount == 0){
                self.removeImageWithDelay()
            }
        })
        LaunchFlag = true
    }
    
    func isIPhoneX() -> Bool {
        var iPhoneX:Bool = false
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone{
            return iPhoneX
        }
        if #available(iOS 11.0, *) {
            if Double((UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)!) > 0.0 {
                iPhoneX = true
            }
        }
        return iPhoneX
    }
    
    @objc func btnClick(){
         self.removeImageWithDelay()
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
            self.timer?.invalidate()
            self.timer = nil
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.image.alpha = 0
                self.bottomImage.alpha = 0
            }, completion: { (finished) -> Void in
                if(finished){
                    self.image.removeFromSuperview()
                    self.bottomImage.removeFromSuperview()
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
            var i = 1
            for _image in photos {
                print("压缩图片！")
                let imageData = _image.jpegData(compressionQuality: 0.4)
                let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
                let name = _image.accessibilityIdentifier
                let filePath = rootPath + "/" + "image_\(i)" + ".jpg"
                let fileManager = FileManager.default
                zipImageURLS.append(filePath)
                print("zipFilePath:  " + filePath)
                fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
                i+=1
            }
        }
        var i = 0
        var j = 0
        print("assets:  \(assets)")
        for asset in assets {
            print("i:  \(i)")
            PHImageManager.default().requestImage(for: asset as! PHAsset, targetSize: targetSize, contentMode: .aspectFit, options:nil, resultHandler: {(image, info:[AnyHashable : Any]?) in
                print ("j:  \(j)")
                if(isSelectOriginalPhoto == true){
                    print("请求原图！")
                    let imageURL = info!["PHImageFileURLKey"] as! URL
                    print("路径：",imageURL)
                    self.photoPath.append(imageURL.path)
                    print("photopath:",self.photoPath)
                    if(j < assets.count-1){
                        self.photoPath.append(",")
                    }
                    if(j == assets.count-1){
                        self.ImageCallBack(path: self.photoPath, callBackfunName: self.imagecallBackfunName)
                    }
                }else if((isSelectOriginalPhoto == false)&&j<zipImageURLS.count){
                    print("请求缩略图！")
                    self.photoPath.append(zipImageURLS[j])
                    if(j < assets.count-1){
                        self.photoPath.append(",")
                    }
                    print(zipImageURLS[j])
                    if(j == assets.count-1){
                        self.ImageCallBack(path: self.photoPath, callBackfunName: self.imagecallBackfunName)
                    }
                }
                j = j + 1
            })
            i = i + 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        if self.webview != nil {
            self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
            self.webview.uiDelegate = nil
            self.webview.navigationDelegate = nil
            webview.configuration.userContentController.removeScriptMessageHandler(forName: "NativeMethod")
        }else{
            print("no webview")
        }
    }
    
    // 图片单选 - 拍照取消
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        self.imagePicker = nil
        print("bye")
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     
     */
    
    // 当前statusBar使用的样式
    var style: UIStatusBarStyle = .default
    // 重现statusBar相关方法
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
}
