//
//  BURN.m
//  BombSquad
//
//  Created by Andrew Foulke on 2/26/15.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#include <stdlib.h>
#import "BURN.h"

@interface BURN () <AVAudioPlayerDelegate>

@end

@implementation BURN

@synthesize burnLevel = burnLevel, clips = clips, runningPlayer = runningPlayer, startPlayer = startPlayer, defusedPlayer = defusedPlayer, wonPlayer = wonPlayer, lostPlayer = lostPlayer, pausePlayer = pausePlayer, waitingPlayer = waitingPlayer, selectPlayer = selectPlayer, currentPlayers = currentPlayers, timer = timer;

- (BURN *)init {
    NSLog(@"BURN::init");
    timer = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [defaults objectForKey:@"burnLevel"];
    if (num == nil) {
        num = [NSNumber numberWithInt:0];
        [defaults setObject:num forKey:@"burnLevel"];
        [defaults synchronize];
    }
    burnLevel = (BURNLevel)[num integerValue];
    currentPlayers = [[NSMutableArray alloc] init];
    NSArray *files = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"m4a" subdirectory:@""];
    clips = [[NSMutableArray alloc] init];
    for (BURNType type = BURN_RUNNING; type <= BURN_SELECT; ++type) {
        [clips addObject:[[NSArray alloc] initWithObjects:[[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init], nil]];
    }
    for (NSURL *url in files) {
        NSString *fname = [url lastPathComponent];
        NSLog(@"URL %@", fname);
        if (fname.length >= 2) {
            NSInteger type = [fname characterAtIndex:0] - '0';
            NSInteger sev = [fname characterAtIndex:1] - '0';
            if (type >= BURN_RUNNING && type <= BURN_SELECT && sev >= NO_BURN && sev <= HEAVY_BURN) {
                [clips[type][sev] addObject:url];
            }
        }
    }
    [self resetClips];
    NSLog(@"BURN::init done");
    return self;
}

- (void)resetClips {
    [currentPlayers removeAllObjects];
    runningPlayer = [self selectClipType:BURN_RUNNING level:burnLevel];
    startPlayer = [self selectClipType:BURN_STARTING level:burnLevel];
    defusedPlayer = [self selectClipType:BURN_DEFUSED level:burnLevel];
    wonPlayer = [self selectClipType:BURN_WON level:burnLevel];
    lostPlayer = [self selectClipType:BURN_LOST level:burnLevel];
    pausePlayer = [self selectClipType:BURN_PAUSE level:burnLevel];
    waitingPlayer = [self selectClipType:BURN_WAITING level:burnLevel];
}

- (void)setBURNlevel:(int)level {
    if (level >= 0 && level <= 3) {
        burnLevel = level;
    }
}

- (AVAudioPlayer *)selectClipType:(BURNType)type level:(BURNLevel)level {
    NSMutableArray *choices = [[NSMutableArray alloc] initWithArray:clips[type][NO_BURN]];
    if (level >= LIGHT_BURN) {
        [choices addObjectsFromArray:clips[type][LIGHT_BURN]];
    }
    if (level >= MED_BURN) {
        [choices addObjectsFromArray:clips[type][MED_BURN]];
    }
    if (level >= HEAVY_BURN) {
        [choices addObjectsFromArray:clips[type][HEAVY_BURN]];
    }
    if (choices.count == 0) {
        return nil;
    }
    NSInteger choice = arc4random_uniform((unsigned int)choices.count);
    NSURL *url = [choices objectAtIndex:choice];
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (player != nil) {
        [player setVolume:1.0];
        [player prepareToPlay];
        player.delegate = self;
        [currentPlayers addObject:player];
    }
    return player;
}

- (NSInteger)getInterval {
    NSInteger interval = 0;
    if (burnLevel == LIGHT_BURN) {
        interval = arc4random_uniform((unsigned int)50) + 10;
    } else if (burnLevel == MED_BURN) {
        interval = arc4random_uniform((unsigned int)25) + 5;
    } else if (burnLevel == HEAVY_BURN) {
        interval = arc4random_uniform((unsigned int)10) + 2;
    }
    return interval;
}

- (void)timerFired:(NSTimer *)tm {
    if (runningPlayer != nil) {
        [runningPlayer play];
        runningPlayer = [self selectClipType:BURN_RUNNING level:burnLevel];
        timer = [NSTimer scheduledTimerWithTimeInterval:[self getInterval] target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    }
}

- (void)waitFired:(NSTimer *)tm {
    if (waitingPlayer != nil) {
        [waitingPlayer play];
        waitingPlayer = [self selectClipType:BURN_WAITING level:burnLevel];
    }
}

- (void)start {
    timer = [NSTimer scheduledTimerWithTimeInterval:[self getInterval] target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
}

- (void)stop {
    [timer invalidate];
    timer = nil;
}

- (void)startWaiting {
    timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(waitFired:) userInfo:nil repeats:YES];
}

- (void)stopAll {
    for (NSInteger idx = currentPlayers.count - 1; idx >= 0; --idx) {
        AVAudioPlayer *player = [currentPlayers objectAtIndex:idx];
        [currentPlayers removeObjectAtIndex:idx];
        [player stop];
    }
}

- (void)playStart {
    if (startPlayer != nil) {
        [startPlayer play];
        startPlayer = [self selectClipType:BURN_STARTING level:burnLevel];
    }
}

- (void)playDefused {
    if (defusedPlayer != nil) {
        [defusedPlayer play];
        defusedPlayer = [self selectClipType:BURN_DEFUSED level:burnLevel];
    }
}

- (void)playWon {
    if (wonPlayer != nil) {
        [wonPlayer play];
        wonPlayer = [self selectClipType:BURN_WON level:burnLevel];
    }
}

- (void)playLost {
    if (lostPlayer != nil) {
        [lostPlayer play];
        lostPlayer = [self selectClipType:BURN_LOST level:burnLevel];
    }
}

- (void)playSelect {
    if (selectPlayer != nil) {
        [selectPlayer play];
        selectPlayer = [self selectClipType:BURN_SELECT level:burnLevel];
    }
}

- (void)playPause {
    if (pausePlayer != nil) {
        [pausePlayer play];
        pausePlayer = [self selectClipType:BURN_PAUSE level:burnLevel];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSInteger index = [currentPlayers indexOfObject:player];
    if (index != NSNotFound) {
        [currentPlayers removeObjectAtIndex:index];
    }
}

@end
