//
//  RMMusicPlayer.m
//  RTMaxAudio
//
//  Created by derek on 2018/6/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "RMMusicPlayer.h"

@interface RMMusicPlayer()
{
    dispatch_queue_t queueDis;
}
//进会提醒
@property (nonatomic, strong) AVPlayer * player;

@property (nonatomic, copy) void (^completionBlock)(void);



@end

@implementation RMMusicPlayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        queueDis = dispatch_queue_create("com.dync.musicQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

static RMMusicPlayer *playerManager;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerManager = [[RMMusicPlayer alloc] init];
    });
    return playerManager;
}
- (void)play:(NSURL *)url loops:(NSInteger)loops completion:(void (^)(void))completion {
    
//    [self stop];
    //dispatch_async(queueDis, ^{
       // dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            if ([[AVAudioSession sharedInstance].category isEqualToString:@"AVAudioSessionCategoryMultiRoute"]) {
                return;
            }

            BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryMultiRoute error:&error];

            if (success) {
                [[AVAudioSession sharedInstance] setActive:YES error:&error];
            }
       // });

        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
        if (!self.player) {
             self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        }
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
//        NSLog(@"moviePlayDidStart");
        [self.player play];
        self.completionBlock = completion;
   // });
}

- (void)stop {
    dispatch_async(queueDis, ^{
        if (self.player) {
            [self.player pause];
            self.completionBlock = nil;
        }
    });
}
- (void)moviePlayDidEnd {
//    NSLog(@"moviePlayDidEnd");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        if (![[AVAudioSession sharedInstance].category isEqualToString:@"AVAudioSessionCategoryPlayAndRecord"]) {
            BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];

            if (success) {
                [[AVAudioSession sharedInstance] setActive:YES error:&error];
            }
        }
    });
}

void soundCompleteCallBack(SystemSoundID soundID, void *clientData)
{
    NSLog(@"播放完成");
}

- (void)playUp {
    return;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Talkie_Up" ofType:@"wav"];
    NSURL *tempUrl = [NSURL fileURLWithPath:path];
    [self play:tempUrl loops:1 completion:nil];
}
- (void)playScuess {
    return;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Talkie_Tick_2" ofType:@"wav"];
    NSURL *tempUrl = [NSURL fileURLWithPath:path];
    [self play:tempUrl loops:1 completion:nil];
}
- (void)playOver {
    return;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Talkie_Tick_Short" ofType:@"wav"];
    NSURL *tempUrl = [NSURL fileURLWithPath:path];
    [self play:tempUrl loops:1 completion:nil];
}
@end
