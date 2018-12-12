//
//  RATalkbackViewController.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/24.
//  Copyright © 2018 derek. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,GroupStatus) {
    GroupStatusNone,
    //呼叫或者被呼叫状态
    GroupStatusCall,
    //P2P状态回调
    GroupStatusP2P,
    //被监看状态
    GroupStatusMonitor,
    //自己在上报状态
    GroupStatusReport,
};

@interface RATalkbackViewController : BaseViewController

// 状态
@property (nonatomic, assign) GroupStatus groupStatus;

@end

NS_ASSUME_NONNULL_END
