//
//  RMReportViewController.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/29.
//  Copyright © 2018 derek. All rights reserved.
//

#import "BaseViewController.h"
#import "RMVideoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMReportViewController : BaseViewController

@property (nonatomic, strong) ARMaxKit *maxKit;
@property (nonatomic, strong) RMVideoView *videoView;
//上报中收到监看
- (void)dismiss;

//自己主动关掉上报
typedef void(^LeaveBlock)(void);
@property (nonatomic, copy) LeaveBlock leaveBlock;

@end

NS_ASSUME_NONNULL_END
