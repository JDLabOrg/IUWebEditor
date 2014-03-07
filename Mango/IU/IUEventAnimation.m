//
//  IUEventAnimation.m
//  Mango
//
//  Created by JD on 13. 6. 11..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUEventAnimation.h"

@implementation IUEventAnimation
@synthesize isVertical;
@synthesize duration;
@synthesize enabled;


-(id)init{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPaths:[IUEventAnimation propertyList] options:0 context:@"IUEvent"];
    }
    return self;
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"isVertical", @"duration", @"enabled"]];
    return array;
}

+(NSArray*)propertyList{
    return [self autoPropertyList];
}

-(void)loadWithDict:(NSDictionary *)dict{
    [self importPropertyFromDict:dict ofClass:[IUEventAnimation class]];
}

-(NSMutableDictionary*)dict{
    if (enabled == NO) {
        return nil;
    }
    return [self exportPropertyFromDictOfClass:[IUEventAnimation class]];
}

@end