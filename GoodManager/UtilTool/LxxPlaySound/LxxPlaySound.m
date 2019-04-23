//
//  LxxPlaySound.m
//  GoodManager
//
//  Created by DJ on 2019/4/21.
//  Copyright © 2019 GoodManager. All rights reserved.
//

#import "LxxPlaySound.h"
#import <AVFoundation/AVFoundation.h>
@implementation LxxPlaySound

-(id)initForPlayingVibrate{
    self = [super init];
    if (self) {
        soundID = kSystemSoundID_Vibrate;
    }
    return self;
}


-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type{

    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"new-mail",@"caf"];
        if (path) {
            NSString *url = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",path);
            NSLog(@"%@",url);
            
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
            if (error != kAudioServicesNoError) {
                soundID = 0;
            }
            NSLog(@"!!!!!!!!!!!!! %d",soundID);
        }
    }
    return self;
}


-(id)initForPlayingSoundEffectWith:(NSString *)filename{
    self = [super init];
    if (self) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (fileURL != nil){
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError){
                soundID = theSoundID;
            }else {
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}

-(void)play{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)playWithSound{
//    AudioServicesPlaySystemSound(1007);
    SystemSoundID sound;
    NSString*path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received1",@"caf"];
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
    
    if(error!=kAudioServicesNoError)sound = nil;
    
    AudioServicesPlaySystemSound(sound);
    
  
}

-(void)dealloc{
    AudioServicesDisposeSystemSoundID(soundID);
}

@end

