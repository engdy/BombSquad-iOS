//
//  SingleBombMissionVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/19/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "SingleBombMissionVC.h"

@interface SingleBombMissionVC ()

@end

@implementation SingleBombMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    NSInteger numBombs = [self.timer.bombs.bombs count];
    self.btnPlay = self.btnPlayPause;
    self.view.userInteractionEnabled = YES;
    NSMutableArray *tmpButtons = [[NSMutableArray alloc] init];
    NSMutableArray *tmpViews = [[NSMutableArray alloc] init];
    NSMutableArray *tmpTimeText = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < numBombs; ++i) {
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
        [biv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bomb%ld%@", (long)b.level, b.letter]]];
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
        UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(self.scrollTimers.frame.size.width * i, 0.0, self.scrollTimers.frame.size.width, self.scrollTimers.frame.size.height)];
        txt.text = @"30:00";
        [txt setTextColor:[UIColor redColor]];
        [txt setBackgroundColor:[UIColor clearColor]];
//        [txt setFont:[UIFont systemFontOfSize:isIpad ? 150.0 : 80.0]];
        [txt setFont:[UIFont systemFontOfSize:isIpad ? 300.0 : 160.0]];
        [txt setTextAlignment:NSTextAlignmentCenter];
        [self.scrollTimers addSubview:txt];
        [tmpTimeText addObject:txt];
    }
    self.bombButtons = tmpButtons;
    self.backgroundViews = tmpViews;
    self.txtTimes = tmpTimeText;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger numBombs = [self.timer.bombs.bombs count];
    CGFloat width = self.scrollTimers.frame.size.width;
    CGFloat height = self.scrollTimers.frame.size.height;
    self.scrollTimers.contentSize = CGSizeMake(width * numBombs, height);
    [self makeFocusBombNum:self.focusBombNum];
    [self zipToBombNum:self.focusBombNum];
    for (NSInteger i = 0; i < numBombs; ++i) {
        Bomb *b = [self.timer.bombs.bombs objectAtIndex:i];
        UILabel *txt = [self.txtTimes objectAtIndex:i];
        txt.frame = CGRectMake(width * i, 0.0, width, height);
        NSString *txtStr;
        if (b.state == LIVE) {
            txtStr = [b timeLeftFromElapsed:self.timer.elapsedMillis];
        } else if (b.state == DISABLED) {
            txtStr = [Bomb stringFromTime:b.disarmedMillisRemain];
        } else {
            txtStr = @"00:00";
        }
        NSLog(@"Time = %@", txtStr);
        txt.text = txtStr;
    }
    [self checkbuttons];
}

- (void)checkbuttons {
    BOOL isAlive = NO;
    for (NSInteger i = 0; i < [self.timer.bombs.bombs count]; ++i) {
        Bomb *b = self.timer.bombs.bombs[i];
        isAlive |= (b.state == LIVE);
    }
    [self.btnPlayPause setImage:(isAlive && self.timer.isTimerRunning) ? [UIImage imageNamed:@"pause"] : [UIImage imageNamed:@"start"] forState:UIControlStateNormal];
}

- (void)updateMainTime:(NSString *)time {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger bombNum = (NSInteger)((offset + width / 2.0) / width);
    [self makeFocusBombNum:bombNum];
}

- (void)updateBomb:(Bomb *)bomb idx:(NSInteger)idx duration:(NSInteger)duration {
    UILabel *txt = self.txtTimes[idx];
    if (duration < 0) {
        UIButton *btn = self.bombButtons[idx];
        [btn setBackgroundImage:[UIImage imageNamed:@"redex"] forState:UIControlStateNormal];
        [txt setBackgroundColor:[UIColor blackColor]];
        txt.text = @"00:00";
        [self checkbuttons];
    } else {
        txt.text = [bomb timeLeftFromElapsed:duration];
        if (self.willAlertVisually) {
            CGFloat diff = bomb.durationMillis - duration;
            if (diff < 30000.0) {
                CGFloat mag = floor((30000.0 - diff) / 1000.0);
                NSInteger sdiff = (NSInteger)diff % 1000;
                CGFloat redVal = (mag * (CGFloat)sdiff / 30000.0);
                [txt setBackgroundColor:[UIColor colorWithRed:redVal green:0.0 blue:0.0 alpha:1.0]];
            }
        }
    }
}

- (void)viewDidUnload {
    [self setBtnPlayPause:nil];
    [self setScrollTimers:nil];
    [super viewDidUnload];
}

- (IBAction)done:(id)sender {
    [self.delegate runningMissionDone:self];
}

- (IBAction)playPause:(id)sender {
    [self pause];
    [self checkbuttons];
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)sender {
    [self.delegate runningMissionDone:self];
}

- (void)makeFocusBombNum:(NSInteger)idx {
    UIImageView *biv = self.backgroundViews[self.focusBombNum];
    [biv setImage:[UIImage imageNamed:@"notselected"]];
    self.focusBomb = self.timer.bombs.bombs[idx];
    self.focusBombNum = idx;
    biv = self.backgroundViews[self.focusBombNum];
    [biv setImage:[UIImage imageNamed:@"selected"]];
}

- (void)bombPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"Bomb %ld pressed", (long)btn.tag);
    Bomb *b = self.timer.bombs.bombs[btn.tag];
    if (b == self.focusBomb && self.timer.isTimerRunning) {
        if (b.state == LIVE) {
            UIAlertView *alert = [[UIAlertView alloc] init];
            alert.tag = btn.tag;
            [alert setTitle:@"Confirm"];
            [alert setMessage:[NSString stringWithFormat:@"Are you sure you've deactivated bomb %ld%@?", (long)b.level, b.letter]];
            [alert setDelegate:self];
            [alert addButtonWithTitle:@"Yes"];
            [alert addButtonWithTitle:@"No"];
            [alert show];
            self.isTimerRunningDuringAlert = self.timer.isTimerRunning;
            [self.timer stopTimer];
        }
    } else {
        [self makeFocusBombNum:btn.tag];
        [self zipToBombNum:self.focusBombNum];
    }
}

- (void)zipToBombNum:(NSInteger)bombNum {
    [self.scrollTimers setContentOffset:CGPointMake(bombNum * self.scrollTimers.frame.size.width, 0.0)];
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
        UILabel *txt = self.txtTimes[bombNum];
        [txt setBackgroundColor:[UIColor blackColor]];
        b = [self.timer.bombs findUrgentBomb];
        if (b != nil) {
            [self.timer playDefuse];
        }
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
