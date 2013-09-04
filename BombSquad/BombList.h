//
//  BombList.h
//  Bomb Squad
//
//  Created by Andrew Foulke on 5/24/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bomb.h"

@interface BombList : NSObject

@property (nonatomic, retain) NSMutableArray *bombs;
@property (nonatomic) BOOL showResumeButton;

- (BombList *)init;
- (BombList *)initWithBombs:(Bomb *)firstBomb, ... NS_REQUIRES_NIL_TERMINATION;
- (NSInteger)findMaxTime;
- (Bomb *)findMaxTimeBomb;
- (Bomb *)findMinTimeBomb;
- (NSInteger)findIndexOfBomb:(Bomb *)bomb;
- (NSString *)maxTimeAsString;
- (BOOL)checkForLetter:(NSString *)letter level:(NSInteger)level;
- (BOOL)addBomb:(Bomb *)bomb;
- (void)removeBombAtIndex:(NSInteger)index;

@end
