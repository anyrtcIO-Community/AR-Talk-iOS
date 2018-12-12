//
//  RMCallViewController.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RMCallType) {
    RMCallVideoType = 0,
    RMCallAudioType = 1,
};

@interface RMCallViewController : BaseViewController

@property (nonatomic, strong) RTMaxKit *maxKit;

@property (nonatomic, strong) NSMutableArray *videoArr;

//当前呼叫类型
@property (nonatomic, assign) RMCallType callType;

- (void)refreshLayout;

//呼叫中收到监看
- (void)dismiss;

//主播离开了，游客的处理
typedef void(^LeaveByBlock)(BOOL isOk);
- (void)leaveEvent:(LeaveByBlock)block;

@end

NS_ASSUME_NONNULL_END
