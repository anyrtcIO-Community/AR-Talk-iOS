//
//  RMNetManager.h
//  RTMaxAudio
//
//  Created by zjq on 2019/12/16.
//  Copyright © 2019 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RMNetType) {
    RMNetTypeNoNet = 0,
    RMNetTypeWiFi,
    RMNetType2G,
    RMNetType3G,
    RMNetType4G,
    
};

@interface RMNetManager : NSObject


@property (nonatomic, assign) RMNetType netType;

+ (instancetype)shard;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
