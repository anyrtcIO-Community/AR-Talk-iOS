//
//  NSDictionary+STSafeObject.h
//  SuperToys
//
//  Created by stefan on 15/7/8.
//  Copyright (c) 2015年 stefan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (STSafeObject)
/** 查找字典中是否有这个值 */
-(id)safeObjectForKey:(id)key;
@end
