//
//  CampaignSetupVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "CampaignSetupVC.h"
#import "ScrollMissionVC.h"

@interface CampaignSetupVC ()

@end

@implementation CampaignSetupVC

@synthesize selectedCampaign = _selectedCampaign, campaignList = _campaignList, selectedImage = _selectedImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildCampaigns];
    [[_btnMissionImage imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self selectionResults:0];
}

- (void)viewDidUnload {
    [self setPickerMission:nil];
    [self setBtnMissionImage:nil];
    [super viewDidUnload];
}

- (void)buildCampaigns {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    BombList *bl = [[BombList alloc] initWithBombs:[[Bomb alloc] initWithLevel:1 letter:@"A" duration:12 * 60 * 1000], nil];
    [list addObject:[[Campaign alloc] initWithName:@"Training Mission Alpha" picture:@"missiona" bombList:bl]];
    
    bl = [[BombList alloc] initWithBombs:[[Bomb alloc] initWithLevel:1 letter:@"A" duration:12 * 60 * 1000], nil];
    [list addObject:[[Campaign alloc] initWithName:@"Training Mission Bravo" picture:@"missionb" bombList:bl]];
    
    bl = [[BombList alloc] initWithBombs:[[Bomb alloc] initWithLevel:2 letter:@"A" duration:12 * 60 * 1000], nil];
    [list addObject:[[Campaign alloc] initWithName:@"Training Mission Charlie" picture:@"missionc" bombList:bl]];

    bl = [[BombList alloc] initWithBombs:[[Bomb alloc] initWithLevel:1 letter:@"A" duration:10 * 60 * 1000], [[Bomb alloc] initWithLevel:4 letter:@"F" duration:20 * 60 * 1000], nil];
    [list addObject:[[Campaign alloc] initWithName:@"Mission #1" picture:@"mission1" bombList:bl]];
    
    bl = [[BombList alloc] initWithBombs:[[Bomb alloc] initWithLevel:1 letter:@"A" duration:10 * 60 * 1000], [[Bomb alloc] initWithLevel:2 letter:@"B" duration:20 * 60 * 1000], [[Bomb alloc] initWithLevel:4 letter:@"F" duration:30 * 60 * 1000], nil];
    [list addObject:[[Campaign alloc] initWithName:@"Mission #2" picture:@"mission2" bombList:bl]];
    
    _campaignList = list;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ViewMissionSegue"]) {
        ScrollMissionVC *vc = [segue destinationViewController];
        vc.image = [UIImage imageNamed:[NSString stringWithFormat:@"big%@", _selectedCampaign.picture]];
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

#pragma mark - Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_campaignList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Campaign *camp = [_campaignList objectAtIndex:row];
    return camp.name;
}

- (void)selectionResults:(NSInteger)row {
    _selectedCampaign = [self.campaignList objectAtIndex:row];
    self.timer.bombs.bombs = _selectedCampaign.bombs.bombs;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"big%@", _selectedCampaign.picture]];
    } else {
        self.selectedImage = [UIImage imageNamed:_selectedCampaign.picture];
    }
    [_btnMissionImage setImage:self.selectedImage forState:UIControlStateNormal];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self selectionResults:row];
}

@end
