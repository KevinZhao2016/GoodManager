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

class MainViewController: BaseViewController,TZImagePickerControllerDelegate {
    var mark:String = ""
    var url:String = "http://api.yiganzi.cn/StartupPage.ashx?action=getStartupData"
    var webview:WKWebView!
    var image = FLAnimatedImageView(frame: UIScreen.main.bounds)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        APPChooseSingleVideo(source:1, maxVideoLength:10, callBackfunName:"String")
//       APPPlayVideo(path:"https://media.w3.org/2010/05/sintel/trailer.mp4", startPosition:10, callBackfunName:"String")
    }
    
    func setupLaunchView(){
             //启动图片
        image.sd_setImage(with: URL(string: picUrl ?? ""), placeholderImage: UIImage(named: "launch"))
        //http://img.zcool.cn/community/01d7e15a0f0f2ca801204a0e8190bc.gif
        self.view.addSubview(image)
        //添加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        image.addGestureRecognizer(singleTapGesture)
        image.isUserInteractionEnabled = true
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (Timer) in
            self.removeImageWithDelay()
        })
        LaunchFlag = true
    }
    
    func setupWebview(){
        // 创建配置
        let config = WKWebViewConfiguration()
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        let userContent = WKUserContentController()
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        userContent.add(self, name: "NativeMethod")
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent
        webview = WKWebView(frame: CGRect(x: 0, y: STATUS_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), configuration: config)
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
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        var path:String = " "
        var targetSize = PHImageManagerMaximumSize
        if isSelectOriginalPhoto == true {
            targetSize = PHImageManagerMaximumSize
        }else{
            targetSize = CGSize(width: 200, height: 200)
        }
     
            PHImageManager.default().requestImage(for: assets.first as! PHAsset,
                                                  targetSize: targetSize, contentMode: .aspectFit,
                                                  options: nil, resultHandler: { (image, info:[AnyHashable : Any]?) in
//                                                    print (info?.keys)
                                                    if(isSelectOriginalPhoto == true){
                                                        let imageURL = info!["PHImageFileURLKey"] as! URL
                                                        print("路径：",imageURL)
                                                    }else{
                                                        let fileManager = FileManager.default
                                                        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                                                           .userDomainMask, true)[0] as String
                                                        let name = info!["PHImageResultDeliveredImageFormatKey"] as! Int
                                                        let filePath = rootPath + "/" + "\(name)" + ".jpg"
                                                        let imageData = image?.jpegData(compressionQuality: 1)
                                                        print ("name:"+"\(name)")
                                                        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
                                                        print(filePath)
                                                    }
            })
            
        
        
    }
    
    func APPSetProgressBarColor(color:String){
        self.progressView.tintColor = UIColor(named: color)
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
