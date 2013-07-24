//
//  AddBombVC.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/18/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "AddBombVC.h"

@interface AddBombVC ()

@end

@implementation AddBombVC

@synthesize bombs = _bombs, levels = _levels, letters = _letters, minutes = _minutes, seconds = _seconds, editBomb = _editBomb, isEditMode = _isEditMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    _levels = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"Final", nil];
    _letters = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", nil];
    NSMutableArray *nums = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 60; ++i) {
        [nums addObject:[NSString stringWithFormat:@"%02d", i]];
    }
    _minutes = [[NSArray alloc] initWithArray:nums];
    _seconds = [[NSArray alloc] initWithArray:nums];
    if (_editBomb != nil) {
        _isEditMode = YES;
        self.navItem.title = @"Edit Bomb";
        [self.pickerBomb selectRow:_editBomb.level - 1 inComponent:0 animated:NO];
        NSUInteger i = 0;
        for (i = 0; i < [_letters count]; ++i) {
            if ([_editBomb.letter isEqualToString:_letters[i]]) {
                [self.pickerBomb selectRow:i inComponent:1 animated:NO];
                break;
            }
        }
        NSUInteger mins = _editBomb.durationMillis / 60000;
        NSUInteger secs = (_editBomb.durationMillis / 1000) % 60;
        [self.pickerBomb selectRow:mins inComponent:2 animated:NO];
        [self.pickerBomb selectRow:secs inComponent:3 animated:NO];
    } else {
        _isEditMode = NO;
        self.navItem.title = @"Add Bomb";
    }
}

- (void)viewDidUnload {
    [self setPickerBomb:nil];
    [self setNavItem:nil];
    [super viewDidUnload];
}

#pragma mark - Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [_levels count];
            
        case 1:
            return [_letters count];
            
        case 2:
            return [_minutes count];
            
        case 3:
            return [_seconds count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [_levels objectAtIndex:row];
            
        case 1:
            return [_letters objectAtIndex:row];
            
        case 2:
            return [_minutes objectAtIndex:row];
            
        case 3:
            return [_seconds objectAtIndex:row];
    }
    return @"";
}

- (IBAction)done:(id)sender {
    NSInteger millis = ([self.pickerBomb selectedRowInComponent:2] * 60000) + ([self.pickerBomb selectedRowInComponent:3] * 1000);
    NSInteger level = [self.pickerBomb selectedRowInComponent:0] + 1;
    NSString *letter = [_letters objectAtIndex:[self.pickerBomb selectedRowInComponent:1]];
    if (millis == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Instant Bomb" message:@"Your bomb needs a time delay!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
        return;
    }
    if ([_bombs checkForLetter:letter level:level]) {
        if (!_isEditMode || ![letter isEqualToString:_editBomb.letter] || level != _editBomb.level) {
            NSString *msg = (level == 4) ? @"You already have a final bomb!" : [NSString stringWithFormat:@"You already have bomb '%d%@'!", level, letter];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Duplicate Bomb" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [message show];
            return;
        }
    }
    if ([_bombs.bombs count] == 4 && ![_bombs checkForLetter:@"F" level:4] && level != 4) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Too Many Bombs" message:@"Your 5th bomb must be a Final Bomb!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
        return;
    }
    Bomb *finalBomb = nil;
    for (NSInteger i = 0; i < [_bombs.bombs count]; ++i) {
        Bomb *b = [_bombs.bombs objectAtIndex:i];
        if (b.level == 4) {
            finalBomb = b;
            break;
        }
    }
    if ((finalBomb && finalBomb.durationMillis < millis) || (level == 4 && millis < [_bombs findMaxTime])) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Bad Time" message:@"Your Final Bomb must have the longest duration!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
        return;
    }
    if (_isEditMode) {
        _editBomb.level = level;
        _editBomb.letter = (level == 4) ? @"F" : letter;
        _editBomb.durationMillis = millis;
    }
    else {
        Bomb *bomb = [[Bomb alloc] initWithLevel:level letter:letter duration:millis];
        [_bombs addBomb:bomb];
    }
    [self.delegate addBombVCDidFinish:self];
}

- (IBAction)cancel:(id)sender {
    [self.delegate addBombVCDidCancel:self];
}

@end
