//
//  CampaignSetupVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "MissionSetupVC.h"
#import "Campaign.h"

@interface CampaignSetupVC : MissionSetupVC <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerMission;
@property (weak, nonatomic) IBOutlet UIButton *btnMissionImage;
@property (nonatomic, retain) Campaign *selectedCampaign;
@property (nonatomic, retain) NSArray *campaignList;
@property (nonatomic, retain) UIImage *selectedImage;

@end
