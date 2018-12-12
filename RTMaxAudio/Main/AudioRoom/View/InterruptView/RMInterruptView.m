//
//  RMInterruptView.m
//  RTMaxAudio
//
//  Created by zjq on 2018/10/30.
//  Copyright © 2018 derek. All rights reserved.
//

#import "RMInterruptView.h"
@interface RMInterruptView()

@property (nonatomic, strong) UIView *backView;
//倒计时
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation RMInterruptView

- (void)setUserID:(NSString *)userID {
    _userID = userID;
    self.titleLabel.text = [NSString stringWithFormat:@"%@正在与你强插对讲",userID];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
        self.backView = [[UIView alloc]init];
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:self.backView];
        
        CGFloat width = SCREEN_WIDTH/2;
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(width));
        }];
        
        UIImageView *iamgeView = [UIImageView new];
        NSMutableArray *iamgeArray = [[NSMutableArray alloc] init];
        for (int i =0; i<6; i++) {
            NSString *imageTitle = [NSString stringWithFormat:@"语音聊天_%d",i];
            [iamgeArray addObject:[UIImage imageNamed:imageTitle]];
        }
        iamgeView.animationImages = iamgeArray;
        iamgeView.animationDuration = 0.6;
        [iamgeView startAnimating];
        
        [self.backView addSubview:iamgeView];
        [iamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView.mas_centerX);
            make.centerY.equalTo(self.backView.mas_centerY).multipliedBy(0.9);
            make.width.equalTo(self.backView.mas_width).multipliedBy(.3);
            make.height.equalTo(iamgeView.mas_width).multipliedBy(32.0/22.0);
        }];
        
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.text = @"管理员对您发起视频呼叫是否同意？";
        self.titleLabel.textColor = [RMCommons getColor:@"#FFFFFF"];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.backView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iamgeView.mas_bottom).offset(10);
            make.centerX.equalTo(self.backView.mas_centerX);
            make.bottom.equalTo(self.backView.mas_bottom).offset(-15);
        }];
        
    }
    return self;
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        CAKeyframeAnimation * animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.15;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        [self.backView.layer addAnimation:animation forKey:nil];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if( ![self checkSpeakerOn]) {
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
    NSString *cate = [AVAudioSession sharedInstance].category;
    NSLog(@"category:%@",cate);
}
- (BOOL)checkSpeakerOn
{
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    if((route == NULL) || (CFStringGetLength(route) == 0))
    {
        // Silent Mode
    }
    else
    {
        NSString* routeStr = (__bridge_transfer NSString*)route;
        NSRange speakerRange = [routeStr rangeOfString : @"Speaker"];
        if (speakerRange.location != NSNotFound) {
             NSLog(@"checkSpeakerOn:打开了");
             return YES;
        }else{
             NSLog(@"checkSpeakerOn:关闭了");
            return NO;
        }
    }
    NSLog(@"checkSpeakerOn:没打开");
    return NO;
}
- (void)dismiss{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
