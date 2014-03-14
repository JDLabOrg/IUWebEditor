//
//  IUTransitionView.m
//  WebGenerator
//
//  Created by JD on 3/3/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "IUTransitionView.h"

@implementation IUTransitionInnerView

-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.percentFlagWidth = YES;
    self.iuFrame.defaultScreenFrame.percentFlagHeight = YES;
    self.iuFrame.defaultScreenFrame.percentWidth = 100;
    self.iuFrame.defaultScreenFrame.percentHeight = 100;
    return self;
}


-(void)iuLoad{
    [super iuLoad];
    self.draggable = NO;
    [self.iuManager.pWC.iuController addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];
    
}
-(void)dealloc{
    [self.iuManager.pWC.iuController removeObserver:self forKeyPath:@"selectedObjects"];
    
}


-(void)selectedObjectsDidChange{
    if ([[self.iuManager.pWC.iuController selectedObjects] count] != 1) {
        return;
    }
    if ([self.allChildren containsObject:[self.iuManager.pWC.iuController.selectedObjects objectAtIndex:0]]) {
        [self becomeFocusedIU];
    }
}


-(BOOL)removeFromSuperIU:(id)sender{
    return NO;
}

-(BOOL)shouldBeMovedByUser:(IUView *)newParent{
    return NO;
}


-(BOOL)shouldChangeXByUserInput:(CGFloat)x{
    return NO;
}

-(BOOL)shouldChangeYByUserInput:(CGFloat)y{
    return NO;
}

-(BOOL)shouldChangeZByUserInput:(NSInteger)z{
    return NO;
}

-(BOOL)shouldChangeHeightByUserInput:(CGFloat)h{
    return YES;
}

-(BOOL)shouldChangeWidthByUserInput:(CGFloat)w{
    return YES;
}

-(BOOL)shouldChangeFlowLayoutByUserInput:(BOOL)flowLayout{
    return NO;
}


-(void)becomeFocusedIU{
    IUTransitionInnerView *hideV;
    if (self.index == 0) {
        hideV = [self.parent.children objectAtIndex:1];
    }
    else{
        hideV = [self.parent.children objectAtIndex:0];
    }
    hideV.showing = NO;
    self.showing = YES;
    
    [hideV setNeedsDisplay:IUNeedsDisplayActionCSS];
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];
}

-(NSMutableDictionary*)CSSDictWithScreenType:(IUScreenType)screenType{
    NSMutableDictionary *dict = [super CSSDictWithScreenType:screenType];
    if (self.showing == NO) {
        [dict putString:@"hidden" forKey:@"visibility" param:nil];
    }
    return dict;    
}

-(IUObj*)requestFocusAvariableIU{
    if (self.parent.hasFocus || self.parent.childHasFocus) {
        return self;
    }
    else{
        return [self.parent requestFocusAvariableIU];
    }
}

-(IUObj*)iuHitTest:(NSPoint)point{
    if (self.showing == 0) {
        return nil;
    }
    return [super iuHitTest:point];
}
@end


@implementation IUTransitionView
-(id)instantiate{
    [super instantiate];
    IUTransitionInnerView *defaultV = [[[IUTransitionInnerView alloc] init] instantiate];
    defaultView = defaultV;
    [self addIU:defaultV error:nil];

    IUTransitionInnerView *overlap = [[[IUTransitionInnerView alloc] init] instantiate];
    overlapView = overlap;
    [self addIU:overlap error:nil];
    
    self.animation = @"Fly From Right Side";
    self.targetOpacity = 0;
    self.transitionEvent = @"MouseOn";
    return self;
}

+(NSArray*)propertyList{
    return [self autoPropertyList];
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    NSDictionary *myDict = [dict objectForKey:@"IUTransitionView"];
    [self importPropertyFromDict:myDict ofClass:[IUTransitionView class]];
}

-(void)iuLoad{
    [super iuLoad];
    [[self.children objectAtIndex:0] becomeFocusedIU];
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    NSDictionary *myDict = [self exportPropertyFromDictOfClass:[IUTransitionView class]];
    [dict setObject:myDict forKey:@"IUTransitionView"];
    return dict;
}

-(NSMutableDictionary*)outputDict2{
    NSMutableDictionary *dict = [super outputDict2];
    [dict putString:self.transitionEvent forKey:@"transitionEvent" param:nil];
    [dict putString:self.animation forKey:@"animation" param:nil];
    [dict putFloat:(4-self.targetOpacity)*0.25 forKey:@"targetOpacity" param:nil];
    return dict;
}

-(BOOL)preventMarginCollapse{
    return NO;
}

@end
