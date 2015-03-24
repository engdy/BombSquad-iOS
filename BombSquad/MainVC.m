//
//  MainVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "MainVC.h"
#import "SettingsVC.h"
#import "CampaignSetupVC.h"
#import "QuickSetupVC.h"
#import "AllBombsMissionVC.h"

@interface MainVC () <MissionSetupVCDelegate,RunningMissionVCDelegate>

@end

@implementation MainVC

@synthesize timer = _timer, btnResume = _btnResume;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = [[BSTimer alloc] init];
}

- (void)viewDidUnload {
    [self setBtnResume:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSInteger timeLeft = [_timer.bombs findMaxTime] - _timer.elapsedMillis;
    BOOL shouldShowResume = _timer.bombs.showResumeButton && [_timer.bombs.bombs count] > 0 && timeLeft > 0;
    [_btnResume setEnabled:shouldShowResume];
    [_btnResume setHidden:!shouldShowResume];
    [_timer stopMusic];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CampaignSetupSegue"]) {
        [self.timer.burn resetClips];
        CampaignSetupVC *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.timer = self.timer;
    } else if ([[segue identifier] isEqualToString:@"QuickSetupSegue"]) {
        [self.timer.burn resetClips];
        QuickSetupVC *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.timer = self.timer;
    } else if ([[segue identifier] isEqualToString:@"ResumeMissionSegue"]) {
        [self.timer.burn resetClips];
        AllBombsMissionVC *vc = [segue destinationViewController];
        vc.timer = self.timer;
        self.timer.currentVC = vc;
        vc.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"SettingsSegue"]) {
        SettingsVC *vc = [segue destinationViewController];
        vc.timer = self.timer;
    }
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

- (void)missionSetupDone:(MissionSetupVC *)vc {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)runningMissionDone:(RunningMissionVC *)vc {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)settingsDone:(SettingsVC *)vc {
    [self.timer stopMusic];
}

@end
