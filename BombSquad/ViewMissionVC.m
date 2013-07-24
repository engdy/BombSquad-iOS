//
//  ViewMissionVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/18/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "ViewMissionVC.h"

@interface ViewMissionVC () {
    CGFloat tx;
    CGFloat ty;
    CGFloat scale;
}

@end

@implementation ViewMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imgMission setImage:self.image];
    self.imgMission.userInteractionEnabled = YES;
}

- (void)viewDidUnload {
    [self setImgMission:nil];
    [self setPinchRecognizer:nil];
    [self setTapRecognizer:nil];
    [self setPanRecognizer:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    NSUInteger supportedOrientations = UIInterfaceOrientationMaskLandscape;
    return supportedOrientations;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (NSString *)dumpRect:(CGRect)r {
    return [NSString stringWithFormat:@"%.02f, %.02f, %.02f, %.02f", r.origin.x, r.origin.y, r.size.width, r.size.height];
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.currentScale = sender.scale;
    } else if (sender.state == UIGestureRecognizerStateBegan && self.currentScale != 0.0f) {
        sender.scale = self.currentScale;
    }
    if (sender.scale != NAN && sender.scale != 0.0) {
        sender.view.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
//        sender.view.transform = CGAffineTransformRotate(sender.view.transform, M_PI_2);
    }
    NSLog(@"View size = %f x %f", sender.view.frame.size.width, sender.view.frame.size.height);
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
    UIView *iv = sender.view;
    UIView *top = iv.superview;
    NSLog(@"iv frame = %@", [self dumpRect:iv.frame]);
    NSLog(@"iv bounds = %@", [self dumpRect:iv.bounds]);
    NSLog(@"top frame = %@", [self dumpRect:top.frame]);
    NSLog(@"top bounds = %@", [self dumpRect:top.bounds]);
    NSLog(@"iv center = %.02f, %.02f", iv.center.x, iv.center.y);
    if (sender.state != UIGestureRecognizerStateEnded && sender.state != UIGestureRecognizerStateFailed) {
        CGPoint translation = [sender translationInView:top];
        iv.center = CGPointMake(iv.center.x + translation.x, iv.center.y + translation.y);
        CGPoint newcenter = iv.center;
        float halfx = CGRectGetMidX(iv.frame);
        NSLog(@"halfx = %.02f", halfx);
        newcenter.x = MAX(halfx, iv.center.x);
        newcenter.x = MIN(top.bounds.size.width - halfx, newcenter.x);
        iv.center = newcenter;
        [sender setTranslation:CGPointMake(0, 0) inView:top];
    }
}

@end
