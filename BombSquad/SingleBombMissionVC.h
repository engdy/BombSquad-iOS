//
//  SingleBombMissionVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/19/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "RunningMissionVC.h"

@interface SingleBombMissionVC : RunningMissionVC <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnPlayPause;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollTimers;
@property (nonatomic, retain) NSArray *bombButtons;
@property (nonatomic, retain) NSArray *backgroundViews;
@property (nonatomic, retain) NSArray *txtTimes;
@property (nonatomic, retain) Bomb *focusBomb;
@property (nonatomic) NSInteger focusBombNum;
@property (nonatomic) BOOL isTimerRunningDuringAlert;

- (IBAction)done:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)handleSingleTap:(UITapGestureRecognizer *)sender;

@end
