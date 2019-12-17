//
//  RATalkbackViewController.m
//  RTMaxAudio
//
//  Created by zjq on 2018/10/24.
//  Copyright © 2018 derek. All rights reserved.
//

#import "RATalkbackViewController.h"
#import "RATalkbackViewController.h"
#import "RTTipLabel.h"
#import "RMMessageView.h"
#import "RMCallViewController.h"
#import "RMMenuView.h"
#import "RMVideoView.h"
#import "RMReportViewController.h"
#import "RMInterruptView.h"
#import "RMAlertView.h"
#import "UIAlertController+Blocks.h"


@interface RATalkbackViewController ()<ARMaxKitDelegate>
{
     BOOL _isOtherSpeaking;
}
@property (strong, nonatomic) RASpeakButton *audioButtonView;

@property (nonatomic, strong) ARMaxKit *maxKit;
@property (nonatomic, strong) NSString *userId;

// 提示信息
@property (nonatomic, strong) RTTipLabel *tipLabel;
// 工具栏
@property (nonatomic, strong) RMMenuView *menuView;

// 消息
@property (nonatomic, strong) RMMessageView *messageView;
// 呼叫的view
@property (nonatomic, strong) NSMutableArray *videoArr;
// 被呼叫相关视图
@property (nonatomic, strong) RMCallViewController *callVc;

@property (nonatomic, strong) UIView *localView;

@property (nonatomic, strong) RMReportViewController *reportVc;

@property (nonatomic, strong) RMInterruptView *interruptView;

@property (nonatomic, assign) BOOL isSpeakButtonOk;

@end

@implementation RATalkbackViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.callVc = nil;
//    (self.groupStatus == GroupStatusCall) ? (self.groupStatus = GroupStatusNone) : 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.videoArr = [[NSMutableArray alloc] initWithCapacity:4];
    
    //实例化抢麦对象
    [self initializeMaxKit];
    
    [self initializeInterface];
}
- (void)initializeMaxKit{
    //实例化
    self.maxKit = [[ARMaxKit alloc] initWithDelegate:self];
    [self.maxKit setAudioActiveCheck:YES];
    self.userId = NULL;
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_PhoneNumber"];
    if (userId.length != 0) {
        self.userId = userId;
        
    }else{
        self.userId = [RMCommons randomNumString:4];
        [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:@"User_PhoneNumber"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
    NSDictionary *dict  = [[NSDictionary alloc] initWithObjectsAndKeys:
                           self.userId,@"userId",
                           nil];
    [self.maxKit joinTalkGroupByToken:nil groupId:@"123456789" userId:self.userId userData:[RMCommons fromDicToJSONStr:dict]];
}

- (void)initializeInterface{
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 35, 30);
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [closeButton setTitle:@"退出" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.tipLabel = [[RTTipLabel alloc] initWithFrame:CGRectMake(0, 0, 180,20)];
    self.navigationItem.titleView = self.tipLabel;
    
    WEAKSELF;
    _audioButtonView = [[RASpeakButton alloc]init];
    _audioButtonView.stateButton =  ButtonStateRobType;
    
    _audioButtonView.frame = CGRectMake(CGRectGetWidth(self.view.frame) /2 - 80, CGRectGetHeight(self.view.frame) - 200, 160, 160);
    [self.view addSubview:_audioButtonView];
    
    UILabel *userLabel = [UILabel new];
    userLabel.text = [NSString stringWithFormat:@"用户ID:%@",self.userId];
    userLabel.textAlignment = NSTextAlignmentCenter;
    userLabel.textColor = [RMCommons getColor:@"#999999"];
    userLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:userLabel];
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioButtonView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    // 工具栏
    
    if ([RMCommons isIPhoneX]) {
        self.menuView = [[RMMenuView alloc] initWithFrame:CGRectMake(0, 84, CGRectGetWidth(self.view.frame), 190)];
    }else{
        self.menuView = [[RMMenuView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 190)];
    }
    
    
    self.menuView.mediaBlock = ^(NSString * _Nonnull userID) {
        [weakSelf reportUser:userID];
    };
    self.menuView.messageBlock = ^(NSString * _Nonnull messageStr) {
        [weakSelf sendMessage:messageStr];
    };
    [self.view addSubview:self.menuView];
   
    //消息
    self.messageView = [[RMMessageView alloc] init];
    self.messageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.messageView];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(2/3.0);
        make.top.equalTo(self.menuView.mas_bottom).offset(20);
        make.bottom.equalTo(self.audioButtonView.mas_top).offset(-20);
    }];
    
    //按下
    
    _audioButtonView.speakTouchDownAction = ^(RASpeakButton *recordButton) {
        RATalkbackViewController *strongSelf = weakSelf;
        if (strongSelf->_isOtherSpeaking) {
            strongSelf.tipLabel.messageItem = [weakSelf message:TipMessageTypeSpeakingOther withNickName:nil withLineNum:0 withText:nil];
        }else{
            if (strongSelf->_isSpeakButtonOk) {
                int code = [strongSelf->_maxKit applyTalk:1];
                if (code == 0) {
                    strongSelf.tipLabel.messageItem = [weakSelf message:TipMessageTypePrepareSpeaking withNickName:@"我" withLineNum:0 withText:nil];
                    [[RMMusicPlayer sharedInstance] playUp];
                    
                } else {
                    strongSelf.tipLabel.messageItem = [weakSelf message:TipMessageTypeSpeakingError withNickName:nil withLineNum:0 withText:nil];
                }
            }else{
                strongSelf.tipLabel.messageItem = [weakSelf message:TipMessageTypeSpeakingServerError withNickName:nil withLineNum:0 withText:nil];
            }
            
        }
    };
    
    //松手
    _audioButtonView.speakTouchUpInsideAction = ^(RASpeakButton *sender){
         [weakSelf stopTalking];
    };
    
    //类似松手
    _audioButtonView.speakTouchUpOutsideAction = ^(RASpeakButton *recordButton) {
         [weakSelf stopTalking];
    };
    
    //点击或者松开
    _audioButtonView.speakEventBlock = ^(BOOL isSelected) {
        RATalkbackViewController *strongSelf = weakSelf;
        if (isSelected) {
            [[RMMusicPlayer sharedInstance] playUp];
            int code = [strongSelf->_maxKit applyTalk:1];
            if (code == 0) {
                strongSelf.tipLabel.messageItem = [weakSelf message:TipMessageTypePrepareSpeaking withNickName:@"我" withLineNum:0 withText:nil];
            } else {
                strongSelf.title = @"操作过于频繁";
                strongSelf.tipLabel.messageItem = [weakSelf message:TipMessageTypeSpeakingError withNickName:nil withLineNum:0 withText:nil];
            }
        } else {
             [weakSelf stopTalking];
        }
    };
}
#pragma mark - 事件
// 上报给用户
- (void)reportUser:(NSString*)uerID {
    if (self.groupStatus == GroupStatusMonitor) {
        [RMCommons showCenterWithText:@"当前被监看中...，请稍后上报"];
        return;
    }
   
    self.reportVc = nil;
    RMVideoView *myVideo = [[RMVideoView alloc] init];
    // 显示自己
    [self.maxKit setLocalVideoCapturer:myVideo.videoView option:nil];
    
    myVideo.pubID = @"Video_MySelf";
    self.reportVc.maxKit = self.maxKit;
    self.reportVc.videoView = myVideo;
    [[RMCommons topViewController] presentViewController:self.reportVc animated:YES completion:nil];
    [self.maxKit reportVideo:uerID];
    self.groupStatus = GroupStatusReport;
}
// 发消息
- (void)sendMessage:(NSString*)sendMessage {
    if (sendMessage.length!=0) {
        if (self.maxKit) {
            [self.maxKit sendUserMessage:self.userId userHeader:@"" content:sendMessage];
            //本地预览
            RMMessageModel *messageItem = [[RMMessageModel alloc] init];
            messageItem.userID = self.userId;
            messageItem.messageStr = sendMessage;
            messageItem.isMe = YES;
            [self.messageView sendMessage:messageItem];
        }
    }
}
// 停止对讲
- (void)stopTalking{
   
    [_maxKit cancleTalk];
    [[RMMusicPlayer sharedInstance] playOver];
    if (!_isOtherSpeaking) {
        self.tipLabel.messageItem = [self message:TipMessageTypeSpeakingEnd withNickName:nil withLineNum:0 withText:nil];
    }
}

// 离开
- (void)closeButtonEvent:(UIButton*)sender {
    
    WEAKSELF;
    [UIAlertController showActionSheetInViewController:weakSelf withTitle:@"退出后将无法接收到语音对讲信息，是否确认退出语音对讲" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 2) {
            RATalkbackViewController *strongSelf = weakSelf;
            if (strongSelf->_maxKit) {
                [strongSelf->_maxKit leaveTalkGroup];
            }
             [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
//    if (self.maxKit) {
//        [self.maxKit leaveTalkGroup];
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Get
- (RMCallViewController *)callVc{
    if (!_callVc) {
        _callVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"callController"];
    }
    return _callVc;
}
- (RMReportViewController*)reportVc {
    if (!_reportVc) {
        _reportVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"reportController"];
        WEAKSELF;
        _reportVc.leaveBlock = ^{
            weakSelf.groupStatus = GroupStatusNone;
        };
    }
    return _reportVc;
}
// 提示消息相关
- (MessageItem *)message:(TipMessageType)type withNickName:(NSString*)nickName withLineNum:(NSInteger)lineNum withText:(NSString *)currentText{
    NSString *tipStr;
    switch (type) {
        case TipMessageTypeSpeakingServerError:
            tipStr = @"对讲服务异常,请稍后重试";
            break;
        case TipMessageTypeSpeakingTimeOutError:
        case TipMessageTypeSpeakingTimeOut:
            tipStr = @"超时或异常了";
            break;
        case TipMessageTypePrepareSpeaking:
            tipStr = @"准备中...";
            break;
        case TipMessageTypeSpeaking:
            tipStr = [NSString stringWithFormat:@"%@正在发言",nickName];
            break;
        case TipMessageTypeSpeakingEnd:
            tipStr = [NSString stringWithFormat:@"%@下麦了",nickName];
            break;
        case TipMessageTypeSpeakingOther:
            tipStr = [NSString stringWithFormat:@"其他人正在说话"];
            break;
        case TipMessageTypeSpeakingError:
            tipStr = [NSString stringWithFormat:@"操作过于频繁"];
            break;
        case TipMessageTypeLine:
            //位置共享显示级别最低
            if ([RMCommons isStringContains:currentText string:@"共享"] || currentText.length == 0) {
                (lineNum == 0) ? (lineNum = 1) : 0;
                tipStr = [NSString stringWithFormat:@"当前%ld人在线",(long)lineNum];
            } else {
                return nil;
            }
            break;
        case TipMessageTypeEnterTip:
            tipStr = [NSString stringWithFormat:@"%@进来啦",nickName];
            break;
        case TipMessageTypeOutTip:
            tipStr = [NSString stringWithFormat:@"%@离开啦",nickName];
            break;
        case TipMessageTypeSpeakingInterrupt:
            tipStr = [NSString stringWithFormat:@"%@打断了您",nickName];
            break;
        default:
            tipStr = [NSString stringWithFormat:@"联网失败，请检查网络"];
            break;
    }
    
    MessageItem *item = [[MessageItem alloc] init];
    item.nickName = nickName;
    item.tipStr = tipStr;
    item.tipType = type;
    
    return item;
}
#pragma mark - ARMaxKitDelegate 对讲调度相关回调

#pragma mark - 进出语音通道是否成功
- (void)onRTCJoinMaxGroupOk:(NSString*)groupId {
    self.isSpeakButtonOk = YES;
}
- (void)onRTCJoinMaxGroupFailed:(NSString*)groupId code:(ARMaxCode)code reason:(NSString*)reason {
    self.isSpeakButtonOk = NO;
}
- (void)onRTCTempLeaveMaxGroup:(ARMaxCode)code {
    self.isSpeakButtonOk = NO;
}
- (void)onRTCLeaveMaxGroup:(ARMaxCode)code {
    self.isSpeakButtonOk = NO;
}
#pragma mark - 对讲相关回调
- (void)onRTCApplyTalkOk {
    //申请对讲成功
     _isOtherSpeaking = NO;
     self.tipLabel.messageItem = [self message:TipMessageTypeSpeaking withNickName:@"我" withLineNum:0 withText:nil];
     [[RMMusicPlayer sharedInstance] playScuess];
}
- (void)onRTCApplyTalkClosed:(ARMaxCode)code userId:(NSString*)userId userData:(NSString*)userData {
    if (code == 802 ) {
        //抢麦没权限
        self.tipLabel.messageItem = [self message:TipMessageTypeSpeakingOther withNickName:nil withLineNum:0 withText:nil];
        if (_audioButtonView) {
            [_audioButtonView reset];
        }
        
    }else if(code == 813 || code == 814 || code == 815 || code == 816) {
        self.tipLabel.messageItem = [self message:TipMessageTypeSpeakingTimeOutError withNickName:nil withLineNum:0 withText:nil];
        if (_audioButtonView) {
            [_audioButtonView reset];
        }
    }else if (code == 810) {
        // 麦被抢了
        [[RMMusicPlayer sharedInstance] playOver];
        [_maxKit cancleTalk];
        [_audioButtonView reset];
        
        self.tipLabel.messageItem =[self message:TipMessageTypeSpeakingInterrupt withNickName:userId withLineNum:self.tipLabel.number withText:nil];
        
    }
}

- (void)onRTCTalkOn:(NSString*)userId userData:(NSString*)userData {
    //其他人正在对讲组中讲话
    _isOtherSpeaking = YES;
    //别人上麦了
    self.tipLabel.messageItem = [self message:TipMessageTypeSpeaking  withNickName:userId withLineNum:0 withText:nil];
    
}

- (void)onRTCTalkClosed:(ARMaxCode)code userId:(NSString*)userId userData:(NSString*)userData {
    //对讲结束
   // NSLog(@"onRtcTalkClosed:%d",nCode);
   //当前讲话人下线
   if (!_isOtherSpeaking && ![userId isEqualToString:self.userId]) {
       [RMCommons showCenterWithText:[NSString stringWithFormat:@"当前对话被%@打断",userId]];
   }
   _isOtherSpeaking = NO;
   [_audioButtonView reset];
   
   self.tipLabel.messageItem = [self message:TipMessageTypeSpeakingEnd withNickName:userId withLineNum:self.tipLabel.number withText:nil];
}

#pragma mark - 进出组是否成功
- (void)onRTCJoinTalkGroupOK:(NSString *)strGroupId {
    //加入对讲组成功/切换对讲组成功
}
- (void)onRTCJoinTalkGroupFailed:(NSString*)strGroupId code:(ARMaxCode)code reason:(NSString*)reason {
     //加入对讲组失败/切换对讲组失败
}
- (void)onRTCLeaveTalkGroup:(ARMaxCode)code {
    
}

- (void)onRTCAudioActive:(NSString*)strRTCPeerId userId:(NSString*)strUserId audioLevel:(int)nLevel showTime:(int)nTime {
  //  NSLog(@"onRTCAudioActive:%d withPeerID:%@",nLevel,strRTCPeerId);
    //音频检测
    if ([strRTCPeerId isEqualToString:@"RtcPublisher"]) {
        if (_audioButtonView) {// 自己
            [_audioButtonView setVolumeLeave:nLevel];
        }
    }
}
- (void)onRTCMemberNum:(int)num {
    
    self.tipLabel.messageItem  = [self message:TipMessageTypeLine withNickName:nil withLineNum:num withText:self.tipLabel.text];
    self.tipLabel.number = num;
}
#pragma mark - P2P相关
- (void)onRTCTalkP2POn:(NSString*)userId userData:(NSString*)userData {
    // 麦被抢了
    [[RMMusicPlayer sharedInstance] playOver];
    [_audioButtonView reset];
    if (self.interruptView) {
        [self.interruptView dismiss];
    }
    self.interruptView = [RMInterruptView new];
    self.interruptView.userID = userId;
    [self.interruptView show];

}
- (void)onRTCTalkP2POff:(NSString*)userData {
    if (self.interruptView) {
        [self.interruptView dismiss];
    }
}
#pragma mark - 监看相关
- (void)onRTCVideoMonitorRequest:(NSString*)userId userData:(NSString*)userData {
    
    if (self.groupStatus == GroupStatusMonitor || self.groupStatus == GroupStatusCall || self.groupStatus == GroupStatusReport) {
        [_maxKit rejectVideoMonitor:userId];
        return;
    }
    //状态更改（自己被监看了）
    self.groupStatus = GroupStatusMonitor;
    [_maxKit acceptVideoMonitor:userId];
    
    [RMCommons showCenterWithText:[NSString stringWithFormat:@"正在被用户%@监看",userId]];
    _localView = [[UIView alloc] initWithFrame:CGRectZero];
    [_maxKit setLocalVideoCapturer:_localView option:nil];
   
}
- (void)onRTCVideoMonitorClose:(NSString*)userId userData:(NSString*)userData {
    // 收到监看结束
    //监看关闭的回调
    _localView = nil;
    self.groupStatus = GroupStatusNone;
    [RMCommons showCenterWithText:@"监看已结束"];
}

- (void)onRTCVideoMonitorResult:(NSString*)userId code:(ARMaxCode)code userData:(NSString*)userData {
    
}
#pragma mark - 视频上报
- (void)onRTCVideoReportRequest:(NSString*)userId userData:(NSString*)userData {
    
}
- (void)onRTCVideoReportClose:(NSString*)userId {
    
}

#pragma mark - 音视频呼叫相关
- (void)onRTCMakeCallOK:(NSString*)callId {
}
- (void)onRTCAcceptCall:(NSString*)userId userData:(NSString*)userData {
}
- (void)onRTCRejectCall:(NSString*)userId code:(ARMaxCode)code userData:(NSString*)userData {
}
- (void)onRTCLeaveCall:(NSString*)userId {
    // 被叫方调用方法时，主叫方收到
}
- (void)onRTCReleaseCall:(NSString*)callId {
}

- (void)onRTCMakeCall:(NSString*)callId callType:(int)callType userId:(NSString*)userId userData:(NSString*)userData {
   
    //收到呼叫的回调
    if (self.groupStatus == GroupStatusMonitor) {
        //监看中收到呼叫
        [_maxKit rejectCall:callId];
        return;
    }
    if (self.groupStatus == GroupStatusReport) {
        //上报中收到呼叫
        [_maxKit rejectCall:callId];
        return;
    }
    if (self.groupStatus == GroupStatusCall) {
        [_maxKit rejectCall:callId];
        return;
    }
    self.groupStatus = GroupStatusCall;
    NSString *title;
    if (callType==0) {
        title = @"管理员对您发起视频呼叫是否同意？";
    }else{
        title = @"管理员对您发起音频呼叫是否同意？";
    }
    WEAKSELF;
    RMAlertView *alert = [[RMAlertView alloc] initWithTitle:@"" contentTitle:title otherButtonTitles:@[] withBlock:^(NSInteger buttonIndex) {
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (buttonIndex) {
                [strongSelf.maxKit acceptCall:callId];
                if (callType==0) {
                    RMVideoView *videoView = [[RMVideoView alloc] init];
                    videoView.pubID = @"Video_MySelf";
                    // 视频呼叫
                    [strongSelf.maxKit setLocalVideoCapturer:videoView.videoView option:nil];
                    [strongSelf.videoArr addObject:videoView];
                    strongSelf.callVc = nil;
                    strongSelf.callVc.videoArr = strongSelf.videoArr;
                    strongSelf.callVc.callType = RMCallVideoType;
                    
                }else{
                    strongSelf.callVc.callType = RMCallAudioType;
                }
                strongSelf.callVc.maxKit = self.maxKit;
                [[RMCommons topViewController] presentViewController:weakSelf.callVc animated:YES completion:nil];
            } else {
                //拒绝
                [strongSelf->_maxKit rejectCall:callId];
                weakSelf.groupStatus = GroupStatusNone;
            }
        }
    }];
    alert.callId = callId;
    [alert show];
    
//    [self.maxKit acceptCall:strCallId];
//    if (nCallType==0) {
//        RMVideoView *videoView = [[RMVideoView alloc] init];
//        videoView.pubID = @"Video_MySelf";
//        // 视频呼叫
//        [self.maxKit setLocalVideoCapturer:videoView.videoView option:nil];
//        [self.videoArr addObject:videoView];
//        self.callVc = nil;
//        self.callVc.videoArr = self.videoArr;
//        self.callVc.callType = RMCallVideoType;
//
//    }else{
//        self.callVc.callType = RMCallAudioType;
//    }
//     self.callVc.maxKit = self.maxKit;
//
//    [[RMCommons topViewController] presentViewController:self.callVc animated:YES completion:nil];
//
    //拒绝
    //[self.maxKit rejectCall:strCallId];
}
- (void)onRTCEndCall:(NSString*)callId userId:(NSString*)userId code:(ARMaxCode)code {
    
}
-(void)onRTCOpenRemoteVideoRender:(NSString*)peerId pubId:(NSString *)pubId userId:(NSString*)userId userData:(NSString*)userData {
    NSLog(@"onRTCOpenRemoteVideoRender:%@ pubId:%@ userId:%@ userData:%@",peerId,pubId,userId,userData);
    if (self.groupStatus == GroupStatusCall) {
        RMVideoView *videoView = [[RMVideoView alloc] init];
        [self.maxKit setRemoteVideoRender:videoView.videoView pubId:pubId];
        videoView.pubID = pubId;
        videoView.userID = userId;
        [self.videoArr addObject:videoView];
        self.callVc.videoArr = self.videoArr;
        [self.callVc refreshLayout];
    }
}
-(void)onRTCCloseRemoteVideoRender:(NSString*)peerId pubId:(NSString *)pubId userId:(NSString*)userId{
    // 被呼叫的
    if (self.groupStatus == GroupStatusCall) {
        //通话的
        [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RMVideoView *rmVideoView = (RMVideoView *)obj;
            if ([rmVideoView.pubID isEqualToString:pubId]) {
                [rmVideoView removeFromSuperview];
                [self.videoArr removeObject:rmVideoView];
                *stop = YES;
            }
        }];
        // 被邀请通话的人员判断是否通话结束
        WEAKSELF;
        [self.callVc leaveEvent:^(BOOL isOk) {
            if (isOk) {
                weakSelf.groupStatus = GroupStatusNone;
            }
        }];
    }
}
-(void) onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size {
    
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RMVideoView *rmVideoView = (RMVideoView *)obj;
        if (rmVideoView.videoView == videoView) {
            rmVideoView.videoSize = size;
            *stop = YES;
        }
    }];
}
- (void)onRTCOpenRemoteAudioTrack:(NSString*)peerId userId:(NSString *)userId userData:(NSString*)userData {
    if (self.groupStatus == GroupStatusCall) {
        RMVideoView *videoView = [[RMVideoView alloc] init];
        videoView.userID = userId;
        [self.videoArr addObject:videoView];
        self.callVc.videoArr = self.videoArr;
        [self.callVc refreshLayout];
    }
}
- (void)onRTCCloseRemoteAudioTrack:(NSString*)peerId userId:(NSString *)userId {
    //通话的
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RMVideoView *rmVideoView = (RMVideoView *)obj;
        if ([rmVideoView.userID isEqualToString:userId]) {
            if (rmVideoView.superview) {
                 [rmVideoView removeFromSuperview];
            }
            [self.videoArr removeObject:rmVideoView];
            *stop = YES;
        }
    }];
    // 被邀请通话的人员判断是否j通话结束
    WEAKSELF;
    [self.callVc leaveEvent:^(BOOL isOk) {
        if (isOk) {
            if (weakSelf.groupStatus != GroupStatusMonitor) {
                 weakSelf.groupStatus = GroupStatusNone;
            }
        }
    }];
}
-(void)onRTCAVStatus:(NSString*) strRTCPeerId audio:(BOOL)bAudio video:(BOOL)bVideo {
    
}
- (void)onRTCNetworkStatus:(NSString*)strRTCPeerId userId:(NSString *)strUserId netSpeed:(int)nNetSpeed packetLost:(int)nPacketLost {
    
}
#pragma mark - 录音录像地址回调
- (void)onRTCGotRecordFile:(int)nRecordType userData:(NSString*)strUserData filePath:(NSString*)strFilePath {
    
}
#pragma mark - 消息相关回调
- (void)onRTCUserMessage:(NSString*)strUserId userName:(NSString*)strUserName userHeader:(NSString*)strUserHeaderUrl content:(NSString*)strContent {
    //本地预览
    RMMessageModel *messageItem = [[RMMessageModel alloc] init];
    messageItem.userID = strUserId;
    messageItem.messageStr = strContent;
    messageItem.isMe = NO;
    [self.messageView sendMessage:messageItem];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
