//
//  RMCommons.h
//  RTMaxAudio
//
//  Created by derek on 2018/6/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMCommons : NSObject

+ (NSString*)createUUID;

+ (BOOL)isStringContains:(NSString *)str string:(NSString *)smallStr;

// 将16进制颜色转换成UIColor
+ (UIColor *)getColor:(NSString *)color;

//随机数字
+ (NSString*)randomNumString:(int)len;

//显示提示
+ (void)showCenterWithText:(NSString *)text;
//随机字符串
+ (NSString*)randomString:(int)len;

//居中布局
+ (void)centerMonitorLayOut:(NSArray*)array withY:(CGFloat)Y;

//最上层视图
+ (UIViewController *)topViewController;

//随机英文首字母大写
+ (NSString*)randomLetterString:(int)len;

//将字典转换为JSON对象
+ (NSString *)fromDicToJSONStr:(NSDictionary *)dic;

// 将字符串转换为字典
+ (id)fromJsonStr:(NSString*)jsonStrong;

//模糊图片
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
@end
