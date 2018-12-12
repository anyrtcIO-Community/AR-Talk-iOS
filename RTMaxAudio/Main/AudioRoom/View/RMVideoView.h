//
//  RMVideoView.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RMVideoView : UIView

// 视频显示
@property (nonatomic, strong) UIView *videoView;
// 用户ID
@property (nonatomic, strong) NSString *userID;
// 发布ID
@property (nonatomic, strong) NSString *pubID;
// 呼叫ID
@property (nonatomic, strong) NSString *callID;
// 视频大小
@property (nonatomic, assign) CGSize videoSize;

@end

NS_ASSUME_NONNULL_END
