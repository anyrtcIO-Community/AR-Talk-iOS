//
//  ARMaxOption.h
//  RTMaxEngine
//
//  Created by zjq on 2019/1/17.
//  Copyright © 2019 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARObjects.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARMaxOption : NSObject

/**
 使用默认配置生成一个 ARMaxOption 对象
 
 @return 生成的 ARMaxOption 对象
 */
+ (nonnull ARMaxOption *)defaultOption;

/**
 视频配置项
 */
@property (nonatomic, strong) ARVideoConfig *videoConfig;


@end

NS_ASSUME_NONNULL_END
