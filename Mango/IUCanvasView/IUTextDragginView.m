//
//  IUTextDragginView.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 3. 6..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUTextDragginView.h"

@implementation IUTextDragginView

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

-(BOOL)acceptsFirstResponder{
    return YES;
}

-(NSView *)hitTest:(NSPoint)aPoint{
    return self;
}


#pragma mark - keyboard

-(void)keyDown:(NSEvent *)theEvent{
    [super keyDown:theEvent];

    if(theEvent.keyCode == 53){//ESC key
        if([[self delegate] respondsToSelector:@selector(endEditing)]){
            [[self delegate] performSelector:@selector(endEditing)];
        }
    }
}

@end
