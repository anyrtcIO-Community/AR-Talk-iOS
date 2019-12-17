//
//  RASpeakButton.m
//  RTMaxAudio
//
//  Created by derek on 2018/6/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "RASpeakButton.h"

@interface RASpeakButton()

// rob
@property (nonatomic, strong) UIButton *speakButton;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, assign) BOOL isSpeaking;

// tap
@property (nonatomic, strong) UIImageView *mirrorImageView;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) NSMutableArray *picArray;

@end

@implementation RASpeakButton

- (void)setStateButton:(ButtonStateType)stateButton {
    
    self.isSpeaking = NO;
    
    _stateButton = stateButton;
    if (_stateButton == ButtonStateRobType) {
        //抢麦模式
        if (_mirrorImageView) {
            _mirrorImageView.hidden = YES;
            self.tap.enabled = NO;
        }
        [self creatUI];
    } else {
        //点击说话模式
        if (self.bgImageView) {
            self.bgImageView.hidden = YES;
            [self.speakButton removeFromSuperview];
            self.speakButton = nil;
        }
        [self createMirrorImageView];
        if (!self.picArray) {
            self.picArray = [[NSMutableArray alloc] initWithCapacity:4];
            for (int i = 1; i < 6; i ++) {
                NSString *imageName = [NSString stringWithFormat:@"audio_tap_%d",i];
                UIImage *image =  [UIImage imageNamed:imageName];
                [self.picArray addObject:image];
            }
        }
    }
}

- (void)createMirrorImageView {
    self.backgroundColor = [UIColor clearColor];
    WEAKSELF;
    self.mirrorImageView = [[UIImageView alloc] init];
    [self addSubview:self.mirrorImageView];
    self.mirrorImageView.image = [UIImage imageNamed:@"no_audio_tap"];
    [self.mirrorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.height.equalTo(@60);
        make.width.equalTo(@60);
    }];
    
    if (!self.tap) {
        self.tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tap];
        [self.tap addTarget:self action:@selector(tapEvent:)];
    } else {
        self.tap.enabled = YES;
    }
}

- (void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    WEAKSELF;
    self.bgImageView = [[UIImageView alloc] init];
    [self addSubview:self.bgImageView];
    self.bgImageView.image = [UIImage imageNamed:@"speakVolume"];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.width.equalTo(weakSelf);
        make.height.equalTo(weakSelf);
    }];
    
    self.speakButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.speakButton];
    [self.speakButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.height.equalTo(weakSelf);
        make.width.equalTo(weakSelf);
    }];
    [self.speakButton setBackgroundImage:[UIImage imageNamed:@"audio_default"] forState:UIControlStateNormal];
    [self.speakButton setBackgroundImage:[UIImage imageNamed:@"audio_active"] forState:UIControlStateHighlighted];
    [self addEvent];
}

//根据音量变化大小
- (void)setVolumeLeave:(int)volume {
    return;
    //点击说话模式
    if (_stateButton == ButtonStateTapType) {
        if (volume != 0) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(deleteGif:) object:nil];
            self.mirrorImageView.animationImages = self.picArray;
            
            self.mirrorImageView.animationDuration = 0.5;
            
            [self.mirrorImageView startAnimating];
            
            [self performSelector:@selector(deleteGif:) withObject:nil afterDelay:1];
        }
    } else {
        if (!self.isSpeaking) {
            [self reset];
            return;
        }
        int withHeight = 60+volume*4;
        
        CGFloat widthMax = [UIScreen mainScreen].bounds.size.width/4*3;
        if (withHeight>widthMax) {
            withHeight = widthMax;
        }
        WEAKSELF;
        [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf);
            make.height.equalTo(@(withHeight));
            make.width.equalTo(@(withHeight));
        }];
        [UIView animateWithDuration:0.4 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)deleteGif:(id)object {
    [self.mirrorImageView stopAnimating];
    self.mirrorImageView.animationImages = nil;
    if (!self.isSpeaking) {
        self.mirrorImageView.image = [UIImage imageNamed:@"no_audio_tap"];
    }
}

- (void)reset {
    WEAKSELF;
    if (!self.isSpeaking) {
        return;
    }
    self.isSpeaking = NO;
    
    if (_stateButton == ButtonStateTapType) {
        [_mirrorImageView stopAnimating];
        _mirrorImageView.animationImages = nil;
        return;
    }
    
    [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.height.equalTo(weakSelf);
        make.width.equalTo(weakSelf);
    }];
    
    [UIView animateWithDuration:.2 animations:^{
      [self layoutIfNeeded];
    }];
    //高亮结束
    self.speakButton.highlighted = NO;
}

- (void)addEvent {
    [self.speakButton addTarget:self action:@selector(speakTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.speakButton addTarget:self action:@selector(speakTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.speakButton addTarget:self action:@selector(speakTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.speakButton addTarget:self action:@selector(speakTouchDragEnter) forControlEvents:UIControlEventTouchDragEnter];
    [self.speakButton addTarget:self action:@selector(speakTouchDragInside) forControlEvents:UIControlEventTouchDragInside];
    [self.speakButton addTarget:self action:@selector(speakTouchDragOutside) forControlEvents:UIControlEventTouchDragOutside];
    [self.speakButton addTarget:self action:@selector(speakTouchDragExit) forControlEvents:UIControlEventTouchDragExit];
    [self.speakButton addTarget:self action:@selector(speakTouchCancle) forControlEvents:UIControlEventTouchCancel];
}

#pragma mark - 事件

- (void)tapEvent:(UITapGestureRecognizer*)event {
    self.isSpeaking = !self.isSpeaking;
    !self.isSpeaking ? (self.mirrorImageView.image = [UIImage imageNamed:@"no_audio_tap"]) : (self.mirrorImageView.image = [UIImage imageNamed:@"audio_tap_1"]);
    if (self.speakEventBlock) {
        self.speakEventBlock(self.isSpeaking);
    }
}

- (void)speakTouchCancle {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self reset];
    if (self.speakTouchUpOutsideAction) {
        self.speakTouchUpOutsideAction(self);
    }
}

- (void)speakTouchDown {
     [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    if (self.isSpeaking) {
        return;
    }
    NSLog(@"speakTouchDown");
    self.isSpeaking = YES;
    if (self.speakTouchDownAction) {
        self.speakTouchDownAction(self);
    }
}

- (void)speakTouchUpOutside {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self reset];
    if (self.speakTouchUpOutsideAction) {
        self.speakTouchUpOutsideAction(self);
    }
}

- (void)speakTouchUpInside {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self reset];
    if (self.speakTouchUpInsideAction) {
        self.speakTouchUpInsideAction(self);
    }
}

- (void)speakTouchDragEnter {
    if (self.speakTouchDragEnterAction) {
        self.speakTouchDragEnterAction(self);
    }
}

- (void)speakTouchDragInside {
    if (self.speakTouchDragInsideAction) {
        self.speakTouchDragInsideAction(self);
    }
}

- (void)speakTouchDragOutside {
    if (self.speakTouchDragOutsideAction) {
        self.speakTouchDragOutsideAction(self);
    }
}

- (void)speakTouchDragExit {
    if (self.speakTouchDragExitAction) {
        self.speakTouchDragExitAction(self);
    }
}

@end
