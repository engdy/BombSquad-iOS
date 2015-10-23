//
//  HelpVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 11/22/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picts = [[NSArray alloc] initWithObjects:@"help1", @"help2", @"help3", @"help4", @"help5", @"help6", @"help7", @"help8", @"help9", @"help10", @"help11", @"help12", @"help13", @"help14", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.selectedImage = 0;
    [self updateImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)left:(id)sender {
    if (self.selectedImage > 0) {
        --self.selectedImage;
        [self updateImage];
    }
}

- (IBAction)right:(id)sender {
    if (self.selectedImage < [self.picts count] - 1) {
        ++self.selectedImage;
        [self updateImage];
    }
}

- (IBAction)btnHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)checkButtons {
    [self.btnLeft setEnabled:self.selectedImage != 0];
    [self.btnLeft setHidden:self.selectedImage == 0];
    [self.btnRight setEnabled:self.selectedImage < [self.picts count] - 1];
    [self.btnRight setHidden:self.selectedImage >= [self.picts count] - 1];
}

- (void)updateImage {
    [self.image setImage:[UIImage imageNamed:[self.picts objectAtIndex:self.selectedImage]]];
    [self checkButtons];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    }
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
