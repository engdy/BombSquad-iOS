//
//  BURN.h
//  BombSquad
//
//  Created by Andrew Foulke on 2/26/15.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {NO_BURN, LIGHT_BURN, MED_BURN, HEAVY_BURN} BURNLevel;
typedef enum {BURN_RUNNING, BURN_STARTING, BURN_DEFUSED, BURN_WON, BURN_LOST, BURN_PAUSE, BURN_WAITING, BURN_SELECT} BURNType;

@interface BURN : NSObject

@property (nonatomic) BURNLevel burnLevel;
@property (nonatomic, retain) NSMutableArray *clips;
@property (nonatomic, retain) AVAudioPlayer *runningPlayer;
@property (nonatomic, retain) AVAudioPlayer *startPlayer;
@property (nonatomic, retain) AVAudioPlayer *defusedPlayer;
@property (nonatomic, retain) AVAudioPlayer *wonPlayer;
@property (nonatomic, retain) AVAudioPlayer *lostPlayer;
@property (nonatomic, retain) AVAudioPlayer *pausePlayer;
@property (nonatomic, retain) AVAudioPlayer *waitingPlayer;
@property (nonatomic, retain) AVAudioPlayer *selectPlayer;
@property (nonatomic, retain) NSMutableArray *currentPlayers;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSMutableArray *lastPlayed;

- (BURN *)init;
- (void)setBURNlevel:(int)level;
- (void)resetClips;
- (void)start;
- (void)stop;
- (void)startWaiting;
- (void)stopAll;
- (void)playStart;
- (void)playDefused;
- (void)playWon;
- (void)playLost;
- (void)playSelect;
- (void)playPause;

@end
