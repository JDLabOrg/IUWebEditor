//
//  IUEvent.m
//  Mango
//
//  Created by JD on 13. 6. 11..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUEvent.h"

#import "IUEventAnimation.h"
#import "IUEventMouseOn.h"
#import "IUEventVariableReceiver.h"
#import "IUEventVariableTrigger.h"
#import "IUEventVariableFrameReceiver.h"

@implementation IUEvent


-(id)initWithOwner:(IUObj*)iu{
    self = [super init];
    if (self) {
        self.owner = iu;
        _mouseOn = [[IUEventMouseOn alloc] initWithOwner:self];
        _variableReceiver = [[IUEventVariableReceiver alloc] initWithOwner:self];
        _animation = [[IUEventAnimation alloc] init];
        _variableTrigger = [[IUEventVariableTrigger alloc] initWithOwner:self];
        _variableFrameReceiver = [[IUEventVariableFrameReceiver alloc] initWithOwner:self];
    }
    return self;
}


-(void) loadWithDict:(NSDictionary *)dict{
    loadedDict = dict;
    [_mouseOn loadWithDict:[dict objectForKey:NSStringFromClass([IUEventMouseOn class])]];
    [_variableReceiver loadWithDict:[dict objectForKey:NSStringFromClass([IUEventVariableReceiver class])]];
    [_animation loadWithDict:[dict objectForKey:NSStringFromClass([IUEventAnimation class])]];
    [_variableTrigger loadWithDict:[dict objectForKey:NSStringFromClass([IUEventVariableTrigger class])]];
    [_variableFrameReceiver loadWithDict:[dict objectForKey:NSStringFromClass([IUEventVariableFrameReceiver class])]];
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectRemoveNil:[_mouseOn dict] forKey:NSStringFromClass([IUEventMouseOn class])];
    [dict setObjectRemoveNil:[_variableReceiver dict] forKey:NSStringFromClass([IUEventVariableReceiver class])];
    [dict setObjectRemoveNil:[_animation dict] forKey:NSStringFromClass([IUEventAnimation class])];
    [dict setObjectRemoveNil:[_variableTrigger dict] forKey:NSStringFromClass([IUEventVariableTrigger class])];
    [dict setObjectRemoveNil:[_variableFrameReceiver dict] forKey:NSStringFromClass([IUEventVariableFrameReceiver class])];
    if ([dict count]) {
        return dict;
    }
    return nil;
}


@end
