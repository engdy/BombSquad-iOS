//
//  RunningMissionVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/19/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "RunningMissionVC.h"

@interface RunningMissionVC ()

@end

@implementation RunningMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnPlay = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    Bomb *longestBomb = [self.timer.bombs findMaxTimeBomb];
    if (longestBomb != nil) {
        [self updateMainTime:[longestBomb timeLeftFromElapsed:self.timer.elapsedMillis]];
    } else {
        [self updateMainTime:@"00:00"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkbuttons];
}

- (void)checkbuttons {
    NSLog(@"checkbuttons");
}

- (void)updateMainTime:(NSString *)time {
    NSLog(@"updateMainTime");
}

- (void)updateBomb:(Bomb *)bomb idx:(NSInteger)idx duration:(NSInteger)duration {
    NSLog(@"updateBomb %d (%@): %d", idx, bomb, duration);
}

- (void)pause {
    if (self.timer.isTimerRunning) {
        [self.timer stopTimer];
        [self.timer stopMusic];
    } else {
        [self.timer startTimer];
        [self.timer startMusic];
    }
}

@end