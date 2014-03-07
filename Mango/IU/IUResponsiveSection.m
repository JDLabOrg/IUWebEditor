//
//  IUResponsiveImage.m
//  WebGenerator
//
//  Created by JD on 11/13/13.
//  Copyright (c) 2013 jdlab.org. All rights reserved.
//

#import "IUResponsiveSection.h"
#import "IUResponsiveContainer.h"
#import "IUViewManager.h"

@implementation IUResponsiveSection

-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.pixelHeight = 500;
    self.iuFrame.disableX = YES;
    self.iuFrame.defaultScreenFrame.flowLayout = YES;
    self.bg.bgSize = IUBGSizeCover;
    self.iuFrame.defaultScreenFrame.percentFlagWidth = YES;
    self.iuFrame.defaultScreenFrame.percentWidth = 100;
    
    IUResponsiveContainer *container = [[IUResponsiveContainer alloc] init];
    [container instantiate];
    container.parent = self;
    [self.iuFrame setFullWidth];
    
    [self insertIU:container atIndex:0 error:nil];
    return self;
}


-(NSMutableDictionary*)CSSDictWithScreenType:(IUScreenType)screenType{
    NSMutableDictionary *dict = [super CSSDictWithScreenType:screenType];
    [dict removeObjectForKey:@"margin-top"];
    return dict;
}
-(BOOL)shouldChangeXByUserInput:(CGFloat)x{
    if (x == 0) {
        return YES;
    }
    return NO;
}

-(BOOL)shouldBeInsertedByUser:(IUView *__autoreleasing *)parent atIndex:(NSUInteger *)zIndex{
    IUView *childOfRoot = *parent;
    while (childOfRoot.parent.parent) {
        childOfRoot = childOfRoot.parent;
    }
    *parent = (*parent).rootIU;
    NSUInteger newIdx = childOfRoot.index;
    if ((*parent).children.count >= *zIndex + 1) {
        *zIndex = newIdx + 1;
    }
    else{
        *zIndex = newIdx;
    }
    return YES;
}

-(NSMutableString*)outputHTMLSource2:(id)sender{
    NSMutableString *str = [super outputHTMLSource2:sender];
    [str appendString:@"<!-- end of ResponsiveSection --!>"];
    return str;
}
@end
