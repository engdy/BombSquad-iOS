//
//  CampaignSetupVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "MissionSetupVC.h"
#import "Campaign.h"

@interface CampaignSetupVC : MissionSetupVC <UIPickerViewDataSource,UIPickerViewDelegate,CMPopTipViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerMission;
@property (weak, nonatomic) IBOutlet UIButton *btnMissionImage;
@property (nonatomic, retain) Campaign *selectedCampaign;
@property (nonatomic, retain) NSArray *campaignList;
@property (nonatomic, retain) UIImage *selectedImage;

@end
