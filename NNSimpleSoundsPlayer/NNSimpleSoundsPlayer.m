//
//  NNSimpleSoundsPlayer.m
//  FourSigns
//
//  Created by Natan Abramov on 11/12/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "NNSimpleSoundsPlayer.h"

#import "NNLogger.h"
#import "NNUtilities.h"

@import AudioToolbox;

@implementation NNSimpleSoundsPlayer

+ (instancetype)sharedPlayer {
    static NNSimpleSoundsPlayer *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    if(self = [super init]) {
        _sounds = [NSMutableDictionary dictionary];
        _mute = NO;
    }
    return self;
}

- (void)playSound:(NSString *)soundFile {
    if(_mute) {
        return;
    }
    
    id soundObject = [NNUtilities validObjectFromObject: _sounds[soundFile]];
    if(soundObject) {
        [NNLogger logFromInstance: self message: @"Playing sound"];
        SystemSoundID sound = [soundObject unsignedIntValue];
        AudioServicesPlaySystemSound(sound);
    } else {
        if([self addSound: soundFile]) {
            soundObject = [NNUtilities validObjectFromObject: _sounds[soundFile]];
            AudioServicesPlaySystemSound([soundObject unsignedIntValue]);
        }
    }
}

- (BOOL)addSound:(NSString *)soundFile {
    NSArray *components = [soundFile componentsSeparatedByString: @"."];
    if(components.count > 1) {
        NSString *path = [[NSBundle mainBundle] pathForResource: components[0] ofType: components[1]];
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        if(path) {
            SystemSoundID soundID;
            OSStatus success = AudioServicesCreateSystemSoundID((__bridge CFURLRef)pathURL, &soundID);
            if(success == kAudioServicesNoError) {
                //No errors in creation
                _sounds[soundFile] = [NSNumber numberWithUnsignedInt: soundID];
                return YES;
            } else {
                [NNLogger logFromInstance: self message: @"Failed to create system sound" data: [NSString stringWithFormat: @"%d", (int)success]];
            }
        }
    }
    return NO;
}

- (void)toggleSound {
    _mute = !_mute;
}

- (void)dealloc {
    for(NSNumber *soundID in [_sounds allValues]) {
        AudioServicesDisposeSystemSoundID([soundID unsignedIntValue]);
    }
}

@end
