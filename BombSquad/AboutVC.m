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
    [self.labelVersion setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.scrollView.contentSize = CGSizeMake(320.0, 600.0);
        CGFloat yPos = 55.0;
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12.0];
        label.text = @"Bomb Squad is a cooperative game where 2-6 players are members of a team, operating a disposal robot with the mission to disarm bombs and save hostages. The players work together, racing against the clock to provide the appropriate instructions for the robot to achieve their mission objectives.";
        CGSize allowedSize = CGSizeMake(280.0, MAXFLOAT);
        CGSize labelSize = [label.text sizeWithFont:label.font constrainedToSize:allowedSize lineBreakMode:UILineBreakModeWordWrap];
        label.frame = CGRectMake(20.0, yPos, labelSize.width, labelSize.height);
        [self.scrollView addSubview:label];
        yPos += labelSize.height + 10.0;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.font = [UIFont systemFontOfSize:17.0];
        label.text = @"Companion App";
        labelSize = [label.text sizeWithFont:label.font constrainedToSize:allowedSize];
        label.frame = CGRectMake(20.0, yPos, labelSize.width, labelSize.height);
        [self.scrollView addSubview:label];
        yPos += labelSize.height + 10.0;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12.0];
        label.text = @"This app is a companion to the physical board game. In Campaign Mode, it provides preloaded setups for each mission, managing all of the bomb timers as well as providing screenshots to aid in setting up the physical game. In QuickPlay Mode, it allows the user to create custom setups, which provides infinite possible missions. Additionally, the app comes with several soundtracks and options for various alerts.";
        labelSize = [label.text sizeWithFont:label.font constrainedToSize:allowedSize lineBreakMode:UILineBreakModeWordWrap];
        label.frame = CGRectMake(20.0, yPos, labelSize.width, labelSize.height);
        [self.scrollView addSubview:label];
        yPos += labelSize.height + 10.0;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12.0];
        label.text = @"It is not required to play, but we have found that it significantly enhances the game experience and makes the tension of the bombs counting down feel more real as you play. We hope you enjoy it as much as we do.";
        labelSize = [label.text sizeWithFont:label.font constrainedToSize:allowedSize lineBreakMode:UILineBreakModeWordWrap];
        label.frame = CGRectMake(20.0, yPos, labelSize.width, labelSize.height);
        [self.scrollView addSubview:label];
        yPos += labelSize.height + 10.0;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.font = [UIFont systemFontOfSize:17.0];
        label.text = @"Credits";
        labelSize = [label.text sizeWithFont:label.font constrainedToSize:allowedSize];
        label.frame = CGRectMake(20.0, yPos, labelSize.width, labelSize.height);
        [self.scrollView addSubview:label];
        yPos += labelSize.height + 10.0;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12.0];
        label.text = @"Game Design and Development: Dan Keltner and David Short\nGraphic Design and Artwork: Dan Keltner and David Short\nApp Development: Andy Foulke\nMusic: Kevin MacLeod";
        labelSize = [label.text sizeWithFont:label.font constrainedToSize:allowedSize lineBreakMode:UILineBreakModeWordWrap];
        label.frame = CGRectMake(20.0, yPos, labelSize.width, labelSize.height);
        [self.scrollView addSubview:label];
        yPos += labelSize.height + 10.0;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.font = [UIFont systemFontOfSize:17.0];
        label.text = @"Version:";
        labelSize = [label.text sizeWithFont:label.font constrainedToSize:allowedSize];
        label.frame = CGRectMake(20.0, yPos, labelSize.width, labelSize.height);
        [self.scrollView addSubview:label];
        CGFloat xPos = 30.0 + labelSize.width;
        labelSize = [self.labelVersion.text sizeWithFont:self.labelVersion.font constrainedToSize:allowedSize];
        self.labelVersion.frame = CGRectMake(xPos, yPos, labelSize.width, labelSize.height);
    }
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.engdy.net/dl/BombSquad_Rulebook_5.3.pdf"]];
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
