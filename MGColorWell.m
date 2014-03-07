//
//  NSColorWell+MGColorWell.m
//  WebGenerator
//
//  Created by JD on 1/22/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "MGColorWell.h"

@implementation MGColorWell
-(void)mouseDown:(NSEvent *)theEvent{
    [[NSColorPanel sharedColorPanel] setAction:nil];
    [[NSColorPanel sharedColorPanel] setTarget:nil];
    
    [super mouseDown:theEvent];
}

@end
