//
//  QuickSetupVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "QuickSetupVC.h"
#import "AddBombVC.h"

@interface QuickSetupVC () <AddBombVCDelegate>

@end

@implementation QuickSetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkButtons];
}

- (void)viewDidUnload {
    [self setBtnStart:nil];
    [self setBtnAdd:nil];
    [self setBtnRemove:nil];
    [self setTxtTimeLeft:nil];
    [self setTableBombs:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [defaults objectForKey:@"quickInstructions"];
    if (num == nil) {
        num = [NSNumber numberWithBool:YES];
        [defaults setObject:num forKey:@"quickInstructions"];
        [defaults synchronize];
    }
    self.willDisplayInstructions = [num boolValue];
    if (self.willDisplayInstructions && self.tipView == nil) {
        self.tipView = [[CMPopTipView alloc] initWithMessage:@"You will need to add at least one bomb to your mission (tap this tip when done)"];
        self.tipView.delegate = self;
        [self.tipView presentPointingAtView:self.btnAdd inView:self.view animated:YES];
        self.iCurrentTip = 0;
    }
}

- (void)checkButtons {
    if ([self.timer.bombs.bombs count] > 0) {
        [self.btnRemove setEnabled:YES];
        [self.btnStart setEnabled:YES];
    } else {
        [self.btnRemove setEnabled:NO];
        [self.btnStart setEnabled:NO];
    }
    [self.btnAdd setEnabled:[self.timer.bombs.bombs count] < 5];
    [self.txtTimeLeft setText:[self.timer.bombs maxTimeAsString]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"AddBombSegue"]) {
        AddBombVC *vc = [segue destinationViewController];
        vc.bombs = self.timer.bombs;
        vc.editBomb = nil;
        vc.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"EditBombSegue"]) {
        AddBombVC *vc = [segue destinationViewController];
        vc.bombs = self.timer.bombs;
        Bomb *bomb = [self.timer.bombs.bombs objectAtIndex:self.selectedRow];
        vc.editBomb = bomb;
        vc.delegate = self;
    } else {
        if (self.tipView != nil) {
            [self.tipView dismissAnimated:NO];
            self.tipView = nil;
        }
        [self saveInstructionDisplay:NO];
        [super prepareForSegue:segue sender:sender];
    }
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.timer.bombs.bombs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableViewCellIdentifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    UIImageView *iv;
    UILabel *lab;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(32.0, 0.0, 44.0, 44.0)];
        iv.tag = 1;
        [cell.contentView addSubview:iv];
        lab = [[UILabel alloc] initWithFrame:CGRectMake(76.0, 0.0, 120.0, 44.0)];
        [lab setTextAlignment:NSTextAlignmentRight];
        [lab setFont:[UIFont systemFontOfSize:26.0]];
        lab.tag = 2;
        [cell.contentView addSubview:lab];
    } else {
        iv = (UIImageView *)[cell.contentView viewWithTag:1];
        lab = (UILabel *)[cell.contentView viewWithTag:2];
    }
    Bomb *b = [self.timer.bombs.bombs objectAtIndex:indexPath.row];
    if (b.level == 4) {
        [iv setImage:[UIImage imageNamed:@"bombF"]];
    } else {
        [iv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bomb%d%@", b.level, b.letter]]];
    }
    [lab setText:[b timeLeftFromElapsed:0]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.timer.bombs removeBombAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self checkButtons];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedRow = [indexPath row];
    [self performSegueWithIdentifier:@"EditBombSegue" sender:self];
}

- (IBAction)removeClicked:(id)sender {
    [self.tableBombs setEditing:![self.tableBombs isEditing] animated:YES];
}

- (void)addBombVCDidFinish:(AddBombVC *)vc {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self checkButtons];
    [self.tableBombs reloadData];
}

- (void)addBombVCDidCancel:(AddBombVC *)vc {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - CMPopTipView

- (void)saveInstructionDisplay:(BOOL)flag {
    if (self.willDisplayInstructions) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [NSNumber numberWithBool:flag];
        [defaults setObject:num forKey:@"quickInstructions"];
        [defaults synchronize];
        self.willDisplayInstructions = flag;
    }
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    [self.tipView dismissAnimated:YES];
    switch (self.iCurrentTip) {
        case 0:
            self.tipView = [[CMPopTipView alloc] initWithMessage:@"This shows the duration of your longest bomb. (tap this tip when done)"];
            self.tipView.delegate = self;
            [self.tipView presentPointingAtView:self.txtTimeLeft inView:self.view animated:YES];
            self.iCurrentTip = 1;
            break;
            
        case 1:
            self.tipView = [[CMPopTipView alloc] initWithMessage:@"When you're done adding bombs, tap Start to begin your mission! (tap this tip when done)"];
            self.tipView.delegate = self;
            [self.tipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
            self.iCurrentTip = 2;
            break;
            
        default:
            self.tipView = nil;
            [self saveInstructionDisplay:NO];
            break;
    }
}

@end
