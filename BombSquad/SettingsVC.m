//
//  SettingsVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.soundNames = [[NSArray alloc] initWithObjects:@"Impending Boom", @"A Mission", @"Spy Groove", @"Hitman", @"Hidden Agenda", @"Mechanical", @"Ticking Clock", @"Heartbeat", nil];
    self.soundResources = [[NSArray alloc] initWithObjects:@"impendingboom", @"amission", @"spygroove", @"hitman", @"hiddenagenda", @"mechanical", @"tickingclock", @"heartbeat", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSNumber *num = [defaults objectForKey:@"soundtrack"];
    if (num == nil) {
        num = [NSNumber numberWithBool:YES];
        [defaults setObject:num forKey:@"soundtrack"];
        [defaults synchronize];
    }
    BOOL willPlaySoundtrack = [num boolValue];

    num = [defaults objectForKey:@"volumeMusic"];
    if (num == nil) {
        num = [NSNumber numberWithDouble:0.5];
        [defaults setObject:num forKey:@"volumeMusic"];
        [defaults synchronize];
    }
    CGFloat musicVolume = [num doubleValue];

    num = [defaults objectForKey:@"visualAlert"];
    if (num == nil) {
        num = [NSNumber numberWithBool:YES];
        [defaults setObject:num forKey:@"visualAlert"];
        [defaults synchronize];
    }
    BOOL willShowVisualAlert = [num boolValue];

    num = [defaults objectForKey:@"audioAlert"];
    if (num == nil) {
        num = [NSNumber numberWithBool:YES];
        [defaults setObject:num forKey:@"audioAlert"];
        [defaults synchronize];
    }
    BOOL willPlayAudioAlert = [num boolValue];

    num = [defaults objectForKey:@"audioBomb"];
    if (num == nil) {
        num = [NSNumber numberWithBool:YES];
        [defaults setObject:num forKey:@"audioBomb"];
        [defaults synchronize];
    }
    BOOL willPlayBombSound = [num boolValue];

    num = [defaults objectForKey:@"volumeBomb"];
    if (num == nil) {
        num = [NSNumber numberWithDouble:1.0];
        [defaults setObject:num forKey:@"volumeBomb"];
        [defaults synchronize];
    }
    CGFloat bombVolume = [num doubleValue];

    NSString *selectedSoundtrack = [defaults objectForKey:@"selectedSoundtrack"];
    if (selectedSoundtrack == nil) {
        selectedSoundtrack = @"tickingclock";
        [defaults setObject:selectedSoundtrack forKey:@"selectedSoundtrack"];
        [defaults synchronize];
    }
    self.frameDown = self.viewGroup.frame;
    self.frameUp = CGRectMake(self.frameDown.origin.x, self.frameDown.origin.y - 216.0, self.frameDown.size.width, self.frameDown.size.height);
    self.viewGroup.frame = willPlaySoundtrack ? self.frameDown : self.frameUp;
    [self.sliderSoundtrack setEnabled:willPlaySoundtrack];
    [self.sliderBombSound setEnabled:willPlayBombSound];
    [self.sliderSoundtrack setValue:musicVolume];
    [self.sliderBombSound setValue:bombVolume];
    [self.timer enableSoundtrack:willPlaySoundtrack withResourceName:selectedSoundtrack volume:musicVolume];
    [self.timer enableBombSounds:willPlayBombSound volume:bombVolume];
    [self.switchSoundtrack setOn:willPlaySoundtrack];
    [self.pickerSoundtrack setHidden:!willPlaySoundtrack];
    [self.switchVisualAlert setOn:willShowVisualAlert];
    [self.switchAudioAlert setOn:willPlayAudioAlert];
    [self.switchBombSounds setOn:willPlayBombSound];
    for (NSInteger i = 0; i < [self.soundResources count]; ++i) {
        if ([selectedSoundtrack isEqualToString:(NSString *)[self.soundResources objectAtIndex:i]]) {
            [self.pickerSoundtrack selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    if (willPlaySoundtrack) {
        [self.timer startMusic];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer stopMusic];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [NSNumber numberWithDouble:self.sliderSoundtrack.value];
    [defaults setObject:num forKey:@"volumeMusic"];
    num = [NSNumber numberWithDouble:self.sliderBombSound.value];
    [defaults setObject:num forKey:@"volumeBomb"];
    [defaults synchronize];
}

- (void)viewDidUnload {
    [self setSwitchSoundtrack:nil];
    [self setPickerSoundtrack:nil];
    [self setSwitchVisualAlert:nil];
    [self setSwitchAudioAlert:nil];
    [self setSwitchBombSounds:nil];
    [self setViewGroup:nil];
    [self setSliderSoundtrack:nil];
    [self setSliderBombSound:nil];
    [super viewDidUnload];
}

#pragma mark - Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.soundResources count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.soundNames objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.soundResources objectAtIndex:row] forKey:@"selectedSoundtrack"];
    [defaults synchronize];
    if ([self.timer isPlayingSoundtrack]) {
        [self.timer stopMusic];
        [self.timer enableSoundtrack:YES withResourceName:[self.soundResources objectAtIndex:row] volume:self.sliderSoundtrack.value];
        [self.timer startMusic];
    }
}

- (IBAction)toggleSoundtrack:(id)sender {
    BOOL isOn = self.switchSoundtrack.isOn;
    NSNumber *num = [NSNumber numberWithBool:isOn];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:num forKey:@"soundtrack"];
    [defaults synchronize];
    [self.sliderSoundtrack setEnabled:isOn];
    [self.pickerSoundtrack setHidden:!isOn];
    self.viewGroup.frame = isOn ? self.frameDown : self.frameUp;
    if (isOn) {
        NSString *selectedSound = [defaults objectForKey:@"selectedSoundtrack"];
        for (NSInteger i = 0; i < [self.soundResources count]; ++i) {
            if ([selectedSound isEqualToString:[self.soundResources objectAtIndex:i]]) {
                [self.pickerSoundtrack selectRow:i inComponent:0 animated:NO];
                break;
            }
        }
        [self.timer enableSoundtrack:YES withResourceName:selectedSound volume:self.sliderSoundtrack.value];
        [self.timer startMusic];
    } else {
        [self.timer stopMusic];
    }
}

- (IBAction)toggleVisual:(id)sender {
    NSNumber *num = [NSNumber numberWithBool:[self.switchVisualAlert isOn]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:num forKey:@"visualAlert"];
    [defaults synchronize];
}

- (IBAction)toggleAudio:(id)sender {
    NSNumber *num = [NSNumber numberWithBool:[self.switchAudioAlert isOn]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:num forKey:@"audioAlert"];
    [defaults synchronize];
}

- (IBAction)toggleBombs:(id)sender {
    BOOL isOn = self.switchBombSounds.isOn;
    NSNumber *num = [NSNumber numberWithBool:isOn];
    [self.sliderBombSound setEnabled:isOn];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:num forKey:@"audioBomb"];
    [defaults synchronize];
}

- (IBAction)updateMusicVolume:(UISlider *)sender {
    [self.timer adjustMusicVolume:self.sliderSoundtrack.value];
}

- (IBAction)updateBombVolume:(UISlider *)sender {
    [self.timer adjustBombVolume:self.sliderBombSound.value];
}

@end
