//
//  HelpVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 11/22/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (retain, nonatomic) NSArray *picts;
@property (nonatomic) NSUInteger selectedImage;

- (IBAction)left:(id)sender;
- (IBAction)right:(id)sender;
- (IBAction)btnHome:(id)sender;

@end
