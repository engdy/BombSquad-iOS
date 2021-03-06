//
//  Bomb.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2015 Tasty Minstrel Games. All rights reserved.
//

#import "Bomb.h"

@implementation Bomb

@synthesize level = _level, letter = _letter, durationMillis = _durationMillis, disarmedMillisRemain = _disarmedMillisRemain, state = _state, isGameEnding = _isGameEnding;

- (Bomb *)initWithLevel:(NSInteger)level letter:(NSString *)letter duration:(NSInteger)duration gameEnding:(BOOL)terminal {
    _level = level;
    _letter = letter;
    _durationMillis = duration;
    _disarmedMillisRemain = 0;
    _state = LIVE;
    _isGameEnding = terminal;
    return self;
}

- (NSString *)asString {
    return [NSString stringWithFormat:@"%ld%@ %@%@", (long)_level, _letter, [Bomb stringFromTime:_durationMillis], _isGameEnding ? @" (terminal)" : @""];
}

- (NSComparisonResult)compare:(Bomb *)b2 {
    if (self.durationMillis < b2.durationMillis) {
        return NSOrderedAscending;
    }
    if (self.durationMillis > b2.durationMillis) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

+ (NSString *)stringFromTime:(NSInteger)millis {
    NSInteger displaySeconds = (millis / 1000) % 60;
    NSInteger displayMinutes = millis / 60000;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)displayMinutes, (long)displaySeconds];
}

- (NSString *)timeLeftFromElapsed:(NSInteger)elapsedMillis {
    NSInteger time = _durationMillis - elapsedMillis;
    if (time < 0) {
        time = 0;
    }
    return [Bomb stringFromTime:time];
}

@end
