//
//  IUViewPage.m
//  Mango
//
//  Created by JD on 13. 7. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUViewPage.h"

@implementation IUViewPage{
    IUView3 *bgV;
}

@synthesize bgV;

-(id)initWithIUFrame:(IUFrame*)_iuFrame bgView:(IUView3*)_bgV wantsLayer:(BOOL)wantsLayer{
    self = [super initWithIUFrame:_iuFrame wantsLayer:wantsLayer];
    if (self) {
        bgV = _bgV;
    }
    return self;
}


@end
