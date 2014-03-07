//
//  IUHoverBinder.h
//  Mango
//
//  Created by JD on 13. 2. 22..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>
#import "IUProperty.h"
#import "IUEvent.h"

@interface IUEventMouseOn : IUProperty{
    float bgX;
    float bgY;
    NSColor *bgColor, *textColor;
    BOOL   enableBGColor, enableTextColor;
}

-(id)initWithOwner:(IUEvent*)event;

@property   IUEvent   *owner;

//enabled on TextView;
@property BOOL disableText;
@property BOOL enableBGColor, enableTextColor;

@property float bgX;
@property float bgY;
@property NSColor   *bgColor, *textColor;

@end
