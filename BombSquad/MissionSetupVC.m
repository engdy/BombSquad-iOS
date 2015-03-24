//
//  MissionSetupVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "MissionSetupVC.h"
#import "AllBombsMissionVC.h"

@interface MissionSetupVC () <RunningMissionVCDelegate>

@end

@implementation MissionSetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer.bombs = [[BombList alloc] init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"StartMissionSegue"]) {
        AllBombsMissionVC *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.timer = self.timer;
        vc.timer.currentVC = vc;
        self.timer.elapsedMillis = 0;
    }
}

- (void)runningMissionDone:(RunningMissionVC *)vc {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.delegate missionSetupDone:self];
}

@end
