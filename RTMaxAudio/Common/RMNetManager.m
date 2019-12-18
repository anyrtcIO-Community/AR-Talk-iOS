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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange) name:kReachabilityChangedNotification object:nil];
        [_hostReachability startNotifier];
        
    }
    return self;
}

- (void)netChange{
    NetworkStatus status = [_hostReachability currentReachabilityStatus];
    if (status == NotReachable) {
        self.netType = RMNetTypeNoNet;
        return;
    }
    if (status == ReachableViaWiFi) {
         self.netType = RMNetTypeWiFi;
        return;
    }
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    RMNetType networkType = RMNetType4G;
    if ([info respondsToSelector:@selector(currentRadioAccessTechnology)]) {
        NSString *currentStatus = info.currentRadioAccessTechnology;
        NSArray *network2G = @[CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x];
        NSArray *network3G = @[CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD];
        NSArray *network4G = @[CTRadioAccessTechnologyLTE];
        
        if ([network2G containsObject:currentStatus]) {
            networkType = RMNetType2G;
        }else if ([network3G containsObject:currentStatus]) {
            networkType = RMNetType3G;
        }else if ([network4G containsObject:currentStatus]){
            networkType = RMNetType4G;
        }else {
            networkType = RMNetType4G;
        }
    }
    self.netType = networkType;
}


//网络监控
- (void)start {
    
}


- (void)stop {
    
}
@end
