//
//  IUBorderLayer.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 28..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUBorderLayer.h"

@implementation IUBorderLayer


-(id)initWithIU:(IUObj *)obj{
    self = [super init];
    if (self) {
        iu = obj;
        [self addObserver:self forKeyPaths:@[@"iu.iuFrame.gridFrameFromScreen", @"iu.iuFrame.rootGridPoint"] options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:@"draw"];
        
        self.backgroundColor = [[NSColor yellowColor] CGColor];
        self.borderWidth = 0;
        
        
        path = [NSBezierPath bezierPath];
        
        
        /*disable animation*/
        /*sublayer disable animation*/
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           [NSNull null], @"position",
                                           [NSNull null], @"bounds",
                                           [NSNull null], @"path",
                                           nil];
        self.actions = newActions;
        
        
        [self setStrokeColor:[[NSColor yellowColor] CGColor]];
        [self setLineWidth:0.5];
//        [self setLineDashPattern:@[@"2",@"3"]];
        
        //first draw call
        [self drawContextDidChange];
        
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"iu.iuFrame.gridFrameFromScreen"];
    [self removeObserver:self forKeyPath:@"iu.iuFrame.rootGridPoint"];
}

-(void)drawContextWillChange{
    [path  removeAllPoints];
}

-(void)drawContextDidChange{
    
    NSPoint start, end;
    
    CGFloat x = [iu.iuFrame gridOriginFromScreen].x;
    CGFloat y = [iu.iuFrame gridOriginFromScreen].y;
    CGFloat w = iu.iuFrame.currentScreenFrame.pixelWidth;
    CGFloat h = iu.iuFrame.currentScreenFrame.pixelHeight;
    
    
    start = NSMakePoint(x, y);
    end = NSMakePoint(x, y+h);
    [path drawline:start end:end];
    
    end = NSMakePoint(x+w, y);
    [path drawline:start end:end];
    
    start = NSMakePoint(x+w, y);
    end = NSMakePoint(x+w, y+h);
    [path drawline:start end:end];
    
    start = NSMakePoint(x, y+h);
    end = NSMakePoint(x+w, y+h);
    [path drawline:start end:end];
    
    self.path = [path quartzPath];
    
}

@end
