# AR-Talk-iOS

## 项目介绍

AR-Talk-iOS智能调度对讲，基于RTMaxEngine SDK，快速实现对讲、视频上报、视频监看、音视频通话，发送消息等功能。</br>

## 安装
### 1、编译环境
Xcode 8以上</br>

### 2、运行环境
真机运行、iOS 8.0以上（建议最新）


## 导入SDK

### Cocoapods导入
```
pod 'RTMaxEngine'
```
### 手动导入

1. 下载Demo，或者前往[anyRTC官网](https://www.anyrtc.io/resoure)下载SDK</br>

2. 在Xcode中选择“Add files to 'Your project name'...”，将RTCPEngine.framework添加到你的工程目录中</br>

3.  打开General->Embedded Binaries中添加RTMaxEngine.framework</br>


## 如何使用？

### 注册账号
登陆[AnyRTC官网](https://www.anyrtc.io/)

### 填写信息
创建应用，在管理中心获取开发者ID，AppID，AppKey，AppToken，替换AppDelegate.h中的相关信息

### 操作步骤：
1、Web端开启调度台，在启动一个手机</br>

2、Web端输入手机端的id,可以监看手机端、对讲、音视频通信。</br>

### 资源中心
 [更多详细方法使用，请查看API文档](https://www.anyrtc.io/resoure)

## 扫描二维码下载demo
![Talk](/Talk.png)


## 支持的系统平台
**iOS** 8.0及以上

## 支持的CPU架构
**iOS** armv7 、arm64。  支持bitcode
## ipv6
苹果2016年6月新政策规定新上架app必须支持ipv6-only。该库已经适配
## Android版
[AR-Talk-Android](https://github.com/anyRTC/AR-Talk-Android)
## 网页版
[AR-Talk-Web](https://github.com/anyRTC/AR-Talk-Web)


## 技术支持
anyRTC官方网址：https://www.anyrtc.io </br>
anyRTC官方论坛：https://bbs.anyrtc.io </br>
QQ技术交流群：554714720 </br>
联系电话:021-65650071-816 </br>
Email:hi@dync.cc </br>
## 关于直播
本公司有一整套直播解决方案，特别针对移动端。本公司开发者平台[www.anyrtc.io](http://www.anyrtc.io)。除了基于RTMP协议的直播系统外，我公司还有基于WebRTC的时时交互直播系统、P2P呼叫系统、会议系统等。快捷集成SDK，便可让你的应用拥有时时通话功能。欢迎您的来电~
## License

RTMaxEngine is available under the MIT license. See the LICENSE file for more info.
