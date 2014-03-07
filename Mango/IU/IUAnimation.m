//
//  IUAnimation.m
//  Mango
//
//  Created by JD on 13. 6. 7..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUAnimation.h"


@implementation IUAnimation
@synthesize direction;
@synthesize duration;


+(NSArray *)propertyList{
    return @[@"direction",@"duration"];
}

+(NSMutableArray*)undoPropertyList{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[@"direction",@"duration"]];
    return array;
}

@end
