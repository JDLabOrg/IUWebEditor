//
//  IUViewWeb.m
//  Mango
//
//  Created by JD on 13. 7. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUViewWeb.h"
#import "IUView3.h"


@implementation IUViewWeb

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.UIDelegate = self;
        
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        self.UIDelegate = self;
        [self setDrawsBackground:NO];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
