//
//  RunningMissionVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/19/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTimer.h"

@protocol RunningMissionVCDelegate;

@interface RunningMissionVC : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) id <RunningMissionVCDelegate> delegate;
@property (nonatomic, retain) BSTimer *timer;
@property (nonatomic, retain) UIButton *btnPlay;
@property (nonatomic) BOOL willAlertVisually;
@property (nonatomic) BOOL willAlertAudibly;

- (void)pause;
- (void)checkbuttons;
- (void)updateMainTime:(NSString *)time;
- (void)updateBomb:(Bomb *)bomb idx:(NSInteger)idx duration:(NSInteger)duration;

@end

@protocol RunningMissionVCDelegate <NSObject>

- (void)runningMissionDone:(RunningMissionVC *)vc;

@end