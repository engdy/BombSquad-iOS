//
//  ScrollMissionVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/24/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollMissionVC : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imgMission;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
