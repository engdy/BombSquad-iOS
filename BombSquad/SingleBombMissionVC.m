//
//  SingleBombMissionVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/19/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "SingleBombMissionVC.h"

@interface SingleBombMissionVC ()

@end

@implementation SingleBombMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnPlay = self.btnPlayPause;
    self.view.userInteractionEnabled = YES;
    NSMutableArray *tmpButtons = [[NSMutableArray alloc] init];
    NSMutableArray *tmpViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [self.timer.bombs.bombs count]; ++i) {
        Bomb *b = [self.timer.bombs.bombs objectAtIndex:i];
        if (b == self.focusBomb) {
            self.focusBombNum = i;
        }
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(94.0 + (i * 74.0), 20.0, 54.0, 54.0)];
        [iv setImage:[UIImage imageNamed:b == self.focusBomb ? @"selected" : @"notselected"]];
        iv.tag = i;
        [self.view addSubview:iv];
        [tmpViews addObject:iv];
        UIImageView *biv = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 44.0, 44.0)];
        [biv setImage:[UIImage imageNamed:b.level == 4 ? @"bombF" : [NSString stringWithFormat:@"bomb%d%@", b.level, b.letter]]];
        [iv addSubview:biv];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
        if (b.state == LIVE) {
            [btn setBackgroundColor:[UIColor clearColor]];
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:b.state == DETONATED ? @"redex" : @"greencheck"] forState:UIControlStateNormal];
        }
        btn.tag = i;
        [btn setEnabled:YES];
        [iv setUserInteractionEnabled:YES];
        [biv setUserInteractionEnabled:YES];
        [btn addTarget:self action:@selector(bombPressed:) forControlEvents:UIControlEventTouchUpInside];
        [biv addSubview:btn];
        [tmpButtons addObject:btn];
    }
    self.bombButtons = tmpButtons;
    self.backgroundViews = tmpViews;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.btnMainTime setTitle:[self.focusBomb timeLeftFromElapsed:self.timer.elapsedMillis] forState:UIControlStateNormal];
}

- (void)checkbuttons {
    [self.btnPlayPause setImage:(self.timer.isTimerRunning) ? [UIImage imageNamed:@"pause"] : [UIImage imageNamed:@"start"] forState:UIControlStateNormal];
}

- (void)updateMainTime:(NSString *)time {
}

- (void)updateBomb:(Bomb *)bomb idx:(NSInteger)idx duration:(NSInteger)duration {
    if (duration < 0) {
        UIButton *btn = self.bombButtons[idx];
        [btn setBackgroundImage:[UIImage imageNamed:@"redex"] forState:UIControlStateNormal];
    }
    if (bomb == self.focusBomb) {
        [self.btnMainTime setTitle:[bomb timeLeftFromElapsed:duration] forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload {
    [self setBtnMainTime:nil];
    [self setBtnPlayPause:nil];
    [super viewDidUnload];
}

- (IBAction)done:(id)sender {
    [self.delegate runningMissionDone:self];
}

- (IBAction)playPause:(id)sender {
    [self pause];
    [self checkbuttons];
}

- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender {
    NSInteger idx = self.focusBombNum + 1;
    if (idx >= [self.timer.bombs.bombs count]) {
        idx = 0;
    }
    [self makeFocusBombNum:idx];
}

- (IBAction)handleSwipeRight:(UISwipeGestureRecognizer *)sender {
    NSInteger idx = self.focusBombNum - 1;
    if (idx < 0) {
        idx = [self.timer.bombs.bombs count] - 1;
    }
    [self makeFocusBombNum:idx];
}

- (void)makeFocusBombNum:(NSInteger)idx {
    UIImageView *biv = self.backgroundViews[self.focusBombNum];
    [biv setImage:[UIImage imageNamed:@"notselected"]];
    self.focusBomb = self.timer.bombs.bombs[idx];
    self.focusBombNum = idx;
    biv = self.backgroundViews[self.focusBombNum];
    [biv setImage:[UIImage imageNamed:@"selected"]];
    [self.btnMainTime setTitle:[self.focusBomb timeLeftFromElapsed:self.timer.elapsedMillis] forState:UIControlStateNormal];
}

- (void)bombPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"Bomb %d pressed", btn.tag);
    Bomb *b = self.timer.bombs.bombs[btn.tag];
    if (b == self.focusBomb && self.timer.isTimerRunning && b.level < 4) {
        if (b.state == LIVE) {
            UIAlertView *alert = [[UIAlertView alloc] init];
            alert.tag = btn.tag;
            [alert setTitle:@"Confirm"];
            [alert setMessage:[NSString stringWithFormat:@"Are you sure you've deactivated bomb %d%@?", b.level, b.letter]];
            [alert setDelegate:self];
            [alert addButtonWithTitle:@"Yes"];
            [alert addButtonWithTitle:@"No"];
            [alert show];
            self.isTimerRunningDuringAlert = self.timer.isTimerRunning;
            [self.timer stopTimer];
        }
    } else {
        [self makeFocusBombNum:btn.tag];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSInteger bombNum = alertView.tag;
        Bomb *b = [self.timer.bombs.bombs objectAtIndex:bombNum];
        b.disarmedMillisRemain = b.durationMillis - self.timer.elapsedMillis;
        b.durationMillis = 0;
        b.state = DISABLED;
        UIButton *btn = self.bombButtons[bombNum];
        [btn setBackgroundImage:[UIImage imageNamed:@"greencheck"] forState:UIControlStateNormal];
    }
    if (self.isTimerRunningDuringAlert) {
        [self.timer startTimer];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
