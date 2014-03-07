//
//  IUEventTrigger.m
//  Mango
//
//  Created by JD on 13. 10. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUEventVariableTrigger.h"
#import "IUEvent.h"


@implementation IUEventVariableTrigger


-(id)initWithOwner:(IUEvent*)event{
    self = [super init];
    if (self) {
        self.owner = event;
        [self addObserver:self forKeyPaths:@[@"initialValue", @"variable", @"range", @"event"] options:NSKeyValueObservingOptionPrior context:@"btn"];
    }
    return self;
}
+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"enable", @"variable", @"initialValue", @"range", @"event", @"isExtern", @"submit"]];
    return array;
}

+(NSArray*)propertyList{
    return [self autoPropertyList];
}

+(NSArray*)propertyListExclude{
    return @[@"owner"];
}

-(NSMutableDictionary*)dict{
    return [self exportPropertyFromDictOfClass:[IUEventVariableTrigger class]];
}

-(void)loadWithDict:(NSDictionary *)dict{
    [self importPropertyFromDict:dict ofClass:[IUEventVariableTrigger class]];
}



@end
