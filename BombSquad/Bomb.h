//
//  Bomb.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {LIVE, DISABLED, DETONATED} BombStateType;

@interface Bomb : NSObject

@property (nonatomic) NSInteger level;
@property (nonatomic, retain) NSString *letter;
@property (nonatomic) NSInteger durationMillis;
@property (nonatomic) NSInteger disarmedMillisRemain;
@property (nonatomic) BombStateType state;

- (Bomb *)initWithLevel:(NSInteger)level letter:(NSString *)letter duration:(NSInteger)duration;
- (NSString *)asString;
- (NSComparisonResult)compare:(Bomb *)b2;
+ (NSString *)stringFromTime:(NSInteger)millis;
- (NSString *)timeLeftFromElapsed:(NSInteger)elapsedMillis;

@end
