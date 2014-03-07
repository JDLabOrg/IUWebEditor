//
//  MGInitVC.m
//  Mango
//
//  Created by JD on 13. 10. 4..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGNewProjectVC.h"

@interface MGNewProjectVC ()

@end

@implementation MGNewProjectVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.nextEnabled = YES;
    }
    return self;
}

-(BOOL)pressFinishBtn{
    NSAssert(0, @"this is abstract function");
    return NO;
}



@end
