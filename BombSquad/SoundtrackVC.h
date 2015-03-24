//
//  SoundtrackVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 3/23/15.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTimer.h"

@interface SoundtrackVC : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerSoundtrack;
@property (nonatomic, retain) NSArray *soundNames;
@property (nonatomic, retain) NSArray *soundResources;
@property (nonatomic, retain) BSTimer *timer;
@property (nonatomic) float soundtrackVolume;
@property (nonatomic) NSUInteger selection;

@end
