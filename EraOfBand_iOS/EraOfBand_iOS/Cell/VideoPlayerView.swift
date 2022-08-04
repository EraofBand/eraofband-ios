//
//  VideoPlayerView.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/23.
//

import UIKit
import AVKit

class VideoPlayerView: UIView{
    var playerLayer: AVPlayerLayer?
    //var playerLooper: AVPlayerLooper?
    var queuePlayer: AVQueuePlayer?
    var urlStr: String?
    
    init(frame: CGRect, urlStr: String){
        self.urlStr = urlStr
        super.init(frame: frame)
        
        let videoURL = URL(string: urlStr)!
        let playItem = AVPlayerItem(url: videoURL)
        
        self.queuePlayer = AVQueuePlayer(playerItem: playItem)
        playerLayer = AVPlayerLayer()
        
        playerLayer!.player = queuePlayer
        playerLayer!.videoGravity = .resizeAspectFill
        
        self.layer.addSublayer(playerLayer!)
        
        //playerLooper
        
        queuePlayer!.play()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder) has not been implemented")
    }
    
    public func cleanup(){
        queuePlayer?.pause()
        queuePlayer?.removeAllItems()
        queuePlayer = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer!.frame = bounds
    }
}
