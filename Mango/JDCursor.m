//
//  JDCursor.m
//  WebGenerator
//
//  Created by JD on 2014. 2. 19..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "JDCursor.h"

@implementation JDCursor
-(void)mouseExited:(NSEvent *)theEvent{
    NSView *v = [NSApp mainWindow].contentView;
    [[NSApp mainWindow] invalidateCursorRectsForView:v];
}

@end
