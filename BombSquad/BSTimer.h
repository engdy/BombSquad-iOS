//
//  BSTimer.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BombList.h"

@class RunningMissionVC;

@interface BSTimer : NSObject

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) BOOL isTimerRunning;
@property (nonatomic) NSInteger startMillis;
@property (nonatomic) NSInteger elapsedMillis;
@property (nonatomic, retain) BombList *bombs;
@property (nonatomic) BOOL willPlaySoundtrack;
@property (nonatomic) BOOL willPlayBombSounds;
@property (nonatomic, retain) AVAudioPlayer *backgroundPlayer;
@property (nonatomic, retain) AVAudioPlayer *smallBombPlayer;
@property (nonatomic, retain) AVAudioPlayer *bigBombPlayer;
@property (nonatomic, retain) RunningMissionVC *currentVC;

- (BSTimer *)init;
- (void)enableSoundtrack:(BOOL)willPlaySoundtrack withResourceName:(NSString *)name;
- (void)enableBombSounds:(BOOL)willPlayBombSounds;
- (void)startTimer;
- (void)stopTimer;
- (void)startMusic;
- (void)stopMusic;
- (BOOL)isPlayingSoundtrack;

@end
