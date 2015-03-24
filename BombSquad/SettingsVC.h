//
//  SettingsVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTimer.h"

@interface SettingsVC : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *switchSoundtrack;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerSoundtrack;
@property (weak, nonatomic) IBOutlet UISwitch *switchVisualAlert;
@property (weak, nonatomic) IBOutlet UISwitch *switchAudioAlert;
@property (weak, nonatomic) IBOutlet UISwitch *switchBombSounds;
@property (weak, nonatomic) IBOutlet UIButton *btnSoundtrack;
@property (weak, nonatomic) IBOutlet UISlider *sliderSoundtrack;
@property (weak, nonatomic) IBOutlet UISlider *sliderBombSound;
@property (weak, nonatomic) IBOutlet UISlider *sliderBURNLevel;
@property (nonatomic, retain) NSArray *soundNames;
@property (nonatomic, retain) NSArray *soundResources;
@property (nonatomic) CGRect frameUp;
@property (nonatomic) CGRect frameDown;
@property (nonatomic, retain) BSTimer *timer;
@property (nonatomic) NSUInteger selectedSoundtrackIndex;

- (IBAction)toggleSoundtrack:(id)sender;
- (IBAction)toggleVisual:(id)sender;
- (IBAction)toggleAudio:(id)sender;
- (IBAction)toggleBombs:(id)sender;
- (IBAction)updateMusicVolume:(UISlider *)sender;
- (IBAction)updateBombVolume:(UISlider *)sender;
- (IBAction)updateBURNLevel:(UISlider *)sender;

@end
