//
//  RMCommons.m
//  RTMaxAudio
//
//  Created by derek on 2018/6/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "RMCommons.h"
#import <Accelerate/Accelerate.h>
#import "RMVideoView.h"

@implementation RMCommons

+ (NSString*)createUUID {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (__bridge NSString *)CFStringCreateCopy(NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
//字符串包含
+ (BOOL)isStringContains:(NSString *)str string:(NSString *)smallStr{
    if ([str rangeOfString:smallStr].location == NSNotFound || str.length == 0) {
        return NO;
    }
    return YES;
}

/**
 * 将16进制颜色转换成UIColor
 *
 **/
+(UIColor *)getColor:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+ (NSString*)randomNumString:(int)len {
    char* charSet = "0123456789";
    char* temp = malloc(len + 1);
    for (int i = 0; i < len; i++) {
        int randomPoz = (int) floor(arc4random() % strlen(charSet));
        temp[i] = charSet[randomPoz];
    }
    temp[len] = '\0';
    NSMutableString* randomString = [[NSMutableString alloc] initWithUTF8String:temp];
    free(temp);
    return randomString;
}
//提示
+ (void)showCenterWithText:(NSString *)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        [XHToast showCenterWithText:text];
    });
}


//随机字符串
+ (NSString*)randomString:(int)len {
    char* charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    char* temp = malloc(len + 1);
    for (int i = 0; i < len; i++) {
        int randomPoz = (int) floor(arc4random() % strlen(charSet));
        temp[i] = charSet[randomPoz];
    }
    temp[len] = '\0';
    NSMutableString* randomString = [[NSMutableString alloc] initWithUTF8String:temp];
    free(temp);
    return randomString;
}

+ (void)centerMonitorLayOut:(NSArray*)array withY:(CGFloat)Y {
    CGFloat widthVideo = SCREEN_WIDTH/4;
    CGFloat heightVideo = widthVideo*(4.0/3.0);
    
    switch (array.count) {
        case 1:
        {
            RMVideoView *videoView = [array firstObject];
            videoView.frame = CGRectMake(SCREEN_WIDTH/2-widthVideo/2, Y, widthVideo, heightVideo);
        }
            break;
        case 2:
        {
            RMVideoView *video1 = [array firstObject];
            video1.frame = CGRectMake(SCREEN_WIDTH/2-widthVideo, Y, widthVideo, heightVideo);
            
            RMVideoView *video2 = [array lastObject];
            video2.frame = CGRectMake(SCREEN_WIDTH/2, Y, widthVideo, heightVideo);
            
            
        }
            break;
        case 3:
        {
            CGFloat X = widthVideo/2;
            for (int i =0; i<3; i++) {
                RMVideoView *video = [array objectAtIndex:i];
                video.frame = CGRectMake(X, Y, widthVideo, heightVideo);
                X += widthVideo;
            }
        }
            break;
        case 4:
        {
            CGFloat X = 0;
            for (int i =0; i<4; i++) {
                RMVideoView *video = [array objectAtIndex:i];
                video.frame = CGRectMake(X, Y, widthVideo, heightVideo);
                X += widthVideo;
            }
        }
            break;
            
        default:
            break;
    }
}
+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}
+ (UIViewController *)topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

//随机英文首字母大写
+ (NSString*)randomLetterString:(int)len {
    char* charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    char* temp = malloc(len + 1);
    for (int i = 0; i < len; i++) {
        int randomPoz = (int) floor(arc4random() % strlen(charSet));
        temp[i] = charSet[randomPoz];
    }
    temp[len] = '\0';
    NSMutableString* randomString = [[NSMutableString alloc] initWithUTF8String:temp];
    free(temp);
    return [randomString capitalizedString];
}

//将字典转换为JSON对象
+ (NSString *)fromDicToJSONStr:(NSDictionary *)dic{
    NSString *JSONStr;
    //判断对象是否可以构造为JSON对象
    if ([NSJSONSerialization isValidJSONObject:dic]){
        NSError *error;
        //转换为NSData对象
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        //转换为字符串，即为JSON对象
        JSONStr=[[NSMutableString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return JSONStr;
}

+ (id)fromJsonStr:(NSString*)jsonStrong {
    if ([jsonStrong isKindOfClass:[NSDictionary class]]) {
        return jsonStrong;
    }
    NSData* data = [jsonStrong dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}


+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
//    //设置filter
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
//    //模糊图片
//    CIImage *result=[filter valueForKey:kCIOutputImageKey];
//    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
//    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
//    CGImageRelease(outImage);
//    return blurImage;
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
    
}

@end
