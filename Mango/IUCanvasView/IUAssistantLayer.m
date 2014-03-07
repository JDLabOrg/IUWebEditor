//
//  IUAssistantLayer.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 19..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUAssistantLayer.h"
#import "JDUIUtil.h"
#import "IUFrameManager.h"


@implementation IUAssistantLayer


-(id)initWithIU:(IUObj *)obj{
    self = [super init];
    if (self) {
        iu = obj;
        [self addObserver:self forKeyPaths:@[@"iu.lineLocation", @"iu.iuFrame.gridFrameFromScreen", @"iu.iuFrame.rootGridPoint"] options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:@"draw"];
        
        self.backgroundColor = [[NSColor clearColor] CGColor];
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
        
        
        [self setStrokeColor:[[NSColor blueColor] CGColor]];
        [self setLineWidth:1];
        [self setLineDashPattern:@[@"2",@"3"]];
        
        //first draw call
        [self drawContextDidChange];
        
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"iu.iuFrame.gridFrameFromScreen"];
    [self removeObserver:self forKeyPath:@"iu.iuFrame.rootGridPoint"];
    [self removeObserver:self forKeyPath:@"location"];
}

-(void)drawContextWillChange{
    [path  removeAllPoints];
}

-(void)drawContextDidChange{
    
    if(iu.lineLocation ==0) return;
    
    NSPoint start, end;
    
    //For convenient, rewrite variable
    
    CGFloat superx = [iu.parent.iuFrame gridOriginFromScreen].x + iu.parent.iuFrame.currentScreenFrame.pixelWidth;
    CGFloat supery = [iu.parent.iuFrame gridOriginFromScreen].y + iu.parent.iuFrame.currentScreenFrame.pixelHeight;
    CGFloat superstartx = [iu.parent.iuFrame gridOriginFromScreen].x;
    CGFloat superstarty = [iu.parent.iuFrame gridOriginFromScreen].y;
    
    /*
     *
     (outerframe)
     (superstartx superstarty)
     _| _ |_
     _| _ |_
      |   |(superx, supery)
     
     (innerframe)
     (x,y) + (w, h)
     
     */

    CGFloat x = [iu.iuFrame gridOriginFromScreen].x;
    CGFloat y = [iu.iuFrame gridOriginFromScreen].y;
    CGFloat w = iu.iuFrame.currentScreenFrame.pixelWidth;
    CGFloat h = iu.iuFrame.currentScreenFrame.pixelHeight;
    
    if(iu.lineLocation & kIULineLocationLeft){
        start = NSMakePoint(x, superstarty);
        end = NSMakePoint(x, supery);
        [path drawline:start end:end];
        
    }
    if(iu.lineLocation & kIULineLocationCenter){
        start = NSMakePoint(x+w/2, superstarty);
        end = NSMakePoint(x+w/2, supery);
        [path drawline:start end:end];
        
    }
    if(iu.lineLocation & kIULineLocationRight){
        start = NSMakePoint(x+w, superstarty);
        end = NSMakePoint(x+w, supery);
        [path drawline:start end:end];
    }
    if(iu.lineLocation & kIULineLocationTop){
        start = NSMakePoint(superstartx, y);
        end = NSMakePoint(superx, y);
        [path drawline:start end:end];
    }
    if(iu.lineLocation & kIULineLocationMiddle){
        start = NSMakePoint(superstartx, y+h/2);
        end = NSMakePoint(superx, y+h/2);
        [path drawline:start end:end];
    }
    if(iu.lineLocation & kIULineLocationBottom){
        start = NSMakePoint(superstartx, y+h);
        end = NSMakePoint(superx, y+h);
        [path drawline:start end:end];
    }

    self.path = [path quartzPath];

}

@end
