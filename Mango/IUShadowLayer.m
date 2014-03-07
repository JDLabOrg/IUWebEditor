//
//  IUShadowLayer.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 2. 14..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUShadowLayer.h"

@implementation IUShadowLayer

-(id)initWithIU:(IUObj *)obj{
    self = [super init];
    if (self) {
        iu = obj;
        [self addObserver:self forKeyPaths:@[@"iu.iuFrame.frame", @"iu.iuFrame.rootGridPoint"] options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:@"draw"];
        
        self.borderWidth = 0;
        self.opacity = 0.1;
        
   
        
        /*disable animation*/
        /*sublayer disable animation*/
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           [NSNull null], @"position",
                                           [NSNull null], @"bounds",
                                           [NSNull null], @"path",
                                           nil];
        self.actions = newActions;
        
        NSImage*    backgroundImage = [NSImage imageNamed:@"tileShadow"];
        self.backgroundColor =  [[NSColor colorWithPatternImage:backgroundImage] CGColor];
        
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"iu.iuFrame.frame"];
    [self removeObserver:self forKeyPath:@"iu.iuFrame.rootGridPoint"];
}
-(void)drawContextDidChange{
    CGFloat x, y, w, h;
    
    //shadow template content
    if([iu isKindOfClass:[IUPage class]]){
        x = 0;
        y = 0;
        w = iu.iuFrame.currentScreenFrame.pixelWidth;
        h = [iu.iuFrame gridOriginFromScreen].y;
        
    }
    //shadow iucomp content
    else{
        x = [iu.iuFrame gridOriginFromScreen].x;
        y = [iu.iuFrame gridOriginFromScreen].y;
        w = iu.iuFrame.currentScreenFrame.pixelWidth;
        h = iu.iuFrame.currentScreenFrame.pixelHeight;
    }
    
    [self setFrame:NSMakeRect(x, y, w, h)];

}

@end
