//
//  ARMaxKitDelegate.h
//  RTMaxEngine
//
//  Created by zjq on 2019/1/17.
//  Copyright © 2019 derek. All rights reserved.
//

#ifndef ARMaxKitDelegate_h
#define ARMaxKitDelegate_h

#import <UIKit/UIKit.h>
#import "ARMaxEnum.h"


@protocol ARMaxKitDelegate <NSObject>

@optional

#pragma mark - 进出对讲组相关回调
/**
 加入对讲组成功/切换对讲组成功回调
 
 @param groupId 组ID
 */
- (void)onRTCJoinTalkGroupOK:(NSString *)groupId;

/**
 加入对讲组失败/切换对讲组失败回调
 
 @param groupId 组ID
 @param code 错误码
 @param reason 错误原因,rtc错误，或者token错误（错误值自己平台定义）
 */
- (void)onRTCJoinTalkGroupFailed:(NSString*)groupId code:(ARMaxCode)code reason:(NSString*)reason;

/**
 离开对讲组回调
 
 @param code 错误码：0是正常退出；100：网络错误；207：强制退出。其他值参考错误码
 */
- (void)onRTCLeaveTalkGroup:(ARMaxCode)code;

#pragma mark - 对讲相关
/**
 申请对讲成功回调
 */
- (void)onRTCApplyTalkOk;

/**
 其他人正在对讲组中讲话的回调
 
 @param userId 用户Id
 @param userData 用户自定义数据
 */
- (void)onRTCTalkOn:(NSString*)userId userData:(NSString*)userData;

/**
 对讲结束回调
 
 @param code 错误码 0：正常结束对讲；其他参考错误码
 @param userId 用户Id
 @param userData 用户自定义数据
 */
- (void)onRTCTalkClosed:(ARMaxCode)code userId:(NSString*)userId userData:(NSString*)userData;

/**
 当前对讲组在线人数回调
 
 @param num 当前在线人员数量
 */
- (void)onRTCMemberNum:(int)num;

#pragma mark - P2P控制台通话回调
/**
 当用户处于对讲状态时，控制台强制发起P2P通话的回调
 
 @param userId 用户Id
 @param userData 用户自定义数据
 */
- (void)onRTCTalkP2POn:(NSString*)userId userData:(NSString*)userData;

/**
 与控制台的P2P讲话结束回调
 
 @param userData 用户自定义数据
 */
- (void)onRTCTalkP2POff:(NSString*)userData;

#pragma mark - 监看相关
/**
 收到监看请求回调
 
 @param userId 用户Id
 @param userData 用户自定义数据
 */
- (void)onRTCVideoMonitorRequest:(NSString*)userId userData:(NSString*)userData;

/**
 视频监看结束回调
 
 @param userId 用户Id
 @param userData 用户自定义数据
 */
- (void)onRTCVideoMonitorClose:(NSString*)userId userData:(NSString*)userData;

/**
 视频监看请求结果回调
 
 @param userId 用户Id
 @param code 错误码
 @param userData 用户自定义数据
 */
- (void)onRTCVideoMonitorResult:(NSString*)userId code:(ARMaxCode)code userData:(NSString*)userData;

#pragma mark - 视频上报相关
/**
 收到视频上报请求回调
 
 @param userId 用户Id
 @param userData 用户自定义数据
 */
- (void)onRTCVideoReportRequest:(NSString*)userId userData:(NSString*)userData;

/**
 收到视频上报结束回调
 
 @param userId 用户Id
 */
- (void)onRTCVideoReportClose:(NSString*)userId;

#pragma  mark - 音视频呼叫邀请相关
/**
 主叫方发起通话成功回调
 
 @param callId 呼叫Id
 */
- (void)onRTCMakeCallOK:(NSString*)callId;

/**
 主叫方收到被叫方同意通话回调
 
 @param userId 用户Id
 @param userData 用户自定义数据
 */
- (void)onRTCAcceptCall:(NSString*)userId userData:(NSString*)userData;

/**
 主叫方收到被叫方通话拒绝的回调
 
 @param userId 用户Id
 @param code 错误码
 @param userData 用户自定义数据
 */
- (void)onRTCRejectCall:(NSString*)userId code:(ARMaxCode)code userData:(NSString*)userData;

/**
 被叫方调用leaveCall方法时，主叫方收到的回调
 
 @param userId 用户Id
 */
- (void)onRTCLeaveCall:(NSString*)userId;

/**
 主叫方收到通话结束（被叫方和邀请发已全部退出或者主叫方挂断所有参与者）回调
 
 @param callId 呼叫Id
 */
- (void)onRTCReleaseCall:(NSString*)callId;

/**
 被叫方收到通话请求回调
 
 @param callId 呼叫Id
 @param callType 呼叫类型:0:视频;1:音频
 @param userId 用户Id
 @param userData 用户自定义数据
 */
- (void)onRTCMakeCall:(NSString*)callId callType:(int)callType userId:(NSString*)userId userData:(NSString*)userData;

/**
 被叫方收到主叫方挂断通话(收到该回掉，把本地视图从父视图删除)回调
 
 @param callId 呼叫Id
 @param userId 用户自定义数据
 @param code 错误码
 */
- (void)onRTCEndCall:(NSString*)callId userId:(NSString*)userId code:(ARMaxCode)code;

/**
 其他与会者加入（音视频）回调
 
 @param peerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param pubId RTC服务生成流的Id (用于标识与会者发布的流)；
 @param userId 用户Id;
 @param userData 用户自定义数据
 说明：其他与会者进入会议的回调，开发者需调用设置其他与会者视频窗口（setRemoteVideoRender）方法。
 */
-(void)onRTCOpenRemoteVideoRender:(NSString*)peerId pubId:(NSString *)pubId userId:(NSString*)userId userData:(NSString*)userData;

/**
 其他与会者离开（音视频）回调
 
 @param peerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param pubId RTC服务生成流的Id (用于标识与会者发布的流)；
 @param userId 开发者自己平台的Id；
 说明：其他与会者离开将会回调此方法；需本地移除与会者视频视图。
 */
-(void)onRTCCloseRemoteVideoRender:(NSString*)peerId pubId:(NSString *)pubId userId:(NSString*)userId;

/**
 其他与会者加入（音频）回调
 
 @param peerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param userId 用户Id;
 @param userData 用户自定义数据
 说明：其他与会者进入会议的回调。
 */
- (void)onRTCOpenRemoteAudioTrack:(NSString*)peerId userId:(NSString *)userId userData:(NSString*)userData;
/**
 其他与会者离开（音频）回调
 
 @param peerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param userId 用户Id;
 说明：其他与会者离开会议的回调。
 */
- (void)onRTCCloseRemoteAudioTrack:(NSString*)peerId userId:(NSString *)userId;

#pragma mark - 视频第一帧的回调、视频大小变化回调

/**
 本地视频第一帧回调
 
 @param size 视频窗口大小
 */
-(void)onRTCFirstLocalVideoFrame:(CGSize)size;

/**
 远程视频第一帧回调
 
 @param size 视频窗口大小
 @param pubId RTC服务生成流的Id (用于标识与会者发布的流)
 */
-(void)onRTCFirstRemoteVideoFrame:(CGSize)size pubId:(NSString *)pubId;

/**
 本地窗口大小的回调
 
 @param size 视频窗口大小
 */
- (void)onRTCLocalVideoViewChanged:(CGSize)size;

/**
 远程窗口大小的回调
 
 @param size 视频窗口大小
 @param pubId RTC服务生成流的Id (用于标识与会者发布的流)
 */
- (void)onRTCRemoteVideoViewChanged:(CGSize)size pubId:(NSString *)pubId;

#pragma mark - 音视频状态回调

/**
 其他与会者对音视频的操作回调
 
 @param peerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)
 @param audio YES为打开音频，NO为关闭音频
 @param video YES为打开视频，NO为关闭视频
 */
- (void)onRTCRemoteAVStatus:(NSString *)peerId audio:(BOOL)audio video:(BOOL)video;

/**
 别人对自己音视频的操作回调
 
 @param audio YES为打开音频，NO为关闭音频
 @param video YES为打开视频，NO为关闭视频
 */
- (void)onRTCLocalAVStatus:(BOOL)audio video:(BOOL)video;

#pragma mark - 网络状态和音频检测

/**
 其他与会者声音大小回调
 
 @param peerId RTC服务生成的与会者标识Id（用于标识与会者用户，每次随机生成）
 @param userId 连麦者在自己平台的用户Id
 @param level 音频大小（0~100）
 @param time 音频检测在nTime毫秒内不会再回调该方法（单位：毫秒）
 说明：与会者关闭音频后（setLocalAudioEnable为NO）,该回调将不再回调；对方关闭音频检测后（setAudioActiveCheck为NO）,该回调也将不再回调
 */
- (void)onRTCRemoteAudioActive:(NSString *)peerId userId:(NSString *)userId audioLevel:(int)level showTime:(int)time;

/**
 本地声音大小回调
 
 @param level 音频大小（0~100）
 @param time 音频检测在nTime毫秒内不会再回调该方法（单位：毫秒）
 说明：本地关闭音频后（setLocalAudioEnable为NO）,该回调将不再回调；对方关闭音频检测后（setAudioActiveCheck为NO）,该回调也将不再回调
 */
- (void)onRTCLocalAudioActive:(int)level showTime:(int)time;

/**
 其他与会者网络质量回调
 
 @param peerId RTC服务生成的与会者标识Id（用于标识与会者用户，每次随机生成）
 @param userId 用户平台Id
 @param netSpeed 网络上行
 @param packetLost 丢包率
 @param netQuality 网络质量
 */
- (void)onRTCRemoteNetworkStatus:(NSString *)peerId userId:(NSString *)userId netSpeed:(int)netSpeed packetLost:(int)packetLost netQuality:(ARNetQuality)netQuality;

/**
 本地网络质量回调
 
 @param netSpeed 网络上行
 @param packetLost 丢包率
 @param netQuality 网络质量
 */
- (void)onRTCLocalNetworkStatus:(int)netSpeed packetLost:(int)packetLost netQuality:(ARNetQuality)netQuality;

#pragma mark - 录像地址回调
/**
 录像地址回调信息回调
 
 @param recordType 录音的类型（0/1/2/3：对讲本地录音/对讲远端录音/强插P2P录音/语音通话呼叫录音）
 @param userData 用户自定义数据
 @param filePath 录音文件的路径
 */
- (void)onRTCGotRecordFile:(int)recordType userData:(NSString*)userData filePath:(NSString*)filePath;

#pragma mark - 消息回调
/**
 收到消息回调
 
 @param userId 发送消息者在自己平台下的Id；
 @param userName 发送消息者的昵称
 @param userHeaderUrl 发送者的头像
 @param content 消息内容
 说明：该参数来源均为发送消息时所带参数。
 */
- (void)onRTCUserMessage:(NSString*)userId userName:(NSString*)userName userHeader:(NSString*)userHeaderUrl content:(NSString*)content;
@end

#endif /* ARMaxKitDelegate_h */
