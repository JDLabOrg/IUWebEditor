//
//  IUEventTrigger.h
//  Mango
//
//  Created by JD on 13. 10. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUProperty.h"

@class IUEvent;
@interface IUEventVariableTrigger : IUProperty{
}

-(id)initWithOwner:(IUEvent*)event;

@property     IUEvent *owner;
@property BOOL      enable;
@property NSString  *variable;
@property NSInteger initialValue;
@property NSInteger range;
@property NSString  *event;

@property BOOL      isExtern;
@property BOOL      submit;

@end
