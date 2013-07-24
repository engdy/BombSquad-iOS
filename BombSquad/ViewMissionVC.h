//
//  ViewMissionVC.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/18/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewMissionVC : UIViewController

@property (nonatomic, unsafe_unretained) CGFloat currentScale;
@property (nonatomic, retain) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imgMission;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender;
- (IBAction)handleTap:(UITapGestureRecognizer *)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender;

@end
