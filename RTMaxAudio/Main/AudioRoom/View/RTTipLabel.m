//
//  RT.m
//  RTMaxAudio
//
//  Created by zjq on 2018/10/24.
//  Copyright © 2018 derek. All rights reserved.
//

#import "RTTipLabel.h"

@implementation MessageItem

@end



@interface RTTipLabel()
//在线Item
@property (nonatomic, strong) MessageItem *lineItem;
@property (nonatomic, strong) MessageItem *otherTypeItem;
@property (nonatomic, strong) MessageItem *errorTypeItem;
// 被打断
@property (nonatomic, strong) MessageItem *interruptTypeItem;
@end

@implementation RTTipLabel
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont boldSystemFontOfSize:16];
        self.number = 1;
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
         self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

// message
- (void)setMessageItem:(MessageItem *)messageItem {
    switch (messageItem.tipType) {
        case TipMessageTypeLine:
        {
            _lineItem = messageItem;
            [self showLine];
        }
            break;
        case TipMessageTypeSpeaking:{
            _otherTypeItem = messageItem;
            [self showSpeak];
        }
            break;
        case TipMessageTypeSpeakingEnd:{
            _otherTypeItem = nil;
            [self showLine];
        }
            break;
        case TipMessageTypePrepareSpeaking:{
            
            if (!_otherTypeItem) {
                 _otherTypeItem = messageItem;
                 [self showPrepare];
            }
        }
            break;
        case TipMessageTypeSpeakingError:{
            _errorTypeItem = messageItem;
            [self showError];
        }
            break;
        case  TipMessageTypeOutTip:
        case  TipMessageTypeEnterTip:
        {
            _otherTypeItem = messageItem;
            [self showEnterOutTip];
        }
            break;
        case TipMessageTypeSpeakingOther:
        {
            _errorTypeItem = messageItem;
            [self showError];
        }
            break;
        case TipMessageTypeSpeakingInterrupt:
            _interruptTypeItem = messageItem;
            [self showInterrupt];
            break;
        case TipMessageTypeSpeakingTimeOut:
        case TipMessageTypeSpeakingTimeOutError:
        case TipMessageTypeSpeakingServerError:
            _errorTypeItem = messageItem;
            [self showError];
            break;
        default:
            break;
    }
}


- (void)showInterrupt {
    self.textColor = [RMCommons getColor:@"#DC143C"];
    self.text = _interruptTypeItem.tipStr;
}

- (void)showLine {
    if (!_otherTypeItem) {
        self.textColor = [UIColor whiteColor];
        self.text = [NSString stringWithFormat:@"当前%ld人在线",(long)self.number];
    }
    
}
- (void)setNumber:(NSInteger)number {
    _number = number;
    if (!_otherTypeItem) {
         [self showLine];
    }
   
}

- (void)showSpeak {
    if (_interruptTypeItem) {
        _interruptTypeItem = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showSpeak];
        });
    } else {
        if (_otherTypeItem) {
            self.textColor = [UIColor whiteColor];
            self.text = _otherTypeItem.tipStr;
        } else {
            [self showLine];
        }
    }
}

- (void)showPrepare {
    self.textColor = [UIColor whiteColor];
    self.text = _otherTypeItem.tipStr;
}

- (void)showError {
    self.textColor = [RMCommons getColor:@"#DC143C"];
    self.text = _errorTypeItem.tipStr;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_otherTypeItem) {
            [self showPrepare];
        }
    });
}

- (void)showEnterOutTip {
    //self.textColor = [RMCommons getColor:@"#42CA3E"];
    self.text = _otherTypeItem.tipStr;
    _otherTypeItem = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showLine];
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
