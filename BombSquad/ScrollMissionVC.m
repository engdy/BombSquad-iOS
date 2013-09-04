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
    NSLog(@"Image frame = %.02f, %.02f", self.imgMission.frame.size.width, self.imgMission.frame.size.height);
    NSLog(@"Image bounds = %.02f, %.02f", self.imgMission.bounds.size.width, self.imgMission.bounds.size.height);
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.imgMission addGestureRecognizer:tapRecognizer];
    self.imgMission.userInteractionEnabled = YES;
    NSLog(@"Loaded");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.contentSize = self.imgMission.frame.size;
    self.scrollView.zoomScale = 1.0;
    NSLog(@"SV Frame = %.02f, %.02f", self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    NSLog(@"Content size = %.02f, %.02f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    NSLog(@"Image size = %.02f, %.02f", self.image.size.width, self.image.size.height);
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
