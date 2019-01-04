//
//  ScanQRCodeViewController.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/28.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO
import AudioToolbox

typealias QRString = (String) -> Void
class ScanQRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var backClosure: QRString?// 数据回调闭包
    var device: AVCaptureDevice!  //摄像头对象
    var session: AVCaptureSession!  //会话对象
    var previewlayer: AVCaptureVideoPreviewLayer!  //摄像头图层
    var output: AVCaptureMetadataOutput! //输出类
    var scanLine: UIImageView!
    var scanWidth: CGFloat = 0
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavButtonItem()
        configureCameraImage()
        self.view.layer.insertSublayer(previewlayer!, at: 0)
        createScanBackgroundView(scanWidth: 250)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        session.startRunning()
//        startScanLineAnimation()
    }
    
    func createNavButtonItem() -> Void {
        
        let leftItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem.init(title: "相册", style: .plain, target: self, action: #selector(self.imageQRScanAction))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    //MARK: -------相册二维码识别--------
    @objc func imageQRScanAction() -> Void {
        
        //创建相册控制器
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        self.present(imagepicker, animated: true, completion: nil)
    }
    //点击图片时触发该方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获取点击图片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //创建图片扫描仪
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        //获取到二维码数据
        let featureArr = detector?.features(in: CIImage.init(cgImage: image.cgImage!))
        guard let feature = featureArr?.first as? CIQRCodeFeature else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        print(feature.messageString)
        self.backClosure!(feature.messageString!)
        //数据处理
        self.dismiss(animated: true) {
            self.scanSound()
            self.session.stopRunning()
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    //点击取消时调用该方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //返回
    @objc func backAction() -> Void {
        _ = self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //创建扫描UI界面
    func createScanBackgroundView(scanWidth: CGFloat) -> Void {
        
        self.scanWidth = scanWidth
        
        for i in 0...1 {
            
            let Hview = UIView.init()
            Hview.frame = CGRect.init(x: 0, y: CGFloat(i) * (scanWidth + height )/2, width: width, height: (height - scanWidth)/2)
            let Pview = UIView.init()
            Pview.frame = CGRect.init(x: CGFloat(i) * (scanWidth + width )/2, y: Hview.frame.height, width: (width - scanWidth)/2, height: scanWidth)
            
            Hview.alpha = 0.5
            Pview.alpha = 0.5
            
            Hview.backgroundColor = UIColor.black
            Pview.backgroundColor = UIColor.black
            
            self.view.addSubview(Hview)
            self.view.addSubview(Pview)
        }
        
        //设置扫描区域边框图片
        let scanImage = UIImageView(frame: CGRect.init(x: (width - scanWidth)/2, y: (height - scanWidth)/2, width: scanWidth, height: scanWidth))
        let image = UIImage.init(named: "QR.png")
        //拉伸图片处理
        let insetsWidth: CGFloat = 15
        let insets = UIEdgeInsets(top: insetsWidth, left: insetsWidth, bottom: insetsWidth, right: insetsWidth)
        scanImage.image = image?.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        self.view.addSubview(scanImage)
        
        //添加扫描线
//        scanLine = UIImageView.init(frame: CGRect.init(x:(width - scanWidth)/2, y: (height - scanWidth)/2, width: scanWidth, height: 4))
//        scanLine.image = UIImage.init(named: "scanline.png")
//        self.view.addSubview(scanLine)
        
        //设置有效的扫描区域  注意：坐标系原点为右顶点，横为y，竖为x
        output.rectOfInterest = CGRect(x: (height - scanWidth - 64)/2/height, y: (width - scanWidth)/2/width, width: scanWidth, height: scanWidth)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: (height + scanWidth)/2 + 8, width: width, height: 20))
        label.text = "请将二维码/条形码放入框内，即可扫描，点击屏幕控制闪光灯"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        self.view.addSubview(label)
    }
    
    //MARK: ------扫描线动画-------
    func scanLineAnimation(fromValue: Int, toValue: Int) -> CABasicAnimation {
        
        let animate = CABasicAnimation.init(keyPath: "transform.translation.y")
        
        //设置动画的开始和结束的位置
        animate.fromValue = fromValue
        animate.toValue = toValue
        animate.duration = 2
        animate.repeatCount = Float(OPEN_MAX) //无限循环
        //设置动画在非active状态时的行为   让图层动画保持住结束后的状态
        animate.isRemovedOnCompletion = false
        animate.fillMode = CAMediaTimingFillMode.forwards
        //设置动画延时  2s延时在后面+2
        animate.beginTime = CACurrentMediaTime()
        //设置动画渐进渐出效果
        animate.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        return animate
    }
    
//    func startScanLineAnimation() -> Void {
//        let animate = scanLineAnimation(fromValue: 2, toValue: Int(scanWidth)-2)
//        scanLine.layer.add(animate, forKey: "scanLine")
//    }
    
    func stopScanLineAnimation() -> Void {
//        scanLine.layer.removeAnimation(forKey: "scanLine")
    }
    
    //MARK: ------相机扫描二维码--------
    func configureCameraImage() -> Void {
        //获取手机摄像头
        device = AVCaptureDevice.default(for: AVMediaType.video)
        
        //设备输入类
        let input = try! AVCaptureDeviceInput.init(device: device)
        //设备输出类    支持二维码、条形码的扫描识别
        output = AVCaptureMetadataOutput.init()
        //设置
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //创建会话对象  承担实时获取设备数据的责任
        session = AVCaptureSession.init()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        //将输入、输出对象加入到会话中
        session.addInput(input)
        session.addOutput(output)
        
        //只能在执行完上一步之后才能执行设置可识别数据的格式
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.code128]
        
        //创建图层类  可以快速呈现摄像头的原始数据
        previewlayer = AVCaptureVideoPreviewLayer.init(session: session)
        previewlayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewlayer?.frame = self.view.frame
    }
    
    //扫描到二维码时调用
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            
            self.scanSound()
            self.session.stopRunning()
            stopScanLineAnimation()
            
            let metadata: AVMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            print(metadata.stringValue)
            self.backClosure!(metadata.stringValue!)
            //数据处理
            self.dismiss(animated: true) {
                self.scanSound()
                self.session.stopRunning()
            }
            self.navigationController?.dismiss(animated: true, completion: nil)
            //            let messageVC = ZZMessageViewController()
            //            messageVC.data = metadata.stringValue
            //            self.navigationController?.pushViewController(messageVC, animated: true)
        }
    }

    //MARK: -------提示音机震动------
    func scanSound() -> Void {
        
        var soundID: SystemSoundID = 0
        
        let soundFile = Bundle.main.path(forResource: "scanSound", ofType: "wav")
        
        AudioServicesCreateSystemSoundID(NSURL.fileURL(withPath: soundFile!) as  CFURL, &soundID)
        
        //播放提示音 带有震动
        //        AudioServicesPlayAlertSound(soundID)
        //播放系统提示音
        AudioServicesPlaySystemSound(soundID)
    }
    
    //MARK: -----点击屏幕控制闪光灯------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //呼叫控制硬件
        try! device.lockForConfiguration()
        
        //开启、关闭闪光灯
        if device.torchMode == .on {
            device.torchMode = .off
        } else {
            device.torchMode = .on
        }
        //控制完毕需要关闭控制硬件
        device.unlockForConfiguration()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
