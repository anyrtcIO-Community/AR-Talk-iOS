//
//  RMMusicPlayer.h
//  RTMaxAudio
//
//  Created by derek on 2018/6/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMMusicPlayer : NSObject

+ (instancetype)sharedInstance;

- (void)play:(NSURL *)url loops:(NSInteger)loops completion:(void (^)(void))completion;

- (void)stop;

- (void)playUp;

- (void)playScuess;

- (void)playOver;


@end
