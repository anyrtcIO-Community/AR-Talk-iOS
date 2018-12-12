//
//  RMCallViewController.m
//  RTMaxAudio
//
//  Created by zjq on 2018/10/25.
//  Copyright © 2018 derek. All rights reserved.
//

#import "RMCallViewController.h"

@interface RMCallViewController ()

@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *idSubLabel;


@end

@implementation RMCallViewController

- (IBAction)doEvent:(UIButton*)sender {
    switch (sender.tag) {
        case 200:
            [self dismiss];
            break;
        case 201:
            [self.maxKit switchCamera];
            break;
        default:
            break;
    }
}

- (void)leaveEvent:(LeaveByBlock)block {
//    [RMCommons showCenterWithText:@"会话已结束"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
    block(YES);
}

- (void)refreshLayout{
   // 视频呼叫
    if (self.callType == RMCallVideoType) {
        if (self.videoArr.count == 2) {
            RMVideoView *video = [self.videoArr lastObject];
            [self.view insertSubview:video atIndex:1];
            [video mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(-120);
                make.centerX.equalTo(self.view.mas_centerX);
                make.width.equalTo(@(SCREEN_WIDTH/3.5));
                make.height.equalTo(video.mas_width).multipliedBy(1.333);
            }];
        }
    }else{
        //音频呼叫
        RMVideoView *video = [self.videoArr firstObject];
        self.idLabel.text = video.userID;
    }
  
}

- (void)dismiss{
    [self.maxKit leaveCall];
    
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RMVideoView *videoView = (RMVideoView *)obj;
        [videoView removeFromSuperview];
    }];
    [self.videoArr removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.callType == RMCallVideoType) {
        [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[RMVideoView class]]) {
                RMVideoView *videoView = (RMVideoView *)obj;
                if ([videoView.pubID isEqualToString:@"Video_MySelf"]) {
                    [self.view insertSubview:videoView atIndex:0];
                    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];
                    *stop = YES;
                }
            }
        }];
    }else{
        self.switchButton.hidden = YES;
        self.view.backgroundColor = [RMCommons getColor:@"#22C485"];
       
        self.idLabel = [UILabel new];
        self.idLabel.text = @"3324";
        self.idLabel.textColor = [UIColor whiteColor];
        self.idLabel.font = [UIFont boldSystemFontOfSize:27];
        self.idLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.idLabel];
        [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.4);
        }];
        
        self.idSubLabel = [UILabel new];
        self.idSubLabel.textColor = [RMCommons getColor:@"#FFFFFF"];
        self.idSubLabel.font = [UIFont boldSystemFontOfSize:11];
        self.idSubLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.idSubLabel];
        self.idSubLabel.text = @"用户ID";
        [self.idSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.idLabel.mas_bottom).offset(10);
        }];
        
        UIImageView *headImageView = [[UIImageView alloc] init];
        headImageView.image = [UIImage imageNamed:@"语音通话图"];
        [self.view addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.width.equalTo(self.view.mas_width).multipliedBy(0.33);
            make.height.equalTo(headImageView.mas_width);
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
