//
//  IUEventByValue.h
//  Mango
//
//  Created by JD on 13. 6. 11..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUProperty.h"
#import "IUEvent.h"

@interface IUEventVariableReceiver : IUProperty{
    
}

-(id)initWithOwner:(IUEvent*)event;

@property (nonatomic)  IUEvent   *owner;
@property (nonatomic)  NSString  *equation;

@property   BOOL        isHorizontal;
@property   float       duration;

-(BOOL)valid;
@end
