//
//  RMVideoView.m
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import "RMVideoView.h"

@interface RMVideoView()


@end

@implementation RMVideoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.videoView = [UIView new];
        self.videoView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.videoView];
        [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        
        
    }
    return self;
}

- (void)setVideoSize:(CGSize)videoSize {
    _videoSize = videoSize;
    if (videoSize.width>videoSize.height) {
        [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.videoView.mas_width).multipliedBy(videoSize.height/videoSize.width);
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
