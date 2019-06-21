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

class MainViewController: BaseViewController,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate,WeiboSDKDelegate,UIDocumentInteractionControllerDelegate,QQApiInterfaceDelegate{
    
    
    
    var chooseSingleImage = false
    
    // 屏幕宽高
    var SCWIDTH = UIScreen.main.bounds.width
    var SCHEIGHT = UIScreen.main.bounds.height
    
    // 网络状态监听部分
    // Reachability必须一直存在，所以需要设置为全局变量
    let reachability = Reachability()!
    var noteLabel:UILabel = UILabel()
    var newButton:UIButton = UIButton()
    
    // 提醒方式 0：无声无震动  1：有声无震动（未实现） 2：无声有震动  3：有声有震动
    var remaindWay = 0
    
    var mark:String = "max_home_"
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
    
    // 文件分享
    var documentInteractionController = UIDocumentInteractionController()
    
    // 启动页接口地址
    var domainName = "http://hangzhou.api.yiganzi.cn"
    
    // UI
    var imageView:UIImageView = UIImageView()
    let button:UIButton = UIButton(type: .custom);
    var image = FLAnimatedImageView(frame: UIScreen.main.bounds)
    var bottomImage:UIImageView = UIImageView()
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
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if self.children.count == 1{
//            return false
//        }
//        return true
//    }
    
    
    
    //-------------------------生命周期--------------------------
    override func viewDidLoad() {
        print(UIScreen.main.bounds)
        super.viewDidLoad()
        
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        print(self.navigationController?.interactivePopGestureRecognizer?.isEnabled)

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOrientationChange(notification:)),
                                               name: UIApplication.didChangeStatusBarOrientationNotification,
                                               object: nil)
        
        let fileManager = FileManager.default
        let documentsDir = NSHomeDirectory() + "/Documents/localDocuments"
        let fileDir = documentsDir
        do {
            try fileManager.createDirectory(atPath: fileDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error")
        }
        
        // 存储一个普通的文本文件
        let info = "欢迎使用好监理！"
        try! info.write(toFile: fileDir+"/welcom.txt", atomically: true, encoding: String.Encoding.utf8)
        
        NetworkStatusListener()
        
        if reachability.isReachable {
            setupWebview()
        }
        
        
        
        
        if(LaunchFlag == false){
            // 若在启动时
            var netSituation = APPGetNetWork()
            let jsonString = JSON(parseJSON: netSituation)
            netSituation = jsonString["mode"].stringValue
            if netSituation == "0" {
                // 网络不可用
                
                nonetLoad()
            } else {
                // 网络可用
            }
            setupLaunchView() //启动页
        }
        
        locationManager.delegate = self //定位代理方法
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("mainViewController 出现")
        
        
        
        
        
        //        UIApplication.shared.statusBarOrientation = .landscapeLeft
//        if UIApplication.shared.statusBarOrientation.isLandscape {
//            UIView.animate(withDuration: 0.5) {
//                
//                
//                self.view.transform = CGAffineTransform(rotationAngle: 90);
//                print("hhhhhh")
//                
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true;
        
        // 为当前控制器禁用👉右滑返回手势
        if (navigationController?.responds(to: NSSelectorFromString("interactivePopGestureRecognizer")))! {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        
//        self.view.frame = CGRect(x: 0,y: 0,width: min(UIScreen.main.bounds.width,UIScreen.main.bounds.height),height: max(UIScreen.main.bounds.width,UIScreen.main.bounds.height))
//        self.webview.frame = self.view.frame
        
        
//        self.player.fillMode = PlayerFillMode.resizeAspect
//        self.webview.

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true);
        self.navigationController?.isNavigationBarHidden = false;
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        // 为其他控制器开启👉右滑返回手势
        if (navigationController?.responds(to: NSSelectorFromString("interactivePopGestureRecognizer")))! {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    
    
    
    //-----------------------------网络监听-----------------------------------
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
                //self.nonetLoad()
            }
        }
    }
    deinit {// 移除消息通知
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
    
    //-----------------------------工具方法-----------------------------------
    //加载起始页面
    func setupLaunchView(){
        //启动图片 异步获取
        let isIPhoneX:Bool = self.isIPhoneX()
        if isIPhoneX {
            image.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.8)
            image.backgroundColor = UIColor.white;
            bottomImage.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT * 0.8, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.2)
            bottomImage.backgroundColor = UIColor.white;
            bottomImage.image = UIImage(named: "好监理_启动页")
            bottomImage.contentMode = .scaleAspectFit
            self.view.addSubview(bottomImage)
        }
        image.image = UIImage(named: "好监理_启动页")
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .white
        
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
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(image)
        
       
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
        return iPhoneX;
    }
    
//    @objc func btnClick(){
//        self.removeImageWithDelay()
//    }
    

    // 加载webview

    func setupWebview(){
        print("set up webview")
        
        UIApplication.shared.statusBarOrientation = .portrait

        webview = DWKWebView(frame: CGRect(x: 0, y: STATUS_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - STATUS_HEIGHT))
        //bridge
        webview.addJavascriptObject(JsApiSwift(), namespace: nil)
        webview.load(URLRequest(url: URL(string: url)!))
        webview.navigationDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        
        //进度条监听
        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webview.addSubview(self.progressView)
        //适配全面屏,隐藏安全区域
        if #available(iOS 11.0, *) {
            webview.scrollView.contentInsetAdjustmentBehavior = .never;
        }
        self.view.addSubview(webview)
    }
    
    // 提示无网络
    func nonetLoad(){
        self.style = .default
        self.setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = .white

        if self.webview != nil {
            // 去除webview
            self.webview.removeFromSuperview()
        }
        
        let image = UIImage(named: "pic_refresh_1")
        self.imageView.image = image
        self.imageView.frame = CGRect(x:UIScreen.main.bounds.width/2-90,y:150,width:180,height:180)
        
        self.noteLabel = UILabel(frame: CGRect(x: self.SCWIDTH/2-100, y: 310, width: 200, height: 90))
        self.noteLabel.textColor = .lightGray
        self.noteLabel.text = "暂无网络，点击重试"
        self.noteLabel.textAlignment = .center
        
        self.newButton = UIButton(frame: CGRect(x: self.SCWIDTH/2-50, y: 400, width: 100, height: 40))
        //开启遮罩（不开启遮罩设置圆角无效）
        self.newButton.layer.masksToBounds = true
        self.newButton.layer.cornerRadius = 5
        self.newButton.layer.borderWidth = 1
        self.newButton.layer.borderColor = UIColor.init(red: 77/255, green: 191/255, blue: 255/255, alpha: 1).cgColor
        self.newButton.backgroundColor = .white
        self.newButton.setTitle("点击重试", for: .normal)
//        self.newButton.tintColor = .init(red: 77, green: 191, blue: 255, alpha: 1)
        self.newButton.setTitleColor(UIColor.init(red: 77/255, green: 191/255, blue: 255/255, alpha: 1), for: .normal)
        self.newButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        self.newButton.addTarget(self, action: #selector(self.newButtonAction), for: .touchUpInside)
        
        self.view.addSubview(self.noteLabel)
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.newButton)
    }
    
    // 无网络页面刷新
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
    
    // 警告框，提示没有连接网络
    func alert_noNetwrok() -> Void {
        let alert = UIAlertController(title: "系统提示", message: "请打开网络连接", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
//    func isIPhoneX() -> Bool {
////        var iPhoneX:Bool = false
////        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone{
////            return iPhoneX
////        }
////        if #available(iOS 11.0, *) {
////            if Double((UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)!) > 0.0 {
////                iPhoneX = true
////            }
////        }
//        return false;
//    }
    
    // 刷新页面按钮
    @objc func btnClick(){
        self.removeImageWithDelay()
    }
    
    // 跳过起始页面广告
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
    
    // 点击广告图片
    @objc func imageViewClick(){
        if (linkUrl != "" && picUrl != ""){
            APPOutBrowserOpenURL(url: linkUrl)
        }
    }
    
    @objc func pushPreviewController(){
        print("pushPreviewController")
    }
    
    // 监听屏幕旋转
    @objc private func handleOrientationChange(notification: Notification) {
        // 获取设备方向
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        
        if statusBarOrientation.isPortrait {
            print("竖屏了")
            
            //self.player.fillMode = PlayerFillMode.resizeAspect
        } else if statusBarOrientation.isLandscape {
            print("横屏了")
//            self.view.frame = CGRect(x: 0,y: 0,width: max(UIScreen.main.bounds.width,UIScreen.main.bounds.height),height: min(UIScreen.main.bounds.width,UIScreen.main.bounds.height))
//            self.webview.frame = self.view.bounds
            //self.player.fillMode = PlayerFillMode.resizeAspect
        }
    }
    
    
    //--------------------------------代理方法--------------------------------------
    
    // qq回调
    func onReq(_ req: QQBaseReq!) {
        
    }
    
    func onResp(_ resp: QQBaseResp!) {
        var massage = ""
        print(resp)
    }
    
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
        let option = PHVideoRequestOptions.init()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = PHVideoRequestOptionsDeliveryMode.automatic
        PHImageManager.default().requestAVAsset(forVideo: asset, options: option) { (Asset:AVAsset?, AudioMix:AVAudioMix?, info:[AnyHashable : Any]?) in
            let  avAsset = Asset as? AVURLAsset
            let path = avAsset?.url.path
            //print(path)
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
                
                //byte
                var imageData = _image.jpegData(compressionQuality: 1.0)
                //KB
                imageData = self.resetImgSize(sourceImage: _image, maxImageLenght: -1, maxSizeKB: 200)
                
                let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
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
        //print("assets:  \(assets)")
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
            if self.isNeedEdit{
                // 需要编辑
                let imageManagerVC = IJSImageManagerController(edit:image)
                imageManagerVC?.loadImage{(image_:UIImage?,outputPath:URL?,error:Error?) in
                    //print(outputPath)
                    
                    if self.isOriginal{
                        // 需要原图
                        let alert = UIAlertController(title: "是否需要原图？",message: nil,preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "是",style: UIAlertAction.Style.default,handler:{(alert:UIAlertAction) in
                            let result = outputPath?.absoluteString.replacingOccurrences(of: "file://", with: "")
                            ExecWinJS(JSFun: "appChooseSingleImageCallBack" + "(\"" + result! + "\")")
                        }))
                        alert.addAction(UIAlertAction(title: "否",style: UIAlertAction.Style.default,handler:{(alert:UIAlertAction) in
                            //print(outputPath)
                            
                            //byte
                            let imageC = image
                            var data = imageC.jpegData(compressionQuality: 1.0)
                            //KB
                            data = self.resetImgSize(sourceImage: imageC, maxImageLenght: -1, maxSizeKB: 200)
                            
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
                        //byte
                        let imageC = image
                        var data = imageC.jpegData(compressionQuality: 1.0)
                        //KB
                        data = self.resetImgSize(sourceImage: imageC, maxImageLenght: -1, maxSizeKB: 200)
                        
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
                //print("\(image.accessibilityPath)")
                if self.isOriginal{
                    // 需要原图
                    let alert = UIAlertController(title: "是否需要原图？",message: nil,preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "是",style: UIAlertAction.Style.default,handler:{(alert:UIAlertAction) in
                        let data = image.jpegData(compressionQuality: 1);
                        let rootPath = NSHomeDirectory()
                        let name = Int(arc4random() % 10000) + 1
                        let fileMG = FileManager.default
                        let finalPath = rootPath+"/Documents/\(name).jpg"
                        fileMG.createFile(atPath: finalPath, contents: data, attributes: nil)
                        ExecWinJS(JSFun: "appChooseSingleImageCallBack" + "(\"" + finalPath + "\")")
                    }))
                    alert.addAction(UIAlertAction(title: "否",style: UIAlertAction.Style.default,handler:{(alert:UIAlertAction) in
                        // 不需要原图
                        //byte
                        let imageC = image
                        var data = imageC.jpegData(compressionQuality: 1.0)
                        //KB
                        data = self.resetImgSize(sourceImage: imageC, maxImageLenght: -1, maxSizeKB: 200)
                        
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
                    //byte
                    let imageC = image
                    var data = imageC.jpegData(compressionQuality: 1.0)
                    //KB
                    data = self.resetImgSize(sourceImage: imageC, maxImageLenght: -1, maxSizeKB: 200)
                    
                    let rootPath = NSHomeDirectory()
                    let name = Int(arc4random() % 10000) + 1
                    let fileMG = FileManager.default
                    let finalPath = rootPath+"/Documents/\(name).jpg"
                    fileMG.createFile(atPath: finalPath, contents: data, attributes: nil)
                    ExecWinJS(JSFun: "appChooseSingleImageCallBack" + "(\"" + finalPath + "\")")
                }
            }
        }
    }
    
    // 单选图片压缩
    func resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
        var maxSize = maxSizeKB
        var maxImageSize = maxImageLenght
        if (maxSize <= 0.0) {
            maxSize = 1024.0;
        }
        if (maxImageSize <= 0.0)  {
            maxImageSize = 1024.0;
        }
        
        //先调整分辨率
        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
        let tempHeight = newSize.height / maxImageSize;
        let tempWidth = newSize.width / maxImageSize;
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
        }
            
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var imageData = newImage!.jpegData(compressionQuality:1.0)
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        
        //调整大小
        var resizeRate = 0.9;
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            imageData = newImage!.jpegData(compressionQuality:CGFloat(resizeRate))
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            resizeRate -= 0.1;
        }
        return imageData!
    }
    
    // 图片单选 - 拍照取消
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //        self.imagePicker = nil
        print("bye")
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    // 文件分享代理
    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        
    }
    func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
        
    }
    func documentInteractionController(_ controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        
    }
    
    
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        print("willMove")
        print(parent)
        print(mainViewControllers.count)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        print("didMove")
        let mark_ = self.mark
        if parent == nil{
            print("返回")
            var i:Int = 0
            for VC_ in mainViewControllers {
                if(VC_.mark == mark_){
                    print("i: \(i)")
                    let vc = mainViewControllers.remove(at: i)
                    // test
                    for test_ in mainViewControllers {
                        print(test_.mark)
                    }
                    return
                }else{
                    i = i + 1
                }
            }
            print("没有找到： "+mark)
        }
        print(mainViewControllers.count)
    }
}
