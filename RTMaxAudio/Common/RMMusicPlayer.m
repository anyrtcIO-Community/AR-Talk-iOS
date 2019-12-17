//
//  RMMusicPlayer.m
//  RTMaxAudio
//
//  Created by derek on 2018/6/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "RMMusicPlayer.h"

@interface RMMusicPlayer()<AVAudioPlayerDelegate>
{

}

@property (nonatomic, strong) AVAudioPlayer *player;


@property (nonatomic, copy) void (^completionBlock)(void);



@end

@implementation RMMusicPlayer
- (instancetype)init
{
    self = [super init];
    if (self) {
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
    return;
    [self stop];
    
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.numberOfLoops = loops;
    _player.volume = 1.0;
    _player.delegate = self;
    BOOL ret = [_player prepareToPlay];
    if (ret) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error) {
            
        }
    }
    ret = [self.player play];
    if (!ret) {
        [self.player stop];
        error = [NSError errorWithDomain:@"AVAudioPlayer播放失败" code:-1 userInfo:nil];
    }
    _completionBlock = completion;

}

- (void)stop {
    return;
    if (_player && _player.isPlaying) {
        [_player stop];
        _player.delegate = nil;
        _player = nil;
        _completionBlock = nil;
    }
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        
    }
    if (![self hasHeadset]) {
        // 是否是扬声器，不是扬声器打开扬声器
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)__unused player successfully:(BOOL)__unused flag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stop];
        if (self.completionBlock != nil)
            self.completionBlock();
    });
}

- (BOOL)hasHeadset
{
    UInt32 propertySize = sizeof(CFStringRef);
    CFStringRef state   = nil;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute ,&propertySize,&state);
    
    //根据状态判断是否为耳机状态
    if ([(__bridge NSString *)state isEqualToString:@"Headphone"] ||[(__bridge NSString *)state isEqualToString:@"HeadsetInOut"]){
        return YES;
    }else{
        return NO;
    }
    return NO;
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
