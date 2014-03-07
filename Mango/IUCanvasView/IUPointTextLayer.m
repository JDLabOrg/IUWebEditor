//
//  IUPointTextLayer.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 19..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUPointTextLayer.h"
#import "IUFrameManager.h"

@implementation IUPointTextLayer

-(id)initWithIU:(IUObj *)obj option:(NSInteger)select{
    self = [super init];
    if(self){
        iu = obj;
        option = select;
        [self addObserver:self forKeyPaths:@[@"iu.iuFrame.gridFrameFromScreen"] options:0 context:@"draw"];
        
        self.backgroundColor = [[NSColor clearColor] CGColor];
        self.borderWidth = 0;
        
        /*disable animation*/
        /*sublayer disable animation*/
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           [NSNull null], @"position",
                                           [NSNull null], @"bounds",
                                           nil];
        self.actions = newActions;
        textRect.size = NSMakeSize(60, 20);
        [self setFontSize:10];
        [self setForegroundColor:[[NSColor blackColor] CGColor]];
        [self drawContextDidChange];

        
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"iu.iuFrame.gridFrameFromScreen"];
}

-(void)drawContextDidChange{
    
    NSRect frame = [iu.iuFrame gridFrameFromScreen];
    
    switch(option){
        case kIUPointTextOrigin:
            self.string = [[NSString alloc] initWithFormat:@"(%.0f, %.0f)", iu.iuFrame.currentScreenFrame.x, iu.iuFrame.currentScreenFrame.y];
            textRect.origin.x = frame.origin.x - textRect.size.width;
            textRect.origin.y = frame.origin.y - textRect.size.height+5;
            [self setAlignmentMode:kCAAlignmentRight];
            break;
        case kIUPointTextSize:
            self.string = [[NSString alloc] initWithFormat:@"(%.0f, %.0f)", frame.size.width, frame.size.height];
            textRect.origin.x = frame.origin.x + frame.size.width;
            textRect.origin.y = frame.origin.y+ frame.size.height;
            [self setAlignmentMode:kCAAlignmentLeft];
            break;

    }
    
    [self setFrame:textRect];
    
}




@end
