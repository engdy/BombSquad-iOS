//
//  RunningMissionVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/19/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "RunningMissionVC.h"

@interface RunningMissionVC ()

@end

@implementation RunningMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnPlay = nil;
    self.timer.bombs.showResumeButton = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [defaults objectForKey:@"visualAlert"];
    if (num == nil) {
        num = [NSNumber numberWithBool:YES];
        [defaults setObject:num forKey:@"visualAlert"];
        [defaults synchronize];
    }
    self.willAlertVisually = [num boolValue];
    num = [defaults objectForKey:@"audioAlert"];
    if (num == nil) {
        num = [NSNumber numberWithBool:YES];
        [defaults setObject:num forKey:@"audioAlert"];
        [defaults synchronize];
    }
    self.willAlertAudibly = [num boolValue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    Bomb *urgentBomb = [self.timer.bombs findUrgentBomb];
    if (urgentBomb != nil) {
        [self updateMainTime:[urgentBomb timeLeftFromElapsed:self.timer.elapsedMillis]];
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
    NSLog(@"updateBomb %ld (%@): %ld", (long)idx, bomb, (long)duration);
}

- (void)pause {
    if (self.timer.isTimerRunning) {
        [self.timer stopBurn];
        [self.timer startWaiting];
        [self.timer playPause];
        [self.timer stopTimer];
        [self.timer stopMusic];
    } else {
        [self.timer stopWaiting];
        [self.timer startBurn];
        [self.timer playStart];
        [self.timer startTimer];
        [self.timer startMusic];
    }
}

@end
