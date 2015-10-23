//
//  SettingsVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "SettingsVC.h"
#import "SoundtrackVC.h"
#import "BURN.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.soundNames = [[NSArray alloc] initWithObjects:@"Impending Boom", @"A Mission", @"Spy Groove", @"Hitman", @"Hidden Agenda", @"Mechanical", @"Ticking Clock", @"Heartbeat", nil];
    self.soundResources = [[NSArray alloc] initWithObjects:@"impendingboom", @"amission", @"spygroove", @"hitman", @"hiddenagenda", @"mechanical", @"tickingclock", @"heartbeat", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSNumber *num = [defaults objectForKey:@"visualAlert"];
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

    num = [defaults objectForKey:@"burnLevel"];
    if (num == nil) {
        num = [NSNumber numberWithInt:0];
        [defaults setObject:num forKey:@"burnLevel"];
        [defaults synchronize];
    }
    BURNType burnLevel = (BURNType)[num intValue];
    [self.labelBURNLevel setText:[self burnStringForLevel:burnLevel]];

    [self.sliderBombSound setEnabled:willPlayBombSound];
    [self.sliderBombSound setValue:bombVolume];
    [self.sliderBURNLevel setValue:burnLevel];
    self.sliderBURNLevel.continuous = YES;
    [self.sliderBURNLevel addTarget:self action:@selector(burnValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.timer enableBombSounds:willPlayBombSound volume:bombVolume];
    [self.switchVisualAlert setOn:willShowVisualAlert];
    [self.switchAudioAlert setOn:willPlayAudioAlert];
    [self.switchBombSounds setOn:willPlayBombSound];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    NSString *selectedSoundtrack = [defaults objectForKey:@"selectedSoundtrack"];
    if (selectedSoundtrack == nil) {
        selectedSoundtrack = @"tickingclock";
        [defaults setObject:selectedSoundtrack forKey:@"selectedSoundtrack"];
        [defaults synchronize];
    }
    [self.sliderSoundtrack setEnabled:willPlaySoundtrack];
    [self.pickerSoundtrack setUserInteractionEnabled:willPlaySoundtrack];
    [self.sliderSoundtrack setValue:musicVolume];
    [self.timer enableSoundtrack:willPlaySoundtrack withResourceName:selectedSoundtrack volume:musicVolume];
    [self.switchSoundtrack setOn:willPlaySoundtrack];
    self.selectedSoundtrackIndex = 0;
    for (NSUInteger i = 0; i < [self.soundResources count]; ++i) {
        if ([selectedSoundtrack isEqualToString:(NSString *)[self.soundResources objectAtIndex:i]]) {
            self.selectedSoundtrackIndex = i;
            [self.btnSoundtrack setTitle:[self.soundNames objectAtIndex:i] forState:UIControlStateNormal];
            [self.pickerSoundtrack selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    if (willPlaySoundtrack) {
        [self.timer startMusic];
    }
}

- (NSString *)burnStringForLevel:(NSUInteger)val {
    switch (val) {
        case 0:
            return @"Silent game";
        case 1:
            return @"Some BURN chatter";
        case 2:
            return @"BURN taunts rising";
        case 3:
            return @"Maximum taunts from BURN";
    }
    return @"";
}

- (void)burnValueChanged:(UISlider *)slider {
    NSUInteger val = (NSUInteger)(slider.value + 0.5);
    [slider setValue:val animated:NO];
    [self.labelBURNLevel setText:[self burnStringForLevel:val]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [NSNumber numberWithDouble:self.sliderSoundtrack.value];
    [defaults setObject:num forKey:@"volumeMusic"];
    num = [NSNumber numberWithDouble:self.sliderBombSound.value];
    [defaults setObject:num forKey:@"volumeBomb"];
    num = [NSNumber numberWithInt:(int)self.sliderBURNLevel.value];
    [defaults setObject:num forKey:@"burnLevel"];
    [defaults synchronize];
}

- (void)viewDidUnload {
    [self setSwitchSoundtrack:nil];
    [self setPickerSoundtrack:nil];
    [self setSwitchVisualAlert:nil];
    [self setSwitchAudioAlert:nil];
    [self setSwitchBombSounds:nil];
    [self setSliderSoundtrack:nil];
    [self setSliderBombSound:nil];
    [self setSliderBURNLevel:nil];
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
    self.selectedSoundtrackIndex = row;
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
    [self.pickerSoundtrack setUserInteractionEnabled:isOn];
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

- (IBAction)updateBURNLevel:(UISlider *)sender {
    [self.timer.burn setBURNlevel:self.sliderBURNLevel.value];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SoundtrackSegue"]) {
        SoundtrackVC *vc = [segue destinationViewController];
        vc.timer = self.timer;
        vc.soundNames = self.soundNames;
        vc.soundResources = self.soundResources;
        vc.soundtrackVolume = self.sliderSoundtrack.value;
        vc.selection = self.selectedSoundtrackIndex;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
