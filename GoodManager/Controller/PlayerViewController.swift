//
//  PlayerViewController.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/7.
//  Copyright © 2019 GoodManager. All rights reserved.
//



import UIKit
import Player
import CoreMedia

class PlayerViewController: UIViewController,PlayerDelegate,PlayerPlaybackDelegate {
    var player = Player()
    //let myProgressView = UIProgressView(frame: CGRectMake(0, UIScreen.main.bounds.height, UIScreen.main.bounds.width, 5))
    
    // 进度条
//    var slider = UISlider()
    
    var progressView = UIProgressView(progressViewStyle:UIProgressView.Style.default)
    
    var beginTouchX:CGFloat = 0.0
    var endTouchX:CGFloat = 0.0
    
    var urlpath:String?
    var playfromtime:Double?
    var callbackfun:String?
    
    
    let noti = NotificationCenter.default.addObserver(self, selector: Selector("receiverNotification"), name:UIDevice.orientationDidChangeNotification, object: nil)

    func receiverNotification(){
        print("旋转！")
        let orient = UIDevice.current.orientation
        switch orient {
        case .portrait:
            print("屏幕正常竖向")
            break
        case .portraitUpsideDown:
            print("屏幕倒立")
//            self.player.view.frame = self.view.bounds
            break
        case .landscapeLeft:
            print("屏幕左旋转")
            self.player.view.frame = self.view.bounds
            break
        case .landscapeRight:
            print("屏幕右旋转")
            self.player.view.frame = self.view.bounds
            break
        default:
            break
        }
    }
    
    
    // 横屏
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // viewWillAppear 设置页面横屏
    override func viewWillAppear(_ animated: Bool) {
        //let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //UIDevice.current.setValue(value, forKey: "orientation")
        super.viewWillAppear(animated)
        if !UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOrientationChange(notification:)),
                                            name: UIApplication.didChangeStatusBarOrientationNotification,
                                               object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 横屏
        appDelegate.blockRotation = true
        
        showCloseButton()
        
        self.title = "视频播放"
        self.navigationController?.navigationBar.titleTextAttributes = {[NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont(name: "Heiti SC", size: 18.0)!
            ]}()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.view.backgroundColor = .black
        self.player.view.backgroundColor = .black
        
        let videoUrl: URL = URL(fileURLWithPath: urlpath!)// file or http url
        
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = self.view.bounds
        self.player.view.center = self.view.center
        self.player.url = videoUrl
        self.addChild(self.player)
        self.view.addSubview(self.player.view)
        self.player.didMove(toParent: self)
        self.player.fillMode = PlayerFillMode.resizeAspect
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        self.progressView.center = CGPoint(x: self.view.center.x, y: UIScreen.main.bounds.height - 30)
        //self.progressView.frame(forAlignmentRect: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 5))
        progressView.progress = 0 //默认进度 0%
        self.view.addSubview(progressView)
    }
    
    // viewWillDisappear设置页面转回竖屏
    override func viewWillDisappear(_ animated: Bool) {
        

        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    
    
    // 横屏页面是否支持旋转
    // 默认为true
    override var shouldAutorotate: Bool {
        return true
    }
    
    // 监听屏幕旋转
    @objc private func handleOrientationChange(notification: Notification) {
        // 获取设备方向
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation.isPortrait {
            print("竖屏了")
            self.view.frame = CGRect(x: 0,y: 0,width: min(UIScreen.main.bounds.width,UIScreen.main.bounds.height),height: max(UIScreen.main.bounds.width,UIScreen.main.bounds.height))
            self.player.view.frame = self.view.bounds
            self.player.fillMode = PlayerFillMode.resizeAspect
        } else if statusBarOrientation.isLandscape {
            print("横屏了")
            self.view.frame = CGRect(x: 0,y: 0,width: max(UIScreen.main.bounds.width,UIScreen.main.bounds.height),height: min(UIScreen.main.bounds.width,UIScreen.main.bounds.height))
            self.player.view.frame = self.view.bounds
            self.player.fillMode = PlayerFillMode.resizeAspect
        }
    }
    
    func showCloseButton(){
        let barButton = UIBarButtonItem.init(title: "返回", style: .done, target: self, action: #selector(self.back))
        barButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func back(){
        print(self.player.currentTime)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        appDelegate.blockRotation = false
        
        if UIApplication.shared.statusBarOrientation.isLandscape{
            print("landscape")
            UIApplication.shared.statusBarOrientation = .portrait
            print("!!!!!!!!!!!!!!!!")
        }else{
            print("p")
        }
        if UIApplication.shared.statusBarOrientation.isLandscape{
            print("landscape")
            UIApplication.shared.statusBarOrientation = .portrait
            print("!!!!!!!!!!!!!!!!")
        }else{
            print("p")
        }
        self.dismiss(animated: true, completion: {() in
//            if UIApplication.shared.statusBarOrientation.isLandscape{
//                print("landscape")
//            }else{
//                print("p")
//            }
        })
        ExecWinJS(JSFun: callbackfun! + "(\"" + "\(self.player.currentTime)" + "\")")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.player.seek(to: CMTime(seconds: self.playfromtime!, preferredTimescale: 1), completionHandler: nil)
        self.player.autoplay = true
        self.player.playFromCurrentTime()
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
//        let fraction = Double(player.currentTime) / Double(player.maximumDuration)
//        self.setProgress(progress: CGFloat(fraction), animated: true)
        self.progressView.progress = Float(self.player.currentTime/self.player.maximumDuration)
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    // 缓存的视频长度
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        print(bufferTime)
        print(self.player.maximumDuration)
        print(Float(bufferTime/self.player.maximumDuration))
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        print(error as Any)
    }

}
extension PlayerViewController {
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        switch (self.player.playbackState.rawValue) {
        case PlaybackState.stopped.rawValue:
            self.player.playFromBeginning()
            break
        case PlaybackState.paused.rawValue:
            self.player.playFromCurrentTime()
            break
        case PlaybackState.playing.rawValue:
            self.player.pause()
            break
        case PlaybackState.failed.rawValue:
            self.player.pause()
            break
        default:
            self.player.pause()
            break
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.beginTouchX = (touches.first?.location(in: self.view).x)!
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //    获得到当前播放的时间(秒)
        //Float64 cur = CMTimeGetSeconds(player.currentTime);
        //var cur = CMTimeGetSeconds(player.currentTime)
        
        super.touchesMoved(touches, with: event)
        
//        self.endTouchX = (touches.last?.location(in: self.view).x)!
        
//        var endX:CGFloat
//        var changedX:CGFloat
//        //获取点击的坐标位置
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            print("startx:  \(beginTouchX)  movingx:  \(t.location(in: self.view).x)")

            //var changeX = t.location(in: self.view).x - _startPoin
            self.endTouchX = t.location(in: self.view).x
//
//            changedX = endX - beginTouchX
//
//            if changedX > 10 {
//                var cur = player.currentTime
//                cur += 2;
//                self.player.seek(to: CMTime(seconds: cur, preferredTimescale: 1), completionHandler: nil)
//            }else if changedX < -10{
//                var cur = player.currentTime
//                cur -= 1;
//                self.player.seek(to: CMTime(seconds: cur, preferredTimescale: 1), completionHandler: nil)
//            }
        }
        
        
        
        
        
        //[player seekToTime:CMTimeMake(cur, 1)];
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var changedX = 0.0

        changedX = Double(self.endTouchX - self.beginTouchX)
        
        print("changedX:  \(changedX)")
        
        if changedX > 5 {
            var cur = player.currentTime
            cur += 2*(changedX/30);
            self.player.seek(to: CMTime(seconds: cur, preferredTimescale: 500), completionHandler: nil)
        }else if changedX < -5{
            var cur = player.currentTime
            cur += 2*(changedX/40);
            self.player.seek(to: CMTime(seconds: cur, preferredTimescale: 500), completionHandler: nil)
        }
        self.beginTouchX = 0
        self.endTouchX = 0
    }

}
