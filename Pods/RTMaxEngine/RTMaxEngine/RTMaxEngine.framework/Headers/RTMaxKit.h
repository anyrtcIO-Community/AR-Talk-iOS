//
//  RTMaxKit.h
//  RTMaxEngine
//
//  Created by derek on 2018/1/30.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTMaxKitDelegate.h"
#import "RTCCommon.h"
#import "RTMaxOption.h"


@interface RTMaxKit : NSObject
{
    
}
/**
 实例化抢麦对象
 
 @param delegate RTC相关回调代理
 @return 抢麦对象
 */
- (instancetype)initWithDelegate:(id<RTMaxKitDelegate>)delegate;


#pragma mark - 加入或离开对讲组

/**
 加入对讲组
 
 @param strGroupId 对讲组id（同一个anyrtc平台的appid内保持唯一性）
 @param strUserId 用户的第三方平台的用户Id
 @param strUserData 用户的自定义数据
 @return -1：strGroupId为空；0：成功;2：strUserData 大于512

 */
- (int)joinTalkGroup:(NSString*)strGroupId userId:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 切换对讲组

 @param strGroupId 对讲组id（同一个anyrtc平台的appid内保持唯一性）
 @param strUserData 用户的自定义数据
 @return  -2：切换对讲组失败，-1：strGroupId为空，0：成功；2：strUserData 大于512字节
 */
- (int)switchTalkGroup:(NSString*)strGroupId userData:(NSString*)strUserData;

/**
 离开对讲组
 */
- (void)leaveTalkGroup;

#pragma mark - 对讲相关
/**
 抢麦

 @param nPriority 申请抢麦用户的级别（0权限最大（数值越大，权限越小）；除0意外，可以后台设置0-10之间的抢麦权限大小））
 @return 0: 调用OK  -1:未登录  -2:正在对讲中  -3: 资源还在释放中 -4: 操作太过频繁
 */
- (int)applyTalk:(int)nPriority;

/**
 取消抢麦/下麦
 */
- (void)cancleTalk;


#pragma mark - 公共功能

/**
 设置本地视频采集窗口
 
 @param render 视频显示对象
 @param option 视频配置
 说明：该方法用于本地视频采集。
 */
- (void)setLocalVideoCapturer:(UIView*)render option:(RTMaxOption*)option;

/**
 切换前后摄像头
 说明:切换本地前后摄像头。
 */
- (void)switchCamera;

/**
 设置音频检测
 
 @param bEnable YES/NO
 说明：默认关闭音频检测
 */
- (void)setAudioDetect:(BOOL)bEnable;

/**
 获取当前是否打开了音频检测
 
 @return 音频检测打开与否
 */
- (BOOL)getAudioDetectEnabled;

/**
 设置本地音频是否传输
 
 @param bEnable 打开或关闭本地音频
 说明：yes为传输音频,no为不传输音频，默认传输
 */
- (void)setLocalAudioEnable:(BOOL)bEnable;

/**
 设置本地视频是否传输
 
 @param bEnable 打开或关闭本地视频
 说明：yes为传输视频，no为不传输视频，默认视频传输
 */
- (void)setLocalVideoEnable:(BOOL)bEnable;

/**
 设置录像
 
 @param strFilePath 呼叫通话录音的保存路径（文件夹路径）
 @param strTalkPath 对讲录音的保存路径（文件夹路径）
 @param strTalkP2PPath 强插P2P录像的保存路径（文件夹路径）
 @return 0/1:文件夹不存在设置成功
 */
- (BOOL)setRecordPath:(NSString*)strFilePath talkPath:(NSString*)strTalkPath talkP2PPath:(NSString*)strTalkP2PPath;


/**
 设置远端用户是否可以接收自己的音视频
 
 @param strUserId 远端用户UserId
 @param bAudioEnable YES：音频可用，NO：音频不可用
 @param bVideoEnable YES：视频可用，NO：视频不可用
 */
- (void)setRemoteAVEnable:(NSString*)strUserId audio:(BOOL)bAudioEnable video:(BOOL)bVideoEnable;

/**
 设置不接收指定通道的音视频
 
 @param strPeerId 视频通道的PeerId或者PubId
 @param bAudioEnable  YES：音频可用，NO：音频不可用
 @param bVideoEnable YES：视频可用，NO：视频不可用
 */
- (void)setRemotePeerAVEnable:(NSString*)strPeerId audio:(BOOL)bAudioEnable video:(BOOL)bVideoEnable;

#pragma mark - 视频流信息监测

/**
 打开或者关闭网络监控状态
 
 @param bEnable YES:打开网络状态;NO:关闭网络状态
 说明:默认关闭
 */
- (void)setNetworkStatus:(BOOL)bEnable;

/**
 网络状态是否打开
 
 @return 网络状态
 */
- (BOOL)networkStatusEnabled;

#pragma mark - P2P关闭（回掉会把当前通话变为P2P）
/**
 关闭P2P通话
 说明:在控制台强插对讲后，关闭和控制台之间的P2P通话
 */
- (void)closeP2PTalk;

#pragma mark - 视频通话
/**
 发起呼叫

 @param strUserId 被呼叫用户Id
 @param nType 呼叫类型：0:视频;1:音频
 @param strUserData 用户的自定义数据
 @return 0:调用OK;-1:未登录;-2:没有通话-3:视频资源占用中;-5:本操作不支持自己对自己;-6:会话未创建（没有被呼叫用户）
 */
- (int)makeCall:(NSString*)strUserId type:(int)nType userData:(NSString*)strUserData;

/**
 邀请用户

 @param strUserId 被邀请用户的Id
 @param strUserData 用户的自定义数据
 @return 0:调用OK;-1:未登录;-2:没有通话-3:视频资源占用中;-5:本操作不支持自己对自己;-6:会话未创建（没有被呼叫用户）
 */
- (int)inviteCall:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 主叫端结束某一路正在进行的通话
 
 @param strUserId 结束的这路视频的用户ID
 */
- (void)endCall:(NSString*)strUserId;

/**
 同意呼叫或通话邀请

 @param strCallId 呼叫请求时收到的Id
 @return 0:调用OK;-1:未登录;-2:会话不存在-3:视频资源占用中;
 */
- (int)acceptCall:(NSString*)strCallId;

/**
 拒绝通话或通话

 @param strCallId 呼叫的Id
 */
- (void)rejectCall:(NSString*)strCallId;

/**
 被叫端离开通话
 
 说明：调用该方法后，把本地视频窗口从父视图上删除
 */
- (void)leaveCall;
/**
 设置显示其他端视频窗口
 
 @param strRTCPubId RTC服务生成流的ID (用于标识与会者发布的流)；
 @param render 对方视频的窗口，本地设置；
 说明：该方法用于与会者接通后，与会者视频接通回调中（onRTCOpenVideoRender）使用。
 */
- (void)setRTCVideoRender:(NSString*)strRTCPubId render:(UIView*)render;

#pragma mark - 视频监看
/**
 发起视频监看（或者收到视频上报请求时查看视频）
 
 @param strUserId 被监看用户Id
 @param strUserData  用户的自定义数据
 @return 0:调用OK;-1:未登录;-5:本操作不支持自己对自己
 */
- (int)monitorVideo:(NSString*)strUserId userData:(NSString*)strUserData;

/**
 同意别人视频监看
 
 @param strUserId 发起人的用户Id
 @return 0:调用OK;-1:未登录;-3:视频资源占用中;-5:本操作不支持自己对自己
 说明：该方法为被监看方调用，在接收到回掉（onRtcVideoMonitorRequest）后调用
 */
- (int)acceptVideoMonitor:(NSString*)strUserId;

/**
 拒绝监看

 @param strUserId 发起人的用户Id
 */
-(void)rejectVideoMonitor:(NSString*)strUserId;

/**
 监看发起者关闭视频监看（谁监看谁关闭）
 @param strUserId 被监看的用户Id
 说明：关闭成功会有回掉（onRTCCloseVideoRender），把显示的视图从父视图上删除掉
 */
- (void)closeVideoMonitor:(NSString*)strUserId;

/**
 视频上报（接收端收到上报请求时，调用monitorVideo进行视频查看）
 
 @param strUserId 上报对象的用户的Id
 @return 0:调用OK;-1:未登录;-3:视频资源占用中;-5:本操作不支持自己对自己
 */
- (int)reportVideo:(NSString*)strUserId;

/**
 上报者关闭上报
 说明：上报功能只能自己关闭
 */
- (void)closeReportVideo;


#pragma mark - 消息
/**
 发送消息
 
 @param strUserName 用户昵称(最大256字节)，不能为空，否则发送失败；
 @param strUserHeaderUrl 用户头像(最大512字节)，可选
 @param strContent 消息内容(最大1024字节)不能为空，否则发送失败；
 @return YES/NO 发送成功/发送失败
 说明：如果加入RTC（joinRTC）没有设置strUserid，发送失败。
 */

- (BOOL)sendUserMessage:(NSString*)strUserName userHeader:(NSString*)strUserHeaderUrl content:(NSString*)strContent;

@end
