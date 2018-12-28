//
//  BMPlayerViewController.swift
//  GoodManager
//
//  Created by KevinZhao on 2018/12/28.
//  Copyright © 2018 GoodManager. All rights reserved.
//

import UIKit
import SnapKit
import BMPlayer

class BMPlayerViewController: BaseViewController {
    let player = BMPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(player)
        
        player.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.left.right.equalTo(self.view)
            // 注意此处，宽高比 16:9 优先级比 1000 低就行，在因为 iPhone 4S 宽高比不是 16：9
            make.height.equalTo(self.view.snp.height).offset(-30)
        }
        player.backBlock = { [unowned self] (isFullScreen) in
            let _ = self.navigationController?.popViewController(animated: true)
        }
        let asset = BMPlayerResource(url: URL(string: "http://vjs.zencdn.net/v/oceans.mp4")!,
                                     name: "风格互换：原来你我相爱")
        player.setVideo(resource: asset)
        player.autoPlay()
        
        //Listen to when the player is playing or stopped
        player.playStateDidChange = { (isPlaying: Bool) in
            print("playStateDidChange \(isPlaying)")
        }
        
        //Listen to when the play time changes
        player.playTimeDidChange = { (currentTime: TimeInterval, totalTime: TimeInterval) in
            print("playTimeDidChange currentTime: \(currentTime) totalTime: \(totalTime)")
        }
    }

}
//
//extension BMPlayerViewController:BMPlayerDelegate{
//    
//}
