//
//  LFLiveKitDemoViewController.swift
//  SycLiveDemo
//
//  Created by 623971951 on 2017/12/22.
//  Copyright © 2017年 syc. All rights reserved.
//

import UIKit


class LFLiveKitDemoViewController: UIViewController {

    private let streamUrl = "rtmp://192.168.1.113:1935/rtmplive/test"
    
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3, outputImageOrientation: UIInterfaceOrientation.portrait)
        
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        
        session?.delegate = self
        session?.preView = self.view
        session?.running = true
        return session!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "LFLiveKitDemo"
        self.view.backgroundColor = UIColor.white
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startLive()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopLive()
    }
    
    func startLive() -> Void {
        let stream = LFLiveStreamInfo()
        stream.url = streamUrl
        session.startLive(stream)
    }
    func stopLive() -> Void {
        session.stopLive()
    }
}

extension LFLiveKitDemoViewController: LFLiveSessionDelegate{
    // MARK: LFLiveSession delegate
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("liveSession debugInfo \(debugInfo!.streamId) \(debugInfo!.uploadUrl)")
    }
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        /*
         typedef NS_ENUM (NSUInteger, LFLiveSocketErrorCode) {
         LFLiveSocketError_PreView = 201,              ///< 预览失败
         LFLiveSocketError_GetStreamInfo = 202,        ///< 获取流媒体信息失败
         LFLiveSocketError_ConnectSocket = 203,        ///< 连接socket失败
         LFLiveSocketError_Verification = 204,         ///< 验证服务器失败
         LFLiveSocketError_ReConnectTimeOut = 205      ///< 重新连接服务器超时
         };*/
        switch errorCode {
        case LFLiveSocketErrorCode.preView:
            print("liveSession errorCode preView")
            
        case LFLiveSocketErrorCode.getStreamInfo:
            print("liveSession errorCode getStreamInfo")
            
        case LFLiveSocketErrorCode.connectSocket:
            print("liveSession errorCode connectSocket")
            
        case LFLiveSocketErrorCode.verification:
            print("liveSession errorCode verification")
            
        case LFLiveSocketErrorCode.reConnectTimeOut:
            print("liveSession errorCode reConnectTimeOut")
        }
    }
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveSession stateDidChange \(state.rawValue)")
    }
}
