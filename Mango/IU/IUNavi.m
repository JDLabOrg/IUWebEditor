//
//  IUNavi.m
//  WebGenerator
//
//  Created by JD on 1/5/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "IUNavi.h"
#import "IUNaviLinkBar.h"

@implementation IUNavi{
}

-(id)instantiate{
    [super instantiate];
    
    IUNaviLinkBar *bar;
    IUObj         *logo;
    IUText    *title;
    
    bar = [[[IUNaviLinkBar alloc] init] instantiate];
    [self addIU:bar error:nil];
    [self.iuFrame setFullWidth];
    self.iuFrame.defaultScreenFrame.pixelHeight = 140;
    bar.iuFrame.defaultScreenFrame.pixelY = 70;
    
    logo = [[[IUObj alloc] init] instantiate];
    [self addIU:logo error:nil];
    logo.bg.img = @"logo.png";
    logo.iuFrame.defaultScreenFrame.pixelWidth = 120;
    logo.iuFrame.defaultScreenFrame.pixelHeight = 70;
    
    
    title = [[[IUText alloc] init] instantiate];
    [self addIU:title error:nil];
    
    [title setSampleText:@"Lorem Ipsum Dolor Sit Amet"];
    
    title.iuFrame.defaultScreenFrame.pixelWidth = 400;
    title.fontColor = [NSColor whiteColor];
    title.enableHeading = YES;
    title.headingLevel = 0;
    title.fontSize = 24;
    title.iuFrame.defaultScreenFrame.pixelX = 120;

    return self;
}

-(BOOL)shouldChangeXByUserInput:(CGFloat)x{
    return NO;
}

-(BOOL)shouldBeInsertedByUser:(IUView *__autoreleasing *)parent atIndex:(NSUInteger *)zIndex{
    *parent = (*parent).rootIU;
    return YES;
}

-(BOOL)shouldChangeYByUserInput:(CGFloat)y{
    return NO;
}


@end
