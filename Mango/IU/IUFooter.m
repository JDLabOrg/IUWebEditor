//
//  IUFooter.m
//  Mango
//
//  Created by JD on 13. 2. 12..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUFooter.h"

@implementation IUFooter
-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.pixelHeight = 70;
    self.iuFrame.defaultScreenFrame.percentFlagWidth = YES;
    self.iuFrame.defaultScreenFrame.percentWidth = 100;
    self.iuFrame.defaultScreenFrame.flowLayout = YES;
    self.iuFrame.disableX = YES;
    self.iuFrame.disableY = YES;
    self.draggable = NO;
    
    
    return self;
}

-(void)iuLoad{
    [super iuLoad];
    self.draggable = NO;
}

-(BOOL)removeFromSuperIU:(id)sender{
    NSBeep();
    return NO;
}
@end
