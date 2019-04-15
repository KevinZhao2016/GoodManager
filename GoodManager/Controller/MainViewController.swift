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
import Reachability

class MainViewController: BaseViewController,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate,WeiboSDKDelegate{
   
    var chooseSingleImage = false
    
    // 屏幕宽高
    var SCWIDTH = UIScreen.main.bounds.width
    var SCHEIGHT = UIScreen.main.bounds.height
    
    // 网络状态监听部分
    // Reachability必须一直存在，所以需要设置为全局变量
    let reachability = Reachability()!
    var noteLabel:UILabel = UILabel()
    var newButton:UIButton = UIButton()
    
    var mark:String = "main"
    var url:String = mainUrl
    var webview:DWKWebView!
    
    // 倒计时更改
    var timeCount:Int = 5
    var timer:Timer?
    
    //用于定位
    lazy var locationManager = CLLocationManager()
    lazy var currLocation = CLLocation()
    lazy var locationModel = LocationModel()
    
    // 单选图片是否 选择原图
    var isOriginal:Bool = true
    // 单选图片是否 需要编辑
    var isNeedEdit:Bool = true
    
    // UI
    var imageView:UIImageView = UIImageView()
    let button:UIButton = UIButton(type: .custom);
    var image = FLAnimatedImageView(frame: UIScreen.main.bounds)
    var bottomImage:UIImageView = UIImageView(frame: UIScreen.main.bounds)
    lazy var videocallBackfunName:String = ""
    lazy var imagecallBackfunName:String = ""
    var photoPath:String = ""
    lazy  var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 2))
        // 进度条颜色
        self.progressView.tintColor = UIColor.green
        // 进度条背景色
        self.progressView.trackTintColor = UIColor.white
        return self.progressView
    }()
    
    override func viewDidLoad() {
        print(UIScreen.main.bounds)
        super.viewDidLoad()
        
        // 文件管理
        var fileManager = FileManager.default
        // 文件存放总目录
        let documentsDir = NSHomeDirectory() + "/Documents/localDocuments"
        // 本地文件存放地址
        let fileDir = documentsDir
        do {
            try fileManager.createDirectory(atPath: fileDir, withIntermediateDirectories: true, attributes: nil)
        } catch is Error {
            print("Error")
        }
        
        NetworkStatusListener()
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // 1、设置网络状态消息监听 2、获得网络Reachability对象
    func NetworkStatusListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    // 主动检测网络状态
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        
        if reachability.isReachable { // 判断网络连接状态
            print("网络连接：可用")
            if reachability.isReachableViaWiFi { // 判断网络连接类型
                print("连接类型：WiFi")
                // strServerInternetAddrss = getHostAddress_WLAN() // 获取主机IP地址 192.168.31.2 小米路由器
                // processClientSocket(strServerInternetAddrss)    // 初始化Socket并连接，还得恢复按钮可用
            } else {
                print("连接类型：移动网络")
                // getHostAddrss_GPRS()  // 通过外网获取主机IP地址，并且初始化Socket并建立连接
            }
        } else {
            print("网络连接：不可用")
            DispatchQueue.main.async { // 不加这句导致界面还没初始化完成就打开警告框，这样不行
                
                self.webview.removeFromSuperview()
                
                self.view.backgroundColor = .white
                
                let image = UIImage(named: "pic_refresh_1")
                self.imageView.image = image
                self.imageView.frame = CGRect(x:UIScreen.main.bounds.width/2-60,y:150,width:120,height:120)
                self.view.addSubview(self.imageView)
                
                self.noteLabel = UILabel(frame: CGRect(x: self.SCWIDTH/2-100, y: 270, width: 200, height: 90))
                self.noteLabel.textColor = .darkGray
                self.noteLabel.text = "暂无网络，点击重试"
                self.noteLabel.textAlignment = .center
                self.view.addSubview(self.noteLabel)
                
                self.newButton = UIButton(frame: CGRect(x: self.SCWIDTH/2-50, y: 350, width: 100, height: 40))
                //开启遮罩（不开启遮罩设置圆角无效）
                self.newButton.layer.masksToBounds = true
                //设置圆角半径
                self.newButton.layer.cornerRadius = 5
                //设置按钮边框宽度
                self.newButton.layer.borderWidth = 3
                //设置按钮边框颜色
                self.newButton.layer.borderColor = UIColor.init(red: 77/255, green: 191/255, blue: 255/255, alpha: 1).cgColor
                self.newButton.backgroundColor = .white
                self.newButton.setTitle("点击重试", for: .normal)
                self.newButton.tintColor = .init(red: 77, green: 191, blue: 255, alpha: 1)
                self.newButton.setTitleColor(UIColor.init(red: 77/255, green: 191/255, blue: 255/255, alpha: 1), for: .normal)
                self.newButton.setTitleColor(UIColor.darkGray, for: .highlighted)
                self.newButton.addTarget(self, action: #selector(self.newButtonAction), for: .touchUpInside)
                self.view.addSubview(self.newButton)
                
                self.alert_noNetwrok() // 警告框，提示没有网络
            }
        }
    }
    deinit {// 移除消息通知
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
    // 警告框，提示没有连接网络
    func alert_noNetwrok() -> Void {
        let alert = UIAlertController(title: "系统提示", message: "请打开网络连接", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func newButtonAction() {
        print("检查网络！")
        var netSituation = APPGetNetWork()
        let jsonString = JSON(parseJSON: netSituation)
        netSituation = jsonString["mode"].stringValue
        if netSituation != "0" {
            print("网络可用！")
            self.newButton.removeFromSuperview()
            self.noteLabel.removeFromSuperview()
            setupWebview()
        }else{
            print("网络不可用！")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true;
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true);
    self.navigationController?.isNavigationBarHidden = false;
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
//        var iPhoneX:Bool = false
//        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone{
//            return iPhoneX
//        }
//        if #available(iOS 11.0, *) {
//            if Double((UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)!) > 0.0 {
//                iPhoneX = true
//            }
//        }
        return false;
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
    
    @objc func pushPreviewController(){
        print("pushPreviewController")
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
        
        chooseSingleImage = false
    }
    
    private func VideoCallBack(path:String, callBackfunName:String){
        ExecWinJS(JSFun: callBackfunName + "(\"" + path + "\")")
    }
    
    private func ImageCallBack(path:String, callBackfunName:String){
        ExecWinJS(JSFun: callBackfunName + "(\"" + path + "\")")
    }
    
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        print("imagePickerController")
        
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
    
    // 单选图片 - 拍照获得图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获得照片
        let image:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // 拍照
        if picker.sourceType == .camera {
            //保存相册
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    // 单选图片 - 拍照后存储
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject){
        if error != nil {
            print("保存失败")
            let alert = UIAlertController(title: "保存图片失败！",message: nil,preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "确定",style: UIAlertAction.Style.default,handler: nil))
        } else {
            print("保存成功")
            let alert = UIAlertController(title: "保存图片成功！",message: nil,preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "确定",style: UIAlertAction.Style.default,handler: {(alert:UIAlertAction) in
                if self.isNeedEdit{
                    // 需要编辑
                    let imageManagerVC = IJSImageManagerController(edit:image)
                    imageManagerVC?.loadImage{(image_:UIImage?,outputPath:URL?,error:Error?) in
                        print(outputPath)
                        
                        if self.isOriginal{
                            // 需要原图
                            let alert = UIAlertController(title: "是否需要原图？",message: nil,preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "是",style: UIAlertAction.Style.default,handler:{(alert:UIAlertAction) in
                                let result = outputPath?.absoluteString.replacingOccurrences(of: "file://", with: "")
                                ExecWinJS(JSFun: "appChooseSingleImageCallBack" + "(\"" + result! + "\")")
                            }))
                            alert.addAction(UIAlertAction(title: "否",style: UIAlertAction.Style.default,handler:{(alert:UIAlertAction) in
                                print(outputPath)
                                var data = image.jpegData(compressionQuality: 1);
                                if data!.count/1024 > 200{
                                    data = image.jpegData(compressionQuality: 0.01);//压缩比例在0~1之间
                                }
                                let rootPath = NSHomeDirectory()
                                let name = Int(arc4random() % 10000) + 1
                                let fileMG = FileManager.default
                                let finalPath = rootPath+"/Documents/\(name).jpg"
                                fileMG.createFile(atPath: finalPath, contents: data, attributes: nil)
                                ExecWinJS(JSFun: "appChooseSingleImageCallBack" + "(\"" + finalPath + "\")")
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            // 不需要原图
                            var data = image.jpegData(compressionQuality: 1);
                            if data!.count/1024 > 200{
                                data = image.jpegData(compressionQuality: 0.01);//压缩比例在0~1之间
                            }
                            let rootPath = NSHomeDirectory()
                            let name = Int(arc4random() % 10000) + 1
                            let fileMG = FileManager.default
                            let finalPath = rootPath+"/Documents/\(name).jpg"
                            fileMG.createFile(atPath: finalPath, contents: data, attributes: nil)
                            ExecWinJS(JSFun: "appChooseSingleImageCallBack" + "(\"" + finalPath + "\")")
                        }
                    }
                    self.present(imageManagerVC!,animated:true,completion:nil)
                }else{
                    // 不需要编辑
                    print("\(image.accessibilityPath)")
                    if self.isOriginal{
                        // 需要原图
                        let alert = UIAlertController(title: "是否需要原图？",message: nil,preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "是",style: UIAlertAction.Style.default,handler:{(alert:UIAlertAction) in
                            var data = image.jpegData(compressionQuality: 1);
                            let rootPath = NSHomeDirectory()
                            let name = Int(arc4random() % 10000) + 1
                            let fileMG = FileManager.default
                            let finalPath = rootPath+"/Documents/\(name).jpg"
                            fileMG.createFile(atPath: finalPath, contents: data, attributes: nil)
                            ExecWinJS(JSFun: "appChooseSingleImageCallBack" + "(\"" + finalPath + "\")")
                        }))
                        alert.addAction(UIAlertAction(title: "否",style: UIAlertAction.Style.default,handler:{(alert:UIAlertAction) in
                            // 不需要原图
                            var data = image.jpegData(compressionQuality: 1);
                            if data!.count/1024 > 200{
                                data = image.jpegData(compressionQuality: 0.01);//压缩比例在0~1之间
                            }
                            let rootPath = NSHomeDirectory()
                            let name = Int(arc4random() % 10000) + 1
                            let fileMG = FileManager.default
                            let finalPath = rootPath+"/Documents/\(name).jpg"
                            fileMG.createFile(atPath: finalPath, contents: data, attributes: nil)
                            ExecWinJS(JSFun: "appChooseSingleImageCallBack" + "(\"" + finalPath + "\")")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        // 不需要原图
                        var data = image.jpegData(compressionQuality: 1);
                        if data!.count/1024 > 200{
                            data = image.jpegData(compressionQuality: 0.01);//压缩比例在0~1之间
                        }
                        let rootPath = NSHomeDirectory()
                        let name = Int(arc4random() % 10000) + 1
                        let fileMG = FileManager.default
                        let finalPath = rootPath+"/Documents/\(name).jpg"
                        fileMG.createFile(atPath: finalPath, contents: data, attributes: nil)
                        ExecWinJS(JSFun: "appChooseSingleImageCallBack" + "(\"" + finalPath + "\")")
                    }
                }
            }))
            self.present(alert,animated:true,completion:nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        if response is WBSendMessageToWeiboResponse {
            let rm = response as! WBSendMessageToWeiboResponse
            
            if rm.statusCode == WeiboSDKResponseStatusCode.success {
                // 成功
                print("分享成功")
                // 如果在创建WBSendMessageToWeiboRequest 实例对象时, accessToken传nil, 这里是获取不到授权信息的
                //                let accessToken = rm.authResponse.accessToken
                //                let uid = rm.authResponse.userID
                let userInfo = rm.requestUserInfo // request 中设置的自定义信息
                
                print("分享成功\n\(userInfo ?? ["假的": ""])")
            } else {
                // 失败
                print("分享失败")
            }
        }
    }
    
    
}
