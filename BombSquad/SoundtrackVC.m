//
//  SoundtrackVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 3/23/15.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "SoundtrackVC.h"

@interface SoundtrackVC ()

@end

@implementation SoundtrackVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pickerSoundtrack selectRow:self.selection inComponent:0 animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer stopMusic];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        [self.timer enableSoundtrack:YES withResourceName:[self.soundResources objectAtIndex:row] volume:self.soundtrackVolume];
        [self.timer startMusic];
    }
}

@end
