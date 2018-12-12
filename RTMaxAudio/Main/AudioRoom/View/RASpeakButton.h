//
//  RASpeakButton.h
//  RTMaxAudio
//
//  Created by derek on 2018/6/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ButtonStateType ){
    ButtonStateRobType = 0,//抢麦模式
    ButtonStateTapType// 点击说话模式
};

@class RASpeakButton;

typedef void (^SpeakTouchDown)         (RASpeakButton *recordButton);
typedef void (^SpeakTouchUpOutside)    (RASpeakButton *recordButton);
typedef void (^SpeakTouchUpInside)     (RASpeakButton *recordButton);
typedef void (^SpeakTouchDragEnter)    (RASpeakButton *recordButton);
typedef void (^SpeakTouchDragInside)   (RASpeakButton *recordButton);
typedef void (^SpeakTouchDragOutside)  (RASpeakButton *recordButton);
typedef void (^SpeakTouchDragExit)     (RASpeakButton *recordButton);


typedef void (^SpeakButtonEventBlock)(BOOL isSelected);

@interface RASpeakButton : UIView

@property (nonatomic, copy) SpeakTouchDown         speakTouchDownAction;
@property (nonatomic, copy) SpeakTouchUpOutside    speakTouchUpOutsideAction;
@property (nonatomic, copy) SpeakTouchUpInside     speakTouchUpInsideAction;
@property (nonatomic, copy) SpeakTouchDragEnter    speakTouchDragEnterAction;
@property (nonatomic, copy) SpeakTouchDragInside   speakTouchDragInsideAction;
@property (nonatomic, copy) SpeakTouchDragOutside  speakTouchDragOutsideAction;
@property (nonatomic, copy) SpeakTouchDragExit     speakTouchDragExitAction;

//点下动作
@property (nonatomic, copy) SpeakButtonEventBlock speakEventBlock;

//状态
@property (nonatomic, assign) ButtonStateType stateButton;

#pragma mark - 动画
- (void)setVolumeLeave:(int)volume;

- (void)reset;

@end
