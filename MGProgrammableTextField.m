//
//  MGTextField.m
//  WebGenerator
//
//  Created by JD on 2/17/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "MGProgrammableTextField.h"

@implementation MGProgrammableTextField

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)setEnabled:(BOOL)flag{
    [super setEnabled:flag];
    if (flag == NO) {
        [[self animator] setAlphaValue:0.3];
        [self setToolTip:@"Disabled : Project is not programmable"];
    }
}

@end
