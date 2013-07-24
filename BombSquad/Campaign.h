//
//  Campaign.h
//  BombSquad
//
//  Created by Andrew Foulke on 7/18/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BombList.h"

@interface Campaign : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *picture;
@property (nonatomic, retain) BombList *bombs;

- (Campaign *)initWithName:(NSString *)name picture:(NSString *)picture bombList:(BombList *)bombList;

@end
