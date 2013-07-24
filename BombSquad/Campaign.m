//
//  Campaign.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/18/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import "Campaign.h"

@implementation Campaign

@synthesize name = _name, picture = _picture, bombs = _bombs;

- (Campaign *)initWithName:(NSString *)name picture:(NSString *)picture bombList:(BombList *)bombList {
    _name = name;
    _picture = picture;
    _bombs = bombList;
    return self;
}

@end
