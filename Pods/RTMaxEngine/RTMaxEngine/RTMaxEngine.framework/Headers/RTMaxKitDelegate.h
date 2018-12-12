//
//  RTMaxKitDelegate.h
//  RTMaxEngine
//
//  Created by derek on 2018/1/30.
//  Copyright © 2018年 derek. All rights reserved.
//

#ifndef RTMaxKitDelegate_h
#define RTMaxKitDelegate_h

#import <UIKit/UIKit.h>

@protocol RTMaxKitDelegate <NSObject>

@optional

#pragma mark - 进出对讲组相关回调
/**
 加入对讲组成功/切换对讲组成功

 @param strGroupId 组ID
 */
- (void)onRTCJoinTalkGroupOK:(NSString *)strGroupId;

/**
 加入对讲组失败/切换对讲组失败

 @param strGroupId 组ID
 @param nCode 错误码
 */
- (void)onRTCJoinTalkGroupFailed:(NSString*)strGroupId code:(int)nCode;

/**
 离开对讲组

 @param nCode 错误码：0是正常退出；100：网络错误；207：强制退出。其他值参考错误码
 */
- (void)onRTCLeaveTalkGroup:(int)nCode;

#pragma mark - 对讲相关
/**
 申请对讲成功
 */
- (void)onRTCApplyTalkOk;

/**
 申请对讲成功之后，语音通道建立，可以开始讲话
 */
- (void)onRTCTalkCouldSpeak;

/**
 其他人正在对讲组中讲话

 @param strUserId 用户Id
 @param strUserData 用户自定义数据
 */
- (void)onRTCTalkOn:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 对讲结束

 @param nCode 错误码 0：正常结束对讲；其他参考错误码
 @param strUserId 用户Id
 @param strUserData 用户自定义数据
 */
- (void)onRTCTalkClosed:(int)nCode userId:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 音频检测

 @param strRTCPeerId 当前用户的peerId
 @param strUserId 用户Id
 @param nLevel 音量（0~100）
 @param nTime 说话时间值（在该段时间内不会再次回调）
 */
- (void)onRTCAudioActive:(NSString*)strRTCPeerId userId:(NSString*)strUserId audioLevel:(int)nLevel showTime:(int)nTime;

/**
 当前对讲组在线人数回调

 @param nNum 当前在线人员数量
 */
- (void)onRTCMemberNum:(int)nNum;

#pragma mark - P2P控制台通话回调
/**
 当用户处于对讲状态时，控制台强制发起P2P通话时回调信息

 @param strUserId 用户Id
 @param strUserData 用户自定义数据
 */
- (void)onRTCTalkP2POn:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 与控制台的P2P讲话结束回调

 @param strUserData 用户自定义数据
 */
- (void)onRTCTalkP2POff:(NSString*)strUserData;

#pragma mark - 监看相关
/**
 收到监看请求

 @param strUserId 用户Id
 @param strUserData 用户自定义数据
 */
- (void)onRTCVideoMonitorRequest:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 视频监看结束

 @param strUserId 用户Id
 @param strUserData 用户自定义数据
 */
- (void)onRTCVideoMonitorClose:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 视频监看请求结果

 @param strUserId 用户Id
 @param nCode 错误码
 @param strUserData 用户自定义数据
 */
- (void)onRTCVideoMonitorResult:(NSString*)strUserId code:(int)nCode userData:(NSString*)strUserData;

#pragma mark - 视频上报相关
/**
 收到视频上报请求

 @param strUserId 用户Id
 @param strUserData 用户自定义数据
 */
- (void)onRTCVideoReportRequest:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 收到视频上报结束

 @param strUserId 用户Id
 */
- (void)onRTCVideoReportClose:(NSString*)strUserId;

#pragma  mark - 音视频呼叫邀请相关
/**
 主叫方发起通话成功

 @param strCallId 呼叫Id
 */
- (void)onRTCMakeCallOK:(NSString*)strCallId;

/**
 主叫方收到被叫方同意通话

 @param strUserId 用户Id
 @param strUserData 用户自定义数据
 */
- (void)onRTCAcceptCall:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 主叫方收到被叫方通话拒绝的回调

 @param strUserId 用户Id
 @param nCode 错误码
 @param strUserData 用户自定义数据
 */
- (void)onRTCRejectCall:(NSString*)strUserId code:(int)nCode userData:(NSString*)strUserData;

/**
 被叫方调用leaveCall方法时，主叫方收到

 @param strUserId 用户Id
 */
- (void)onRTCLeaveCall:(NSString*)strUserId;

/**
 主叫方收到通话结束（被叫方和邀请发已全部退出或者主叫方挂断所有参与者）

 @param strCallId 用户Id
 */
- (void)onRTCReleaseCall:(NSString*)strCallId;

/**
 被叫方收到通话请求

 @param strCallId 呼叫Id
 @param nCallType 呼叫类型:0:视频;1:音频
 @param strUserId 用户Id
 @param strUserData 用户自定义数据
 */
- (void)onRTCMakeCall:(NSString*)strCallId callType:(int)nCallType userId:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 被叫方收到主叫方挂断通话(收到该回掉，把本地视图从父视图删除)

 @param strCallId 呼叫Id
 @param strUserId 用户自定义数据
 @param nCode 错误码
 */
- (void)onRTCEndCall:(NSString*)strCallId userId:(NSString*)strUserId code:(int)nCode;

/**
 其他与会者加入（音视频）
 
 @param strRTCPeerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param strRTCPubId RTC服务生成流的Id (用于标识与会者发布的流)；
 @param strUserId 开发者自己平台的Id；
 @param strUserData 开发者自己平台的相关信息（昵称，头像等)；
 说明：其他与会者进入会议的回调，开发者需调用设置其他与会者视频窗口（setRTCVideoRender）方法。
 */
-(void)onRTCOpenVideoRender:(NSString*)strRTCPeerId pubId:(NSString *)strRTCPubId userId:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 其他与会者离开（音视频）
 
 @param strRTCPeerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param strRTCPubId RTC服务生成流的Id (用于标识与会者发布的流)；
 @param strUserId 开发者自己平台的Id；
 说明：其他与会者离开将会回调此方法；需本地移除与会者视频视图。
 */
-(void)onRTCCloseVideoRender:(NSString*)strRTCPeerId pubId:(NSString *)strRTCPubId userId:(NSString*)strUserId;
/**
 视频窗口大小改变
 
 @param videoView 视频显示窗口
 @param size 视频大小
 说明：连麦以及主播视频窗口大小变化的回调。一般处理连麦视频窗口第一针视频显示。
 */
-(void) onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size;
/**
 其他与会者加入（音频）
 
 @param strRTCPeerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param strUserId 开发者自己平台的Id；
 @param strUserData 开发者自己平台的相关信息（昵称，头像等)；
 说明：其他与会者进入会议的回调。
 */
- (void)onRTCOpenAudioTrack:(NSString*)strRTCPeerId userId:(NSString *)strUserId userData:(NSString*)strUserData;
/**
 其他与会者离开（音频）
 
 @param strRTCPeerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param strUserId 与开发者自己平台的Id；
 说明：其他与会者离开会议的回调。
 */
- (void)onRTCCloseAudioTrack:(NSString*)strRTCPeerId userId:(NSString *)strUserId;

/**
 用户的音视频状态
 
 @param strRTCPeerId  RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param bAudio yes为打开音频，no为关闭音频
 @param bVideo yes为打开视频，no为关闭视频
 说明：比如对方关闭了音频，对方关闭了视频
 */
-(void)onRTCAVStatus:(NSString*) strRTCPeerId audio:(BOOL)bAudio video:(BOOL)bVideo;

/**
 网络状态
 
 @param strRTCPeerId RTC服务生成的与会者标识Id（用于标识与会者用户，每次随机生成）
 @param strUserId 连麦者在自己平台的用户Id；
 @param nNetSpeed 网络上行
 @param nPacketLost 丢包率
 */
- (void)onRTCNetworkStatus:(NSString*)strRTCPeerId userId:(NSString *)strUserId netSpeed:(int)nNetSpeed packetLost:(int)nPacketLost;

#pragma mark - 录像地址回调
/**
 录像地址回调信息

 @param nRecordType 录音的类型（0/1/2/3：对讲本地录音/对讲远端录音/强插P2P录音/语音通话呼叫录音）
 @param strUserData 用户自定义数据
 @param strFilePath 录音文件的路径
 */
- (void)onRTCGotRecordFile:(int)nRecordType userData:(NSString*)strUserData filePath:(NSString*)strFilePath;

#pragma mark - 消息回调
/**
 收到消息回调
 
 @param strUserId 发送消息者在自己平台下的Id；
 @param strUserName 发送消息者的昵称
 @param strUserHeaderUrl 发送者的头像
 @param strContent 消息内容
 说明：该参数来源均为发送消息时所带参数。
 */
- (void)onRTCUserMessage:(NSString*)strUserId userName:(NSString*)strUserName userHeader:(NSString*)strUserHeaderUrl content:(NSString*)strContent;
@end

#endif /* RTMaxKitDelegate_h */
