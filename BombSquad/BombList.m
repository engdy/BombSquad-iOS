//
//  BombList.m
//  Bomb Squad
//
//  Created by Andrew Foulke on 5/24/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "BombList.h"
#import "Bomb.h"

@implementation BombList

@synthesize bombs = _bombs, showResumeButton = _showResumeButton;

- (BombList *)init {
    self.bombs = [[NSMutableArray alloc] init];
    self.showResumeButton = NO;
    return self;
}

- (BombList *)initWithBombs:(Bomb *)firstBomb, ... {
    self.bombs = [[NSMutableArray alloc] init];
    va_list args;
    va_start(args, firstBomb);
    for (Bomb *b = firstBomb; b != nil; b = va_arg(args, Bomb *)) {
        [self addBomb:b];
    }
    va_end(args);
    self.showResumeButton = NO;
    return self;
}

- (NSInteger) findIndexOfBomb:(Bomb *)bomb {
    for (NSInteger i = 0; i < [self.bombs count]; ++i) {
        if (bomb == self.bombs[i]) {
            return i;
        }
    }
    return -1;
}

- (NSInteger)findMaxTime {
    Bomb *b = [self findMaxTimeBomb];
    return b.durationMillis;
}

- (Bomb *)findMaxTimeBomb {
    NSInteger maxTime = 0;
    Bomb *max = nil;
    for (Bomb *b in _bombs) {
        if (b.state == LIVE && b.durationMillis > maxTime) {
            max = b;
            maxTime = b.durationMillis;
        }
    }
    return max;
}

- (Bomb *)findMinTimeBomb {
    NSInteger minTime = NSIntegerMax;
    Bomb *min = nil;
    for (Bomb *b in _bombs) {
        if (b.state == LIVE && b.durationMillis < minTime) {
            min = b;
            minTime = b.durationMillis;
        }
    }
    return min;
}

- (NSString *)maxTimeAsString {
    return [Bomb stringFromTime:[self findMaxTime]];
}

- (BOOL)checkForLetter:(NSString *)letter level:(NSInteger)level {
    for (Bomb *b in _bombs) {
        if ([b.letter isEqualToString:letter] && b.level == level) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)addBomb:(Bomb *)bomb {
    [self.bombs addObject:bomb];
    [self.bombs sortUsingSelector:@selector(compare:)];
    return YES;
}

- (void)removeBombAtIndex:(NSInteger)index {
    [self.bombs removeObjectAtIndex:index];
}

@end
