//
//  ScrollMissionVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/24/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "ScrollMissionVC.h"

@interface ScrollMissionVC ()

@end

@implementation ScrollMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imgMission setImage:self.image];
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.contentSize = self.image.size;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.imgMission addGestureRecognizer:tapRecognizer];
    self.imgMission.userInteractionEnabled = YES;
    NSLog(@"Loaded");
}

- (void)viewDidUnload {
    [self setImgMission:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgMission;
}

- (void)handleTap:(UITapGestureRecognizer *)uigr {
    [self dismissViewControllerAnimated:YES completion:NULL];
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

@end
