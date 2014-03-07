//
//  IUEvent.h
//  Mango
//
//  Created by JD on 13. 6. 11..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUObj.h"
#import "IUProperty.h"


@class IUObj;
@class IUEventVariableReceiver;
@class IUEventMouseOn;
@class IUEventAnimation;
@class IUEventVariableTrigger;
@class IUEventVariableFrameReceiver;

@interface IUEvent : IUProperty{
    NSDictionary    *loadedDict;
}

-(id)initWithOwner:(IUObj*)iu;

@property   IUObj           *owner;
@property   IUEventMouseOn          *mouseOn;
@property   IUEventAnimation        *animation;
@property   IUEventVariableTrigger          *variableTrigger;

@property   IUEventVariableReceiver    *variableReceiver;
@property   IUEventVariableFrameReceiver    *variableFrameReceiver;

@end
