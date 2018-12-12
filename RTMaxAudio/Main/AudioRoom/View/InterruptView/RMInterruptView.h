//
//  RMInterruptView.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/30.
//  Copyright © 2018 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RMInterruptView : UIView

@property (nonatomic, strong) NSString *userID;

- (void)dismiss;

- (void)show;

@end

NS_ASSUME_NONNULL_END
