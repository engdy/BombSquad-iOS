//
//  Bomb.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "Bomb.h"

@implementation Bomb

@synthesize level = _level, letter = _letter, durationMillis = _durationMillis, disarmedMillisRemain = _disarmedMillisRemain, state = _state;

- (Bomb *)initWithLevel:(NSInteger)level letter:(NSString *)letter duration:(NSInteger)duration {
    _level = level;
    _letter = letter;
    if (_level == 4) {
        _letter = @"F";
    }
    _durationMillis = duration;
    _disarmedMillisRemain = 0;
    _state = LIVE;
    return self;
}

- (NSString *)asString {
    if (_level == 4) {
        return [NSString stringWithFormat:@"F %@", [Bomb stringFromTime:_durationMillis]];
    }
    return [NSString stringWithFormat:@"%d%@ %@", _level, _letter, [Bomb stringFromTime:_durationMillis]];
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
    return [NSString stringWithFormat:@"%02d:%02d", displayMinutes, displaySeconds];
}

- (NSString *)timeLeftFromElapsed:(NSInteger)elapsedMillis {
    NSInteger time = _durationMillis - elapsedMillis;
    if (time < 0) {
        time = 0;
    }
    return [Bomb stringFromTime:time];
}

@end
