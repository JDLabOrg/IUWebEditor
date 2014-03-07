//
//  IUHeader.m
//  Mango
//
//  Created by JD on 13. 2. 19..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUHeader.h"
#import "IUView.h"
#import "IUScreenFrame.h"

@implementation IUHeader

-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.pixelWidth = 960;
    self.iuFrame.horizontalCenter = YES;
    return self;
}

//IUHeader "should not" be removed this object!
- (BOOL)removeFromSuperIU:(id)sender{
    NSBeep();
    return NO;
}



@end
