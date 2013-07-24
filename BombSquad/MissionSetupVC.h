//
//  MissionSetupVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTimer.h"

@protocol MissionSetupVCDelegate;

@interface MissionSetupVC : UIViewController

@property (nonatomic, retain) id <MissionSetupVCDelegate> delegate;
@property (nonatomic, retain) BSTimer *timer;

@end

@protocol MissionSetupVCDelegate <NSObject>

- (void)missionSetupDone:(MissionSetupVC *)vc;

@end