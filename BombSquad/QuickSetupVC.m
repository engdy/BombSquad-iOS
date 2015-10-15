//
//  QuickSetupVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "QuickSetupVC.h"
#import "AddBombVC.h"

@interface QuickSetupVC () <AddBombVCDelegate>

@end

@implementation QuickSetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bstile"]];
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
    [iv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bomb%ld%@", (long)b.level, b.letter]]];
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

@end
