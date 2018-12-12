//
//  RMMessageModel.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RMMessageModel : NSObject

@property (nonatomic, assign) BOOL isMe;

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *messageStr;

@end

NS_ASSUME_NONNULL_END
