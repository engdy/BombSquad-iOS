//
//  AddBombVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/18/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BombList.h"

@protocol AddBombVCDelegate;

@interface AddBombVC : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, retain) id <AddBombVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerBomb;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UISwitch *switchFatalBomb;
@property (nonatomic, retain) BombList *bombs;
@property (nonatomic, retain) NSArray *levels;
@property (nonatomic, retain) NSArray *letters;
@property (nonatomic, retain) NSArray *minutes;
@property (nonatomic, retain) NSArray *seconds;
@property (nonatomic, retain) Bomb *editBomb;
@property (nonatomic) BOOL isEditMode;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@protocol AddBombVCDelegate <NSObject>

- (void)addBombVCDidFinish:(AddBombVC *)vc;
- (void)addBombVCDidCancel:(AddBombVC *)vc;

@end