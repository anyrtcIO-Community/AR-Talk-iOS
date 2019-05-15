//
//  ARMaxKit.h
//  RTMaxEngine
//
//  Created by zjq on 2019/1/17.
//  Copyright © 2019 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARMaxKitDelegate.h"
#import "ARMaxEnum.h"
#import "ARMaxOption.h"


NS_ASSUME_NONNULL_BEGIN

@interface ARMaxKit : NSObject
/**
 实例化对讲调度对象
 
 @param delegate RTC相关回调代理
 @return 对讲调度对象
 */
- (instancetype)initWithDelegate:(id<ARMaxKitDelegate>)delegate;


#pragma mark - 加入或离开对讲组

/**
 加入对讲组
 
 @param token 令牌:客户端向自己服务申请获得，参考企业级安全指南
 @param groupId 对讲组id（同一个anyrtc平台的appid内保持唯一性）
 @param userId 用户的第三方平台的用户Id
 @param userData 用户的自定义数据
 @return -1：groupId为空；0：成功;2：userData 大于512字节
 
 */
- (int)joinTalkGroupByToken:(NSString* _Nullable)token
                    groupId:(NSString*)groupId
                     userId:(NSString*)userId
                   userData:(NSString*)userData;

/**
 切换对讲组
 
 @param groupId 对讲组id（同一个anyrtc平台的appid内保持唯一性）
 @param userData 用户的自定义数据
 @return  -2：切换对讲组失败，-1：groupId为空，0：成功；2：userData 大于512字节
 */
- (int)switchTalkGroup:(NSString*)groupId userData:(NSString*)userData;

/**
 离开对讲组
 说明：释放对讲调度资源
 */
- (void)leaveTalkGroup;

#pragma mark - 对讲相关
/**
 抢麦
 
 @param priority 申请抢麦用户的级别（0权限最大（数值越大，权限越小）；除0意外，可以后台设置0-10之间的抢麦权限大小）
 @return 0: 调用OK  -1:未登录  -2:正在对讲中  -3: 资源还在释放中 -4: 操作太过频繁
 */
- (int)applyTalk:(int)priority;

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
- (void)setLocalVideoCapturer:(UIView*)render option:(ARMaxOption*)option;

/**
 切换前后摄像头
 说明:切换本地前后摄像头。
 */
- (void)switchCamera;

/**
 设置音量检测
 
 @param on YES为打开音量检测；NO为关闭音量检测
 说明：默认打开
 */
- (void)setAudioActiveCheck:(BOOL)on;

/**
 获取音频检测是否打开
 */
- (BOOL)audioActiveCheck;

/**
 设置本地音频是否传输
 
 @param enable YES为传输音频,NO为不传输音频
 说明：默认传输
 */
- (void)setLocalAudioEnable:(BOOL)enable;

/**
 设置本地视频是否传输
 
 @param enable YES为传输视频，NO为不传输视频
 说明：默认传输
 */
- (void)setLocalVideoEnable:(BOOL)enable;

/**
 设置录像
 
 @param filePath 呼叫通话录音的保存路径（文件夹路径）
 @param talkPath 对讲录音的保存路径（文件夹路径）
 @param talkP2PPath 强插P2P录像的保存路径（文件夹路径）
 @return 0:设置失败;1:设置成功
 */
- (BOOL)setRecordPath:(NSString*)filePath talkPath:(NSString*)talkPath talkP2PPath:(NSString*)talkP2PPath;


/**
 设置远端用户是否可以接收自己的音视频
 
 @param userId 远端用户userId
 @param enable YES：接收音频，NO：不接收音频
 @param enable YES：接收视频，NO：不接收视频
 */
- (void)setRemoteAVEnable:(NSString*)userId audio:(BOOL)enable video:(BOOL)enable;

/**
 设置不接收指定通道的音视频
 
 @param peerId 视频通道的peerId
 @param enable YES：接收音频，NO：不接收音频
 @param enable YES：接收视频，NO：不接收视频
 */
- (void)setRemotePeerAVEnable:(NSString*)peerId audio:(BOOL)enable video:(BOOL)enable;

#pragma mark - 视频流信息监测

/**
 打开或者关闭网络状态回调
 
 @param enable YES:打开网络状态回调;NO:关闭网络状态回调
 说明:默认关闭
 */
- (void)setNetworkStatus:(BOOL)enable;

/**
 获取网络状态是否打开
 
 @return 网络状态是否打开
 */
- (BOOL)networkStatusEnabled;

#pragma mark - P2P关闭（回调会把当前通话变为P2P）
/**
 关闭P2P通话
 说明:在控制台强插对讲后，关闭和控制台之间的P2P通话
 */
- (void)closeP2PTalk;

#pragma mark - 视频通话
/**
 发起呼叫
 
 @param userId 被呼叫用户Id
 @param type 呼叫类型：0:视频;1:音频
 @param userData 用户的自定义数据
 @return 0:调用OK;-1:未登录;-2:没有通话-3:视频资源占用中;-5:本操作不支持自己对自己;-6:会话未创建（没有被呼叫用户）
 */
- (int)makeCall:(NSString*)userId type:(int)type userData:(NSString*)userData;

/**
 邀请用户
 
 @param userId 被邀请用户的Id
 @param userData 用户的自定义数据
 @return 0:调用OK;-1:未登录;-2:没有通话-3:视频资源占用中;-5:本操作不支持自己对自己;-6:会话未创建（没有被呼叫用户）
 */
- (int)inviteCall:(NSString*)userId userData:(NSString*)userData;

/**
 主叫端结束某一路正在进行的通话
 
 @param userId 结束的这路视频的用户ID
 */
- (void)endCall:(NSString*)userId;

/**
 同意呼叫
 
 @param callId 呼叫请求时收到的Id
 @return 0:调用OK;-1:未登录;-2:会话不存在-3:视频资源占用中;
 */
- (int)acceptCall:(NSString*)callId;

/**
 拒绝通话
 
 @param callId 呼叫的Id
 */
- (void)rejectCall:(NSString*)callId;

/**
 被叫端离开通话
 
 说明：调用该方法后，把本地视频窗口从父视图上删除
 */
- (void)leaveCall;
/**
 设置显示其他端视频窗口
 
 @param render 显示对方视频的窗口；
 @param pubId RTC服务生成流的ID (用于标识与会者发布的流)；
 说明：该方法用于与会者接通后，与会者视频接通回调中（onRTCOpenVideoRender）使用。
 */
- (void)setRemoteVideoRender:(UIView*)render pubId:(NSString*)pubId;

#pragma mark - 视频监看
/**
 发起视频监看（或者收到视频上报请求时查看视频）
 
 @param userId 被监看用户Id
 @param userData  用户的自定义数据
 @return 0:调用OK;-1:未登录;-5:本操作不支持自己对自己
 */
- (int)monitorVideo:(NSString*)userId userData:(NSString*)userData;

/**
 同意别人视频监看
 
 @param userId 发起人的用户Id
 @return 0:调用OK;-1:未登录;-3:视频资源占用中;-5:本操作不支持自己对自己
 说明：该方法为被监看方调用，在接收到回调（onRtcVideoMonitorRequest）后调用
 */
- (int)acceptVideoMonitor:(NSString*)userId;

/**
 拒绝监看
 
 @param userId 发起人的用户Id
 */
-(void)rejectVideoMonitor:(NSString*)userId;

/**
 监看发起者关闭视频监看（谁监看谁关闭）
 @param userId 被监看的用户Id
 说明：关闭成功会有回调（onRTCCloseVideoRender），把显示的视图从父视图上删除掉
 */
- (void)closeVideoMonitor:(NSString*)userId;

/**
 视频上报（接收端收到上报请求时，调用monitorVideo进行视频查看）
 
 @param userId 上报对象的用户的Id
 @return 0:调用OK;-1:未登录;-3:视频资源占用中;-5:本操作不支持自己对自己
 */
- (int)reportVideo:(NSString*)userId;

/**
 上报者关闭上报
 说明：上报功能只能自己关闭
 */
- (void)closeReportVideo;


#pragma mark - 消息
/**
 发送消息
 
 @param userName 用户昵称(最大256字节)，不能为空，否则发送失败；
 @param userHeaderUrl 用户头像(最大512字节)，可选
 @param content 消息内容(最大1024字节)不能为空，否则发送失败；
 @return YES/NO 发送成功/发送失败
 说明：如果加入RTC（joinRTC）没有设置userid，发送失败。
 */

- (BOOL)sendUserMessage:(NSString*)userName userHeader:(NSString*)userHeaderUrl content:(NSString*)content;
@end

NS_ASSUME_NONNULL_END
