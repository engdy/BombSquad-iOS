//
//  SingleBombMissionVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/19/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "RunningMissionVC.h"

@interface SingleBombMissionVC : RunningMissionVC

@property (weak, nonatomic) IBOutlet UIButton *btnMainTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayPause;
@property (nonatomic, retain) NSArray *bombButtons;
@property (nonatomic, retain) NSArray *backgroundViews;
@property (nonatomic, retain) Bomb *focusBomb;
@property (nonatomic) NSInteger focusBombNum;
@property (nonatomic) BOOL isTimerRunningDuringAlert;

- (IBAction)done:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender;
- (IBAction)handleSwipeRight:(UISwipeGestureRecognizer *)sender;

@end
