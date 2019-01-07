//
//  PlayerViewController.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/7.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit
import Player

class PlayerViewController: UIViewController,PlayerDelegate,PlayerPlaybackDelegate {
    var player = Player()
    var urlpath:String?
    var playfromtime:Double?
    var callbackfun:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        showCloseButton()
        self.title = "视频播放"
        let videoUrl: URL = URL(fileURLWithPath: urlpath!)// file or http url
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = self.view.bounds
        self.player.url = videoUrl
        self.addChild(self.player)
        self.view.addSubview(self.player.view)
        self.player.didMove(toParent: self)
        self.player.fillMode = PlayerFillMode.resizeAspect
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    func showCloseButton(){
        let barButton = UIBarButtonItem.init(title: "返回", style: .done, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
        print(self.player.currentTime)
        APPExecWinJS(mark: "", JSFun: callbackfun! + "(" + "\(self.player.currentTime)" + ")")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.player.playFrom(time:playfromtime!)
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
//        let fraction = Double(player.currentTime) / Double(player.maximumDuration)
//        self.setProgress(progress: CGFloat(fraction), animated: true)
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
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
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
}
