//
//  IUEventByValue.m
//  Mango
//
//  Created by JD on 13. 6. 11..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUEventVariableReceiver.h"

@implementation IUEventVariableReceiver

+(NSArray*)propertyList{
    return @[@"equation", @"isHorizontal", @"duration"];
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"equation",
                                @"isHorizontal",
                                 @"duration"]];
    return array;
}

-(id)initWithOwner:(IUEvent*)event{
    self = [super init];
    if (self) {
        self.owner = event;
        [self addObserver:self forKeyPaths:[IUEventVariableReceiver propertyList] options:NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionOld context:@"receiver"];
    }
    return self;
}


-(void)loadWithDict:(NSDictionary *)dict{
    if (dict) {
        [self importPropertyFromDict:dict ofClass:[IUEventVariableReceiver class]];
    }
}

-(NSMutableDictionary*)dict{
    //필요한 정보만 내보냄
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([self valid]) {
        if ([self.equation length]) {
            [dict setObject:_equation forKey:@"equation"];
        }
        if (self.duration != 0) {
            [dict setObject:@(_duration) forKey:@"duration"];
            [dict setObject:@(_isHorizontal) forKey:@"isHorizontal"];
        }
        return dict;
    }
    return nil;
}

-(void)setEquation:(NSString *)equation{
    _equation = equation;
}

-(void)setVariable:(NSString *)variable{
    if ([variable length]) {
        if (self.equation) {
            self.equation = nil;
        }
    }

}

-(BOOL)valid{
    if (_equation) {
        return YES;
    }
    return NO;
}


@end