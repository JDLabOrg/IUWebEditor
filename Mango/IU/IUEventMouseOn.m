//
//  IUHoverBinder.m
//  Mango
//
//  Created by JD on 13. 2. 22..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUEventMouseOn.h"

@implementation IUEventMouseOn

@synthesize bgX;
@synthesize bgY;
@synthesize bgColor, textColor;
@synthesize enableBGColor, enableTextColor;


-(id)initWithOwner:(IUEvent*)event{
    self = [super init];
    if (self) {
        self.bgColor = [NSColor cyanColor];
        self.textColor = [NSColor blackColor];
        self.disableText = TRUE;
        [self addObserver:self forKeyPaths:[[IUEventMouseOn class] propertyList] options:0 context:nil];
    }
    return self;
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"disableText",
                                @"enableBGColor",
                                @"enableTextColor",
                                @"bgX",
                                @"bgY",
                                @"bgColor",
                                @"textColor",
                                 ]];
    return array;
}

-(void)dealloc{
    [self removeObserver:self forKeyPaths:[[IUEventMouseOn class] propertyList]];
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setFloat:bgX forKey:@"bgX" ignoreZero:YES];
    [dict setFloat:bgY forKey:@"bgY" ignoreZero:YES];
    if (enableBGColor) {
        [dict setObjectRemoveNil:[bgColor rgbString] forKey:@"bgColor"];
    }
    if(enableTextColor){
        [dict setObjectRemoveNil:[textColor rgbString] forKey:@"textColor"];
    }
    if ([dict count] == 0) {
        return nil;
    }
    return dict;
}

-(void)loadWithDict:(NSDictionary *)dict{
    if ([dict objectForKey:@"bgColor"]) {
        self.enableBGColor = YES;
        self.bgColor = [[dict objectForKey:@"bgColor"] color];
    }
    if([dict objectForKey:@"textColor"]){
        self.enableTextColor = YES;
        self.textColor = [[dict objectForKey:@"textColor"] color];
    }
    self.bgX = [[dict objectForKey:@"bgX"] intValue];
    self.bgY = [[dict objectForKey:@"bgY"] intValue];
}
@end