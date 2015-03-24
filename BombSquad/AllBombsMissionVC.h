//
//  AllBombsMissionVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/19/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "RunningMissionVC.h"

@interface AllBombsMissionVC : RunningMissionVC
@property (weak, nonatomic) IBOutlet UIButton *btnMainTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayPause;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeHome;
@property (nonatomic, retain) NSArray *bombStates;
@property (nonatomic, retain) NSArray *bombButtons;
@property (nonatomic, retain) NSArray *bombTimes;
@property (nonatomic) BOOL isTimerRunningDuringAlert;
@property (nonatomic, retain) Bomb *focusBomb;
@property (nonatomic) NSInteger focusBombNum;

- (IBAction)playPause:(id)sender;
- (IBAction)home:(id)sender;
- (IBAction)mainTimePressed:(id)sender;

@end
