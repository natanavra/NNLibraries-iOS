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

#pragma mark - Singleton Init

+ (instancetype)soundPlayer {
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

#pragma mark - Sound Playing

- (void)toggleSound {
    _mute = !_mute;
}

- (void)playSound:(NSString *)soundFile {
    if(_mute) {
        [NNLogger logFromInstance: self message: @"Not playing, MUTED!"];
        return;
    }
    
    @synchronized(self) {
        id soundObject = [NNUtilities validObjectFromObject: _sounds[soundFile]];
        if(!soundObject) {
            [NNLogger logFromInstance: self message: @"Sound file not cached" data: soundFile];
            BOOL success = [self addSound: soundFile];
            if(success) {
                soundObject = [NNUtilities validObjectFromObject: _sounds[soundFile]];
            }
        }
        
        if(soundObject) {
            [NNLogger logFromInstance: self message: @"Playing sound" data: soundFile];
            SystemSoundID sound = [soundObject unsignedIntValue];
            AudioServicesPlaySystemSound(sound);
        }
    }
}

- (void)vibrate {
    [NNLogger logFromInstance: self message: @"Vibrate"];
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

#pragma mark - Sound Caching

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
                [NNLogger logFromInstance: self message: @"Cached sound file" data: soundFile];
                _sounds[soundFile] = [NSNumber numberWithUnsignedInt: soundID];
                return YES;
            } else {
                [NNLogger logFromInstance: self message: @"Failed to create system sound" data: [NSString stringWithFormat: @"%d", (int)success]];
            }
        }
    }
    return NO;
}

#pragma mark - Overrides

- (NSString *)description {
    return [NSString stringWithFormat: @"%@\nMuted: %@,\nCached Sounds: %@", [super description], _mute ? @"YES" : @"NO", _sounds];
}

#pragma mark - Dealloc

- (void)dealloc {
    for(NSNumber *soundID in [_sounds allValues]) {
        AudioServicesDisposeSystemSoundID([soundID unsignedIntValue]);
    }
}

@end
