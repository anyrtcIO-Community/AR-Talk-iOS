//
//  RMMessageView.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMessageModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface RMMessageView : UIView

- (void)sendMessage:(RMMessageModel*)message;

@end

NS_ASSUME_NONNULL_END
