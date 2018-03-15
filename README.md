# SycLive

一个简单的直播 rtmp

## IOS 端

![image](https://github.com/doingself/SycLive/blob/master/images/photo2.jpeg)

### LFLiveKit

[LaiFengiOS/LFLiveKit](https://github.com/LaiFengiOS/LFLiveKit)

```
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
func startLive() -> Void {
    let stream = LFLiveStreamInfo()
    stream.url = streamUrl
    session.startLive(stream)
}
func stopLive() -> Void {
    session.stopLive()
}
```

### IJKFramework

![image](https://github.com/doingself/SycLive/blob/master/images/image1.jpg)

```
let urlStr = "rtmp://192.168.1.113:1935/rtmplive/test"
let options = IJKFFOptions.byDefault()

IJKFFMoviePlayerController.setLogReport(false)
IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_ERROR)
IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)

moviePlayerController = IJKFFMoviePlayerController(contentURLString: urlStr, with: options)
moviePlayerController.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, .flexibleHeight]
moviePlayerController.view.frame = UIScreen.main.bounds
moviePlayerController.scalingMode = IJKMPMovieScalingMode.aspectFit
moviePlayerController.shouldAutoplay = true
self.view.addSubview(moviePlayerController.view)
moviePlayerController.prepareToPlay()
moviePlayerController.play()
```






## Mac搭建nginx+rtmp服务器

### Homebrew

终端运行 `man brew` 查询是否安装 `Homebrew`

+ `Homebrew` 安装
 `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

+ `Homebrew` 卸载
 `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"`

### Nginx

+ clone Nginx 项目到本地
 `brew tap homebrew/nginx`

+ 安装
 `brew install nginx-full --with-rtmp-module`

+ 测试
 输入`nginx` 在浏览器打开 http://localhost:8080 能正常访问表示安装成功


+ 查看
 输入 `brew info nginx-full` 在输出信息中我找到

 > ==> Caveats
 > Docroot is: /usr/local/var/www
 > 
 > The default port has been set in /usr/local/etc/nginx/nginx.conf to 8080 so that
 > nginx can run without sudo.
 > 
 > nginx will load all files in /usr/local/etc/nginx/servers/.

+ 编辑 `nginx.conf` 添加 RTMP 配置
```
# 在http节点后面加上rtmp配置：
rtmp {
  	server {
      	listen 1935;


    	#直播流配置
      	application rtmplive {
          	live on;
      		#为 rtmp 引擎设置最大连接数。默认为 off
      		max_connections 1024;
		}
    
    	application hls{
        	live on;
          	hls on;
          	hls_path /usr/local/var/www/hls;
          	hls_fragment 1s;
      	}
   	}
}
```


+ 重启 Nginx
 `/usr/local/Cellar/nginx-full/1.12.2/bin/nginx -s reload`
 或者
 `nginx -s reload`
 `nginx -s stop` // 停止
 `nginx -s quit` // 退出

### FFmpeg

+ 安装
 `brew install ffmpeg`


### 使用 FFmpeg 推流

推流拉流同时进行

+ 推流 MOV 视频文件
 `ffmpeg -re -i /Users/syc/Desktop/test.MOV -vcodec libx264 -acodec aac -strict -2 -f flv rtmp://localhost:1935/rtmplive/test`

+ 推流 桌面(桌面分享)
 `ffmpeg -f avfoundation -i "1" -vcodec libx264 -preset ultrafast -acodec libfaac -f flv rtmp://localhost:1935/rtmplive/test`
 ![image](https://github.com/doingself/SycLive/blob/master/images/photo1.jpeg)

+ 推流 桌面+麦克风
 `ffmpeg -f avfoundation -i "1:0" -vcodec libx264 -preset ultrafast -acodec libmp3lame -ar 44100 -ac 1 -f flv rtmp://localhost:1935/rtmplive/test`

+ 推流 桌面+麦克风+摄像头
 `ffmpeg -f avfoundation -framerate 30 -i "1:0" \-f avfoundation -framerate 30 -video_size 640x480 -i "0" \-c:v libx264 -preset ultrafast \-filter_complex 'overlay=main_w-overlay_w-10:main_h-overlay_h-10' -acodec libmp3lame -ar 44100 -ac 1  -f flv rtmp://localhost:1935/rtmplive/test`

### 使用 VLC 拉流播放
 `Open Network` 打开 `rtmp://localhost:1935/rtmplive/test`

# Requirements

+ Swift 4
+ iOS 8+
+ Xcode 9+
+ macOS Sierra 10.12.6

### 鸣谢

+ [cocoachina iOS直播实用篇(手把手教)](http://www.cocoachina.com/ios/20161111/18050.html)
+ [cnglogs ffmpeg 常用命令](https://www.cnblogs.com/frost-yen/p/5848781.html)
+ [FFmpeg常用推流命令](http://www.jianshu.com/p/d541b317f71c)
+ [ffmpeg处理RTMP流媒体的命令大全](http://blog.csdn.net/leixiaohua1020/article/details/12029543)
