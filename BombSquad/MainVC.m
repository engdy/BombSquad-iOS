//
//  MainVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
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
    NSInteger timeLeft = [_timer.bombs findMaxTime] - _timer.elapsedMillis;
    [_btnResume setEnabled:[_timer.bombs.bombs count] > 0 && timeLeft > 0];
    [_btnResume setHidden:[_timer.bombs.bombs count] == 0 || timeLeft <= 0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CampaignSetupSegue"]) {
        CampaignSetupVC *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.timer = self.timer;
    } else if ([[segue identifier] isEqualToString:@"QuickSetupSegue"]) {
        QuickSetupVC *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.timer = self.timer;
    } else if ([[segue identifier] isEqualToString:@"ResumeMissionSegue"]) {
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

@end
