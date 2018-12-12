//
//  RMAlertView.m
//  Talkback
//
//  Created by jh on 2018/8/22.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "RMAlertView.h"

@interface RMAlertView ()

@property (nonatomic, strong) UIView *backView;
//倒计时
@property (nonatomic, strong) UILabel *countdownLabel;
//同意
@property (nonatomic, strong) UIButton *acceptButton;
//拒绝
@property (nonatomic, strong) UIButton *rejectButton;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, copy) UIAlertBlock alertBlock;

@property (nonatomic, copy) NSString *contentStr;

@end

@implementation RMAlertView
//间距
static CGFloat const margin_Padding = 25;
//宽度
static CGFloat const alert_Width = 280;

- (instancetype _Nullable )initWithTitle:(NSString *_Nullable)title contentTitle:(NSString *_Nullable)contentTitle otherButtonTitles:(nullable NSArray *)otherButtonTitles withBlock:(UIAlertBlock _Nullable )tapBlock {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.contentStr = contentTitle;
        self.alertBlock = tapBlock;
        [self initializeAlertView];
    }
    return self;
}

- (void)initializeAlertView {
    self.backView = [[UIView alloc]init];
    self.backView.layer.cornerRadius = 8;
    self.backView.layer.masksToBounds = YES;
    self.backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(alert_Width));
    }];
    
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.numberOfLines = 2;
    messageLabel.text =self.contentStr;// @"管理员对您发起视频呼叫是否同意？";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.font = [UIFont boldSystemFontOfSize:16];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.backView addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(40);
        make.right.equalTo(self.backView).offset(-margin_Padding);
    }];
    
    //底部
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = RGBA(200, 200, 200, 1);
    [self.backView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.backView);
        make.height.equalTo(@(50));
        make.top.equalTo(messageLabel.mas_bottom).offset(margin_Padding);
    }];
    
    self.rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rejectButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rejectButton.backgroundColor = [UIColor whiteColor];
    [self.rejectButton setTitle:@"拒绝(30s)" forState:UIControlStateNormal];
    [self.rejectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.rejectButton addTarget:self action:@selector(doSomethingEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.rejectButton];
    [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(1);
        make.left.bottom.equalTo(bottomView);
        make.width.equalTo(@(alert_Width/2));
    }];
    
    self.acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.acceptButton.tag = 1;
    self.acceptButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.acceptButton.backgroundColor = [UIColor whiteColor];
    [self.acceptButton setTitle:@"同意" forState:UIControlStateNormal];
    [self.acceptButton setTitleColor:RGB(21, 126, 251) forState:UIControlStateNormal];
    [self.acceptButton addTarget:self action:@selector(doSomethingEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.acceptButton];
    [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(1);
        make.left.equalTo(self.rejectButton.mas_right).offset(1);
        make.bottom.equalTo(bottomView);
        make.width.equalTo(@(alert_Width/2));
    }];
}

- (void)doSomethingEvent:(UIButton *)sender{
    if (self.alertBlock) {
        self.alertBlock(sender.tag);
    }
    [self removeAlertView];
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
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    NSTimeInterval seconds = 30;
    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:seconds];
    
    dispatch_source_set_event_handler(self.timer, ^{
        int interval = [endTime timeIntervalSinceNow];
        if (interval > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rejectButton setTitle:[NSString stringWithFormat:@"拒绝(%ds)",interval] forState:UIControlStateNormal];
            });
        } else { // 倒计时结束，关闭
            if (self.alertBlock) {
                self.alertBlock(0);
            }
            [self removeAlertView];
        }
    });
    dispatch_resume(self.timer);
}

- (void)removeAlertView{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

@end
