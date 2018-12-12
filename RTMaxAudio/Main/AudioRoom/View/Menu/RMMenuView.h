//
//  RMMenuView.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RMMenuView : UIView
typedef void(^MediaEventBlock)(NSString*userID);
typedef void(^MessageEventBlock)(NSString*messageStr);

@property (nonatomic, copy)MediaEventBlock mediaBlock;
@property (nonatomic, copy)MessageEventBlock messageBlock;


@end

NS_ASSUME_NONNULL_END
