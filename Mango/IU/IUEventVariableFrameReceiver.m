//
//  IUEventVariableFrameReceiver.m
//  WebGenerator
//
//  Created by JD on 13. 10. 31..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUEventVariableFrameReceiver.h"

@implementation IUEventVariableFrameReceiver

+(NSArray*)propertyList{
    return [[super propertyList] arrayByAddingObjectsFromArray:@[@"x", @"y", @"width", @"height"]];
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray * array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"x", @"y", @"width", @"height"]];
    return array;
}

-(id)initWithOwner:(IUEvent*)event{
    self = [super init];
    if (self) {
        self.owner = event;
    }
    return self;
}

-(void)loadWithDict:(NSDictionary *)dict{
    if (dict) {
        [self importPropertyFromDict:dict ofClass:[IUEventVariableFrameReceiver class]];
    }
}


-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    if (_width) {
        [dict setObject:_width forKey:@"width"];
    }
    if (_height) {
        [dict setObject:_height forKey:@"height"];
    }
    return dict;
}

@end