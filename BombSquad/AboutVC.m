//
//  AboutVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(320.0, 520.0);
    [self.labelVersion setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setLabelVersion:nil];
    [super viewDidUnload];
}

- (IBAction)bgg:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://boardgamegeek.com/boardgame/142267/bomb-squad"]];
}

- (IBAction)rules:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://boardgamegeek.com/file/download/nv86hbejm3/Bomb_Squad_-_PnP_Rulebook_v5.3.pdf"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
