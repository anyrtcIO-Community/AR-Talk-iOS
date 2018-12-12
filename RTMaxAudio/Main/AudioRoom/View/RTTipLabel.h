//
//  RTTipLabel.h
//  RTMaxAudio
//
//  Created by zjq on 2018/10/24.
//  Copyright © 2018 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TipMessageType){
    TipMessageTypeLine = 0,//在线提醒
    TipMessageTypeEnterTip,//进会提醒
    TipMessageTypeOutTip,//出会提醒
    TipMessageTypeSpeaking,//说话者
    TipMessageTypePrepareSpeaking,// 准备说话（自己）
    TipMessageTypeSpeakingEnd,// 说话结束
    TipMessageTypeSpeakingError,//自己抢麦出错
    TipMessageTypeSpeakingOther,//其他人在说话
    TipMessageTypeSpeakingInterrupt,//自己说话被打断
};

@interface MessageItem:NSObject
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *tipStr;
@property (nonatomic, assign) TipMessageType tipType;
@end

@interface RTTipLabel : UILabel

//在线人数
@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) MessageItem *messageItem;

@end

NS_ASSUME_NONNULL_END
