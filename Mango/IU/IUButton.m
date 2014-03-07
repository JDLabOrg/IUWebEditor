//
//  IUButton.m
//  Mango
//
//  Created by JD on 13. 2. 21..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//
#if 0
#import "IUButton.h"

@implementation IUButton


+(NSString*)getIconFileName{
    return IUButtonIconFileName;
}


+(NSArray*)propertyList{
    return @[@"defaultValue", @"range", @"variable", @"isExtern", @"submit", @"jsscript"];
}

-(NSString*)desc{
    return @"IUObj is basic object IU framework.";
}


- (id)initWithIUManager:(IUManager *)_iuManager
{
    self = [super initWithIUManager:_iuManager];
    if (self) {
        [self.bg setRandomOpaqueColor];
        self.exposeBinding = YES;
        [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld context:nil];
        self.range = 1;
    }
    return self;
}

-(void)iuDidLoad{
    [super iuDidLoad];
    [self addObserver:self forKeyPaths:@[@"defaultValue", @"variable", @"range"] options:NSKeyValueObservingOptionPrior context:@"btn"];
    [self btnContextDidChange:nil];
}

-(void)nameDidChange:(NSDictionary*)change{
    NSString *old = [change objectForKey:NSKeyValueChangeOldKey];
    if (old == nil) {
        self.variable = self.name;
    }
}

-(void)btnContextWillChange{
    [self.rootIU removeJSTrigger:self];
    if (_variable) {
        [self.rootIU removeJSVariable:_variable];
    }
}

-(void)btnContextDidChange:(NSDictionary*)change{
    if (_isExtern == NO) {
        if (_variable) {
            [self.rootIU addJSVariable:_variable initialValue:self.defaultValue range:_range];
        }
    }
    if (_variable) {
        [self.rootIU addJSTrigger:self event:@"click" variable:_variable];
    }
}

-(void)removeFromSuperIU{
    if (_isExtern == NO && _variable) {
        [self.rootIU removeJSVariable:_variable];
        [self.rootIU removeJSTrigger:self];
    }
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    if (dict) {
        [dict setObject:[self exportPropertyFromDictOfClass:[IUButton class]] forKey:@"IUButton"];
    }
    return dict;
}


-(void)loadWithDict:(NSMutableDictionary *)dict{
    [super loadWithDict:dict];
    [self importPropertyFromDict:[dict objectForKey:@"IUButton"] ofClass:[IUButton class]];
}



@end
#endif