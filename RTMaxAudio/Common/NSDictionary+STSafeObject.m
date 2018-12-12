//
//  NSDictionary+STSafeObject.m
//  SuperToys
//
//  Created by stefan on 15/7/8.
//  Copyright (c) 2015年 stefan. All rights reserved.
//  字典的类扩展，当为空得时候防崩

#import "NSDictionary+STSafeObject.h"

@implementation NSDictionary (STSafeObject)
-(id)safeObjectForKey:(id)key
{
    id result=[self objectForKey:key];
    
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        return [result stringValue];
    }
    return result;
}
@end
