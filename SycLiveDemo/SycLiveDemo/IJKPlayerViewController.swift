//
//  IJKPlayerViewController.swift
//  SycDemo
//
//  Created by rigour on 2017/12/19.
//  Copyright © 2017年 syc. All rights reserved.
//

import UIKit

class IJKPlayerViewController: UIViewController {
    
    
    var urlStr: String?
    
    private var moviePlayerController: IJKFFMoviePlayerController!
    private var timer: Timer?
    private var timeLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "ijkplayer"
        
        if urlStr == nil || urlStr?.isEmpty == true{
            urlStr = "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8"
            urlStr = "rtmp://192.168.1.113:1935/rtmplive/test"
        }
        
        let options = IJKFFOptions.byDefault()
        
        IJKFFMoviePlayerController.setLogReport(false)
        IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_ERROR)
        IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
        
        // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
        moviePlayerController = IJKFFMoviePlayerController(contentURLString: urlStr!, with: options)
        moviePlayerController.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, .flexibleHeight]
        moviePlayerController.view.frame = UIScreen.main.bounds
        moviePlayerController.scalingMode = IJKMPMovieScalingMode.aspectFit
        moviePlayerController.shouldAutoplay = true
        self.view.addSubview(moviePlayerController.view)
        self.view.autoresizesSubviews = true
        
        timeLab = UILabel(frame: CGRect(x: 10, y: 100, width: 200, height: 50))
        timeLab.textAlignment = .center
        timeLab.textColor = UIColor.red
        timeLab.isUserInteractionEnabled = true
        timeLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.labTap(sender:))))
        timeLab.layer.borderWidth = 1
        timeLab.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(timeLab)
        self.view.bringSubview(toFront: timeLab)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.ijkLoadStateDidChange(sender:)), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ijkPlaybackDidFinish(sender:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ijkPlaybackPreparedToPlayDidChange(sender:)), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ijkPlaybackDidChange(sender:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: nil)

        // 准备播放
        moviePlayerController.prepareToPlay()
        moviePlayerController.play()
        
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (time: Timer) in
                self.refreshLab(sender: time)
            })
        } else {
            // Fallback on earlier versions
            timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.refreshLab(sender:)), userInfo: nil, repeats: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 停止播放
        moviePlayerController.pause()
        moviePlayerController.stop()
        moviePlayerController.shutdown()
        
        NotificationCenter.default.removeObserver(self)
        
        if timer != nil{
            timer?.invalidate()
        }
    }
    
    // MARK: notification
    
    @objc func ijkLoadStateDidChange(sender: Notification){
        let loadState: IJKMPMovieLoadState = moviePlayerController.loadState
        switch loadState {
        case IJKMPMovieLoadState.playable:
            print("ijkLoadStateDidChange playable")
        case IJKMPMovieLoadState.playthroughOK:
            print("ijkLoadStateDidChange playthroughok")
        case IJKMPMovieLoadState.stalled:
            print("ijkLoadStateDidChange stalled")
        default:
            print("ijkLoadStateDidChange default")
        }
    }
    @objc func ijkPlaybackDidFinish(sender: Notification){
        if let reason = sender.userInfo?[IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as? Int{
            print("ijk playback did finish reason = \(reason)")
        }
    }
    @objc func ijkPlaybackPreparedToPlayDidChange(sender: Notification){
        print("ijk playback prepared to play did change")
    }
    @objc func ijkPlaybackDidChange(sender: Notification){
        
        if timer != nil{
            // 定时器暂停
            timer?.fireDate = Date.distantFuture
        }
        
        switch moviePlayerController.playbackState {
        case IJKMPMoviePlaybackState.stopped:
            print("ijk playback did change stoped")
        case IJKMPMoviePlaybackState.playing:
            print("ijk playback did change playing")
            
            if timer != nil{
                // 定时器继续
                timer?.fireDate = Date.distantPast
            }
            
        case IJKMPMoviePlaybackState.paused:
            print("ijk playback did change paused")
        case IJKMPMoviePlaybackState.interrupted:
            print("ijk playback did change interrupted")
        case IJKMPMoviePlaybackState.seekingForward:
            print("ijk playback did change seekingforward")
        case IJKMPMoviePlaybackState.seekingBackward:
            print("ijk playback did change seekingbackward")
        }
    }
    // MARK: timer
    @objc func refreshLab(sender: Any?){
        // duration
        let duration: TimeInterval = moviePlayerController.duration
        let durationStr = String(format: "%d:%d", Int(duration/60), Int(duration)%60 )
        // position
        let position: TimeInterval = moviePlayerController.currentPlaybackTime
        let positionStr = String(format: "%d:%d", Int(position/60) ,Int(position)%60 )
        
        timeLab.text = durationStr + " / " + positionStr
        
    }
    // MARK: gesture
    @objc func labTap(sender: Any?){
        // position
        let position: TimeInterval = moviePlayerController.currentPlaybackTime
        moviePlayerController.currentPlaybackTime = position + 5.0
    }
}
