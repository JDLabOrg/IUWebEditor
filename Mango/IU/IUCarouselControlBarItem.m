//
//  IUCarouselControlBarItem.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 2. 3..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUCarouselControlBarItem.h"
#import "IUCSS.h"

@implementation IUCarouselControlBarItem

-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.pixelX = 0;
    self.iuFrame.defaultScreenFrame.pixelY = 0;
    self.iuFrame.defaultScreenFrame.pixelWidth = IUCarouselControlBarItemSize;
    self.iuFrame.defaultScreenFrame.pixelHeight = IUCarouselControlBarItemSize;
    self.draggable = NO;
    self.css.borderRadius = @"10";
    self.css.borderColor = [JDUIUtil randomOpaqueColor];
    self.css.borderSize = @"2";
    self.bg.color= nil;
    self.disableBorderLayer = YES;

    
    return self;
}
- (BOOL)removeFromSuperIU:(id)sender{
    NSBeep();
    return NO;
}

-(NSMutableDictionary*)HTMLDict2{
    NSMutableDictionary *dict = [super HTMLDict2];
    NSInteger left = self.currentIndex*(IUCarouselControlBarItemSize+5);
    NSString *style  = [[NSString alloc] initWithFormat:@"left:%ldpx", left];
    
    [dict putString:style forKey:@"style" param:nil];
    [dict putInt:self.currentIndex forKey:@"c-index" param:nil];
        
    return dict;
    
}

-(NSMutableDictionary*)outputDict2{
    NSMutableDictionary *dict = [super outputDict2];
    NSInteger left = self.currentIndex*(IUCarouselControlBarItemSize+5);
    NSString *style  = [[NSString alloc] initWithFormat:@"left:%ldpx", left];
    
    [dict putString:style forKey:@"style" param:nil];
    [dict putInt:self.currentIndex forKey:@"c-index" param:nil];
    
    return dict;
}
@end
