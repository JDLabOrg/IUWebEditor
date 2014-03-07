//
//  IUHeader.m
//  Mango
//
//  Created by JD on 13. 2. 12..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUObjs.h"
#import "IUHeaderWrapper.h"
#import "IUHeader.h"

@implementation IUHeaderWrapper

-(id)instantiate{
    [super instantiate];
    self.iuFrame.disableY = YES;
    [self.iuFrame setFullWidth];
    self.iuFrame.defaultScreenFrame.pixelHeight = 70;
    self.draggable = NO;
    
    IUHeader *header = [[IUHeader alloc] init];
    [header instantiate];
    [self addIU:header error:nil];
    self.iuFrame.defaultScreenFrame.flowLayout = YES;
    return self;
}

-(void)iuLoad{
    [super iuLoad];
    self.draggable=NO;
}

//IUHeaderWrapper should not be removed
- (BOOL)removeFromSuperIU:(id)sender{
    NSBeep();
    return NO;
}


@end