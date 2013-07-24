//
//  AllBombsMissionVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/19/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "RunningMissionVC.h"

@interface AllBombsMissionVC : RunningMissionVC
@property (weak, nonatomic) IBOutlet UILabel *txtMainTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayPause;
@property (nonatomic, retain) NSArray *bombStates;
@property (nonatomic, retain) NSArray *bombButtons;
@property (nonatomic, retain) NSArray *bombTimes;
@property (nonatomic) BOOL isTimerRunningDuringAlert;
@property (nonatomic, retain) Bomb *focusBomb;

- (IBAction)playPause:(id)sender;
- (IBAction)home:(id)sender;

@end
