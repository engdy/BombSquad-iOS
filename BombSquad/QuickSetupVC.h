//
//  QuickSetupVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "MissionSetupVC.h"

@interface QuickSetupVC : MissionSetupVC
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove;
@property (weak, nonatomic) IBOutlet UILabel *txtTimeLeft;
@property (weak, nonatomic) IBOutlet UITableView *tableBombs;
@property (nonatomic) NSUInteger selectedRow;

- (IBAction)removeClicked:(id)sender;

@end
