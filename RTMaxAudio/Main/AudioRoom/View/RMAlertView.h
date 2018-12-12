//
//  RMAlertView.h
//  Talkback
//
//  Created by jh on 2018/8/22.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertBlock) (NSInteger buttonIndex);

@interface RMAlertView : UIView
//呼叫id
@property (nonatomic, copy) NSString * _Nonnull callId;

- (instancetype _Nullable )initWithTitle:(NSString *_Nullable)title contentTitle:(NSString *_Nullable)contentTitle otherButtonTitles:(nullable NSArray *)otherButtonTitles withBlock:(UIAlertBlock _Nullable )tapBlock;

- (void)removeAlertView;

- (void)show;

@end
