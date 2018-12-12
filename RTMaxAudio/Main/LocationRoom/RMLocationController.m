//
//  RMLocationController.m
//  RTMaxAudio
//
//  Created by jh on 2018/6/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "RMLocationController.h"
#import "RASpeakButton.h"
#import "RMOperationView.h"

@interface RMLocationController ()<MAMapViewDelegate,RTMaxKitDelegate>{
    RTMaxKit *_maxKit;
    //地图
    MAMapView *_mapView;
    //自己
    RMMapAnnotationView *_userLocationAnnotationView;
    //自己标注
    MAUserLocation *_userAnimatedAnnotation;
    //当前自己位置
    CLLocationCoordinate2D _coordinate2D;
    
    NSArray <MAAnimatedAnnotation *> *_dataArr;
    
    UIButton *_positionButton;

    //中心点
    NSInteger _index;
    
    dispatch_source_t _timer;
    //位置
    NSMutableArray *_arr;
    
    RMOperationView *_operationView;
    
    RASpeakButton *_audioButtonView;
    
    BOOL _isOtherSpeaking;
}

@end

@implementation RMLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArr = [NSMutableArray arrayWithCapacity:10];
    _arr = [NSMutableArray arrayWithCapacity:100];
    //地图
    [self initializeMapView];

    [self initializeInterface];

    _positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _positionButton.frame = CGRectMake(15, CGRectGetHeight(self.view.frame) - 80, 45, 45);
    [_positionButton addTarget:self action:@selector(setCenterCoordinate) forControlEvents:UIControlEventTouchUpInside];
    [_positionButton setImage:[UIImage imageNamed:@"image_location"] forState:UIControlStateNormal];
    [self.view insertSubview:_positionButton aboveSubview:_mapView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive) name:EnterForeground object:nil];
}

- (void)applicationDidBecomeActive{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法获取你的位置信息。请到手机系统中的[设置]打开定位权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL success) {
                    }];
                } else {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
        }];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self leaveRoom];
        }];
        [alert addAction:action];
        [alert addAction:cancle];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)initializeMaxKit{
    //实例化
    _maxKit = [[RTMaxKit alloc]initWithDelegate:self];

    NSDictionary *dict  = [[NSDictionary alloc] initWithObjectsAndKeys:RMUser.fetchUserInfo.userId,@"userId",RMUser.fetchUserInfo.nickName,@"nickName",RMUser.fetchUserInfo.headImage,@"headImage",nil];
    //加入讨论组
    [_maxKit joinTalkGroup:@"88888888" userId:RMUser.fetchUserInfo.userId userData:[RMCommons fromDicToJSONStr:dict]];
}

- (void)initializeInterface{
    WEAKSELF;
    _audioButtonView = [[RASpeakButton alloc]init];
    _audioButtonView.frame = CGRectMake(CGRectGetWidth(self.view.frame) /2 - 30, CGRectGetHeight(self.view.frame) - 100, 60, 60);
    [self.view insertSubview:_audioButtonView aboveSubview:_mapView];

    //顶部
    _operationView = [[RMOperationView alloc]init];
    _operationView.frame = CGRectMake(0, 0,CGRectGetWidth(self.view.frame), 108);
    [self.view insertSubview:_operationView aboveSubview:_mapView];
    
    //按下
    _audioButtonView.speakTouchDownAction = ^(RASpeakButton *recordButton) {
        RMLocationController *strongSelf = weakSelf;
        if (strongSelf->_isOtherSpeaking) {
            [[RMMusicPlayer sharedInstance] playUp];
        }else{
            [[RMMusicPlayer sharedInstance] playUp];
            [strongSelf->_maxKit applyTalk:0];
            [weakSelf message:TipMessageTypePrepareSpeaking withHeadImage:RMUser.fetchUserInfo.headImage withNickName:RMUser.fetchUserInfo.nickName withLineNum:nil];
        }
    };
    
    //松手
    _audioButtonView.speakTouchUpInsideAction = ^(RASpeakButton *sender){
        RMLocationController *strongSelf = weakSelf;
        if (!strongSelf->_isOtherSpeaking) {
            [[RMMusicPlayer sharedInstance] playOver];
            [strongSelf->_maxKit cancleTalk];
            [weakSelf message:TipMessageTypeSpeakingEnd withHeadImage:nil  withNickName:nil withLineNum:nil];
            
            //倒计时结束
            if (strongSelf->_operationView) {
                [strongSelf->_operationView stopCount];
            }
        }
    };
    
    //类似松手
    _audioButtonView.speakTouchUpOutsideAction = ^(RASpeakButton *recordButton) {
        RMLocationController *strongSelf = weakSelf;
        if (!strongSelf->_isOtherSpeaking) {
            [[RMMusicPlayer sharedInstance] playOver];
            [strongSelf->_maxKit cancleTalk];
            [weakSelf message:TipMessageTypeSpeakingEnd withHeadImage:nil  withNickName:nil withLineNum:nil];
            //倒计时结束
            if (strongSelf->_operationView) {
                [strongSelf->_operationView stopCount];
            }
        }
    };
    
    _operationView.closeBlock = ^{
        RMLocationController *strongSelf = weakSelf;
        if (strongSelf->_maxKit) {
            [strongSelf->_maxKit leaveTalkGroup];
        }
        [weakSelf leaveRoom];
    };
    
    _operationView.timeOverBlock = ^{
        RMLocationController *strongSelf = weakSelf;
        if (strongSelf->_maxKit) {
            [[RMMusicPlayer sharedInstance] playOver];
            [strongSelf->_maxKit cancleTalk];
            [weakSelf message:TipMessageTypeSpeakingEnd withHeadImage:nil  withNickName:nil withLineNum:nil];
        }
    };
    
}

- (void)leaveRoom{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"type",nil];
    [_maxKit sendUserMessage:@"RTMAX" userHeader:RMUser.fetchUserInfo.headImage content:[RMCommons fromDicToJSONStr:dic]];
    [_maxKit leaveTalkGroup];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendLocationInformation{
    //10s发送一次位置信息
    //检测一下是否有数据，没数据先用最后一次定位的数据
    if (_arr.count == 0) {
        [_arr addObject:[NSNumber numberWithDouble:_coordinate2D.latitude]];
        [_arr addObject:[NSNumber numberWithDouble:_coordinate2D.longitude]];
    }

    NSMutableArray *infoArr = [_arr copy];
    [_arr removeAllObjects];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:infoArr,@"path",[NSNumber numberWithInt:1],@"type",nil];
    [_maxKit sendUserMessage:@"RTMAX" userHeader:RMUser.fetchUserInfo.headImage content:[RMCommons fromDicToJSONStr:dic]];
}

//设置中心坐标点
- (void)setCenterCoordinate{
    //中心坐标点
    _mapView.centerCoordinate = _coordinate2D;
    [_mapView setZoomLevel:16 animated:YES];
}

// MARK: - MapView

- (void)initializeMapView {
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    //后台定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.rotateEnabled = NO;
    _mapView.showsBuildings = NO;
    
    //最小更新距离
    _mapView.distanceFilter = kCLLocationAccuracyHundredMeters;
    
    _mapView.delegate = self;
    
    //比例尺
    _mapView.showsScale = YES;
    _mapView.scaleOrigin= CGPointMake(10, CGRectGetHeight(_mapView.frame) - 30);
    _mapView.showsCompass = NO;
    //缩放手势
    _mapView.zoomEnabled = YES;
    //地图的缩放级别的范围是[3-19]
    [_mapView setZoomLevel:16 animated:YES];
    
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;
    [_mapView updateUserLocationRepresentation:r];
    
    //隐藏logo
    [_mapView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView * logoM = obj;
            logoM.layer.contents = (__bridge id)[UIImage imageNamed:@""].CGImage;
            *stop = YES;
        }
    }];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    //位置或者设备方向更新后，会调用此函数
    _coordinate2D = (CLLocationCoordinate2D){userLocation.coordinate.latitude,userLocation.coordinate.longitude};
    if (_index == 0 && _coordinate2D.latitude != 0) {
        _mapView.centerCoordinate = _coordinate2D;
        //实例化抢麦对象
        [self initializeMaxKit];
        WEAKSELF;
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 10 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            [weakSelf sendLocationInformation];
        });
        dispatch_resume(_timer);
        _index ++ ;
    }

    [_arr addObject:[NSNumber numberWithDouble:userLocation.location.coordinate.latitude]];
    [_arr addObject:[NSNumber numberWithDouble:userLocation.location.coordinate.longitude]];
    //NSLog(@"--%f--%f-",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

    if (!updatingLocation && _userLocationAnnotationView != nil) {
        //旋转
        [UIView animateWithDuration:0.1 animations:^{

            double degree = userLocation.heading.trueHeading - self ->_mapView.rotationDegree;
            self->_userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f);
        }];
    }
}

//大头针、气泡
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        //复用标识
        NSString *pointReuseIndetifier = @"myReuseIndetifier";
        //自定义
        RMMapAnnotationView *annotationView = (RMMapAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (!annotationView) {
            annotationView = [[RMMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.image = [UIImage imageNamed:@"image_tourists"];
        }
        annotationView.draggable = NO;

        if ([annotation isKindOfClass:[MAUserLocation class]]) {
            annotationView.image = [UIImage imageNamed:@"image_me"];
            _userLocationAnnotationView = annotationView;
            _userAnimatedAnnotation = (MAUserLocation *)annotation;
        }

        return annotationView;
    }
    return nil;
}

// MARK: - RTMaxKitDelegate

- (void)onRTCJoinTalkGroupOK:(NSString *)strGroupId{
    //加入对讲组成功/切换对讲组成功
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@[[NSNumber numberWithDouble:_coordinate2D.latitude],[NSNumber numberWithDouble:_coordinate2D.longitude]],@"position",[NSNumber numberWithInt:0],@"type",nil];
    [_maxKit sendUserMessage:@"RTMAX" userHeader:RMUser.fetchUserInfo.headImage content:[RMCommons fromDicToJSONStr:dic]];
}

- (void)onRTCJoinTalkGroupFailed:(NSString*)strGroupId code:(int)nCode{
    //加入对讲组失败/切换对讲组失败
}

- (void)onRTCLeaveTalkGroup:(int)nCode{
    //离开对讲组
}

- (void)onRTCApplyTalkOk{
    //申请对讲成功
}

- (void)onRTCTalkCouldSpeak{
    //申请对讲成功之后，语音通道建立，可以开始讲话
    [[RMMusicPlayer sharedInstance] playScuess];
    [self message:TipMessageTypeSpeaking withHeadImage:RMUser.fetchUserInfo.headImage withNickName:@"我" withLineNum:nil];
    if (_operationView) {
        [_operationView startCount];
    }
}

- (void)onRtcApplyTalkStatus {

}

- (void)onRTCTalkOn:(NSString*)strUserId userData:(NSString*)strUserData{
    //其他人正在对讲组中讲话
    _isOtherSpeaking = YES;
    
    NSDictionary *jsonDict = [RMCommons fromJsonStr:strUserData];
    //别人上麦了
    [self message:TipMessageTypeSpeaking withHeadImage:[jsonDict objectForKey:@"headImage"]  withNickName:[jsonDict objectForKey:@"nickName"] withLineNum:nil];
}

- (void)onRTCTalkClosed:(int)nCode userId:(NSString*)strUserId userData:(NSString*)strUserData{
    //对讲结束
    _isOtherSpeaking = NO;
    
    NSDictionary *jsonDict = [RMCommons fromJsonStr:strUserData];
    //抢麦没权限
    if (nCode == 802) {
        return;
    } else {
        [self message:TipMessageTypeSpeakingEnd withHeadImage:[jsonDict objectForKey:@"headImage"]  withNickName:[jsonDict objectForKey:@"nickName"] withLineNum:nil];
    }
}

- (void)onRTCMemberNum:(int)nNum{
    //人员变化
    [self message:TipMessageTypeLine withHeadImage:nil withNickName:nil withLineNum:[NSString stringWithFormat:@"%d",nNum]];
}

- (void)onRTCUserMessage:(NSString*)strUserId userName:(NSString*)strUserName userHeader:(NSString*)strUserHeaderUrl content:(NSString*)strContent{
    //收到消息回调
    NSInteger count = 0;
    RMAnimatedAnnotation *animatedAnnotation;// = [[RMAnimatedAnnotation alloc]init];
    for (NSInteger i = 0; i < _mapView.annotations.count; i++) {
        id obj = _mapView.annotations[i];
        if ([obj isKindOfClass:[RMAnimatedAnnotation class]]) {
            RMAnimatedAnnotation *ann = (RMAnimatedAnnotation *)obj;
            if ([ann.userId isEqualToString:strUserId]) {
                count ++;
                animatedAnnotation = ann;
                [ann reset];
                break;
            }
        }
    }

    NSDictionary *dic = [RMCommons fromJsonStr:strContent];
    NSString *type = [dic objectForKey:@"type"];
    switch ([type intValue]) {
        case 0:
        {
            //定位消息
            NSArray *locationArr = [dic objectForKey:@"position"];
            if (locationArr.count == 2 && count == 0) {
                RMAnimatedAnnotation *annotation = [[RMAnimatedAnnotation alloc] init];
                WEAKSELF;
                annotation.leaveBlock = ^(RMAnimatedAnnotation *annotation) {
                    [weakSelf moveOverView:annotation];
                };
                annotation.userId = strUserId;
                annotation.coordinate = CLLocationCoordinate2DMake([locationArr[0] doubleValue],[locationArr[1] doubleValue]);
                [_mapView addAnnotation:annotation];
                [self showAllAnnotations];
            }
        }
            break;
        case 1:
        {
            //移动消息
            NSArray *pathArr = [dic objectForKey:@"path"];

            if (pathArr.count != 0) {
                //添加数据
                CLLocationCoordinate2D coordinate[pathArr.count/2];
                NSInteger idx = 0;
                for (NSInteger i = 0; i < pathArr.count; i++) {
                    if (i%2 == 0) {
                        coordinate[idx].latitude = [pathArr[i] doubleValue];
                        coordinate[idx].longitude = [pathArr[i+1] doubleValue];
                        idx++;
                    }
                }

                if (count == 0) {
                    RMAnimatedAnnotation *annotation = [[RMAnimatedAnnotation alloc] init];
                    WEAKSELF;
                    annotation.leaveBlock = ^(RMAnimatedAnnotation *annotation) {
                        [weakSelf moveOverView:annotation];
                    };
                    annotation.userId = strUserId;
                    annotation.coordinate = coordinate[0];
                    [_mapView addAnnotation:annotation];
                    [self showAllAnnotations];
                }

                [animatedAnnotation addMoveAnimationWithKeyCoordinates:coordinate count:sizeof(coordinate) / sizeof(coordinate[0]) withDuration:10.5 withName:nil completeCallback:^(BOOL isFinished) {

                }];
            }
        }
            break;
        default:
            break;
    }
}

- (void)showAllAnnotations{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_mapView.annotations];
    if (_userAnimatedAnnotation) {
        [arr addObject:_userAnimatedAnnotation];
    }
    [_mapView showAnnotations:arr animated:YES];
}

- (void)message:(TipMessageType)type withHeadImage:(NSString*)headImageStr withNickName:(NSString*)nickName withLineNum:(NSString*)lineNum{
    NSString *tipStr;
    switch (type) {
        case TipMessageTypePrepareSpeaking:
            tipStr = @"准备中...";
            break;
        case TipMessageTypeSpeaking:
            tipStr = [NSString stringWithFormat:@"%@正在发言",nickName];
            break;
        case TipMessageTypeSpeakingEnd:
            tipStr = [NSString stringWithFormat:@"%@下麦了",nickName];
            break;
        case TipMessageTypeSpeakingError:
            tipStr = [NSString stringWithFormat:@"当前正在有人上麦"];
            break;
        case TipMessageTypeLine:
            tipStr = [NSString stringWithFormat:@"%@人在共享位置",lineNum];
            break;
        case TipMessageTypeEnterTip:
            tipStr = [NSString stringWithFormat:@"%@进来啦",nickName];
            break;
        case TipMessageTypeOutTip:
            tipStr = [NSString stringWithFormat:@"%@离开啦",nickName];
            break;
        default:
            break;
    }
    MessageItem *item = [[MessageItem alloc] init];
    item.nickName = nickName;
    item.headImage = [UIImage imageNamed:headImageStr];
    item.tipStr = tipStr;
    item.tipType = type;
    
    _operationView.messageItem = item;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EnterForeground object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self applicationDidBecomeActive];
}

- (void)moveOverView:(RMAnimatedAnnotation*)annotation {
     [_mapView removeAnnotation:annotation];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
