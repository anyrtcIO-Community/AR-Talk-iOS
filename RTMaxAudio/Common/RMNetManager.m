//
//  RMNetManager.m
//  RTMaxAudio
//
//  Created by zjq on 2019/12/16.
//  Copyright © 2019 derek. All rights reserved.
//

#import "RMNetManager.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface RMNetManager()

@property (nonatomic , strong) Reachability *hostReachability;


@end

@implementation RMNetManager

static RMNetManager *manager = NULL;
+ (instancetype)shard {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RMNetManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hostReachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        __weak typeof(RMNetManager)*weakSelf = self;
        _hostReachability.reachableBlock = ^(Reachability *reachability) {
            
        };
    }
    return self;
}

//网络监控
- (void)start {
    
}


- (void)stop {
    
}
@end
