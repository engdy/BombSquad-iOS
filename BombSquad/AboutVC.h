//
//  AboutVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutVC : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelVersion;

- (IBAction)bgg:(UIButton *)sender;
- (IBAction)rules:(UIButton *)sender;

@end
