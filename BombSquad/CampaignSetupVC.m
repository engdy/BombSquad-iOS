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

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [defaults objectForKey:@"campaignInstructions"];
    if (num == nil) {
        num = [NSNumber numberWithBool:YES];
        [defaults setObject:num forKey:@"campaignInstructions"];
        [defaults synchronize];
    }
    self.willDisplayInstructions = [num boolValue];
    if (self.willDisplayInstructions && self.tipView == nil) {
        self.tipView = [[CMPopTipView alloc] initWithMessage:@"Start by selecting a mission (tap this tip when done)"];
        self.tipView.delegate = self;
        [self.tipView presentPointingAtView:self.pickerMission inView:self.view animated:YES];
        self.iCurrentTip = 0;
    }
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
        if (self.tipView != nil) {
            [self.tipView dismissAnimated:NO];
            self.tipView = nil;
        }
        [self saveInstructionDisplay:NO];
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

#pragma mark - CMPopTipView

- (void)saveInstructionDisplay:(BOOL)flag {
    if (self.willDisplayInstructions) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [NSNumber numberWithBool:flag];
        [defaults setObject:num forKey:@"campaignInstructions"];
        [defaults synchronize];
        self.willDisplayInstructions = flag;
    }
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    [self.tipView dismissAnimated:YES];
    switch (self.iCurrentTip) {
        case 0:
            self.tipView = [[CMPopTipView alloc] initWithMessage:@"View mission setup details in the image below (tap this tip when done)"];
            self.tipView.delegate = self;
            [self.tipView presentPointingAtView:self.btnMissionImage inView:self.view animated:YES];
            self.iCurrentTip = 1;
            break;
        case 1:
            self.tipView = [[CMPopTipView alloc] initWithMessage:@"Then tap Start to begin your mission! (tap this tip when done)"];
            self.tipView.delegate = self;
            [self.tipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
            self.iCurrentTip = 2;
            break;
            
        default:
            self.tipView = nil;
            [self saveInstructionDisplay:NO];
            break;
    }
}

@end
