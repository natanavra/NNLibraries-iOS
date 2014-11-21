//
//  NNSimpleSoundsPlayer.h
//  FourSigns
//
//  Created by Natan Abramov on 11/12/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNSimpleSoundsPlayer : NSObject {
    __strong NSMutableDictionary *_sounds;
}
@property (nonatomic) BOOL mute;

+ (instancetype)sharedPlayer;

- (BOOL)addSound:(NSString *)soundFile;
- (void)playSound:(NSString *)soundFile;
- (void)toggleSound;

@end
