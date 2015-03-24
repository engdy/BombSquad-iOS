//
//  MainVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTimer.h"

@interface MainVC : UIViewController

@property (nonatomic, retain) BSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *btnResume;

@end
