//
//  AllBombsMissionVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/19/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "AllBombsMissionVC.h"
#import "SingleBombMissionVC.h"

@interface AllBombsMissionVC () <RunningMissionVCDelegate>

@end

@implementation AllBombsMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnPlay = self.btnPlayPause;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [defaults objectForKey:@"soundtrack"];
    if (num == nil) {
        num = [NSNumber numberWithBool:YES];
        [defaults setObject:num forKey:@"soundtrack"];
        [defaults synchronize];
    }
    BOOL willPlaySoundtrack = [num boolValue];
    num = [defaults objectForKey:@"audioBomb"];
    if (num == nil) {
        num = [NSNumber numberWithBool:YES];
        [defaults setObject:num forKey:@"audioBomb"];
        [defaults synchronize];
    }
    BOOL willPlayBombSound = [num boolValue];
    NSString *selectedSoundtrack = [defaults objectForKey:@"selectedSoundtrack"];
    if (selectedSoundtrack == nil) {
        selectedSoundtrack = @"tickingclock";
        [defaults setObject:selectedSoundtrack forKey:@"selectedSoundtrack"];
        [defaults synchronize];
    }
    [self.timer enableSoundtrack:willPlaySoundtrack withResourceName:selectedSoundtrack];
    [self.timer enableBombSounds:willPlayBombSound];
    NSMutableArray *tmpStates = [[NSMutableArray alloc] init];
    NSMutableArray *tmpButtons = [[NSMutableArray alloc] init];
    NSMutableArray *tmpTimes = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [self.timer.bombs.bombs count]; ++i) {
        Bomb *b = [self.timer.bombs.bombs objectAtIndex:i];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 190.0 + (i * 52.0), 44.0, 44.0)];
        if (b.state == DISABLED) {
            [iv setImage:[UIImage imageNamed:@"greencheck"]];
        } else if (b.state == DETONATED) {
            [iv setImage:[UIImage imageNamed:@"redex"]];
        }
        [self.view addSubview:iv];
        [tmpStates addObject:iv];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(72.0, 190.0 + (i * 52.0), 44.0, 44.0);
        btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
        NSString *imageName = b.level == 4 ? @"bombF" : [NSString stringWithFormat:@"bomb%d%@", b.level, b.letter];
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setEnabled:b.level < 4];
        [btn setUserInteractionEnabled:b.level < 4];
        [btn addTarget:self action:@selector(bombPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [tmpButtons addObject:btn];
        btn = [[UIButton alloc] initWithFrame:CGRectMake(124.0, 190.0 + (i * 52.0), 100.0, 44.0)];
        [btn setTitle:[b timeLeftFromElapsed:0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:26.0]];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn.titleLabel setTextAlignment:NSTextAlignmentRight];
        btn.tag = i;
        [btn setEnabled:YES];
        [btn setUserInteractionEnabled:YES];
        [btn addTarget:self action:@selector(timePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [tmpTimes addObject:btn];
    }
    self.bombStates = tmpStates;
    self.bombButtons = tmpButtons;
    self.bombTimes = tmpTimes;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (NSInteger i = 0; i < [self.timer.bombs.bombs count]; ++i) {
        Bomb *b = self.timer.bombs.bombs[i];
        UIButton *btnTime = [self.bombTimes objectAtIndex:i];
        UIButton *btnBomb = [self.bombButtons objectAtIndex:i];
        UIImageView *iv = [self.bombStates objectAtIndex:i];
        if (b.state == LIVE) {
            [btnTime setTitle:[b timeLeftFromElapsed:self.timer.elapsedMillis] forState:UIControlStateNormal];
            [btnTime setEnabled:YES];
            [btnBomb setEnabled:YES];
        } else if (b.state == DISABLED) {
            [btnTime setTitle:[Bomb stringFromTime:b.disarmedMillisRemain] forState:UIControlStateNormal];
            [btnTime setEnabled:NO];
            [btnBomb setEnabled:NO];
            [iv setImage:[UIImage imageNamed:@"greencheck"]];
        } else {
            [btnTime setTitle:@"00:00" forState:UIControlStateNormal];
            [btnTime setEnabled:NO];
            [btnBomb setEnabled:NO];
            [iv setImage:[UIImage imageNamed:@"redex"]];
        }
    }
}

- (void)viewDidUnload {
    [self setTxtMainTime:nil];
    [self setBtnPlayPause:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SingleBombSegue"]) {
        SingleBombMissionVC *vc = [segue destinationViewController];
        vc.timer = self.timer;
        vc.delegate = self;
        vc.focusBomb = self.focusBomb;
        self.timer.currentVC = vc;
    }
}

- (void)checkButtons {
    [self.btnPlayPause setImage:(self.timer.isTimerRunning) ? [UIImage imageNamed:@"pause"] : [UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    for (NSInteger i = 0; i < [self.timer.bombs.bombs count]; ++i) {
        Bomb *b = self.timer.bombs.bombs[i];
        BOOL enableButton = self.timer.isTimerRunning && (b.state == LIVE);
        UIButton *btn = self.bombButtons[i];
        [btn setEnabled:enableButton && b.level < 4];
    }
}

- (void)updateMainTime:(NSString *)time {
    [self.txtMainTime setText:time];
}

- (void)updateBomb:(Bomb *)bomb idx:(NSInteger)idx duration:(NSInteger)duration {
    if (duration < 0) {
        UIImageView *iv = [self.bombStates objectAtIndex:idx];
        [iv setImage:[UIImage imageNamed:@"redex"]];
        UIButton *btnTime = [self.bombTimes objectAtIndex:idx];
        [btnTime setTitle:@"00:00" forState:UIControlStateNormal];
        [self checkButtons];
    } else {
        UIButton *btnTime = [self.bombTimes objectAtIndex:idx];
        [btnTime setTitle:[bomb timeLeftFromElapsed:duration] forState:UIControlStateNormal];
//        NSInteger diff = bomb.durationMillis - duration;
//        if (self.willAlertVisually && diff < 30000) {
//            CGFloat nonRedVal = (CGFloat)diff / 30000.0;
//            [btnTime setBackgroundColor:[UIColor colorWithRed:1.0 green:nonRedVal blue:nonRedVal alpha:1.0]];
//        }
    }
}

- (void)bombPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"Bomb %d pressed", btn.tag);
    Bomb *b = self.timer.bombs.bombs[btn.tag];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSInteger bombNum = alertView.tag;
        Bomb *b = [self.timer.bombs.bombs objectAtIndex:bombNum];
        b.disarmedMillisRemain = b.durationMillis - self.timer.elapsedMillis;
        b.durationMillis = 0;
        b.state = DISABLED;
        UIImageView *iv = [self.bombStates objectAtIndex:bombNum];
        [iv setImage:[UIImage imageNamed:@"greencheck"]];
        UIButton *btnTime = [self.bombTimes objectAtIndex:bombNum];
        [btnTime setBackgroundColor:[UIColor whiteColor]];
    }
    if (self.isTimerRunningDuringAlert) {
        [self.timer startTimer];
    }
    [self checkButtons];
}

- (IBAction)playPause:(id)sender {
    [self pause];
    [self checkButtons];
}

- (IBAction)home:(id)sender {
    [self.timer stopTimer];
    [self.timer stopMusic];
    [self.delegate runningMissionDone:self];
}

- (void)timePressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"Time %d pressed", btn.tag);
    self.focusBomb = [self.timer.bombs.bombs objectAtIndex:btn.tag];
    [self performSegueWithIdentifier:@"SingleBombSegue" sender:self];
}

- (void)runningMissionDone:(RunningMissionVC *)vc {
    self.timer.currentVC = self;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
