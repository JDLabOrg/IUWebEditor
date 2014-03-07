//
//  IUCarouselItemBox.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 29..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUCarouselItemBox.h"

@implementation IUCarouselItemBox

-(id)instantiate{
    [super instantiate];
    self.draggable = NO;
    self.iuFrame.defaultScreenFrame.pixelY =0;
    self.iuFrame.defaultScreenFrame.pixelX =0;
    self.iuFrame.defaultScreenFrame.percentFlagWidth = NO;
    self.iuFrame.defaultScreenFrame.pixelWidth = 20000;
    self.iuFrame.defaultScreenFrame.percentFlagHeight = YES;
    self.iuFrame.defaultScreenFrame.percentHeight = 90;
    self.bg.color = nil;
    self.currentIndex = 0;

    
    return self;
}

-(void)iuLoad{
    [super iuLoad];

    
}

#pragma mark -
#pragma mark override function

-(IUObj*)iuHitTest:(NSPoint)point{
    if ([super iuHitTest:point]) {
        for (IUObj *child in children.reversedArray) {
            IUObj *hit = [child iuHitTest:point];
            if (hit) {
                if([hit isKindOfClass:[IUCarouselItem class]]){
                    NSAssert(self.currentIndex >= 0, @"Bug : cannot be currentindex smaller than 0");
                    return self.children[self.currentIndex];
                }
                else return hit;
            }
        }
        return self;
    }
    return nil;
}


- (BOOL)removeFromSuperIU:(id)sender{
    NSBeep();
    return NO;
}


-(BOOL)shouldInsertIU:(IUObj *__autoreleasing *)insertedIU{
    IUObj *iu = *insertedIU;
    if ([iu isKindOfClass:[IUCarouselItem class]]) {
        return YES;
    }
    return NO;
}

-(IUObj*)requestFocusAvariableIU{
    if (self.parent.hasFocus || self.parent.childHasFocus) {
        return self;
    }
    else{
        return [self.parent requestFocusAvariableIU];
    }
}



@end
