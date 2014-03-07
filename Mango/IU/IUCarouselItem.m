//
//  IUCarouselItem.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 29..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUCarouselItem.h"
#import "IUCarousel.h"
#import "IUCSS.h"


@implementation IUCarouselItem


-(id)instantiate{
    [super instantiate];
    self.draggable = NO;
    self.iuFrame.defaultScreenFrame.pixelX =0;
    self.iuFrame.defaultScreenFrame.pixelY =0;
    self.iuFrame.defaultScreenFrame.pixelWidth = 900;
    self.iuFrame.defaultScreenFrame.pixelHeight = 400;
    self.iuFrame.disableX =0;
    self.iuFrame.disableY =0;
    self.iuFrame.disableHeight=0;
    self.iuFrame.disableWidth=0;
    self.iuFrame.defaultScreenFrame.flowLayout = NO;
    self.disableBorderLayer = YES;

    return self;
}

-(void)iuLoad{
    [super iuLoad];
    self.iuFrame.currentScreenFrame.pixelX =0;
    self.iuFrame.currentScreenFrame.pixelY =0;


}


#pragma mark -
#pragma mark shouldXXX

-(BOOL)shouldChangeFlowLayoutByUserInput:(BOOL)flowLayout{
    return NO;
}

-(BOOL)shouldInsertIU:(IUObj *__autoreleasing *)insertedIU{
    IUObj *iu = *insertedIU;
    if ([iu isKindOfClass:[IUCarouselItem class]]
        || [iu isKindOfClass:[IUCarousel class]]) {
        return NO;
    }
    return YES;
}

-(BOOL)shouldBeInsertedByUser:(IUView *__autoreleasing *)parent atIndex:(NSUInteger *)zIndex{
    IUObj *iu = *parent;
    if([iu isKindOfClass:[IUCarouselItemBox class]]){
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


-(BOOL)shouldChangeXByUserInput:(CGFloat)x{
    return NO;
}
-(BOOL)shouldChangeYByUserInput:(CGFloat)y{
    return NO;
}
@end
